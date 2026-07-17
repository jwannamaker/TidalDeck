const int xAxisPin = A0; 
const int yAxisPin = A1;

void setup() {
  // Initialize the serial communication channel
  Serial.begin(9600);
  while (!Serial); // Wait for the terminal interface to connect
  Serial.println("--- PSP 1000 Joystick Raw Diagnostic Live ---");
}

void loop() {
  // Read the raw 10-bit analog-to-digital converter channels
  int rawX = analogRead(xAxisPin);
  int rawY = analogRead(yAxisPin);

  // Print the raw workspace data to the console
  Serial.print("Raw X (A0): ");
  Serial.print(rawX);
  Serial.print("   |   Raw Y (A1): ");
  Serial.println(rawY);

  delay(200); // 5 updates per second is easy to read visually
}

