import processing.serial.*;
import org.firmata.*;
import cc.arduino.*;

Arduino arduino;
final int kPinBase = 22;
final int kPinCount = 22;

void setupArduino()
{
  // Prints out the available serial ports.
  println(Arduino.list());

  if (Arduino.list().length == 0) return;

  arduino = new Arduino(this, Arduino.list()[1], 57600);

  for (int i = 0; i < kPinCount; i++)
  {
    arduino.pinMode(kPinBase + i, Arduino.INPUT);
  }
}

boolean isPinHigh(int id)
{
  if (arduino == null) return false;

  return arduino.digitalRead(kPinBase + id) == Arduino.HIGH;
}


