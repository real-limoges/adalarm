# Bill of Materials and Sourcing

This is the reference build: the parts the firmware's drivers are written against, because they are the parts the original clock used.
Nothing requires them.
Swapping a part is allowed, and the cost of a swap is the driver that was written for the old part.
Each part below says what it costs to replace.

Prices and stock were checked against adafruit.com on 2026-10-02 and will drift.
Adafruit product IDs (PIDs) are stable, so search by PID at any distributor that carries Adafruit (DigiKey, Mouser, Pimoroni, The Pi Hut) when Adafruit itself is out of stock.

## The One Real Constraint

The microcontroller must be an ESP32-S3.
The firmware runs on the bare-metal `ada_esp32s3` runtime, and that runtime targets this chip and no other.
Any ESP32-S3 board works; a different one only changes the GPIO numbers in [`hardware.md`](hardware.md).
The QT Py is chosen because its STEMMA QT port makes the I2C parts solderless and the amp board stacks directly onto it.

Everything else is open.

## Reference Build

| Role | Part | Source | PID | Price | Stock (2026-10-02) |
|---|---|---|---|---|---|
| MCU | Adafruit QT Py ESP32-S3, 8 MB flash, no PSRAM | [Adafruit](https://www.adafruit.com/product/5426) | 5426 | $12.50 | In stock |
| MCU (alternate) | Adafruit QT Py ESP32-S3, 4 MB flash, 2 MB PSRAM | [Adafruit](https://www.adafruit.com/product/5700) | 5700 | $12.50 | Out of stock |
| Audio amp | Adafruit I2S Amplifier BFF (MAX98357A) | [Adafruit](https://www.adafruit.com/product/5770) | 5770 | $4.95 | In stock |
| Speaker cable | Molex PicoBlade 2-pin cable, 200mm | [Adafruit](https://www.adafruit.com/product/3922) | 3922 | $0.95 | |
| Speaker | 40mm, 4 ohm | [Adafruit](https://www.adafruit.com/product/3968) | 3968 | $4.95 | Out of stock |
| Speaker (alternate) | Mono enclosed speaker, 3W, 4 ohm | [Adafruit](https://www.adafruit.com/product/3351) | 3351 | | In stock |
| Input | Adafruit I2C STEMMA QT Rotary Encoder Breakout, encoder fitted | [Adafruit](https://www.adafruit.com/product/5880) | 5880 | $7.95 | In stock |
| Display | 16x2 character LCD, blue backlight, PCF8574 I2C backpack fitted | Generic; Amazon, AliExpress, eBay | | ~$5 to $10 | |

### MCU

- **Variant.** [`hardware.md`](hardware.md) does not say which QT Py ESP32-S3 the original clock used.
  The no-PSRAM board (5426) is the one in stock.
  Whether this build needs PSRAM is unverified; TLS is the step most likely to want the extra memory, so the PSRAM board is the safer buy if both are available.
- **Swap cost.** Another ESP32-S3 board: new pin numbers, nothing else.
  A non-S3 chip: abandons the `ada_esp32s3` runtime, and with it the whole firmware design.

### Audio Amp and Speaker

- **Connections.** The BFF's speaker socket is Molex PicoBlade.
  Neither speaker listed plugs into it as sold: 3968 has about 9cm of bare wire, and 3351 ends in a JST PH plug.
  Join the PicoBlade cable (3922) to the speaker leads with solder, a crimp, or a lever-nut connector.
- **Speaker rating.** `hardware.md` lists a 40mm 4 ohm 3W speaker; Adafruit now lists 3968 at 5W.
  A higher rating is harmless: the MAX98357A delivers about 3W into 4 ohms at 5V, so it cannot overdrive either speaker.
  3351 is not 40mm, so check it against any enclosure.
- **Swap cost.** Any 4 or 8 ohm speaker: free.
  Any other MAX98357A board: new pin numbers.
  A different amp or DAC chip: changes the I2S audio driver, and anything that needs I2C configuration (the MAX98357A needs none) adds work there.

### Encoder

- **Part.** Buy 5880, which ships with the encoder already soldered on and connects by STEMMA QT cable.
  The older 4991 is the same Seesaw board (address 0x36) without the encoder; it needs a separate encoder such as PID 377 soldered on.
- **Swap cost.** A bare rotary encoder wired to three GPIOs is cheaper and needs soldering.
  It replaces the Seesaw-over-I2C encoder driver with GPIO interrupts and quadrature decoding, which is a different lesson, not a harder one.

### Display

The display is the part most worth reconsidering.
The 16x2 LCD with a PCF8574 backpack is generic, so quality and the backpack's address chip vary by seller, and it is a 5V part on a 3.3V board (see [the LCD voltage trap](#the-lcd-voltage-trap)).
It is also the only reference part not sold by Adafruit.

- **Buying the reference part.** Sold as "1602 I2C LCD" or "LCD1602 with IIC/I2C backpack".
  Buy the version with the backpack already soldered on.
  Check the backpack chip: a PCF8574 answers at 0x27, which is what the firmware expects; a PCF8574**A** answers at 0x3F.
  Most backpacks have address jumpers (A0 to A2) if the address needs moving.
- **A 3.3V STEMMA QT OLED.** Solderless, no level shifting, and sold by Adafruit: 128x64 at 0.96 inch (PID 326, $17.50), 128x128 at 1.12 inch (5297, $17.50), or 128x32 at 0.91 inch (4440, $12.50).
  Swap cost: the display driver becomes a pixel framebuffer with a bitmap font instead of a character LCD, which is a larger job.
  For a bedside clock, two tradeoffs are worth weighing; neither has been tested on this build.
  OLED is dark where it shows nothing, which suits a bedroom at night, and a static clock face can burn in over months.
- **An Adafruit character LCD.** A 16x2 LCD (181, $9.95, needs soldering) with Adafruit's STEMMA QT backpack (292, $9.95).
  That backpack uses an MCP23008 rather than a PCF8574, so the expander layer of the LCD driver changes; the HD44780 layer above it does not.
  Whether it runs cleanly from 3.3V without level shifting is unverified.

## Tools for a First Build

Only two joints need a soldering iron in the reference build: the header pins joining the BFF to the QT Py, and the speaker lead to the PicoBlade cable (avoidable with a lever-nut connector).
The encoder and the display connect by cable.

- A temperature-controlled soldering iron, such as a Pinecil or a Hakko FX-888D
- Rosin-core solder, 0.6 to 0.8mm
- Flush cutters, for trimming header pins and leads
- A multimeter, for checking that 5V is not reaching the I2C lines
- A breadboard, optional, for trying parts before soldering anything permanent

These are suggestions, not checked against current prices or stock.

## The LCD Voltage Trap

Applies only to the reference display.
Most 16x2 LCD backpacks are 5V parts, and the ESP32-S3 is a 3.3V part whose pins are not 5V tolerant.
Two things follow:

1. The LCD needs 5V on VCC for usable contrast.
2. Many backpacks carry 4.7k pull-up resistors from SDA and SCL to their own VCC.
   At 5V, those pull the shared I2C bus to 5V, which the ESP32-S3 pins on GPIO 40 and 41 are not rated for.

The Adafruit QT 3V to 5V Level Booster (5649) handles both.
It sits between the 3.3V STEMMA QT bus and the backpack, generates its own 5V (100mA continuous, which covers a typical backlight), and shifts the I2C lines to match.
The alternative is to remove the backpack's pull-ups and power it from the QT Py's 5V pin; this is unverified for any particular backpack, since the resistor placement varies by vendor.

This is a caution about generic modules, not a measured failure on this build.

## Cables

| Role | Part | Source | PID | Price | Stock (2026-10-02) |
|---|---|---|---|---|---|
| QT Py to encoder | STEMMA QT / Qwiic JST SH 4-pin cable, 100mm | [Adafruit](https://www.adafruit.com/product/4210) | 4210 | $0.95 | In stock |
| Level booster, reference LCD only | Adafruit QT 3V to 5V Level Booster, STEMMA QT | [Adafruit](https://www.adafruit.com/product/5649) | 5649 | | In stock |
| Booster to LCD backpack | STEMMA QT cable with female sockets, 150mm | [Adafruit](https://www.adafruit.com/product/4397) | 4397 | $0.95 | In stock |
| Power and flashing | USB-A to USB-C cable, 1m | [Adafruit](https://www.adafruit.com/product/4474) | 4474 | | In stock |

With an OLED in place of the LCD, drop the booster and the female-socket cable and add a second 4210.

## Optional

| Role | Part | Source | PID |
|---|---|---|---|
| Spare encoder for the 4991 board | Rotary encoder + extras | [Adafruit](https://www.adafruit.com/product/377) | 377 |
| Short STEMMA QT jumpers | STEMMA QT / Qwiic JST SH 4-pin cable, 50mm | [Adafruit](https://www.adafruit.com/product/4399) | 4399 |
| Breadboard bring-up | STEMMA QT to male headers, 150mm | [Adafruit](https://www.adafruit.com/product/4209) | 4209 |

## Estimated Total

About $40 to $50 for one clock in parts, before shipping, tools, and any enclosure.
This is an estimate from the listed prices, not a receipt.
