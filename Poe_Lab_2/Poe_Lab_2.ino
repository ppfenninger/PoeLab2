
const int analogInPin = A0;
int sensorValue = 0; 
double distance = 0; 

#include <Servo.h>

Servo panServo;  // create servo object to control a servo
int panPos = 0;    // variable to store the servo position

Servo tiltServo;
int tiltPos = 0; 

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  panServo.attach(9);
  tiltServo.attach(10); 
}

void loop() {
  for (panPos = 0; panPos <= 180; panPos += 20) { //goes from 0 to 180 degrees
    panServo.write(panPos);
    delay(2000); //allows time for servo to get into position
    for (tiltPos = 0; tiltPos <= 180; tiltPos += 5) {
      tiltServo.write(tiltPos);
      delay(120); //allows time for the sensor to get a reading
      sensorValue = analogRead(analogInPin);
      Serial.print(panPos); 
      Serial.print(tiltPos); 
      Serial.println(sensorValue);
    }
    tiltServo.write(0);
    delay(1000); 
  }
  // put your main code here, to run repeatedly:
  Serial.println(-1);   
}
