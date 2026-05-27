package cjsfml.window

import cenum.CEnum
import cjsfml.system.{Vector3f}

foreign {
    func sfSensor_isAvailable(sensor: SensorType): Bool

    func sfSensor_setEnabled(sensor: SensorType, enabled: Bool): Unit

    func sfSensor_getValue(sensor: SensorType): Vector3f
}

/**
 * Sensor type.
 */
@CEnum[public SensorType](
    Accelerometer // Measures the raw acceleration (m/s^2)
    Gyroscope // Measures the raw rotation rates (radians/s)
    Magnetometer // Measures the ambient magnetic field (micro-teslas)
    Gravity // Measures the direction and intensity of gravity, independent of device acceleration (m/s^2)
    UserAcceleration // Measures the direction and intensity of device acceleration, independent of the gravity (m/s^2)
    Orientation // Measures the absolute 3D orientation (radians)
    Count // The total number of sensor types
)

/**
 * Give access to the real-time state of the sensors.
 *
 * `Sensor` provides an interface to the state of the
 * various sensors that a device provides.
 *
 * This class allows users to query the sensors values at any
 * time and directly, without having to deal with a window and
 * its events. Compared to the `SensorChanged` event, `Sensor`
 * can retrieve the state of a sensor at any time (you don't need to
 * store and update its current value on your side).
 *
 * Depending on the OS and hardware of the device (phone, tablet, ...),
 * some sensor types may not be available. You should always check
 * the availability of a sensor before trying to read it, with the
 * `Sensor.isAvailable` function.
 *
 * You may wonder why some sensor types look so similar, for example
 * Accelerometer and Gravity / UserAcceleration. The first one
 * is the raw measurement of the acceleration, and takes into account
 * both the earth gravity and the user movement. The others are
 * more precise: they provide these components separately, which is
 * usually more useful. In fact they are not direct sensors, they
 * are computed internally based on the raw acceleration and other sensors.
 * This is exactly the same for Gyroscope vs Orientation.
 *
 * Because sensors consume a non-negligible amount of current, they are
 * all disabled by default. You must call `Sensor.setEnabled` for each
 * sensor in which you are interested.
 *
 * Usage example:
 * ```
 * if (Sensor.isAvailable(SensorType.Gravity)) {
 *     // gravity sensor is available
 * }
 *
 * // enable the gravity sensor
 * Sensor.setEnabled(SensorType.Gravity, true);
 *
 * // get the current value of gravity
 * let gravity = Sensor.getValue(SensorType.Gravity);
 * ```
 */
public class Sensor {
    /**
     * Check if a sensor is available on the underlying platform.
     *
     * @param sensor Sensor to check
     *
     * @return `true` if the sensor is available, `false` otherwise
     */
    public static func isAvailable(sensor: SensorType): Bool {
        unsafe { sfSensor_isAvailable(sensor) }
    }

    /**
     * Enable or disable a sensor.
     *
     * All sensors are disabled by default, to avoid consuming too
     * much battery power. Once a sensor is enabled, it starts
     * sending events of the corresponding type.
     *
     * This function does nothing if the sensor is unavailable.
     *
     * @param sensor  Sensor to enable
     * @param enabled `true` to enable, `false` to disable
     */
    public static func setEnabled(sensor: SensorType, enabled: Bool): Unit {
        unsafe { sfSensor_setEnabled(sensor, enabled) }
    }

    /**
     * Get the current sensor value.
     *
     * @param sensor Sensor to read
     *
     * @return The current sensor value
     */
    public static func getValue(sensor: SensorType): Vector3f {
        unsafe { sfSensor_getValue(sensor) }
    }
}
