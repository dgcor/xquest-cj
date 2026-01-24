package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import ctemplate.*
import stdx.encoding.json.*
import std.collection.*

public func getAnimationTypeKey(elem: JsonValue, key: String, default!: AnimationType = AnimationType.Looped): AnimationType {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getAnimationTypeVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getAnchorKey(elem: JsonValue, key: String, default!: Anchor = Anchor.Top | Anchor.Left): Anchor {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getAnchorVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getBindingFlagsKey(elem: JsonValue, key: String, default!: BindingFlags = BindingFlags.OnChange): BindingFlags {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getBindingFlagsVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getBlendModeKey(elem: JsonValue, key: String, default!: BlendModeType = BlendAlpha): BlendModeType {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getBlendModeVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getDirectionKey(elem: JsonValue, key: String, default!: Direction = Direction.Up): Direction {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getDirectionVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getBoolKey(elem: JsonValue, key: String, default!: Bool = false): Bool {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getBoolVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getDoubleKey(elem: JsonValue, key: String, default!: Float64 = 0.0): Float64 {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getDoubleVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getFloatKey(elem: JsonValue, key: String, default!: Float32 = 0.0): Float32 {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getFloatVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getIntKey(elem: JsonValue, key: String, default!: Int32 = 0): Int32 {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getIntVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getInt64Key(elem: JsonValue, key: String, default!: Int64 = 0): Int64 {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getInt64Val(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getStringCharKey(elem: JsonValue, key: String, default!: String = String.empty): String {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getStringChar(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getStringKey(elem: JsonValue, key: String, default!: String = String.empty): String {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getStringVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getUIntKey(elem: JsonValue, key: String, default!: UInt32 = 0): UInt32 {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getUIntVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getUInt64Key(elem: JsonValue, key: String, default!: UInt64 = 0): UInt64 {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getUInt64Val(elem, default: default)
            }
        case _ => ()
    }
    return default
}

@Template[T: Int32, Int64, UInt32, UInt64, Float32, Float64](
public func getNumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getNumberVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

@Template[T: Int32, Int64, UInt32, UInt64, Float32, Float64](
public func getUnsignedNumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getUnsignedNumberVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

@Template[T: Vector2f, Vector2i, Vector2u](
public func getVector2NumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getVector2NumberVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

@Template[T: Vector2f, Vector2i, Vector2u](
public func getVector2UnsignedNumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getVector2UnsignedNumberVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

public func getVector2fKey(elem: JsonValue, key: String, default!: Vector2f = Vector2f()): Vector2f {
    getVector2NumberKey(elem, key, default: default)
}

public func getVector2iKey(elem: JsonValue, key: String, default!: Vector2i = Vector2i()): Vector2i {
    getVector2NumberKey(elem, key, default: default)
}

public func getVector2uKey(elem: JsonValue, key: String, default!: Vector2u = Vector2u()): Vector2u {
    getVector2NumberKey(elem, key, default: default)
}

public func getUnsignedVector2fKey(elem: JsonValue, key: String, default!: Vector2f = Vector2f()): Vector2f {
    getVector2UnsignedNumberKey(elem, key, default: default)
}

public func getUnsignedVector2iKey(elem: JsonValue, key: String, default!: Vector2i = Vector2i()): Vector2i {
    getVector2UnsignedNumberKey(elem, key, default: default)
}

public func getUnsignedVector2uKey(elem: JsonValue, key: String, default!: Vector2u = Vector2u()): Vector2u {
    getVector2UnsignedNumberKey(elem, key, default: default)
}

@Template[T: Vector3f, Vector3i](
public func getVector3NumberKey(elem: JsonValue, key: String, default!: T = T()): T {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getVector3NumberVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

public func getVector3fKey(elem: JsonValue, key: String, default!: Vector3f = Vector3f()): Vector3f {
    getVector3NumberKey(elem, key, default: default)
}

public func getVector3iKey(elem: JsonValue, key: String, default!: Vector3i = Vector3i()): Vector3i {
    getVector3NumberKey(elem, key, default: default)
}

@Template[T: FloatRect, IntRect](
public func getVector4NumberKey(elem: JsonValue, key: String, default!: T = T()): T {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getVector4NumberVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

public func getVector4fKey(elem: JsonValue, key: String, default!: FloatRect = FloatRect()): FloatRect {
    getVector4NumberKey(elem, key, default: default)
}

public func getVector4iKey(elem: JsonValue, key: String, default!: IntRect = IntRect()): IntRect {
    getVector4NumberKey(elem, key, default: default)
}

@Template[T: Int32, UInt32](
public func getRangeOrValueKey(elem: JsonValue, key: String, default!: (T, T)): (T, T) {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getRangeOrValueVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

@Template[T: Int32, UInt32](
public func getRangeNKey(elem: JsonValue, key: String, minVal!: T, default!: (T, T)): (T, T) {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getRangeNVal(elem, minVal: minVal, default: default)
        }
        case _ => ()
    }
    return default
})

@Template[T: Int32, UInt32](
public func getRange0Key(elem: JsonValue, key: String, default!: (T, T)): (T, T) {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getRange0Val(elem, default: default)
        }
        case _ => ()
    }
    return default
})

@Template[T: Int32, UInt32](
public func getRange1Key(elem: JsonValue, key: String, default!: (T, T)): (T, T) {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getRange1Val(elem, default: default)
        }
        case _ => ()
    }
    return default
})

public func getPositionKey(elem: JsonValue, key: String, size: Vector2f, refSize: Vector2u): Vector2f {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getPositionVal(elem, size, refSize)
            }
        case _ => ()
    }
    return Vector2f()
}

public func getSizeKey(elem: JsonValue, key: String, default!: Vector2f = Vector2f()): Vector2f {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getSizeVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getFloatRectKey(elem: JsonValue, key: String, default!: FloatRect = FloatRect()): FloatRect {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getFloatRectVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getIntRectKey(elem: JsonValue, key: String, default!: IntRect = IntRect()): IntRect {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getIntRectVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getColorKey(elem: JsonValue, key: String, default!: Color = Color()): Color {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getColorVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getTimeKey(elem: JsonValue, key: String, default!: Time = Time.ZERO): Time {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getTimeVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getTimeUKey(elem: JsonValue, key: String, default!: Time = Time.ZERO): Time {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getTimeUVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getStringVectorKey(elem: JsonValue, key: String): ArrayList<String> {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getStringVectorVal(elem)
            }
        case _ => ()
    }
    return ArrayList<String>()
}

public func getValidStringVectorKey(elem: JsonValue, key: String): ArrayList<String> {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getValidStringVectorVal(elem)
            }
        case _ => ()
    }
    return ArrayList<String>()
}

public func getIgnoreResourceKey(elem: JsonValue, key: String, default!: IgnoreResource = IgnoreResource.None): IgnoreResource {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getIgnoreResourceVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getInputEventTypeKey(elem: JsonValue, key: String, default!: InputEventType = InputEventType.None): InputEventType {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getInputEventTypeVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

@Template[T: Int32, UInt32, Int64, UInt64, Float32, Float64](
public func getMinMaxIntKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.kind()) {
        case JsObject => if (let Some(elem) <- elem.asObject().get(key)) {
            return getMinMaxIntVal(elem, default: default)
        }
        case _ => ()
    }
    return default
})

public func getMinMaxNumber32Key(elem: JsonValue, key: String, default!: Number32 = NumberInt(0)): Number32 {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getMinMaxNumber32Val(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getPrimitiveTypeKey(elem: JsonValue, key: String, default!: PrimitiveType = PrimitiveType.TriangleStrip): PrimitiveType {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getPrimitiveTypeVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getReplaceVarsKey(elem: JsonValue, key: String, default!: ReplaceVars = ReplaceNone): ReplaceVars {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getReplaceVarsVal(elem, default: default)
            }
        case _ => ()
    }
    return default
}

public func getVariableKey(elem: JsonValue, key: String): ?Variable {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getVariableVal(elem)
            }
        case _ => ()
    }
    return None
}

public func getVariablesKey(elem: JsonValue, key: String): ArrayList<(String, Variable)> {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getVariables(elem)
            }
        case _ => ()
    }
    return ArrayList<(String, Variable)>()
}

public func getVariablesMapKey(elem: JsonValue, key: String): HashMap<String, Variable> {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getVariablesMap(elem)
            }
        case _ => ()
    }
    return HashMap<String, Variable>()
}

public func getVarOrPredicateKey(game: Game, elem: JsonValue, key: String): VarOrPredicate {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getVarOrPredicateVal(game, elem)
            }
        case _ => ()
    }
    return VaVariable(VaString(String.empty))
}
