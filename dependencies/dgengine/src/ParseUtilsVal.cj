package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import ctemplate.*
import stdx.encoding.json.*
import std.collection.*
import std.convert.*
import std.math.*

public func getAnchorVal(elem: JsonValue, default!: Anchor = Anchor.Top | Anchor.Left) {
    match (elem.kind()) {
        case JsString => Anchor.get(elem.asString().getValue(), default: default)
        case JsArray =>
            var ret = Anchor.None
            for (elem in elem.asArray().getItems()) {
                ret |= Anchor.get(getStringChar(elem), default: default)
            }
            return ret
        case _ => default
    }
}

public func getAnimationTypeVal(elem: JsonValue, default!: AnimationType = AnimationType.Looped) {
    match (elem.kind()) {
        case JsString => AnimationType.get(elem.asString().getValue(), default: default)
        case _ => default
    }
}

public func getBindingFlagsVal(elem: JsonValue, default!: BindingFlags = BindingFlags.OnChange) {
    match (elem.kind()) {
        case JsString => BindingFlags.get(elem.asString().getValue(), default: default)
        case JsArray =>
            var ret = BindingFlags.OnChange
            for (elem in elem.asArray().getItems()) {
                ret |= BindingFlags.get(getStringChar(elem), default: default)
            }
            return ret
        case _ => default
    }
}

public func getBlendModeVal(elem: JsonValue, default!: BlendModeType = BlendAlpha) {
    match (elem.kind()) {
        case JsString => BlendModeType.get(elem.asString().getValue(), default: default)
        case _ => default
    }
}

public func getDirectionVal(elem: JsonValue, default!: Direction = Direction.Up) {
    match (elem.kind()) {
        case JsString => Direction.get(elem.asString().getValue(), default: default)
        case _ => default
    }
}

public func getBoolVal(elem: JsonValue, default!: Bool = false) {
    match (elem.kind()) {
        case JsBool => elem.asBool().getValue()
        case _ => default
    }
}

public func getDoubleVal(elem: JsonValue, default!: Float64 = 0.0) {
    match (elem.kind()) {
        case JsFloat => elem.asFloat().getValue()
        case _ => default
    }
}

public func getFloatVal(elem: JsonValue, default!: Float32 = 0.0) {
    try {
        match (elem.kind()) {
            case JsFloat =>
                let value = elem.asFloat().getValue()
                let value32 = Float32(value)
                if (Int64(value) == Int64(value32)) {
                    return value32
                }
            case _ => ()
        }
    } catch (_: Exception) {}
    return default
}

