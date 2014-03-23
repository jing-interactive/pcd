import org.firmata.*;
import cc.arduino.*;

Arduino arduino;
final int kPinBase = 22;
final int kPinCount = 22;

void setupArduino()
{
    // Prints out the available serial ports.
    println(Arduino.list());

    // Modify this line, by changing the "0" to the index of the serial
    // port corresponding to your Arduino board (as it appears in the list
    // printed by the line above).
    arduino = new Arduino(this, Arduino.list()[0], 57600);

    for (int i = 0; i < kPinCount; i++)
    {
        arduino.pinMode(kPinBase + i, Arduino.INPUT);
    }
}


//     if (arduino.digitalRead(i+pinAmout) == Arduino.HIGH)

