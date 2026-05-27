package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import ctemplate.*
import std.collection.*
import std.convert.*
import std.math.*
import stdjson2.*

public func getAnchorVal(elem: JsonValue, default!: Anchor = Anchor.Top | Anchor.Left): Anchor {
    if (let Some(str) <- elem.getString()) {
        Anchor.get(str, default: default)
    } else if (elem.isArray()) {
        var ret = Anchor.None
        for (elem in elem) {
            ret |= Anchor.get(getStringChar(elem), default: default)
        }
        ret
    } else {
        default
    }
}

public func getAnimationTypeVal(elem: JsonValue, default!: AnimationType = AnimationType.Looped): AnimationType {
    if (let Some(str) <- elem.getString()) {
        AnimationType.get(str, default: default)
    } else {
        default
    }
}

public func getBindingFlagsVal(elem: JsonValue, default!: BindingFlags = BindingFlags.OnChange): BindingFlags {
    if (let Some(str) <- elem.getString()) {
        BindingFlags.get(str, default: default)
    } else if (elem.isArray()) {
        var ret = BindingFlags.OnChange
        for (elem in elem) {
            ret |= BindingFlags.get(getStringChar(elem), default: default)
        }
        ret
    } else {
        default
    }
}

public func getBlendModeVal(elem: JsonValue, default!: BlendModeType = BlendAlpha): BlendModeType {
    if (let Some(str) <- elem.getString()) {
        BlendModeType.get(str, default: default)
    } else {
        default
    }
}

public func getDirectionVal(elem: JsonValue, default!: Direction = Direction.Up): Direction {
    if (let Some(str) <- elem.getString()) {
        Direction.get(str, default: default)
    } else {
        default
    }
}

public func getBoolVal(elem: JsonValue, default!: Bool = false): Bool {
    elem.getBool() ?? default
}

public func getDoubleVal(elem: JsonValue, default!: Float64 = 0.0): Float64 {
    elem.getFloat64() ?? default
}

public func getFloatVal(elem: JsonValue, default!: Float32 = 0.0): Float32 {
    elem.getFloat32() ?? default
}

public func getIntVal(elem: JsonValue, default!: Int32 = 0): Int32 {
    elem.getInt32() ?? default
}

public func getInt64Val(elem: JsonValue, default!: Int64 = 0): Int64 {
    elem.getInt64() ?? default
}

public func getStringChar(elem: JsonValue, default!: String = String.empty): String {
    elem.getString() ?? default
}

public func getStringVal(elem: JsonValue, default!: String = String.empty): String {
    if (let Some(str) <- elem.getString()) {
        str
    } else if (let Some(value) <- elem.getInt64()) {
        value.toString()
    } else if (let Some(value) <- elem.getFloat64()) {
        toString(value)
    } else {
        default
    }
}

public func getUIntVal(elem: JsonValue, default!: UInt32 = 0): UInt32 {
    elem.getUInt32() ?? default
}

public func getUInt64Val(elem: JsonValue, default!: UInt64 = 0): UInt64 {
    elem.getUInt64() ?? default
}

// gets a number based on its type

@OverflowWrapping
public func getNumberVal(elem: JsonValue, default!: Int32): Int32 {
    if (let Some(value) <- elem.getInt32()) {
        return value
    } else if (let Some(d) <- elem.getFloat64()) {
        let f = Float32(d)
        if (Int64(d) == Int64(f)) {
            return Int32(f)
        }
    }
    return default
}

@OverflowWrapping
public func getNumberVal(elem: JsonValue, default!: Int64): Int64 {
    if (let Some(value) <- elem.getInt64()) {
        return value
    } else if (let Some(value) <- elem.getFloat64()) {
        return Int64(value)
    }
    return default
}

@OverflowWrapping
public func getNumberVal(elem: JsonValue, default!: UInt32): UInt32 {
    if (let Some(value) <- elem.getUInt32()) {
        return value
    } else if (let Some(d) <- elem.getFloat64()) {
        let f = Float32(d)
        if (Int64(d) == Int64(f) && f >= 0.0) {
            return UInt32(f)
        }
    }
    return default
}

