# Specifications for Waveshare OLED 2.42 inch 128x64 resolution

- __OPERATING VOLTAGE__: 3.3V / 5V

- __COMMUNICATION INTERFACE__: 4-wire SPI (default) / I2C

- __DRIVER CHIP__: SSD1309

- __RESOLUTION__: 128 × 64 pixels

- __DISPLAY COLOR__: WHITE

- __DISPLAY SIZE__: 55.01 × 27.49mm

- __PIXEL SIZE__: 0.4 × 0.4mm

- __MODULE SIZE__: 61.50 × 39.50mm

## Hardware Configuration

- OLED module provides two kinds of driver interfaces: 4-wire SPI and I2C interfaces respectively. There are two optional soldering resistors on the back of the module at the lower left corner, through the choice of resistors to select the corresponding communication mode. The module adopts a 4-wire SPI communication mode by default, that is, the resistor is connected to the SPI by default. The specific hardware configuration is as follows:

### 4-wire SPI

- That is the factory demo setting: two 0R resistors are connected to the SPI position; DIN connects to the host MOSI and CLK connects to the host SCLK.

### I2C

- Two 0R resistors are connected to the I2C position; DIN connects to the host SDA and CLK connects to the host SCL.

- The DC pin can be used to change the I2C Address: Set Low, the I2C Address is :0x3C; Set High, the I2C Address is 0x3D.

- __Note__: The demo is set as SPI mode by default, if you need to switch the mode, please modify the DEV_Config.h. See demo description - underlying hardware interface - interface selection for more details.

## Package Content

- 1x 2.42inch OLED Module

- 1x GH1.25 7PIN cable

Online Development Resources /User Manual ://bit.ly/45LKn4c
