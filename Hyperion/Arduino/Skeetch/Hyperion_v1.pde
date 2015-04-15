#include "FastLED.h"

#define NUM_LEDS 76

CRGB leds[NUM_LEDS];

#define PIN 11
#define serialRate 115200


void setup()
{
  delay(2000);
  LEDS.addLeds<WS2812B, 11>(leds, NUM_LEDS);

  Serial.begin(serialRate);

//  start animation
//  for(int x = 0; x < 256; x++) { 
//
//    LEDS.showColor(CRGB(x, 0, 0));
//
//   }
//  for(int x = 255; x >= 0; x--) { 
//    LEDS.showColor(CRGB(x, 0, 0));
//
//  }

}


int waitForPrefix ()
{
    // wait until at least 3 bytes are available
    while (Serial.available() < 3);

    // read 3 bytes of the header
    char header[3];
    Serial.readBytes(header, 3);

    // check the first three bytes of the header
    while (header[0] != 'A' || header[1] != 'd' || header[2] != 'a')
    {
        // wait for an additional byte
        while (Serial.available() == 0);

        // shift the buffer
        header[0] = header[1];
        header[1] = header[2];
        header[2] = Serial.read();
    }

    // wait for the remaining part of the header
    while (Serial.available() < 3);

    // read remaining part of header
    Serial.readBytes(header, 3);

    //TODO: verify checksum and combine high and low count

    // return low count + 1 
    return header[1]+1;
}

void loop()
{
    // wait for header
    int ledCount = waitForPrefix();

    // read all led data
    Serial.write("prefix found");

    for(int i = 0; i < ledCount; ++i)
    {
        // wait till there is enough data
        while (Serial.available() < 3);

        // read data
        Serial.readBytes((char*)leds[i].raw, 3);
    }

    // write to leds
    LEDS.show();
}