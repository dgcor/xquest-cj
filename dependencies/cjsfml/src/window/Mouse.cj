package cjsfml.window

import cenum.*
import cjsfml.system.*

foreign {
    func sfMouse_isButtonPressed(button: MouseButton): SfBool

    func sfMouse_getPosition(relativeTo: CPointer<Unit>): Vector2i

    func sfMouse_setPosition(position: Vector2i, relativeTo: CPointer<Unit>): Unit

    func sfMouse_getPositionWindowBase(relativeTo: CPointer<Unit>): Vector2i

    func sfMouse_setPositionWindowBase(position: Vector2i, relativeTo: CPointer<Unit>): Unit
}

@CEnum[public MouseButton](
    Left
    Right
    Middle
    XButton1
    XButton2
    Count
)

@CEnum[public MouseWheel](
    VerticalWheel
    HorizontalWheel
)

public class Mouse {
    public static func isButtonPressed(button: MouseButton): Bool {
        unsafe { sfMouse_isButtonPressed(button).toBool() }
    }

    public static func getPosition(): Vector2i {
        getPosition(None)
    }

    public static func getPosition(relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfMouse_getPosition(relativeTo?.handle ?? CPointer()) }
    }

    public static func setPosition(position: Vector2i): Unit {
        setPosition(position, None)
    }

    public static func setPosition(position: Vector2i, relativeTo: ?SFMLWindow): Unit {
        unsafe { sfMouse_setPosition(position, relativeTo?.handle ?? CPointer()) }
    }

    public static func getPositionWindowBase(): Vector2i {
        getPositionWindowBase(None)
    }

    public static func getPositionWindowBase(relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfMouse_getPositionWindowBase(relativeTo?.handle ?? CPointer()) }
    }

    public static func setPositionWindowBase(position: Vector2i): Unit {
        setPositionWindowBase(position, None)
    }

    public static func setPositionWindowBase(position: Vector2i, relativeTo: ?SFMLWindow): Unit {
        unsafe { sfMouse_setPositionWindowBase(position, relativeTo?.handle ?? CPointer()) }
    }
}
