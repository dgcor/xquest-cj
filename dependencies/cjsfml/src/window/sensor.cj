package cjsfml.window

import cenum.CEnum
import cjsfml.system.{Vector3f}

foreign {
    func sfSensor_isAvailable(sensor: SensorType): Bool

    func sfSensor_setEnabled(sensor: SensorType, enabled: Bool): Unit

    func sfSensor_getValue(sensor: SensorType): Vector3f
}

@CEnum[public SensorType](
    Accelerometer
    Gyroscope
    Magnetometer
    Gravity
    UserAcceleration
    Orientation
    Count
)

public class Sensor {
    public static func isAvailable(sensor: SensorType): Bool {
        unsafe { sfSensor_isAvailable(sensor) }
    }

    public static func setEnabled(sensor: SensorType, enabled: Bool): Unit {
        unsafe { sfSensor_setEnabled(sensor, enabled) }
    }

    public static func getValue(sensor: SensorType): Vector3f {
        unsafe { sfSensor_getValue(sensor) }
    }
}
