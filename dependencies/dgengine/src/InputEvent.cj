package dgengine

import cenum.*
import cjsfml.window.*

public enum InputEvent <: Equatable<InputEvent> {
    | InputMouse(Int32)
    | InputKeyboard(Int32)
    | InputScancode(Int32)
    | InputJoystick(UInt32)

    public operator func ==(right: InputEvent): Bool {
        match ((this, right)) {
            case (InputMouse(value1), InputMouse(value2)) => value1 == value2
            case (InputKeyboard(value1), InputKeyboard(value2)) => value1 == value2
            case (InputScancode(value1), InputScancode(value2)) => value1 == value2
            case (InputJoystick(value1), InputJoystick(value2)) => value1 == value2
            case (_, _) => false
        }
    }

    public operator func !=(right: InputEvent): Bool {
        !(this == right)
    }

    public func isActive(): Bool {
        match (this) {
            case InputMouse(value) => Mouse.isButtonPressed(MouseButton(value))
            case InputKeyboard(value) => Keyboard.isKeyPressed(KeyCode(value))
            case InputScancode(value) => Keyboard.isKeyPressed(Scancode(value))
            case InputJoystick(value) => Joystick.isButtonPressed(0, value)
        }
    }
}

@FlagEnum[public InputEventType](
    None
    LeftClick
    MiddleClick
    RightClick
    MousePress
    MouseMove
    MouseRelease
    MouseScroll
    KeyPress
    TextEnter
    TouchBegin
    TouchMove
    TouchEnd
    All = 0xFFF
)

extend InputEventType {
    public static func get(str: String, default!: InputEventType): InputEventType {
        match (str.toAsciiLower()) {
            case "none" => InputEventType.None
            case "leftclick" => InputEventType.LeftClick
            case "middleclick" => InputEventType.MiddleClick
            case "rightclick" => InputEventType.RightClick
            case "mousepress" => InputEventType.MousePress
            case "mousemove" => InputEventType.MouseMove
            case "mouserelease" => InputEventType.MouseRelease
            case "mousescroll" => InputEventType.MouseScroll
            case "keypress" => InputEventType.KeyPress
            case "textenter" => InputEventType.TextEnter
            case "touchbegin" => InputEventType.TouchBegin
            case "touchmove" => InputEventType.TouchMove
            case "touchend" => InputEventType.TouchEnd
            case "allleftclick" => InputEventType.All.clear(InputEventType.MiddleClick | InputEventType.RightClick)
            case "allmiddleclick" => InputEventType.All.clear(InputEventType.LeftClick | InputEventType.RightClick)
            case "allrightclick" => InputEventType.All.clear(InputEventType.LeftClick | InputEventType.MiddleClick)
            case "all" => InputEventType.All
            case _ => default
        }
    }
}
