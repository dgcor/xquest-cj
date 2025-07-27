package cjsfml.window

import cenum.*
import endian.utils.*
import std.binary.*

@CEnum[public EventType](
    Closed
    Resized
    LostFocus
    GainedFocus
    TextEntered
    KeyPressed
    KeyReleased
    MouseWheelMoved // deprecated
    MouseWheelScrolled
    MouseButtonPressed
    MouseButtonReleased
    MouseMoved
    MouseEntered
    MouseLeft
    JoystickButtonPressed
    JoystickButtonReleased
    JoystickMoved
    JoystickConnected
    JoystickDisconnected
    TouchBegan
    TouchMoved
    TouchEnded
    SensorChanged
    Count
)

public struct KeyEvent <: Equatable<KeyEvent> & Hashable {
    public const KeyEvent(
        public var code!: KeyCode = KeyCode.Unknown,
        public var scancode!: Scancode = Scancode.Unknown,
        public var alt!: Bool = false,
        public var control!: Bool = false,
        public var shift!: Bool = false,
        public var system!: Bool = false
    ) {}

    public init(eventData: Array<Byte>) {
        code = KeyCode(@ReadEndian[Int32](eventData[4..8]))
        scancode = Scancode(@ReadEndian[Int32](eventData[8..12]))
        alt = @ReadEndian[Bool](eventData[12])
        control = @ReadEndian[Bool](eventData[13])
        shift = @ReadEndian[Bool](eventData[14])
        system = @ReadEndian[Bool](eventData[15])
    }

    public operator func ==(right: KeyEvent): Bool {
        code == right.code && scancode == right.scancode && alt == right.alt && control == right.control && shift == right
            .shift && system == right.system
    }

