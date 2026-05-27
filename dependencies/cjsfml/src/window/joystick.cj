package cjsfml.window

import cenum.CEnum

foreign {
    func sfJoystick_isConnected(joystick: UInt32): Bool

    func sfJoystick_getButtonCount(joystick: UInt32): UInt32

    func sfJoystick_hasAxis(joystick: UInt32, axis: JoystickAxis): Bool

    func sfJoystick_isButtonPressed(joystick: UInt32, button: UInt32): Bool

    func sfJoystick_getAxisPosition(joystick: UInt32, axis: JoystickAxis): Float32

    func sfJoystick_getIdentification(joystick: UInt32): SfJoystickIdentification

    func sfJoystick_update(): Unit
}

/**
 * Axes supported by SFML joysticks
 */
@CEnum[public JoystickAxis](
    X // The X axis
    Y // The Y axis
    Z // The Z axis
    R // The R axis
    U // The U axis
    V // The V axis
    PovX // The X axis of the point-of-view hat
    PovY // The Y axis of the point-of-view hat
)

@C
struct SfJoystickIdentification {
    public let name: CString = CString(CPointer<UInt8>())
    public let vendorId: UInt32 = 0
    public let productId: UInt32 = 0
}

/**
 * Structure holding a joystick's identification.
 */
public struct JoystickIdentification {
    /**
     * Name of the joystick
     */
    public let name: String
    /**
     * Manufacturer identifier
     */
    public let vendorId: UInt32
    /**
     * Product identifier
     */
    public let productId: UInt32

    JoystickIdentification(info: SfJoystickIdentification) {
        name = info.name.toString()
        vendorId = info.vendorId
        productId = info.productId
    }
}

/**
 * Give access to the real-time state of the joysticks.
 *
 * `Joystick` provides an interface to the state of the
 * joysticks. Each joystick is identified by an index that
 * is passed to the functions in this class.
 *
 * This class allows users to query the state of joysticks at any
 * time and directly, without having to deal with a window and
 * its events. Compared to the `JoystickMoved`, `JoystickButtonPressed`
 * and `JoystickButtonReleased` events, `Joystick` can retrieve the
 * state of axes and buttons of joysticks at any time
 * (you don't need to store and update a boolean on your side
 * in order to know if a button is pressed or released), and you
 * always get the real state of joysticks, even if they are
 * moved, pressed or released when your window is out of focus
 * and no event is triggered.
 *
 * SFML supports:
 * - 8 joysticks (`Joystick.Count`)
 * - 32 buttons per joystick (`Joystick.ButtonCount`)
 * - 8 axes per joystick (`Joystick.AxisCount`)
 *
 * Unlike the keyboard or mouse, the state of joysticks is sometimes
 * not directly available (depending on the OS), therefore an `update()`
 * function must be called in order to update the current state of
 * joysticks. When you have a window with event handling, this is done
 * automatically, you don't need to call anything. But if you have no
 * window, or if you want to check joysticks state before creating one,
 * you must call `Joystick.update()` explicitly.
 *
 * Usage example:
 * ```
 * // Is joystick #0 connected?
 * let connected = Joystick.isConnected(0)
 *
 * // How many buttons does joystick #0 support?
 * let buttons = Joystick.getButtonCount(0)
 *
 * // Does joystick #0 define a X axis?
 * let hasX = Joystick.hasAxis(0, JoystickAxis.X)
 *
 * // Is button #2 pressed on joystick #0?
 * let pressed = Joystick.isButtonPressed(0, 2)
 *
 * // What's the current position of the Y axis on joystick #0?
 * let position = Joystick.getAxisPosition(0, JoystickAxis.Y)
 * ```
 *
 * @see `Keyboard`, `Mouse`
 */
public class Joystick {
    /**
     * Check if a joystick is connected.
     *
     * @param joystick Index of the joystick to check
     *
     * @return `true` if the joystick is connected, `false` otherwise
     */
    public static func isConnected(joystick: UInt32): Bool {
        unsafe { sfJoystick_isConnected(joystick) }
    }

    /**
     * Return the number of buttons supported by a joystick.
     *
     * If the joystick is not connected, this function returns 0.
     *
     * @param joystick Index of the joystick
     *
     * @return Number of buttons supported by the joystick
     */
    public static func getButtonCount(joystick: UInt32): UInt32 {
        unsafe { sfJoystick_getButtonCount(joystick) }
    }

    /**
     * Check if a joystick supports a given axis.
     *
     * If the joystick is not connected, this function returns `false`.
     *
     * @param joystick Index of the joystick
     * @param axis     Axis to check
     *
     * @return `true` if the joystick supports the axis, `false` otherwise
     */
    public static func hasAxis(joystick: UInt32, axis: JoystickAxis): Bool {
        unsafe { sfJoystick_hasAxis(joystick, axis) }
    }

    /**
     * Check if a joystick button is pressed.
     *
     * If the joystick is not connected, this function returns `false`.
     *
     * @param joystick Index of the joystick
     * @param button   Button to check
     *
     * @return `true` if the button is pressed, `false` otherwise
     */
    public static func isButtonPressed(joystick: UInt32, button: UInt32): Bool {
        unsafe { sfJoystick_isButtonPressed(joystick, button) }
    }

    /**
     * Get the current position of a joystick axis.
     *
     * If the joystick is not connected, this function returns 0.
     *
     * @param joystick Index of the joystick
     * @param axis     Axis to check
     *
     * @return Current position of the axis, in range [-100 .. 100]
     */
    public static func getAxisPosition(joystick: UInt32, axis: JoystickAxis): Float32 {
        unsafe { sfJoystick_getAxisPosition(joystick, axis) }
    }

    /**
     * Get the joystick information.
     *
     * @param joystick Index of the joystick
     *
     * @return Structure containing joystick information.
     */
    public static func getIdentification(joystick: UInt32): JoystickIdentification {
        JoystickIdentification(unsafe { sfJoystick_getIdentification(joystick) })
    }

    /**
     * Update the states of all joysticks.
     *
     * This function is used internally by SFML, so you normally
     * don't have to call it explicitly. However, you may need to
     * call it if you have no window yet (or no window at all):
     * in this case the joystick states are not updated automatically.
     */
    public static func update(): Unit {
        unsafe { sfJoystick_update() }
    }
}
