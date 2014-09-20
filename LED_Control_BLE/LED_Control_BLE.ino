
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h> 

#define RED_PIN 3
#define GREEN_PIN 5
#define BLUE_PIN 6
#define SPEAKER_PIN 10


int redValue = 255;
int greenValue = 0;
int blueValue = 0;

int soundEndTime = 0;

unsigned char buffer[5] = {0};
unsigned char len = 0;


void setup() {

  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);
  //pinMode(SPEAKER_PIN, OUTPUT);

  
  ble_begin();
  Serial.begin(57600);
  
}

void doBLE() {
  
  buffer[len++] = ble_read();
  if (len == 5) {
      
    int command = (int)buffer[0];
    
    if (command == 61) {
    
      redValue = (int)buffer[1];
      greenValue = (int)buffer[2];
      blueValue = (int)buffer[3];
    }
    if (command == 62) {
       tone(SPEAKER_PIN, 263, 1000); 
    }
      
    if (command == 63) {
       tone(SPEAKER_PIN, 363, 1000); 
    }
    
    if (command == 64) {
       tone(SPEAKER_PIN, 463, 1000); 
    }
    
    len = 0;      
  }
    
}


void doLED(int r, int g, int b) {
  analogWrite(RED_PIN, r);
  analogWrite(GREEN_PIN, g);
  analogWrite(BLUE_PIN, b);
}


void loop() {
   
  while ( ble_available() ) {
    doBLE();
  }

  
  doLED(redValue, greenValue, blueValue);
     
  
  ble_do_events();

  //delay(100);

  //playSound();

  

}