    public operator func !=(right: KeyEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(code.value)
        hasher.write(scancode.value)
        hasher.write(alt)
        hasher.write(control)
        hasher.write(shift)
        hasher.write(system)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct TextEvent <: Equatable<TextEvent> & Hashable {
    public TextEvent(public var unicode!: Rune = Rune(0)) {}

    public init(eventData: Array<Byte>) {
        unicode = Rune(@ReadEndian[UInt32](eventData[4..8]))
    }

    public operator func ==(right: TextEvent): Bool {
        unicode == right.unicode
    }

    public operator func !=(right: TextEvent): Bool {
        unicode != right.unicode
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(unicode)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct MouseMoveEvent <: Equatable<MouseMoveEvent> & Hashable {
    public const MouseMoveEvent(
        public var x!: Int32 = 0,
        public var y!: Int32 = 0
    ) {}

    public init(eventData: Array<Byte>) {
        x = @ReadEndian[Int32](eventData[4..8])
        y = @ReadEndian[Int32](eventData[8..12])
    }

    public operator func ==(right: MouseMoveEvent): Bool {
        x == right.x && y == right.y
    }

    public operator func !=(right: MouseMoveEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(x)
        hasher.write(y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct MouseButtonEvent <: Equatable<MouseButtonEvent> & Hashable {
    public const MouseButtonEvent(
        public var button!: MouseButton = MouseButton.Left,
        public var x!: Int32 = 0,
        public var y!: Int32 = 0
    ) {}

    public init(eventData: Array<Byte>) {
        button = MouseButton(@ReadEndian[Int32](eventData[4..8]))
        x = @ReadEndian[Int32](eventData[8..12])
        y = @ReadEndian[Int32](eventData[12..16])
    }

    public operator func ==(right: MouseButtonEvent): Bool {
        button == right.button && x == right.x && y == right.y
    }

    public operator func !=(right: MouseButtonEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(button.value)
        hasher.write(x)
        hasher.write(y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct MouseWheelScrollEvent <: Equatable<MouseWheelScrollEvent> & Hashable {
    public const MouseWheelScrollEvent(
        public var wheel!: MouseWheel = MouseWheel.VerticalWheel,
        public var delta!: Float32 = 0.0,
        public var x!: Int32 = 0,
        public var y!: Int32 = 0
    ) {}

    public init(eventData: Array<Byte>) {
        wheel = MouseWheel(@ReadEndian[Int32](eventData[4..8]))
        delta = @ReadEndian[Float32](eventData[8..12])
        x = @ReadEndian[Int32](eventData[12..16])
        y = @ReadEndian[Int32](eventData[16..20])
    }

    public operator func ==(right: MouseWheelScrollEvent): Bool {
        wheel == right.wheel && delta == right.delta && x == right.x && y == right.y
    }

    public operator func !=(right: MouseWheelScrollEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(wheel.value)
        hasher.write(delta)
        hasher.write(x)
        hasher.write(y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct JoystickMoveEvent <: Equatable<JoystickMoveEvent> & Hashable {
    public const JoystickMoveEvent(
        public var joystickId!: UInt32 = 0,
        public var axis!: JoystickAxis = JoystickAxis.X,
        public var position!: Float32 = 0.0
    ) {}

    public init(eventData: Array<Byte>) {
        joystickId = @ReadEndian[UInt32](eventData[4..8])
        axis = JoystickAxis(@ReadEndian[Int32](eventData[8..12]))
        position = @ReadEndian[Float32](eventData[12..16])
    }

    public operator func ==(right: JoystickMoveEvent): Bool {
        joystickId == right.joystickId && axis == right.axis && position == right.position
    }

    public operator func !=(right: JoystickMoveEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(joystickId)
        hasher.write(axis.value)
        hasher.write(position)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct JoystickButtonEvent <: Equatable<JoystickButtonEvent> & Hashable {
    public const JoystickButtonEvent(
        public var joystickId!: UInt32 = 0,
        public var button!: UInt32 = 0
    ) {}

    public init(eventData: Array<Byte>) {
        joystickId = @ReadEndian[UInt32](eventData[4..8])
        button = @ReadEndian[UInt32](eventData[8..12])
    }

    public operator func ==(right: JoystickButtonEvent): Bool {
        joystickId == right.joystickId && button == right.button
    }

    public operator func !=(right: JoystickButtonEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(joystickId)
        hasher.write(button)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct JoystickConnectEvent <: Equatable<JoystickConnectEvent> & Hashable {
    public const JoystickConnectEvent(public var joystickId!: UInt32 = 0) {}

    public init(eventData: Array<Byte>) {
        joystickId = @ReadEndian[UInt32](eventData[4..8])
    }

    public operator func ==(right: JoystickConnectEvent): Bool {
        joystickId == right.joystickId
    }

    public operator func !=(right: JoystickConnectEvent): Bool {
        joystickId != right.joystickId
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(joystickId)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct SizeEvent <: Equatable<SizeEvent> & Hashable {
    public const SizeEvent(
        public var width!: UInt32 = 0,
        public var height!: UInt32 = 0
    ) {}

    public init(eventData: Array<Byte>) {
        width = @ReadEndian[UInt32](eventData[4..8])
        height = @ReadEndian[UInt32](eventData[8..12])
    }

    public operator func ==(right: SizeEvent): Bool {
        width == right.width && height == right.height
    }

    public operator func !=(right: SizeEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(width)
        hasher.write(height)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct TouchEvent <: Equatable<TouchEvent> & Hashable {
    public const TouchEvent(
        public var finger!: UInt32 = 0,
        public var x!: Int32 = 0,
        public var y!: Int32 = 0
    ) {}

    public init(eventData: Array<Byte>) {
        finger = @ReadEndian[UInt32](eventData[4..8])
        x = @ReadEndian[Int32](eventData[8..12])
        y = @ReadEndian[Int32](eventData[12..16])
    }

    public operator func ==(right: TouchEvent): Bool {
        finger == right.finger && x == right.x && y == right.y
    }

    public operator func !=(right: TouchEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(finger)
        hasher.write(x)
        hasher.write(y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct SensorEvent <: Equatable<SensorEvent> & Hashable {
    public const SensorEvent(
        public var sensorType!: SensorType = SensorType.Accelerometer,
        public var x!: Float32 = 0.0,
        public var y!: Float32 = 0.0,
        public var z!: Float32 = 0.0
    ) {}

    public init(eventData: Array<Byte>) {
        sensorType = SensorType(@ReadEndian[Int32](eventData[4..8]))
        x = @ReadEndian[Float32](eventData[8..12])
        y = @ReadEndian[Float32](eventData[12..16])
        z = @ReadEndian[Float32](eventData[16..20])
    }

    public operator func ==(right: SensorEvent): Bool {
        sensorType == right.sensorType && x == right.x && y == right.y && z == right.z
    }

    public operator func !=(right: SensorEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(sensorType.value)
        hasher.write(x)
        hasher.write(y)
        hasher.write(z)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public enum Event <: Equatable<Event> & Hashable {
    | EvtClosed
    | EvtResized(SizeEvent)
    | EvtLostFocus
    | EvtGainedFocus
    | EvtTextEntered(TextEvent)
    | EvtKeyPressed(KeyEvent)
    | EvtKeyReleased(KeyEvent)
    | EvtMouseWheelScrolled(MouseWheelScrollEvent)
    | EvtMouseButtonPressed(MouseButtonEvent)
    | EvtMouseButtonReleased(MouseButtonEvent)
    | EvtMouseMoved(MouseMoveEvent)
    | EvtMouseEntered
    | EvtMouseLeft
    | EvtJoystickButtonPressed(JoystickButtonEvent)
    | EvtJoystickButtonReleased(JoystickButtonEvent)
    | EvtJoystickMoved(JoystickMoveEvent)
    | EvtJoystickConnected(JoystickConnectEvent)
    | EvtJoystickDisconnected(JoystickConnectEvent)
    | EvtTouchBegan(TouchEvent)
    | EvtTouchMoved(TouchEvent)
    | EvtTouchEnded(TouchEvent)
    | EvtSensorChanged(SensorEvent)
    | EvtUnknown

    public static func create(eventData: Array<Byte>): Event {
        match (EventType(@ReadEndian[Int32](eventData[0..4]))) {
            case e where e == EventType.Closed => EvtClosed
            case e where e == EventType.Resized => EvtResized(SizeEvent(eventData))
            case e where e == EventType.LostFocus => EvtLostFocus
            case e where e == EventType.GainedFocus => EvtGainedFocus
            case e where e == EventType.TextEntered => EvtTextEntered(TextEvent(eventData))
            case e where e == EventType.KeyPressed => EvtKeyPressed(KeyEvent(eventData))
            case e where e == EventType.KeyReleased => EvtKeyReleased(KeyEvent(eventData))
            case e where e == EventType.MouseWheelScrolled => EvtMouseWheelScrolled(MouseWheelScrollEvent(eventData))
            case e where e == EventType.MouseButtonPressed => EvtMouseButtonPressed(MouseButtonEvent(eventData))
            case e where e == EventType.MouseButtonReleased => EvtMouseButtonReleased(MouseButtonEvent(eventData))
            case e where e == EventType.MouseMoved => EvtMouseMoved(MouseMoveEvent(eventData))
            case e where e == EventType.MouseEntered => EvtMouseEntered
            case e where e == EventType.MouseLeft => EvtMouseLeft
            case e where e == EventType.JoystickButtonPressed => EvtJoystickButtonPressed(
                JoystickButtonEvent(eventData))
            case e where e == EventType.JoystickButtonReleased => EvtJoystickButtonReleased(
                JoystickButtonEvent(eventData))
            case e where e == EventType.JoystickMoved => EvtJoystickMoved(JoystickMoveEvent(eventData))
            case e where e == EventType.JoystickConnected => EvtJoystickConnected(JoystickConnectEvent(eventData))
            case e where e == EventType.JoystickDisconnected => EvtJoystickDisconnected(JoystickConnectEvent(eventData))
            case e where e == EventType.TouchBegan => EvtTouchBegan(TouchEvent(eventData))
            case e where e == EventType.TouchMoved => EvtTouchMoved(TouchEvent(eventData))
            case e where e == EventType.TouchEnded => EvtTouchEnded(TouchEvent(eventData))
            case e where e == EventType.SensorChanged => EvtSensorChanged(SensorEvent(eventData))
            case _ => EvtUnknown
        }
    }

    public operator func ==(right: Event): Bool {
        match ((this, right)) {
            case (EvtClosed, EvtClosed) => true
            case (EvtResized(evt1), EvtResized(evt2)) => evt1 == evt2
            case (EvtLostFocus, EvtLostFocus) => true
            case (EvtGainedFocus, EvtGainedFocus) => true
            case (EvtTextEntered(evt1), EvtTextEntered(evt2)) => evt1 == evt2
            case (EvtKeyPressed(evt1), EvtKeyPressed(evt2)) => evt1 == evt2
            case (EvtKeyReleased(evt1), EvtKeyReleased(evt2)) => evt1 == evt2
            case (EvtMouseWheelScrolled(evt1), EvtMouseWheelScrolled(evt2)) => evt1 == evt2
            case (EvtMouseButtonPressed(evt1), EvtMouseButtonPressed(evt2)) => evt1 == evt2
            case (EvtMouseButtonReleased(evt1), EvtMouseButtonReleased(evt2)) => evt1 == evt2
            case (EvtMouseMoved(evt1), EvtMouseMoved(evt2)) => evt1 == evt2
            case (EvtMouseEntered, EvtMouseEntered) => true
            case (EvtMouseLeft, EvtMouseLeft) => true
            case (EvtJoystickButtonPressed(evt1), EvtJoystickButtonPressed(evt2)) => evt1 == evt2
            case (EvtJoystickButtonReleased(evt1), EvtJoystickButtonReleased(evt2)) => evt1 == evt2
            case (EvtJoystickMoved(evt1), EvtJoystickMoved(evt2)) => evt1 == evt2
            case (EvtJoystickConnected(evt1), EvtJoystickConnected(evt2)) => evt1 == evt2
            case (EvtJoystickDisconnected(evt1), EvtJoystickDisconnected(evt2)) => evt1 == evt2
            case (EvtTouchBegan(evt1), EvtTouchBegan(evt2)) => evt1 == evt2
            case (EvtTouchMoved(evt1), EvtTouchMoved(evt2)) => evt1 == evt2
            case (EvtTouchEnded(evt1), EvtTouchEnded(evt2)) => evt1 == evt2
            case (EvtSensorChanged(evt1), EvtSensorChanged(evt2)) => evt1 == evt2
            case (EvtUnknown, EvtUnknown) => true
            case _ => false
        }
    }

    public operator func !=(right: Event): Bool {
        !(this == right)
    }

    public func hashCode(): Int64 {
        match (this) {
            case EvtClosed => 1
            case EvtResized(evt) => evt.hashCode(2)
            case EvtLostFocus => 3
            case EvtGainedFocus => 4
            case EvtTextEntered(evt) => evt.hashCode(5)
            case EvtKeyPressed(evt) => evt.hashCode(6)
            case EvtKeyReleased(evt) => evt.hashCode(7)
            case EvtMouseWheelScrolled(evt) => evt.hashCode(8)
            case EvtMouseButtonPressed(evt) => evt.hashCode(9)
            case EvtMouseButtonReleased(evt) => evt.hashCode(10)
            case EvtMouseMoved(evt) => evt.hashCode(11)
            case EvtMouseEntered => 12
            case EvtMouseLeft => 13
            case EvtJoystickButtonPressed(evt) => evt.hashCode(14)
            case EvtJoystickButtonReleased(evt) => evt.hashCode(15)
            case EvtJoystickMoved(evt) => evt.hashCode(16)
            case EvtJoystickConnected(evt) => evt.hashCode(17)
            case EvtJoystickDisconnected(evt) => evt.hashCode(18)
            case EvtTouchBegan(evt) => evt.hashCode(19)
            case EvtTouchMoved(evt) => evt.hashCode(20)
            case EvtTouchEnded(evt) => evt.hashCode(21)
            case EvtSensorChanged(evt) => evt.hashCode(22)
            case EvtUnknown => 23
        }
    }

    public static func getEmpty() {
        Array<Byte>(20, repeat: 0)
    }
}