public func getIntVal(elem: JsonValue, default!: Int32 = 0) {
    try {
        return match (elem.kind()) {
            case JsInt => Int32(elem.asInt().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getInt64Val(elem: JsonValue, default!: Int64 = 0) {
    match (elem.kind()) {
        case JsInt => elem.asInt().getValue()
        case _ => default
    }
}

public func getStringChar(elem: JsonValue, default!: String = String.empty) {
    match (elem.kind()) {
        case JsString => elem.asString().getValue()
        case _ => default
    }
}

public func getStringVal(elem: JsonValue, default!: String = String.empty) {
    match (elem.kind()) {
        case JsString => elem.asString().getValue()
        case JsInt => elem.asInt().getValue().toString()
        case JsFloat => toString(elem.asFloat().getValue())
        case _ => default
    }
}

public func getUIntVal(elem: JsonValue, default!: UInt32 = 0) {
    try {
        return match (elem.kind()) {
            case JsInt => UInt32(elem.asInt().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getUInt64Val(elem: JsonValue, default!: UInt64 = 0) {
    try {
        return match (elem.kind()) {
            case JsInt => UInt64(elem.asInt().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

// gets a number based on its type

public func getNumberVal(elem: JsonValue, default!: Int32) {
    try {
        return match (elem.kind()) {
            case JsInt => Int32(elem.asInt().getValue())
            case JsFloat => Int32(elem.asFloat().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getNumberVal(elem: JsonValue, default!: Int64) {
    try {
        return match (elem.kind()) {
            case JsInt => Int64(elem.asInt().getValue())
            case JsFloat => Int64(elem.asFloat().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getNumberVal(elem: JsonValue, default!: UInt32) {
    try {
        return match (elem.kind()) {
            case JsInt => UInt32(elem.asInt().getValue())
            case JsFloat => UInt32(elem.asFloat().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getNumberVal(elem: JsonValue, default!: UInt64) {
    try {
        return match (elem.kind()) {
            case JsInt => UInt64(elem.asInt().getValue())
            case JsFloat => UInt64(elem.asFloat().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getNumberVal(elem: JsonValue, default!: Float32) {
    try {
        match (elem.kind()) {
            case JsInt => return Float32(elem.asInt().getValue())
            case JsFloat =>
                let value = elem.asFloat().getValue()
                let value32 = Float32(value)
                if (Int64(value) == Int64(value32)) {
                    return value32
                }
            case _ => return default
        }
    } catch (_: Exception) {}
    return default
}

public func getNumberVal(elem: JsonValue, default!: Float64) {
    try {
        return match (elem.kind()) {
            case JsInt => Float64(elem.asInt().getValue())
            case JsFloat => Float64(elem.asFloat().getValue())
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

// gets a number based on its type
// if the number is below 0, val is returned

public func getUnsignedNumberVal(elem: JsonValue, default!: Int32) {
    let num = getNumberVal(elem, default: default)
    if (num >= 0) {
        return num
    }
    return default
}

public func getUnsignedNumberVal(elem: JsonValue, default!: Int64) {
    let num = getNumberVal(elem, default: default)
    if (num >= 0) {
        return num
    }
    return default
}

public func getUnsignedNumberVal(elem: JsonValue, default!: UInt32) {
    getNumberVal(elem, default: default)
}

public func getUnsignedNumberVal(elem: JsonValue, default!: UInt64) {
    getNumberVal(elem, default: default)
}

public func getUnsignedNumberVal(elem: JsonValue, default!: Float32) {
    let num = getNumberVal(elem, default: default)
    if (num >= 0.0) {
        return num
    }
    return default
}

public func getUnsignedNumberVal(elem: JsonValue, default!: Float64) {
    let num = getNumberVal(elem, default: default)
    if (num >= 0.0) {
        return num
    }
    return default
}

public func getVector2NumberVal(elem: JsonValue, default!: Vector2f): Vector2f {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector2f(
                            getNumberVal(a[0], default: 0.0f32),
                            getNumberVal(a[1], default: 0.0f32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector2NumberVal(elem: JsonValue, default!: Vector2i): Vector2i {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector2i(
                            getNumberVal(a[0], default: 0i32),
                            getNumberVal(a[1], default: 0i32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector2NumberVal(elem: JsonValue, default!: Vector2u): Vector2u {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector2u(
                            getNumberVal(a[0], default: 0u32),
                            getNumberVal(a[1], default: 0u32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector2UnsignedNumberVal(elem: JsonValue, default!: Vector2f): Vector2f {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector2f(
                            getUnsignedNumberVal(a[0], default: 0.0f32),
                            getUnsignedNumberVal(a[1], default: 0.0f32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector2UnsignedNumberVal(elem: JsonValue, default!: Vector2i): Vector2i {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector2i(
                            getUnsignedNumberVal(a[0], default: 0i32),
                            getUnsignedNumberVal(a[1], default: 0i32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector2UnsignedNumberVal(elem: JsonValue, default!: Vector2u): Vector2u {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector2u(
                            getUnsignedNumberVal(a[0], default: 0u32),
                            getUnsignedNumberVal(a[1], default: 0u32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
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
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 2 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[2].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector3f(
                            getNumberVal(a[0], default: 0.0f32),
                            getNumberVal(a[1], default: 0.0f32),
                            getNumberVal(a[2], default: 0.0f32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector3NumberVal(elem: JsonValue, default!: Vector3i): Vector3i {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 2 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[2].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return Vector3i(
                            getNumberVal(a[0], default: 0i32),
                            getNumberVal(a[1], default: 0i32),
                            getNumberVal(a[2], default: 0i32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector4NumberVal(elem: JsonValue, default!: FloatRect): FloatRect {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 3 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[2].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[3].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return FloatRect(
                            getNumberVal(a[0], default: 0.0f32),
                            getNumberVal(a[1], default: 0.0f32),
                            getNumberVal(a[2], default: 0.0f32),
                            getNumberVal(a[3], default: 0.0f32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getVector4NumberVal(elem: JsonValue, default!: IntRect): IntRect {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 3 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[2].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[3].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return IntRect(
                            getNumberVal(a[0], default: 0i32),
                            getNumberVal(a[1], default: 0i32),
                            getNumberVal(a[2], default: 0i32),
                            getNumberVal(a[3], default: 0i32)
                        )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

@Template[T: Int32, UInt32](
public func getRangeOrValueVal(elem: JsonValue, default!: (T, T)): (T, T) {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return (
                            getNumberVal(a[0], default: 0),
                            getNumberVal(a[1], default: 0)
                        )
                    case _ => default
                }
            case JsInt | JsFloat =>
                let v: T = getNumberVal(elem, default: 0)
                (v, v)
            case _ => default
        }
    } catch (_: Exception) {}
    return default
})

@Template[T: Int32, UInt32](
public func getRangeNVal(elem: JsonValue, minVal!: T, default!: (T, T)): (T, T) {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case size where size > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => ()
                            case _ => return default
                        }
                        return (
                            getNumberVal(a[0], default: 0),
                            getNumberVal(a[1], default: 0)
                        )
                    case _ => default
                }
            case JsInt | JsFloat => (minVal, getNumberVal(elem, default: 0))
            case _ => default
        }
    } catch (_: Exception) {}
    return default
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
    try {
        match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                match (a.size()) {
                    case arrSize where arrSize > 1 =>
                        match (a[0].kind()) {
                            case JsInt | JsFloat => value.x = round(getNumberVal(a[0], default: 0.0f32))
                            case JsString => match (HorizontalAlign.get(a[0].asString().getValue())) {
                                case AlignLeft => ()
                                case AlignCenter => value.x = round((Float32(refSize.x) / 2.0) - (size.x / 2.0))
                                case AlignRight => value.x = Float32(refSize.x) - size.x
                            }
                            case _ => ()
                        }
                        match (a[1].kind()) {
                            case JsInt | JsFloat => value.y = round(getNumberVal(a[1], default: 0.0f32))
                            case JsString => match (VerticalAlign.get(a[1].asString().getValue())) {
                                case AlignTop => ()
                                case AlignCenter => value.y = round((Float32(refSize.y) / 2.0) - (size.y / 2.0))
                                case AlignBottom => value.y = Float32(refSize.y) - size.y
                            }
                            case _ => ()
                        }
                    case _ => ()
                }
            case _ => ()
        }
    } catch (_: Exception) {}
    return value
}

public func getSizeVal(elem: JsonValue, default!: Vector2f = Vector2f()) {
    var size = getVector2fVal(elem, default: default)
    size.x = round(size.x)
    size.y = round(size.y)
    return size
}

public func getFloatRectVal(elem: JsonValue, default!: FloatRect = FloatRect()): FloatRect {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                return match (a.size()) {
                    case size where size >= 4 => FloatRect(
                        getNumberVal(a[0], default: 0.0f32),
                        getNumberVal(a[1], default: 0.0f32),
                        getNumberVal(a[2], default: 0.0f32),
                        getNumberVal(a[3], default: 0.0f32)
                    )
                    case size where size >= 2 => FloatRect(
                        0.0,
                        0.0,
                        getNumberVal(a[0], default: 0.0f32),
                        getNumberVal(a[1], default: 0.0f32)
                    )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getIntRectVal(elem: JsonValue, default!: IntRect = IntRect()): IntRect {
    try {
        return match (elem.kind()) {
            case JsArray =>
                let a = elem.asArray()
                return match (a.size()) {
                    case size where size >= 4 => IntRect(
                        getNumberVal(a[0], default: 0i32),
                        getNumberVal(a[1], default: 0i32),
                        getNumberVal(a[2], default: 0i32),
                        getNumberVal(a[3], default: 0i32)
                    )
                    case size where size >= 2 => IntRect(
                        0,
                        0,
                        getNumberVal(a[0], default: 0i32),
                        getNumberVal(a[1], default: 0i32)
                    )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getColorVal(elem: JsonValue, default!: Color = Color()) {
    try {
        return match (elem.kind()) {
            case JsString => return match (SFMLUtils.stringToColor(elem.asString().getValue())) {
                case Some(color) => color
                case None => default
            }
            case JsInt => SFMLUtils.rgbaToColor(UInt32(elem.asInt().getValue()))
            case JsArray =>
                let a = elem.asArray()
                return match (a.size()) {
                    case size where size == 3 => Color(
                        UInt8(getNumberVal(a[0], default: 0i32)),
                        UInt8(getNumberVal(a[1], default: 0i32)),
                        UInt8(getNumberVal(a[2], default: 0i32))
                    )
                    case size where size > 3 => Color(
                        UInt8(getNumberVal(a[0], default: 0i32)),
                        UInt8(getNumberVal(a[1], default: 0i32)),
                        UInt8(getNumberVal(a[2], default: 0i32)),
                        UInt8(getNumberVal(a[3], default: 0i32))
                    )
                    case _ => default
                }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getKeyCodeVal(elem: JsonValue, default!: KeyCode = KeyCode.Unknown) {
    try {
        return match (elem.kind()) {
            case JsInt => GameUtils.getKeyCode(Int32(elem.asInt().getValue()), default: default)
            case JsString => GameUtils.getKeyCode(elem.asString().getValue(), default: default)
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getScanCodeVal(elem: JsonValue, default!: Scancode = Scancode.Unknown) {
    try {
        return match (elem.kind()) {
            case JsInt => GameUtils.getScanCode(Int32(elem.asInt().getValue()), default: default)
            case JsString => GameUtils.getScanCode(elem.asString().getValue(), default: default)
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getTimeVal(elem: JsonValue, default!: Time = Time.zero): Time {
    try {
        return match (elem.kind()) {
            case JsInt => Time(milliseconds: Int32(elem.asInt().getValue()))
            case JsFloat => Time(seconds: Float32(elem.asFloat().getValue()))
            case JsString =>
                var h = 0i32
                var m = 0i32
                var s = 0i32
                var ms = 0i32
                var sv = splitStringIn2(elem.asString().getValue(), '.')
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
                return Time(milliseconds: totalms)
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

// positive time. returns default if time is negative
public func getTimeUVal(elem: JsonValue, default!: Time = Time.zero): Time {
    let time = getTimeVal(elem, default: default)
    if (time.microseconds < 0) {
        return default
    }
    return time
}

public func getStringVectorVal(elem: JsonValue) {
    let list = ArrayList<String>()
    match (elem.kind()) {
        case JsString => list.add(elem.asString().getValue())
        case JsArray => for (elem in elem.asArray().getItems()) {
            list.add(JsonUtils.toString(elem))
        }
        case _ => ()
    }
    return list
}

public func getValidStringVectorVal(elem: JsonValue) {
    let list = ArrayList<String>()
    match (elem.kind()) {
        case JsString =>
            if (let Some(str) <- getValidString(elem)) {
                list.add(str)
            }
        case JsArray => for (elem in elem.asArray().getItems()) {
            if (let Some(str) <- getValidString(elem)) {
                list.add(str)
            }
        }
        case _ => ()
    }
    return list
}

public func getIgnoreResourceVal(elem: JsonValue, default!: IgnoreResource = IgnoreResource.None) {
    match (elem.kind()) {
        case JsBool => match (elem.asBool().getValue()) {
            case true => IgnoreResource.Draw | IgnoreResource.Update
            case false => IgnoreResource.None
        }
        case JsString => IgnoreResource.get(elem.asString().getValue(), default: default)
        case JsArray =>
            var ret = IgnoreResource.None
            for (elem in elem.asArray().getItems()) {
                ret |= IgnoreResource.get(getStringChar(elem), default: default)
            }
            return ret
        case _ => default
    }
}

public func getInputEventTypeVal(elem: JsonValue, default!: InputEventType = InputEventType.None) {
    match (elem.kind()) {
        case JsBool => match (elem.asBool().getValue()) {
            case true => InputEventType.All
            case false => InputEventType.None
        }
        case JsString => InputEventType.get(elem.asString().getValue(), default: default)
        case JsArray =>
            var ret = InputEventType.None
            for (elem in elem.asArray().getItems()) {
                ret |= InputEventType.get(getStringChar(elem), default: default)
            }
            return ret
        case _ => default
    }
}

// returns a 32 bit number from the json element.
@Template[T: Int32, UInt32, Int64, UInt64, Float32, Float64](
public func getMinMaxIntVal(elem: JsonValue, default!: T): T {
    try {
        return match (elem.kind()) {
            case JsInt => T(elem.asInt().getValue())
            case JsFloat => T(elem.asFloat().getValue())
            case JsBool => match (elem.asBool().getValue()) {
                case true => T(1)
                case false => unsafe {zeroValue<T>()}
            }
            case JsString => match (elem.asString().getValue()) {
                case "min" => T.Min
                case "max" => T.Max
                case _ => default
            }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
})

public func getMinMaxNumber32Val(elem: JsonValue, default!: Number32 = NumberInt(0)): Number32 {
    try {
        return match (elem.kind()) {
            case JsInt => match (elem.asInt().getValue()) {
                case value where value >= 0 => NumberUInt(UInt32(value))
                case value => NumberInt(Int32(value))
            }
            case JsFloat => NumberFloat(Float32(elem.asFloat().getValue()))
            case JsBool => match (elem.asBool().getValue()) {
                case true => NumberInt(1)
                case false => NumberInt(0)
            }
            case JsString => match (elem.asString().getValue()) {
                case "min" => NumberInt(Int32.Min)
                case "max" => NumberInt(Int32.Max)
                case _ => default
            }
            case _ => default
        }
    } catch (_: Exception) {}
    return default
}

public func getPrimitiveTypeVal(elem: JsonValue, default!: PrimitiveType = PrimitiveType.TriangleStrip) {
    match (elem.kind()) {
        case JsString => GameUtils.getPrimitiveType(elem.asString().getValue(), default: default)
        case _ => default
    }
}

public func getReplaceVarsVal(elem: JsonValue, default!: ReplaceVars = ReplaceNone) {
    match (elem.kind()) {
        case JsBool => match (elem.asBool().getValue()) {
            case true => ReplaceString
            case false => ReplaceNone
        }
        case JsString => ReplaceVars.get(elem.asString().getValue(), default: default)
        case _ => default
    }
}

public func getVariableVal(elem: JsonValue): ?Variable {
    match (elem.kind()) {
        case JsString => VaString(elem.asString().getValue())
        case JsInt => VaInteger(elem.asInt().getValue())
        case JsFloat => VaDouble(elem.asFloat().getValue())
        case JsBool => VaBoolean(elem.asBool().getValue())
        case JsArray =>
            let a = elem.asArray()
            return match (a.size()) {
                case 2 => match ((a[0].kind(), a[1].kind())) {
                    case (JsInt, JsInt) => VaTuple2i((a[0].asInt().getValue(), a[1].asInt().getValue()))
                    case (JsFloat, JsFloat) => VaTuple2f((a[0].asFloat().getValue(), a[1].asFloat().getValue()))
                    case _ => None
                }
                case 3 => match ((a[0].kind(), a[1].kind(), a[2].kind())) {
                    case (JsInt, JsInt, JsInt) => VaTuple3i(
                        (a[0].asInt().getValue(), a[1].asInt().getValue(), a[2].asInt().getValue()))
                    case (JsFloat, JsFloat, JsFloat) => VaTuple3f(
                        (a[0].asFloat().getValue(), a[1].asFloat().getValue(), a[2].asFloat().getValue()))
                    case _ => None
                }
                case size where size > 3 => match ((a[0].kind(), a[1].kind(), a[2].kind(), a[3].kind())) {
                    case (JsInt, JsInt, JsInt, JsInt) => VaTuple4i(
                        (a[0].asInt().getValue(), a[1].asInt().getValue(), a[2].asInt().getValue(),
                            a[3].asInt().getValue()))
                    case (JsFloat, JsFloat, JsFloat, JsFloat) => VaTuple4f(
                        (a[0].asFloat().getValue(), a[1].asFloat().getValue(), a[2].asFloat().getValue(),
                            a[3].asFloat().getValue()))
                    case _ => None
                }
                case _ => None
            }
        case _ => None
    }
}

public func getVariables(elem: JsonValue) {
    let list = ArrayList<(String, Variable)>()
    match (elem.kind()) {
        case JsObject => for ((key, elem) in elem.asObject().getFields()) {
            if (let Some(value) <- getVariableVal(elem)) {
                list.add((key, value))
            }
        }
        case _ => ()
    }
    return list
}

public func getVariablesMap(elem: JsonValue) {
    let list = HashMap<String, Variable>()
    match (elem.kind()) {
        case JsObject => for ((key, elem) in elem.asObject().getFields()) {
            if (let Some(value) <- getVariableVal(elem)) {
                list.add(key, value)
            }
        }
        case _ => ()
    }
    return list
}

public func getVarOrPredicateVal(game: Game, elem: JsonValue): VarOrPredicate {
    match (elem.kind()) {
        case JsObject => VaPredicate(getPredicateObj(game, elem))
        case _ => VaVariable(getVariableVal(elem) ?? VaString(String.empty))
    }
}
