int total = 0; 
int counter = 0;
int average;

unsigned long readNext;

 
void setup() {
// put your setup code here, to run once:
Serial.begin(9600);
readNext = millis();
}

void loop() {
  // put your main code here, to run repeatedly:
  if (millis() - readNext >= 60000) { 
    total += analogRead(A0);
    counter++; 
    readNext=millis();
}

  if (counter == 5) { 
    counter = 0; 
    average = total/5;
    total =0; 
    Serial.print(average);
  }
}
