const int clockPin = 2;
const int dataPin = 3;

// use volatile for variables modified inside interrupts
volatile int encoderCount = 0;
int lastCount = 0;

void setup() {
  pinMode(clockPin, INPUT_PULLUP);
  pinMode(dataPin, INPUT_PULLUP);

  Serial.begin(9600);

  // attach interrupt to CLK looking for a falling edge
  attachInterrupt(digitalPinToInterrupt(clockPin), encoderISR, FALLING);
}

void loop() {
  // check if encoder count has changed
  if (encoderCount != lastCount) {
    if (encoderCount > lastCount) {
      Serial.println("RIGHT");
    } else {
      Serial.println("LEFT");
    }
    lastCount = encoderCount;
  }
}

// Interrupt Service Routine executed instantly on pin change
void encoderISR() {
  // read DT pin to determine direction
  if (digitalRead(dataPin) == HIGH) {
    encoderCount++;
  } else {
    encoderCount--;
  }
}
