#include <Mouse.h>

// Pin definitions
const int ENCODER_PIN_A = 1; 
const int ENCODER_PIN_B = 2; 
const int BUTTON_PIN    = 3; 

// Volatile variables for ISR
volatile int32_t encoderTicks = 0;
int32_t lastTicks = 0;

// Button debounce
bool lastButtonState = HIGH;
unsigned long lastDebounceTime = 0;
const unsigned long DEBOUNCE_DELAY = 50; 

// --- SMOOTH ENCODER TUNING ---
// Because your wheel doesn't have clicks, use this to control speed:
// 1 = Maximum sensitivity (scrolls on every single micro-movement)
// 2 = Medium sensitivity (balances smooth feel with speed)
// 4 = Low sensitivity (requires more physical rotation to scroll)
const int SCROLL_SENSITIVITY = 1; 

void readEncoderISR() {
  static uint8_t encoderState = 0;
  encoderState <<= 2;
  encoderState |= (digitalRead(ENCODER_PIN_A) << 1) | digitalRead(ENCODER_PIN_B);
  
  static const int8_t quadratureTable[] = {0, -1, 1, 0, 1, 0, 0, -1, -1, 0, 0, 1, 0, 1, -1, 0};
  encoderTicks += quadratureTable[(encoderState & 0x0F)];
}

void setup() {
  pinMode(ENCODER_PIN_A, INPUT_PULLUP);
  pinMode(ENCODER_PIN_B, INPUT_PULLUP);
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(ENCODER_PIN_A), readEncoderISR, CHANGE);
  attachInterrupt(digitalPinToInterrupt(ENCODER_PIN_B), readEncoderISR, CHANGE);

  Mouse.begin();
}

void loop() {
  int32_t currentTicks;
  
  noInterrupts();
  currentTicks = encoderTicks;
  interrupts();

  // Smooth Scrolling Calculation
  int32_t deltaTicks = currentTicks - lastTicks;
  
  if (abs(deltaTicks) >= SCROLL_SENSITIVITY) {
    int32_t scrollAmount = deltaTicks / SCROLL_SENSITIVITY;
    
    // Send the smooth movement to the OS
    Mouse.move(0, 0, scrollAmount); 
    
    // Keep track of the remainder
    lastTicks += (scrollAmount * SCROLL_SENSITIVITY);
  }

  // Button Handling (Middle Click)
  bool currentButtonReading = digitalRead(BUTTON_PIN);
  if (currentButtonReading != lastButtonState) {
    lastDebounceTime = millis();
    lastButtonState = currentButtonReading;
  }

  if ((millis() - lastDebounceTime) > DEBOUNCE_DELAY) {
    if (currentButtonReading == LOW && !Mouse.isPressed(MOUSE_MIDDLE)) {
      Mouse.press(MOUSE_MIDDLE);
    } else if (currentButtonReading == HIGH && Mouse.isPressed(MOUSE_MIDDLE)) {
      Mouse.release(MOUSE_MIDDLE);
    }
  }
}
