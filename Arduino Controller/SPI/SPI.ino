#include <SPI.h>

const int   ssPin        = 10;
const byte  ACK_EXPECTED = 0x10;         // ACK esperado
const unsigned long TIMEOUT_MS = 3000;   // Timeout 3 segundos

SPISettings spiSettings(62500, MSBFIRST, SPI_MODE0);

enum State { STATE_HANDSHAKE, STATE_RUNNING };
State commState = STATE_HANDSHAKE;

byte nextNibble = 0;  // Nibble que enviaremos (0..15)

void setup() {
  Serial.begin(9600);
  while (!Serial);
  pinMode(ssPin, OUTPUT);
  digitalWrite(ssPin, HIGH);
  SPI.begin();
  Serial.println("Arduino listo.");
}

// Envía dato y verifica si retorna ACK esperado
bool sendAndVerify(byte dato) {
  SPI.beginTransaction(spiSettings);
  digitalWrite(ssPin, LOW);
  byte ack = SPI.transfer(dato);
  digitalWrite(ssPin, HIGH);
  SPI.endTransaction();

  return (ack == ACK_EXPECTED);
}

void loop() {
  static unsigned long startTime;
  bool ok;

  switch (commState) {
    case STATE_HANDSHAKE:
      Serial.println("=== Handshake inicial ===");
      startTime = millis();
      do {
        ok = sendAndVerify(0x00);  // Ping con 0x00
        if (ok) break;
      } while (millis() - startTime < TIMEOUT_MS);

      if (ok) {
        Serial.println("Handshake OK, paso a RUNNING");
        commState = STATE_RUNNING;
      } else {
        Serial.println("Handshake FALLÓ, reintentando...");
        delay(200);
      }
      break;

    case STATE_RUNNING:
      {
        byte dato = (nextNibble & 0x0F) << 4;  // Paquete nibble en MSBs
        Serial.print("Enviando dato 0x");
        Serial.println(nextNibble, HEX);

        startTime = millis();
        do {
          ok = sendAndVerify(dato);
          if (ok) break;
        } while (millis() - startTime < TIMEOUT_MS);

        if (ok) {
          Serial.print("Eco OK: 0x");
          Serial.println(nextNibble, HEX);
          nextNibble = (nextNibble + 1) & 0x0F;  // Incrementa nibble circular 0..15
          delay(1500);
        } else {
          Serial.println("No llegó ACK en 3 s, reinicio handshake");
          commState = STATE_HANDSHAKE;
        }
      }
      break;
  }
}
