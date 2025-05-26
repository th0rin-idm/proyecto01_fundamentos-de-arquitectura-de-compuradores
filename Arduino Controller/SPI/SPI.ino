#include <SPI.h>

const int   ssPin        = 10;
const byte  ACK_EXPECTED = 0x10;
const unsigned long TIMEOUT_MS = 3000;

SPISettings spiSettings(62500, MSBFIRST, SPI_MODE0);

enum State { STATE_HANDSHAKE, STATE_RUNNING };
State commState = STATE_HANDSHAKE;

// El nibble que vamos a enviar en cada comando:
byte nextNibble = 0;

void setup() {
  Serial.begin(9600);
  while (!Serial);
  pinMode(ssPin, OUTPUT);
  digitalWrite(ssPin, HIGH);
  SPI.begin();
}

// Envía y verifica ACK. Retorna true si coincide, false si no.
bool sendAndVerify(byte dato) {
  SPI.beginTransaction(spiSettings);
  digitalWrite(ssPin, LOW);
  byte ack = SPI.transfer(dato);
  digitalWrite(ssPin, HIGH);
  SPI.endTransaction();

  if (ack == ACK_EXPECTED) return true;
  else                    return false;
}

void loop() {
  static unsigned long startTime;
  bool ok;

  switch (commState) {
    case STATE_HANDSHAKE:
      Serial.println("=== Handshake inicial ===");
      // Mandamos 0x0 como “ping” hasta recibir ACK
      startTime = millis();
      do {
        ok = sendAndVerify(0x00);
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
        // Preparamos el dato real (nibble en MSBs)
        byte dato = (nextNibble & 0x0F) << 4;
        Serial.print("Enviando dato 0x");
        Serial.println(nextNibble, HEX);

        // Mandamos y reintentamos hasta timeout
        startTime = millis();
        do {
          ok = sendAndVerify(dato);
          if (ok) break;
        } while (millis() - startTime < TIMEOUT_MS);

        if (ok) {
          Serial.print("Eco OK: 0x");
          Serial.println(nextNibble, HEX);
          // Avanzamos al siguiente nibble
          nextNibble = (nextNibble + 1) & 0x0F;
          // Esperamos “un comando nuevo” (aquí un delay, o sustituye por trigger)
          delay(1500);
        } else {
          Serial.println("No llegó ACK en 3 s, reinicio handshake");
          commState = STATE_HANDSHAKE;
        }
      }
      break;
  }
}