@OverflowWrapping
public func getNumberVal(elem: JsonValue, default!: UInt64): UInt64 {
    if (let Some(value) <- elem.getUInt64()) {
        return value
    } else if (let Some(value) <- elem.getFloat64()) {
        if (value >= 0.0) {
            return UInt64(value)
        }
    }
    return default
}

@OverflowWrapping
public func getNumberVal(elem: JsonValue, default!: Float32): Float32 {
    if (let Some(d) <- elem.getFloat64()) {
        let f = Float32(d)
        if (Int64(d) == Int64(f)) {
            return f
        }
    } else if (let Some(value) <- elem.getInt64()) {
        return Float32(value)
    }
    return default
}

@OverflowWrapping
public func getNumberVal(elem: JsonValue, default!: Float64): Float64 {
    if (let Some(value) <- elem.getFloat64()) {
        return value
    } else if (let Some(value) <- elem.getInt64()) {
        return Float64(value)
    }
    return default
}

// gets a number based on its type
// if the number is below 0, val is returned

public func getUnsignedNumberVal(elem: JsonValue, default!: Int32): Int32 {
    let num = getNumberVal(elem, default: default)
    if (num >= 0) {
        return num
    }
    return default
}

public func getUnsignedNumberVal(elem: JsonValue, default!: Int64): Int64 {
    let num = getNumberVal(elem, default: default)
    if (num >= 0) {
        return num
    }
    return default
}

public func getUnsignedNumberVal(elem: JsonValue, default!: UInt32): UInt32 {
    getNumberVal(elem, default: default)
}

public func getUnsignedNumberVal(elem: JsonValue, default!: UInt64): UInt64 {
    getNumberVal(elem, default: default)
}

public func getUnsignedNumberVal(elem: JsonValue, default!: Float32): Float32 {
    let num = getNumberVal(elem, default: default)
    if (num >= 0.0) {
        return num
    }
    return default
}

public func getUnsignedNumberVal(elem: JsonValue, default!: Float64): Float64 {
    let num = getNumberVal(elem, default: default)
    if (num >= 0.0) {
        return num
    }
    return default
}

