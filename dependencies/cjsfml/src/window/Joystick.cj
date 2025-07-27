package cjsfml.window

import cenum.*
import cjsfml.system.*

foreign {
    func sfJoystick_isConnected(joystick: UInt32): SfBool

    func sfJoystick_getButtonCount(joystick: UInt32): UInt32

    func sfJoystick_hasAxis(joystick: UInt32, axis: JoystickAxis): SfBool

    func sfJoystick_isButtonPressed(joystick: UInt32, button: UInt32): SfBool

    func sfJoystick_getAxisPosition(joystick: UInt32, axis: JoystickAxis): Float32

    func sfJoystick_getIdentification(joystick: UInt32): sfJoystickIdentification

    func sfJoystick_update(): Unit
}

@CEnum[public JoystickAxis](
    X
    Y
    Z
    R
    U
    V
    PovX
    PovY
)

@C
struct sfJoystickIdentification {
    public let name: CString = CString(CPointer<UInt8>())
    public let vendorId: UInt32 = 0
    public let productId: UInt32 = 0
}

public struct JoystickIdentification {
    public let name: String
    public let vendorId: UInt32
    public let productId: UInt32

    JoystickIdentification(info: sfJoystickIdentification) {
        name = info.name.toString()
        vendorId = info.vendorId
        productId = info.productId
    }
}

public class Joystick {
    public static func isConnected(joystick: UInt32): Bool {
        unsafe { sfJoystick_isConnected(joystick).toBool() }
    }

    public static func getButtonCount(joystick: UInt32): UInt32 {
        unsafe { sfJoystick_getButtonCount(joystick) }
    }

    public static func hasAxis(joystick: UInt32, axis: JoystickAxis): Bool {
        unsafe { sfJoystick_hasAxis(joystick, axis).toBool() }
    }

    public static func isButtonPressed(joystick: UInt32, button: UInt32): Bool {
        unsafe { sfJoystick_isButtonPressed(joystick, button).toBool() }
    }

    public static func getAxisPosition(joystick: UInt32, axis: JoystickAxis): Float32 {
        unsafe { sfJoystick_getAxisPosition(joystick, axis) }
    }

    public static func getIdentification(joystick: UInt32): JoystickIdentification {
        JoystickIdentification(unsafe { sfJoystick_getIdentification(joystick) })
    }

    public static func update(): Unit {
        unsafe { sfJoystick_update() }
    }
}
