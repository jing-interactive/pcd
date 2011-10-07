// android_sensorData
// Eric Pavey - 2010-10-10
// http://www.akeric.com
//
// Query the phone's accelerometer and magnetic field data, display on screen.
// Made with Android 2.1, Processing 1.2

//-----------------------------------------------------------------------------------------
// Imports required for sensor usage:
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;
 
// Setup variables for the SensorManager, the SensorEventListeners,
// the Sensors, and the arrays to hold the resultant sensor values:
SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
MySensorEventListener magSensorEventListener;
Sensor acc_sensor;
float[] acc_values;
Sensor mag_sensor;
float[] mag_values;

//-----------------------------------------------------------------------------------------

void acc_setup() {
  orientation(PORTRAIT); 
}

//-----------------------------------------------------------------------------------------

void acc_draw() {
  fill(255);
  if (acc_values != null) {
    text(("Accelerometer: " + acc_values[0] + " " + acc_values[1] + " " + acc_values[2]), 8, 20);
  }
  else {
    text("Accelerometer: null", 8, 20);
  }
  if(mag_values != null) {
    text(("Magnetic Field: " + mag_values[0] + " " + mag_values[1] + " " + mag_values[2]), 8, 40);
  }
  else {
    text("Magnetic Field: null", 8, 40);
  }
}

//-----------------------------------------------------------------------------------------
// Override the parent (super) Activity class:
// States onCreate(), onStart(), and onStop() aren't called by the sketch.  Processing is entered at
// the 'onResume()' state, and exits at the 'onPause()' state, so just override them:

void onResume() {
  super.onResume();
  println("RESUMED! (Sketch Entered...)");
  // Build our SensorManager:
  mSensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  // Build a SensorEventListener for each type of sensor:
  magSensorEventListener = new MySensorEventListener();
  accSensorEventListener = new MySensorEventListener();
  // Get each of our Sensors:
  acc_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  mag_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
  // Register the SensorEventListeners with their Sensor, and their SensorManager:
  mSensorManager.registerListener(accSensorEventListener, acc_sensor, SensorManager.SENSOR_DELAY_GAME);
  mSensorManager.registerListener(magSensorEventListener, mag_sensor, SensorManager.SENSOR_DELAY_GAME);
}

void onPause() {
  // Unregister all of our SensorEventListeners upon exit:
  mSensorManager.unregisterListener(accSensorEventListener);
  mSensorManager.unregisterListener(magSensorEventListener);
  println("PAUSED! (Sketch Exited...)");
  super.onPause();
} 

//-----------------------------------------------------------------------------------------

// Setup our SensorEventListener
class MySensorEventListener implements SensorEventListener {
  void onSensorChanged(SensorEvent event) {
    int eventType = event.sensor.getType();
    if(eventType == Sensor.TYPE_ACCELEROMETER) {
      acc_values = event.values;
    }
    else if(eventType == Sensor.TYPE_MAGNETIC_FIELD) {
      mag_values = event.values;
    }
  }
  void onAccuracyChanged(Sensor sensor, int accuracy) {
    // do nuthin'...
  }
}