public func getVector2NumberVal(elem: JsonValue, default!: Vector2f): Vector2f {
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => Vector2f(
                getNumberVal(elem0, default: 0.0f32),
                getNumberVal(elem1, default: 0.0f32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector2NumberVal(elem: JsonValue, default!: Vector2i): Vector2i { // cjlint-ignore !G.DCL.01 function name already exists
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => Vector2i(
                getNumberVal(elem0, default: 0i32),
                getNumberVal(elem1, default: 0i32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector2NumberVal(elem: JsonValue, default!: Vector2u): Vector2u { // cjlint-ignore !G.DCL.01 function name already exists
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => Vector2u(
                getNumberVal(elem0, default: 0u32),
                getNumberVal(elem1, default: 0u32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector2UnsignedNumberVal(elem: JsonValue, default!: Vector2f): Vector2f {
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => Vector2f(
                getUnsignedNumberVal(elem0, default: 0.0f32),
                getUnsignedNumberVal(elem1, default: 0.0f32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector2UnsignedNumberVal(elem: JsonValue, default!: Vector2i): Vector2i { // cjlint-ignore !G.DCL.01 function name already exists
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => Vector2i(
                getUnsignedNumberVal(elem0, default: 0i32),
                getUnsignedNumberVal(elem1, default: 0i32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector2UnsignedNumberVal(elem: JsonValue, default!: Vector2u): Vector2u { // cjlint-ignore !G.DCL.01 function name already exists
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => Vector2u(
                getUnsignedNumberVal(elem0, default: 0u32),
                getUnsignedNumberVal(elem1, default: 0u32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector2fVal(elem: JsonValue, default!: Vector2f = Vector2f()): Vector2f {
    getVector2NumberVal(elem, default: default)
}

public func getVector2iVal(elem: JsonValue, default!: Vector2i = Vector2i()): Vector2i {
    getVector2NumberVal(elem, default: default)
}

public func getVector2uVal(elem: JsonValue, default!: Vector2u = Vector2u()): Vector2u {
    getVector2NumberVal(elem, default: default)
}

public func getUnsignedVector2fVal(elem: JsonValue, default!: Vector2f = Vector2f()): Vector2f {
    getVector2UnsignedNumberVal(elem, default: default)
}

public func getUnsignedVector2iVal(elem: JsonValue, default!: Vector2i = Vector2i()): Vector2i {
    getVector2UnsignedNumberVal(elem, default: default)
}

public func getUnsignedVector2uVal(elem: JsonValue, default!: Vector2u = Vector2u()): Vector2u {
    getVector2UnsignedNumberVal(elem, default: default)
}

public func getVector3NumberVal(elem: JsonValue, default!: Vector3f): Vector3f {
    match {
        case elem.size > 2 => match ((elem.get(0), elem.get(1), elem.get(2))) {
            case (Some(elem0), Some(elem1), Some(elem2)) where elem0.isNumber() && elem1.isNumber() && elem2.isNumber() => Vector3f(
                getNumberVal(elem0, default: 0.0f32),
                getNumberVal(elem1, default: 0.0f32),
                getNumberVal(elem2, default: 0.0f32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector3NumberVal(elem: JsonValue, default!: Vector3i): Vector3i { // cjlint-ignore !G.DCL.01 function name already exists
    match {
        case elem.size > 2 => match ((elem.get(0), elem.get(1), elem.get(2))) {
            case (Some(elem0), Some(elem1), Some(elem2)) where elem0.isNumber() && elem1.isNumber() && elem2.isNumber() => Vector3i(
                getNumberVal(elem0, default: 0i32),
                getNumberVal(elem1, default: 0i32),
                getNumberVal(elem2, default: 0i32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector4NumberVal(elem: JsonValue, default!: FloatRect): FloatRect {
    match {
        case elem.size > 3 => match ((elem.get(0), elem.get(1), elem.get(2), elem.get(3))) {
            case (Some(elem0), Some(elem1), Some(elem2), Some(elem3)) where elem0.isNumber() && elem1.isNumber() &&
                elem2.isNumber() && elem3.isNumber() => FloatRect(
                getNumberVal(elem0, default: 0.0f32),
                getNumberVal(elem1, default: 0.0f32),
                getNumberVal(elem2, default: 0.0f32),
                getNumberVal(elem3, default: 0.0f32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getVector4NumberVal(elem: JsonValue, default!: IntRect): IntRect { // cjlint-ignore !G.DCL.01 function name already exists
    match {
        case elem.size > 3 => match ((elem.get(0), elem.get(1), elem.get(2), elem.get(3))) {
            case (Some(elem0), Some(elem1), Some(elem2), Some(elem3)) where elem0.isNumber() && elem1.isNumber() &&
                elem2.isNumber() && elem3.isNumber() => IntRect(
                getNumberVal(elem0, default: 0i32),
                getNumberVal(elem1, default: 0i32),
                getNumberVal(elem2, default: 0i32),
                getNumberVal(elem3, default: 0i32)
            )
            case _ => default
        }
        case _ => default
    }
}

@Template[T: Int32, UInt32](
public func getRangeOrValueVal(elem: JsonValue, default!: (T, T)): (T, T) {
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => (
                getNumberVal(elem0, default: 0),
                getNumberVal(elem1, default: 0)
            )
            case _ => default
        }
        case elem.isNumber() =>
            let v: T = getNumberVal(elem, default: 0)
            (v, v)
        case _ => default
    }
})

@Template[T: Int32, UInt32](
public func getRangeNVal(elem: JsonValue, minVal!: T, default!: (T, T)): (T, T) {
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) where elem0.isNumber() && elem1.isNumber() => (
                getNumberVal(elem0, default: 0),
                getNumberVal(elem1, default: 0)
            )
            case _ => default
        }
        case elem.isNumber() => (minVal, getNumberVal(elem, default: 0))
        case _ => default
    }
})

@Template[T: Int32, UInt32](
public func getRange0Val(elem: JsonValue, default!: (T, T)): (T, T) {
    getRangeNVal(elem, minVal: 0, default: default)
})

@Template[T: Int32, UInt32](
public func getRange1Val(elem: JsonValue, default!: (T, T)): (T, T) {
    getRangeNVal(elem, minVal: 1, default: default)
})

public func getPositionVal(elem: JsonValue, size: Vector2f, refSize: Vector2u): Vector2f {
    var value = Vector2f()
    match {
        case elem.size > 1 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) =>
                if (elem0.isNumber()) {
                    value.x = round(getNumberVal(elem0, default: 0.0f32))
                } else if (let Some(str) <- elem0.getString()) {
                    match (HorizontalAlign.get(str)) {
                        case AlignLeft => ()
                        case AlignCenter => value.x = round((Float32(refSize.x) / 2.0) - (size.x / 2.0))
                        case AlignRight => value.x = Float32(refSize.x) - size.x
                    }
                }
                if (elem1.isNumber()) {
                    value.y = round(getNumberVal(elem1, default: 0.0f32))
                } else if (let Some(str) <- elem1.getString()) {
                    match (VerticalAlign.get(str)) {
                        case AlignTop => ()
                        case AlignCenter => value.y = round((Float32(refSize.y) / 2.0) - (size.y / 2.0))
                        case AlignBottom => value.y = Float32(refSize.y) - size.y
                    }
                }
            case _ => ()
        }
        case _ => ()
    }
    return value
}

public func getSizeVal(elem: JsonValue, default!: Vector2f = Vector2f()): Vector2f {
    var size = getVector2fVal(elem, default: default)
    size.x = round(size.x)
    size.y = round(size.y)
    return size
}

public func getFloatRectVal(elem: JsonValue, default!: FloatRect = FloatRect()): FloatRect {
    match (elem.size) {
        case size where size >= 4 => match ((elem.get(0), elem.get(1), elem.get(2), elem.get(3))) {
            case (Some(elem0), Some(elem1), Some(elem2), Some(elem3)) => FloatRect(
                getNumberVal(elem0, default: 0.0f32),
                getNumberVal(elem1, default: 0.0f32),
                getNumberVal(elem2, default: 0.0f32),
                getNumberVal(elem3, default: 0.0f32)
            )
            case _ => default
        }
        case size where size >= 2 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) => FloatRect(
                0.0,
                0.0,
                getNumberVal(elem0, default: 0.0f32),
                getNumberVal(elem1, default: 0.0f32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getIntRectVal(elem: JsonValue, default!: IntRect = IntRect()): IntRect {
    match (elem.size) {
        case size where size >= 4 => match ((elem.get(0), elem.get(1), elem.get(2), elem.get(3))) {
            case (Some(elem0), Some(elem1), Some(elem2), Some(elem3)) => IntRect(
                getNumberVal(elem0, default: 0i32),
                getNumberVal(elem1, default: 0i32),
                getNumberVal(elem2, default: 0i32),
                getNumberVal(elem3, default: 0i32)
            )
            case _ => default
        }
        case size where size >= 2 => match ((elem.get(0), elem.get(1))) {
            case (Some(elem0), Some(elem1)) => IntRect(
                0,
                0,
                getNumberVal(elem0, default: 0i32),
                getNumberVal(elem1, default: 0i32)
            )
            case _ => default
        }
        case _ => default
    }
}

public func getColorVal(elem: JsonValue, default!: Color = Color()): Color {
    if (let Some(str) <- elem.getString()) {
        match (SFMLUtils.stringToColor(str)) {
            case Some(color) => color
            case None => default
        }
    } else if (let Some(value) <- elem.getUInt32()) {
        SFMLUtils.rgbaToColor(value)
    } else {
        match (elem.size) {
            case size where size == 3 => match ((elem.get(0), elem.get(1), elem.get(2))) {
                case (Some(elem0), Some(elem1), Some(elem2)) => Color(
                    UInt8(getNumberVal(elem0, default: 0i32)),
                    UInt8(getNumberVal(elem1, default: 0i32)),
                    UInt8(getNumberVal(elem2, default: 0i32))
                )
                case _ => default
            }
            case size where size > 3 => match ((elem.get(0), elem.get(1), elem.get(2), elem.get(3))) {
                case (Some(elem0), Some(elem1), Some(elem2), Some(elem3)) => Color(
                    UInt8(getNumberVal(elem0, default: 0i32)),
                    UInt8(getNumberVal(elem1, default: 0i32)),
                    UInt8(getNumberVal(elem2, default: 0i32)),
                    UInt8(getNumberVal(elem3, default: 0i32))
                )
                case _ => default
            }
            case _ => default
        }
    }
}

public func getKeyCodeVal(elem: JsonValue, default!: KeyCode = KeyCode.Unknown): KeyCode {
    if (let Some(value) <- elem.getInt32()) {
        GameUtils.getKeyCode(value, default: default)
    } else if (let Some(str) <- elem.getString()) {
        GameUtils.getKeyCode(str, default: default)
    } else {
        default
    }
}

public func getScanCodeVal(elem: JsonValue, default!: Scancode = Scancode.Unknown): Scancode {
    if (let Some(value) <- elem.getInt32()) {
        GameUtils.getScanCode(value, default: default)
    } else if (let Some(str) <- elem.getString()) {
        GameUtils.getScanCode(str, default: default)
    } else {
        default
    }
}

public func getTextStyleVal(elem: JsonValue, default!: TextStyle = TextStyle.Regular): TextStyle {
    if (let Some(str) <- elem.getString()) {
        GameUtils.getTextStyle(str, default: default)
    } else if (elem.isArray()) {
        var ret = TextStyle.Regular
        for (elem in elem) {
            ret |= GameUtils.getTextStyle(getStringChar(elem), default: default)
        }
        ret
    } else {
        default
    }
}

public func getTimeVal(elem: JsonValue, default!: Time = Time.ZERO): Time {
    if (let Some(value) <- elem.getInt32()) {
        Time(milliseconds: value)
    } else if (let Some(value) <- elem.getFloat32()) {
        Time(seconds: value)
    } else if (let Some(str) <- elem.getString()) {
        var h = 0i32
        var m = 0i32
        var s = 0i32
        var ms = 0i32
        var sv = splitStringIn2(str, '.')
        let negativeTime = sv[0].startsWith('-')
        if (sv[1].isEmpty() == false) {
            ms = abs(Int32.tryParse(sv[1]) ?? 0)
        }
        sv = splitStringIn2(sv[0], ':')
        if (sv[1].isEmpty() == false) {
            let sv2 = splitStringIn2(sv[1], ':')
            if (sv2[1].isEmpty() == false) {
                h = abs(Int32.tryParse(sv[0]) ?? 0)
                m = abs(Int32.tryParse(sv2[0]) ?? 0)
                s = abs(Int32.tryParse(sv2[1]) ?? 0)
            } else {
                m = abs(Int32.tryParse(sv[0]) ?? 0)
                s = abs(Int32.tryParse(sv2[0]) ?? 0)
            }
        } else {
            match (Int32.tryParse(sv[0])) {
                case Some(seconds) => s = abs(seconds)
                case _ => return default
            }
        }
        var totalms = (((h * 3600) + (m * 60) + s) * 1000) + (ms * 100)
        if (negativeTime == true) {
            totalms = -totalms
        }
        Time(milliseconds: totalms)
    } else {
        default
    }
}

// positive time. returns default if time is negative
public func getTimeUVal(elem: JsonValue, default!: Time = Time.ZERO): Time {
    let time = getTimeVal(elem, default: default)
    if (time.microseconds < 0) {
        return default
    }
    return time
}

public func getStringVectorVal(elem: JsonValue): ArrayList<String> {
    let list = ArrayList<String>()
    if (let Some(str) <- elem.getString()) {
        list.add(str)
    } else if (elem.isArray()) {
        for (elem in elem) {
            list.add(JsonUtils.toString(elem))
        }
    }
    return list
}

public func getValidStringVectorVal(elem: JsonValue): ArrayList<String> {
    let list = ArrayList<String>()
    if (let Some(str) <- elem.getString()) {
        if (let Some(validStr) <- getValidString(elem)) {
            list.add(validStr)
        }
    } else if (elem.isArray()) {
        for (elem in elem) {
            if (let Some(validStr) <- getValidString(elem)) {
                list.add(validStr)
            }
        }
    }
    return list
}

public func getIgnoreResourceVal(elem: JsonValue, default!: IgnoreResource = IgnoreResource.None): IgnoreResource {
    if (let Some(value) <- elem.getBool()) {
        match (value) {
            case true => IgnoreResource.Draw | IgnoreResource.Update
            case false => IgnoreResource.None
        }
    } else if (let Some(str) <- elem.getString()) {
        IgnoreResource.get(str, default: default)
    } else if (elem.isArray()) {
        var ret = IgnoreResource.None
        for (elem in elem) {
            ret |= IgnoreResource.get(getStringChar(elem), default: default)
        }
        ret
    } else {
        default
    }
}

public func getInputEventTypeVal(elem: JsonValue, default!: InputEventType = InputEventType.None): InputEventType {
    if (let Some(value) <- elem.getBool()) {
        match (value) {
            case true => InputEventType.All
            case false => InputEventType.None
        }
    } else if (let Some(str) <- elem.getString()) {
        InputEventType.get(str, default: default)
    } else if (elem.isArray()) {
        var ret = InputEventType.None
        for (elem in elem) {
            ret |= InputEventType.get(getStringChar(elem), default: default)
        }
        ret
    } else {
        default
    }
}

// returns a 32 bit number from the json element.

public func getMinMaxIntVal(elem: JsonValue, default!: Int32): Int32 {
    if (let Some(value) <- elem.getInt32()) {
        return value
    } else if (let Some(value) <- elem.getFloat32()) {
        return Int32(value)
    } else if (let Some(value) <- elem.getBool()) {
        return match (value) {
            case true => 1
            case false => 0
        }
    } else if (let Some(str) <- elem.getString()) {
        return match (str) {
            case "min" => Int32.Min
            case "max" => Int32.Max
            case _ => default
        }
    }
    return default
}

public func getMinMaxIntVal(elem: JsonValue, default!: UInt32): UInt32 {
    if (let Some(value) <- elem.getUInt32()) {
        return value
    } else if (let Some(value) <- elem.getFloat32()) {
        return UInt32(value)
    } else if (let Some(value) <- elem.getBool()) {
        return match (value) {
            case true => 1
            case false => 0
        }
    } else if (let Some(str) <- elem.getString()) {
        return match (str) {
            case "min" => UInt32.Min
            case "max" => UInt32.Max
            case _ => default
        }
    }
    return default
}

public func getMinMaxIntVal(elem: JsonValue, default!: Float32): Float32 {
    if (let Some(value) <- elem.getFloat32()) {
        return value
    } else if (let Some(value) <- elem.getInt64()) {
        return Float32(value)
    } else if (let Some(value) <- elem.getBool()) {
        return match (value) {
            case true => 1.0
            case false => 0.0
        }
    } else if (let Some(str) <- elem.getString()) {
        return match (str) {
            case "min" => Float32.Min
            case "max" => Float32.Max
            case _ => default
        }
    }
    return default
}

@OverflowWrapping
public func getMinMaxNumber32Val(elem: JsonValue, default!: Number32 = NumberInt(0)): Number32 {
    if (let Some(value) <- elem.getUInt32()) {
        return NumberUInt(value)
    } else if (let Some(value) <- elem.getInt32()) {
        return NumberInt(value)
    } else if (let Some(value) <- elem.getFloat64()) {
        return NumberFloat(Float32(value))
    } else if (let Some(value) <- elem.getBool()) {
        return match (value) {
            case true => NumberInt(1)
            case false => NumberInt(0)
        }
    } else if (let Some(str) <- elem.getString()) {
        return match (str) {
            case "min" => NumberInt(Int32.Min)
            case "max" => NumberInt(Int32.Max)
            case _ => default
        }
    }
    return default
}

public func getPrimitiveTypeVal(elem: JsonValue, default!: PrimitiveType = PrimitiveType.TriangleStrip): PrimitiveType {
    if (let Some(str) <- elem.getString()) {
        GameUtils.getPrimitiveType(str, default: default)
    } else {
        default
    }
}

public func getReplaceVarsVal(elem: JsonValue, default!: ReplaceVars = ReplaceNone): ReplaceVars {
    if (let Some(value) <- elem.getBool()) {
        match (value) {
            case true => ReplaceString
            case false => ReplaceNone
        }
    } else if (let Some(str) <- elem.getString()) {
        ReplaceVars.get(str, default: default)
    } else {
        default
    }
}

public func getVariableVal(elem: JsonValue): ?Variable {
    if (let Some(str) <- elem.getString()) {
        VaString(str)
    } else if (let Some(value) <- elem.getInt64()) {
        VaInteger(value)
    } else if (let Some(value) <- elem.getFloat64()) {
        VaDouble(value)
    } else if (let Some(value) <- elem.getBool()) {
        VaBoolean(value)
    } else if (elem.isArray()) {
        match (elem.size) {
            case 2 => match ((elem.get(0), elem.get(1))) {
                case (Some(elem0), Some(elem1)) where elem0.isInt64() && elem1.isInt64() => VaTuple2i(
                    (elem0.getInt64() ?? 0, elem1.getInt64() ?? 0))
                case (Some(elem0), Some(elem1)) where elem0.isFloat64() && elem1.isFloat64() => VaTuple2f(
                    (elem0.getFloat64() ?? 0.0, elem1.getFloat64() ?? 0.0))
                case _ => None
            }
            case 3 => match ((elem.get(0), elem.get(1), elem.get(2))) {
                case (Some(elem0), Some(elem1), Some(elem2)) where elem0.isInt64() && elem1.isInt64() && elem2.isInt64() => VaTuple3i(
                    (elem0.getInt64() ?? 0, elem1.getInt64() ?? 0, elem2.getInt64() ?? 0))
                case (Some(elem0), Some(elem1), Some(elem2)) where elem0.isFloat64() && elem1.isFloat64() &&
                    elem2.isFloat64() => VaTuple3f(
                    (elem0.getFloat64() ?? 0.0, elem1.getFloat64() ?? 0.0, elem2.getFloat64() ?? 0.0))
                case _ => None
            }
            case size where size > 3 => match ((elem.get(0), elem.get(1), elem.get(2), elem.get(3))) {
                case (Some(elem0), Some(elem1), Some(elem2), Some(elem3)) where elem0.isInt64() && elem1.isInt64() &&
                    elem2.isInt64() && elem3.isInt64() => VaTuple4i(
                    (elem0.getInt64() ?? 0, elem1.getInt64() ?? 0, elem2.getInt64() ?? 0, elem3.getInt64() ?? 0))
                case (Some(elem0), Some(elem1), Some(elem2), Some(elem3)) where elem0.isFloat64() && elem1.isFloat64() &&
                    elem2.isFloat64() && elem3.isFloat64() => VaTuple4f(
                    (elem0.getFloat64() ?? 0.0, elem1.getFloat64() ?? 0.0, elem2.getFloat64() ?? 0.0,
                        elem3.getFloat64() ?? 0.0))
                case _ => None
            }
            case _ => None
        }
    } else {
        None
    }
}

public func getVariables(elem: JsonValue): ArrayList<(String, Variable)> {
    let list = ArrayList<(String, Variable)>()
    if (elem.isObject()) {
        for ((name, value) in elem.memberIterator()) {
            if (let Some(value) <- getVariableVal(value)) {
                list.add((name, value))
            }
        }
    }
    return list
}

public func getVariablesMap(elem: JsonValue): HashMap<String, Variable> {
    let list = HashMap<String, Variable>()
    if (elem.isObject()) {
        for ((name, value) in elem.memberIterator()) {
            if (let Some(value) <- getVariableVal(value)) {
                list.add(name, value)
            }
        }
    }
    return list
}

public func getVarOrPredicateVal(game: Game, elem: JsonValue): VarOrPredicate {
    if (elem.isObject()) {
        VaPredicate(getPredicateObj(game, elem))
    } else {
        VaVariable(getVariableVal(elem) ?? VaString(String.empty))
    }
}
