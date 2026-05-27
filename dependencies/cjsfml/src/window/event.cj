package cjsfml.window

import cenum.CEnum
import cjsfml.system.{Vector2i, Vector2u, Vector3f}
import endian.utils.ReadEndian
import std.binary.* // cjlint-ignore !G.PKG.01 don't import all

// cjlint-ignore -start !G.OPR.01 uncommon operator overloading
/**
 * Enumeration of the event types.
 */
@CEnum[public EventType](
    Closed // The window requested to be closed
    Resized // The window was resized
    FocusLost // The window lost the focus
    FocusGained // The window gained the focus
    TextEntered // A character was entered
    KeyPressed // A key was pressed
    KeyReleased // A key was released
    MouseWheelScrolled // The mouse wheel was scrolled
    MouseButtonPressed // A mouse button was pressed
    MouseButtonReleased // A mouse button was released
    MouseMoved // The mouse cursor moved
    MouseMovedRaw // The mouse cursor moved (raw data)
    MouseEntered // The mouse cursor entered the area of the window
    MouseLeft // The mouse cursor left the area of the window
    JoystickButtonPressed // A joystick button was pressed
    JoystickButtonReleased // A joystick button was released
    JoystickMoved // The joystick moved along an axis
    JoystickConnected // A joystick was connected
    JoystickDisconnected // A joystick was disconnected
    TouchBegan // A touch event began
    TouchMoved // A touch moved
    TouchEnded // A touch event ended
    SensorChanged // A sensor value changed
    Count // Keep last -- the total number of event types
)

/**
 * Key event subtype.
 *
 * Contains the details of a key press or release event.
 */
public struct KeyEvent <: Equatable<KeyEvent> & Hashable {
    /**
     * Construct a key event.
     *
     * @param code Code of the key
     * @param scancode Physical code of the key
     * @param alt Is the Alt key pressed?
     * @param control Is the Control key pressed?
     * @param shift Is the Shift key pressed?
     * @param system Is the System key pressed?
     */
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

/**
 * Text event subtype.
 *
 * Contains the details of a text entered event.
 */
public struct TextEvent <: Equatable<TextEvent> & Hashable {
    /**
     * Construct a text event.
     *
     * @param unicode UTF-32 Unicode value of the character
     */
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

/**
 * Mouse move event subtype.
 *
 * Contains the details of a mouse move event.
 */
public struct MouseMoveEvent <: Equatable<MouseMoveEvent> & Hashable {
    /**
     * Construct a mouse move event.
     *
     * @param position Position of the mouse cursor
     */
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

/**
 * Mouse move raw event subtype.
 *
 * Raw mouse input data comes unprocessed from the
 * operating system hence "raw". While the MouseMoved
 * position value is dependent on the screen resolution,
 * raw data is not. If the physical mouse is moved too
 * little to cause the screen cursor to move at least a
 * single pixel, no MouseMoved event will be generated. In
 * contrast, any movement information generated by the
 * mouse independent of its sensor resolution will always
 * generate a `MouseMovedRaw` event.
 *
 * In addition to screen resolution independence, raw
 * mouse data also does not have mouse acceleration or
 * smoothing applied to it as MouseMoved does.
 *
 * Raw mouse movement data is intended for controlling
 * non-cursor movement, e.g. controlling the camera
 * orientation in a first person view, whereas MouseMoved
 * is intended primarily for controlling things related to
 * the screen cursor hence the additional processing
 * applied to it.
 *
 * Currently, raw mouse input events will only be generated
 * on Windows and Linux.
 */
public struct MouseMoveEventRaw <: Equatable<MouseMoveEventRaw> & Hashable {
    /**
     * Construct a raw mouse move event.
     *
     * @param delta Delta movement of the mouse
     */
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

/**
 * Mouse button event subtype.
 *
 * Contains the details of a mouse button press or release event.
 */
public struct MouseButtonEvent <: Equatable<MouseButtonEvent> & Hashable {
    /**
     * Construct a mouse button event.
     *
     * @param button Code of the button
     * @param position Position of the mouse cursor
     */
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

/**
 * Mouse wheel scroll event subtype.
 *
 * Contains the details of a mouse wheel scroll event.
 */
public struct MouseWheelScrollEvent <: Equatable<MouseWheelScrollEvent> & Hashable {
    /**
     * Construct a mouse wheel scroll event.
     *
     * @param wheel Which wheel (for mice with multiple ones)
     * @param delta Wheel offset (positive is up/left, negative is down/right)
     * @param position Position of the mouse cursor
     */
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

/**
 * Joystick move event subtype.
 *
 * Contains the details of a joystick axis move event.
 */
public struct JoystickMoveEvent <: Equatable<JoystickMoveEvent> & Hashable {
    /**
     * Construct a joystick move event.
     *
     * @param joystickId Index of the joystick
     * @param axis Axis on which the joystick moved
     * @param position New position on the axis
     */
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

/**
 * Joystick button event subtype.
 *
 * Contains the details of a joystick button press or release event.
 */
public struct JoystickButtonEvent <: Equatable<JoystickButtonEvent> & Hashable {
    /**
     * Construct a joystick button event.
     *
     * @param joystickId Index of the joystick
     * @param button Index of the button
     */
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

/**
 * Joystick connect event subtype.
 *
 * Contains the details of a joystick connection or disconnection event.
 */
public struct JoystickConnectEvent <: Equatable<JoystickConnectEvent> & Hashable {
    /**
     * Construct a joystick connect event.
     *
     * @param joystickId Index of the joystick
     */
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

/**
 * Size event subtype.
 *
 * Contains the details of a window resize event.
 */
public struct SizeEvent <: Equatable<SizeEvent> & Hashable {
    /**
     * Construct a size event.
     *
     * @param size New size of the window
     */
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

/**
 * Touch event subtype.
 *
 * Contains the details of a touch event.
 */
public struct TouchEvent <: Equatable<TouchEvent> & Hashable {
    /**
     * Construct a touch event.
     *
     * @param finger Index of the finger
     * @param position Position of the touch
     */
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

/**
 * Sensor event subtype.
 *
 * Contains the details of a sensor value change event.
 */
public struct SensorEvent <: Equatable<SensorEvent> & Hashable {
    /**
     * Construct a sensor event.
     *
     * @param sensorType Type of the sensor
     * @param value Current value of the sensor
     */
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

/**
 * Defines a system event and its parameters.
 *
 * `Event` holds all the information about a system event
 * that just happened. Events are retrieved using the
 * `Window.pollEvent` and `Window.waitEvent` functions.
 *
 * A `Event` instance contains the subtype of the event
 * (mouse moved, key pressed, window closed, ...) as well
 * as the details about this particular event. Each event
 * corresponds to a different subtype struct which contains
 * the data required to process that event.
 *
 * The way to access the current active event subtype is via
 * pattern matching on the enum variants.
 *
 * Usage example:
 * ```
 * while (let event = window.pollEvent()) {
 *     match (event) {
 *         case EvtClosed => window.close()
 *         case EvtKeyPressed(evt) => if (evt.code == KeyCode.Escape) window.close()
 *         case EvtResized(evt) => doSomethingWithTheNewSize(evt.size)
 *         case _ => ()
 *     }
 * }
 * ```
 */
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

