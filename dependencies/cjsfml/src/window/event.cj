package cjsfml.window

import cenum.CEnum
import cjsfml.system.{Vector2i, Vector2u, Vector3f}
import endian.utils.ReadEndian
import std.binary.* // cjlint-ignore !G.PKG.01 don't import all

// cjlint-ignore -start !G.OPR.01 uncommon operator overloading
@CEnum[public EventType](
    Closed
    Resized
    FocusLost
    FocusGained
    TextEntered
    KeyPressed
    KeyReleased
    MouseWheelScrolled
    MouseButtonPressed
    MouseButtonReleased
    MouseMoved
    MouseMovedRaw
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
    public const MouseMoveEvent(public var position!: Vector2i = Vector2i()) {}

    public init(eventData: Array<Byte>) {
        position = Vector2i(
            @ReadEndian[Int32](eventData[4..8]),
            @ReadEndian[Int32](eventData[8..12])
        )
    }

    public operator func ==(right: MouseMoveEvent): Bool {
        position == right.position
    }

    public operator func !=(right: MouseMoveEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(position.x)
        hasher.write(position.y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct MouseMoveEventRaw <: Equatable<MouseMoveEventRaw> & Hashable {
    public const MouseMoveEventRaw(public var delta!: Vector2i = Vector2i()) {}

    public init(eventData: Array<Byte>) {
        delta = Vector2i(
            @ReadEndian[Int32](eventData[4..8]),
            @ReadEndian[Int32](eventData[8..12])
        )
    }

    public operator func ==(right: MouseMoveEventRaw): Bool {
        delta == right.delta
    }

    public operator func !=(right: MouseMoveEventRaw): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(delta.x)
        hasher.write(delta.y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct MouseButtonEvent <: Equatable<MouseButtonEvent> & Hashable {
    public const MouseButtonEvent(
        public var button!: MouseButton = MouseButton.Left,
        public var position!: Vector2i = Vector2i()
    ) {}

    public init(eventData: Array<Byte>) {
        button = MouseButton(@ReadEndian[Int32](eventData[4..8]))
        position = Vector2i(
            @ReadEndian[Int32](eventData[8..12]),
            @ReadEndian[Int32](eventData[12..16])
        )
    }

    public operator func ==(right: MouseButtonEvent): Bool {
        button == right.button && position == right.position
    }

    public operator func !=(right: MouseButtonEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(button.value)
        hasher.write(position.x)
        hasher.write(position.y)
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
        public var position!: Vector2i = Vector2i()
    ) {}

    public init(eventData: Array<Byte>) {
        wheel = MouseWheel(@ReadEndian[Int32](eventData[4..8]))
        delta = @ReadEndian[Float32](eventData[8..12])
        position = Vector2i(
            @ReadEndian[Int32](eventData[12..16]),
            @ReadEndian[Int32](eventData[16..20])
        )
    }

    public operator func ==(right: MouseWheelScrollEvent): Bool {
        wheel == right.wheel && delta == right.delta && position == right.position // cjlint-ignore !G.EXP.02 comparing floats
    }

    public operator func !=(right: MouseWheelScrollEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(wheel.value)
        hasher.write(delta)
        hasher.write(position.x)
        hasher.write(position.y)
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
        joystickId == right.joystickId && axis == right.axis && position == right.position // cjlint-ignore !G.EXP.02 comparing floats
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
    public const SizeEvent(public var size!: Vector2u = Vector2u()) {}

    public init(eventData: Array<Byte>) {
        size = Vector2u(
            @ReadEndian[UInt32](eventData[4..8]),
            @ReadEndian[UInt32](eventData[8..12])
        )
    }

    public operator func ==(right: SizeEvent): Bool {
        size == right.size
    }

    public operator func !=(right: SizeEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(size.x)
        hasher.write(size.y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct TouchEvent <: Equatable<TouchEvent> & Hashable {
    public const TouchEvent(
        public var finger!: UInt32 = 0,
        public var position!: Vector2i = Vector2i()
    ) {}

    public init(eventData: Array<Byte>) {
        finger = @ReadEndian[UInt32](eventData[4..8])
        position = Vector2i(
            @ReadEndian[Int32](eventData[8..12]),
            @ReadEndian[Int32](eventData[12..16])
        )
    }

    public operator func ==(right: TouchEvent): Bool {
        finger == right.finger && position == right.position
    }

    public operator func !=(right: TouchEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(finger)
        hasher.write(position.x)
        hasher.write(position.y)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public struct SensorEvent <: Equatable<SensorEvent> & Hashable {
    public const SensorEvent(
        public var sensorType!: SensorType = SensorType.Accelerometer,
        public var value!: Vector3f = Vector3f()
    ) {}

    public init(eventData: Array<Byte>) {
        sensorType = SensorType(@ReadEndian[Int32](eventData[4..8]))
        value = Vector3f(
            @ReadEndian[Float32](eventData[8..12]),
            @ReadEndian[Float32](eventData[12..16]),
            @ReadEndian[Float32](eventData[16..20])
        )
    }

    public operator func ==(right: SensorEvent): Bool {
        sensorType == right.sensorType && value == right.value
    }

    public operator func !=(right: SensorEvent): Bool {
        !(this == right)
    }

    public func hashCode(res: Int64): Int64 {
        var hasher = DefaultHasher(res: res)
        hasher.write(sensorType.value)
        hasher.write(value.x)
        hasher.write(value.y)
        hasher.write(value.z)
        return hasher.finish()
    }

    public func hashCode(): Int64 {
        hashCode(0)
    }
}

public enum Event <: Equatable<Event> & Hashable {
    | EvtClosed
    | EvtResized(SizeEvent)
    | EvtFocusLost
    | EvtFocusGained
    | EvtTextEntered(TextEvent)
    | EvtKeyPressed(KeyEvent)
    | EvtKeyReleased(KeyEvent)
    | EvtMouseWheelScrolled(MouseWheelScrollEvent)
    | EvtMouseButtonPressed(MouseButtonEvent)
    | EvtMouseButtonReleased(MouseButtonEvent)
    | EvtMouseMoved(MouseMoveEvent)
    | EvtMouseMovedRaw(MouseMoveEventRaw)
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
            case e where e == EventType.FocusLost => EvtFocusLost
            case e where e == EventType.FocusGained => EvtFocusGained
            case e where e == EventType.TextEntered => EvtTextEntered(TextEvent(eventData))
            case e where e == EventType.KeyPressed => EvtKeyPressed(KeyEvent(eventData))
            case e where e == EventType.KeyReleased => EvtKeyReleased(KeyEvent(eventData))
            case e where e == EventType.MouseWheelScrolled => EvtMouseWheelScrolled(MouseWheelScrollEvent(eventData))
            case e where e == EventType.MouseButtonPressed => EvtMouseButtonPressed(MouseButtonEvent(eventData))
            case e where e == EventType.MouseButtonReleased => EvtMouseButtonReleased(MouseButtonEvent(eventData))
            case e where e == EventType.MouseMoved => EvtMouseMoved(MouseMoveEvent(eventData))
            case e where e == EventType.MouseMovedRaw => EvtMouseMovedRaw(MouseMoveEventRaw(eventData))
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
            case (EvtFocusLost, EvtFocusLost) => true
            case (EvtFocusGained, EvtFocusGained) => true
            case (EvtTextEntered(evt1), EvtTextEntered(evt2)) => evt1 == evt2
            case (EvtKeyPressed(evt1), EvtKeyPressed(evt2)) => evt1 == evt2
            case (EvtKeyReleased(evt1), EvtKeyReleased(evt2)) => evt1 == evt2
            case (EvtMouseWheelScrolled(evt1), EvtMouseWheelScrolled(evt2)) => evt1 == evt2
            case (EvtMouseButtonPressed(evt1), EvtMouseButtonPressed(evt2)) => evt1 == evt2
            case (EvtMouseButtonReleased(evt1), EvtMouseButtonReleased(evt2)) => evt1 == evt2
            case (EvtMouseMoved(evt1), EvtMouseMoved(evt2)) => evt1 == evt2
            case (EvtMouseMovedRaw(evt1), EvtMouseMovedRaw(evt2)) => evt1 == evt2
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
            case EvtFocusLost => 3
            case EvtFocusGained => 4
            case EvtTextEntered(evt) => evt.hashCode(5)
            case EvtKeyPressed(evt) => evt.hashCode(6)
            case EvtKeyReleased(evt) => evt.hashCode(7)
            case EvtMouseWheelScrolled(evt) => evt.hashCode(8)
            case EvtMouseButtonPressed(evt) => evt.hashCode(9)
            case EvtMouseButtonReleased(evt) => evt.hashCode(10)
            case EvtMouseMoved(evt) => evt.hashCode(11)
            case EvtMouseMovedRaw(evt) => evt.hashCode(12)
            case EvtMouseEntered => 13
            case EvtMouseLeft => 14
            case EvtJoystickButtonPressed(evt) => evt.hashCode(15)
            case EvtJoystickButtonReleased(evt) => evt.hashCode(16)
            case EvtJoystickMoved(evt) => evt.hashCode(17)
            case EvtJoystickConnected(evt) => evt.hashCode(18)
            case EvtJoystickDisconnected(evt) => evt.hashCode(19)
            case EvtTouchBegan(evt) => evt.hashCode(20)
            case EvtTouchMoved(evt) => evt.hashCode(21)
            case EvtTouchEnded(evt) => evt.hashCode(22)
            case EvtSensorChanged(evt) => evt.hashCode(23)
            case EvtUnknown => 24
        }
    }

    public static func getEmpty(): Array<Byte> {
        Array<Byte>(20, repeat: 0)
    }
}

// cjlint-ignore -end uncommon operator overloading
