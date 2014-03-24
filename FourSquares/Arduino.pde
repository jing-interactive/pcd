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

    arduino = new Arduino(this, Arduino.list()[0], 57600);

    for (int i = 0; i < kPinCount; i++)
    {
        arduino.pinMode(kPinBase + i, Arduino.INPUT);
    }

    thread("threadArduino");
}

boolean isPinHigh(int id)
{
    if (arduino == null) return false;

    return arduino.digitalRead(kPinBase + id) == Arduino.HIGH;
}

boolean[] pinStatus = new boolean[kPinCount];

void threadArduino()
{
    while (true)
    {
        for (int i = 0; i < kPinCount; i++)
        {
            pinStatus[i] = isPinHigh(i);
        }
        delay(10);
    }
}

void drawArduino()
{
    color off = color(4, 79, 111);
    color on = color(84, 145, 158);
    int x0 = 650;
    stroke(on);
    for (int i = 0; i < kPinCount; i++)
    {
        if (pinStatus[i])
            fill(on);
        else
            fill(off);
        rect(x0 + 30, 20+i*20, 10, 10);
        fill(on);
        text("S"+i, x0+4, 10+20*(1+i));
    }
}

