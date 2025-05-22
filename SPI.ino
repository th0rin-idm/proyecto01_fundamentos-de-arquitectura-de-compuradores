#include <SPI.h>

const int ssPin = 10;               // Slave Select pin
byte velocidad = 0;                 // Valor 0–15 que enviamos
const byte ACK_EXPECTED = 0x10;     // El ACK que esperamos de la FPGA

SPISettings spiSettings(62500, MSBFIRST, SPI_MODE0); // 62.5 kHz, MSB first, modo 0

void setup() {
  Serial.begin(9600);
  while (!Serial);               // Solo útil en Leonardo/Micro

  pinMode(ssPin, OUTPUT);
  digitalWrite(ssPin, HIGH);     // Deseleccionar esclavo

  SPI.begin();
  Serial.println("Arduino Maestro SPI Inicializado (con Handshake ACK).");
}

// 1) Función dedicada para envío y verificación de ACK
bool sendAndVerify(byte dato_a_enviar) {
  byte ack_recibido;

  // --- Impresión previa ---
  Serial.print("Enviando Velocidad: ");
  Serial.print(dato_a_enviar >> 4);     // Muestro el nibble 0–15
  Serial.print(" (Byte: 0b");
  for (int i = 7; i >= 0; i--) {
    Serial.print(bitRead(dato_a_enviar, i));
  }
  Serial.print(")... ");

  // --- Transacción SPI ---
  SPI.beginTransaction(spiSettings);
  digitalWrite(ssPin, LOW);              // Seleccionar FPGA
  ack_recibido = SPI.transfer(dato_a_enviar);
  digitalWrite(ssPin, HIGH);             // Deseleccionar FPGA
  SPI.endTransaction();

  // --- Verificación de ACK ---
  if (ack_recibido == ACK_EXPECTED) {
    // Opcional: formateo con dos dígitos hex
    if (ack_recibido < 0x10) Serial.print('0');
    Serial.print(ack_recibido, HEX);
    Serial.println(" - OK!");
    return true;
  } else {
    if (ack_recibido < 0x10) Serial.print('0');
    Serial.print(ack_recibido, HEX);
    Serial.println(" - ERROR!");
    return false;
  }
}

void loop() {
  // Empaquetar la velocidad en los 4 bits altos
  byte dato = (velocidad & 0x0F) << 4;

  // 2) Llamada a la función que envía y verifica
  sendAndVerify(dato);

  // 3) Incremento cíclico de velocidad
  velocidad++;
  if (velocidad > 15) velocidad = 0;

  // 4) Pausa para lectura cómoda en Serial Monitor
  delay(1500);
}
