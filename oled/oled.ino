#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

const int OLED_DC = 6;
const int OLED_CS = 7;
const int OLED_RST = 5;
// OLED CLK to pin 15 (SCK)
// OLED DIN to pin 16 (MOSI)

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64

// Initialize the display using the hardware SPI bus
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &SPI, OLED_DC, OLED_RST, OLED_CS);


void setup() {
  // Initalize the oled screen now
  if (!display.begin(SSD1306_SWITCHCAPVCC)) {
    for( ; ; );
  }

  display.clearDisplay();
  display.drawPixel(64, 32, SSD1306_WHITE);
  display.drawCircle(64, 32, 24, SSD1306_WHITE);
  display.display();
}

void loop() {
}
