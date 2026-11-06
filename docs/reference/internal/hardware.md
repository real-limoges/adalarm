# Hardware

These are the parts of the original clock and the parts the firmware is written against, so they are the reference build, not a constraint.
The only hard constraint is an ESP32-S3 microcontroller, since the runtime targets that chip.
The pinout and addresses below are correct for the reference build and change with it.
What each swap costs, and where to buy each part, is in [`bom.md`](bom.md).

## Bill of Materials

| Role | Part | Notes |
|---|---|---|
| MCU | Adafruit QT Py ESP32-S3 | Dual-core Xtensa LX7 @ 240MHz |
| Audio amp | MAX98357A I2S Class-D (Adafruit I2S Amplifier BFF) | |
| Speaker | 40mm 4-ohm 3W | |
| Display | 16x2 character LCD, blue backlight, via PCF8574 I2C backpack | 4-bit mode |
| Input | Adafruit Rotary Encoder Breakout (Seesaw) | |

Where to buy each part, with product IDs and the LCD voltage caution, is in [`bom.md`](bom.md).

## Pinout

I2C bus is the STEMMA QT bus shared by the display backpack and the encoder.

| Signal | GPIO |
|---|---|
| I2S DIN | 18 |
| I2S LRC | 17 |
| I2S BCLK | 9 |
| I2C SCL | 40 |
| I2C SDA | 41 |

## I2C Addresses

| Device | Address |
|---|---|
| PCF8574 LCD backpack | 0x27 |
| Seesaw rotary encoder | 0x36 |

## Integrations the Finished Clock Targets

Spotify Connect (OAuth2 + HTTPS), Philips Hue (sunrise lighting), school calendar JSON sync, and optionally Sinric Pro / Alexa.
These are the product goals of the original clock; the port reaches them last.