    /**
     * Create an event from raw event data.
     *
     * @param eventData Raw event data byte array
     * @return The constructed Event
     */
    public static func create(eventData: Array<Byte>): Event {
        let evt = EventType(@ReadEndian[Int32](eventData[0..4]))
        match {
            case evt == EventType.Closed => EvtClosed
            case evt == EventType.Resized => EvtResized(SizeEvent(eventData))
            case evt == EventType.FocusLost => EvtFocusLost
            case evt == EventType.FocusGained => EvtFocusGained
            case evt == EventType.TextEntered => EvtTextEntered(TextEvent(eventData))
            case evt == EventType.KeyPressed => EvtKeyPressed(KeyEvent(eventData))
            case evt == EventType.KeyReleased => EvtKeyReleased(KeyEvent(eventData))
            case evt == EventType.MouseWheelScrolled => EvtMouseWheelScrolled(MouseWheelScrollEvent(eventData))
            case evt == EventType.MouseButtonPressed => EvtMouseButtonPressed(MouseButtonEvent(eventData))
            case evt == EventType.MouseButtonReleased => EvtMouseButtonReleased(MouseButtonEvent(eventData))
            case evt == EventType.MouseMoved => EvtMouseMoved(MouseMoveEvent(eventData))
            case evt == EventType.MouseMovedRaw => EvtMouseMovedRaw(MouseMoveEventRaw(eventData))
            case evt == EventType.MouseEntered => EvtMouseEntered
            case evt == EventType.MouseLeft => EvtMouseLeft
            case evt == EventType.JoystickButtonPressed => EvtJoystickButtonPressed(JoystickButtonEvent(eventData))
            case evt == EventType.JoystickButtonReleased => EvtJoystickButtonReleased(JoystickButtonEvent(eventData))
            case evt == EventType.JoystickMoved => EvtJoystickMoved(JoystickMoveEvent(eventData))
            case evt == EventType.JoystickConnected => EvtJoystickConnected(JoystickConnectEvent(eventData))
            case evt == EventType.JoystickDisconnected => EvtJoystickDisconnected(JoystickConnectEvent(eventData))
            case evt == EventType.TouchBegan => EvtTouchBegan(TouchEvent(eventData))
            case evt == EventType.TouchMoved => EvtTouchMoved(TouchEvent(eventData))
            case evt == EventType.TouchEnded => EvtTouchEnded(TouchEvent(eventData))
            case evt == EventType.SensorChanged => EvtSensorChanged(SensorEvent(eventData))
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

    /**
     * Get an empty byte array for event data.
     *
     * @return Empty byte array
     */
    public static func getEmpty(): Array<Byte> {
        Array<Byte>(20, repeat: 0)
    }
}

// cjlint-ignore -end uncommon operator overloading
