package cjsfml.window

import cjsfml.system.*

foreign {
    func sfTouch_isDown(finger: UInt32): SfBool

    func sfTouch_getPosition(finger: UInt32, relativeTo: CPointer<Unit>): Vector2i

    func sfTouch_getPositionWindowBase(finger: UInt32, relativeTo: CPointer<Unit>): Vector2i
}

public class Touch {
    public static func isDown(finger: UInt32): Bool {
        unsafe { sfTouch_isDown(finger).toBool() }
    }

    public static func getPosition(finger: UInt32): Vector2i {
        getPosition(finger, None)
    }

    public static func getPosition(finger: UInt32, relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfTouch_getPosition(finger, relativeTo?.handle ?? CPointer()) }
    }

    public static func getPositionWindowBase(finger: UInt32, relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfTouch_getPositionWindowBase(finger, relativeTo?.handle ?? CPointer()) }
    }
}
