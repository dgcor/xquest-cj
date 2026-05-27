package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import ctemplate.*
import std.collection.*
import stdjson2.*

public func getAnimationTypeKey(elem: JsonValue, key: String, default!: AnimationType = AnimationType.Looped): AnimationType {
    match (elem.get(key)) {
        case Some(elem) => getAnimationTypeVal(elem, default: default)
        case None => default
    }
}

public func getAnchorKey(elem: JsonValue, key: String, default!: Anchor = Anchor.Top | Anchor.Left): Anchor {
    match (elem.get(key)) {
        case Some(elem) => getAnchorVal(elem, default: default)
        case None => default
    }
}

public func getBindingFlagsKey(elem: JsonValue, key: String, default!: BindingFlags = BindingFlags.OnChange): BindingFlags {
    match (elem.get(key)) {
        case Some(elem) => getBindingFlagsVal(elem, default: default)
        case None => default
    }
}

public func getBlendModeKey(elem: JsonValue, key: String, default!: BlendModeType = BlendAlpha): BlendModeType {
    match (elem.get(key)) {
        case Some(elem) => getBlendModeVal(elem, default: default)
        case None => default
    }
}

public func getDirectionKey(elem: JsonValue, key: String, default!: Direction = Direction.Up): Direction {
    match (elem.get(key)) {
        case Some(elem) => getDirectionVal(elem, default: default)
        case None => default
    }
}

public func getBoolKey(elem: JsonValue, key: String, default!: Bool = false): Bool {
    match (elem.get(key)) {
        case Some(elem) => getBoolVal(elem, default: default)
        case None => default
    }
}

public func getDoubleKey(elem: JsonValue, key: String, default!: Float64 = 0.0): Float64 {
    match (elem.get(key)) {
        case Some(elem) => getDoubleVal(elem, default: default)
        case None => default
    }
}

public func getFloatKey(elem: JsonValue, key: String, default!: Float32 = 0.0): Float32 {
    match (elem.get(key)) {
        case Some(elem) => getFloatVal(elem, default: default)
        case None => default
    }
}

public func getIntKey(elem: JsonValue, key: String, default!: Int32 = 0): Int32 {
    match (elem.get(key)) {
        case Some(elem) => getIntVal(elem, default: default)
        case None => default
    }
}

public func getInt64Key(elem: JsonValue, key: String, default!: Int64 = 0): Int64 {
    match (elem.get(key)) {
        case Some(elem) => getInt64Val(elem, default: default)
        case None => default
    }
}

public func getStringCharKey(elem: JsonValue, key: String, default!: String = String.empty): String {
    match (elem.get(key)) {
        case Some(elem) => getStringChar(elem, default: default)
        case None => default
    }
}

public func getStringKey(elem: JsonValue, key: String, default!: String = String.empty): String {
    match (elem.get(key)) {
        case Some(elem) => getStringVal(elem, default: default)
        case None => default
    }
}

public func getUIntKey(elem: JsonValue, key: String, default!: UInt32 = 0): UInt32 {
    match (elem.get(key)) {
        case Some(elem) => getUIntVal(elem, default: default)
        case None => default
    }
}

public func getUInt64Key(elem: JsonValue, key: String, default!: UInt64 = 0): UInt64 {
    match (elem.get(key)) {
        case Some(elem) => getUInt64Val(elem, default: default)
        case None => default
    }
}

@Template[T: Int32, Int64, UInt32, UInt64, Float32, Float64](
public func getNumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.get(key)) {
        case Some(elem) => getNumberVal(elem, default: default)
        case None => default
    }
})

@Template[T: Int32, Int64, UInt32, UInt64, Float32, Float64](
public func getUnsignedNumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.get(key)) {
        case Some(elem) => getUnsignedNumberVal(elem, default: default)
        case None => default
    }
})

@Template[T: Vector2f, Vector2i, Vector2u](
public func getVector2NumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.get(key)) {
        case Some(elem) => getVector2NumberVal(elem, default: default)
        case None => default
    }
})

@Template[T: Vector2f, Vector2i, Vector2u](
public func getVector2UnsignedNumberKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.get(key)) {
        case Some(elem) => getVector2UnsignedNumberVal(elem, default: default)
        case None => default
    }
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
    match (elem.get(key)) {
        case Some(elem) => getVector3NumberVal(elem, default: default)
        case None => default
    }
})

public func getVector3fKey(elem: JsonValue, key: String, default!: Vector3f = Vector3f()): Vector3f {
    getVector3NumberKey(elem, key, default: default)
}

public func getVector3iKey(elem: JsonValue, key: String, default!: Vector3i = Vector3i()): Vector3i {
    getVector3NumberKey(elem, key, default: default)
}

@Template[T: FloatRect, IntRect](
public func getVector4NumberKey(elem: JsonValue, key: String, default!: T = T()): T {
    match (elem.get(key)) {
        case Some(elem) => getVector4NumberVal(elem, default: default)
        case None => default
    }
})

public func getVector4fKey(elem: JsonValue, key: String, default!: FloatRect = FloatRect()): FloatRect {
    getVector4NumberKey(elem, key, default: default)
}

public func getVector4iKey(elem: JsonValue, key: String, default!: IntRect = IntRect()): IntRect {
    getVector4NumberKey(elem, key, default: default)
}

@Template[T: Int32, UInt32](
public func getRangeOrValueKey(elem: JsonValue, key: String, default!: (T, T)): (T, T) {
    match (elem.get(key)) {
        case Some(elem) => getRangeOrValueVal(elem, default: default)
        case None => default
    }
})

@Template[T: Int32, UInt32](
public func getRangeNKey(elem: JsonValue, key: String, minVal!: T, default!: (T, T)): (T, T) {
    match (elem.get(key)) {
        case Some(elem) => getRangeNVal(elem, minVal: minVal, default: default)
        case None => default
    }
})

@Template[T: Int32, UInt32](
public func getRange0Key(elem: JsonValue, key: String, default!: (T, T)): (T, T) {
    match (elem.get(key)) {
        case Some(elem) => getRange0Val(elem, default: default)
        case None => default
    }
})

@Template[T: Int32, UInt32](
public func getRange1Key(elem: JsonValue, key: String, default!: (T, T)): (T, T) {
    match (elem.get(key)) {
        case Some(elem) => getRange1Val(elem, default: default)
        case None => default
    }
})

public func getPositionKey(elem: JsonValue, key: String, size: Vector2f, refSize: Vector2u): Vector2f {
    match (elem.get(key)) {
        case Some(elem) => getPositionVal(elem, size, refSize)
        case None => Vector2f()
    }
}

public func getSizeKey(elem: JsonValue, key: String, default!: Vector2f = Vector2f()): Vector2f {
    match (elem.get(key)) {
        case Some(elem) => getSizeVal(elem, default: default)
        case None => default
    }
}

public func getFloatRectKey(elem: JsonValue, key: String, default!: FloatRect = FloatRect()): FloatRect {
    match (elem.get(key)) {
        case Some(elem) => getFloatRectVal(elem, default: default)
        case None => default
    }
}

public func getIntRectKey(elem: JsonValue, key: String, default!: IntRect = IntRect()): IntRect {
    match (elem.get(key)) {
        case Some(elem) => getIntRectVal(elem, default: default)
        case None => default
    }
}

public func getColorKey(elem: JsonValue, key: String, default!: Color = Color()): Color {
    match (elem.get(key)) {
        case Some(elem) => getColorVal(elem, default: default)
        case None => default
    }
}

public func getTextStyleKey(elem: JsonValue, key: String, default!: TextStyle = TextStyle.Regular): TextStyle {
    match (elem.get(key)) {
        case Some(elem) => getTextStyleVal(elem, default: default)
        case None => default
    }
}

public func getTimeKey(elem: JsonValue, key: String, default!: Time = Time.ZERO): Time {
    match (elem.get(key)) {
        case Some(elem) => getTimeVal(elem, default: default)
        case None => default
    }
}

public func getTimeUKey(elem: JsonValue, key: String, default!: Time = Time.ZERO): Time {
    match (elem.get(key)) {
        case Some(elem) => getTimeUVal(elem, default: default)
        case None => default
    }
}

public func getStringVectorKey(elem: JsonValue, key: String): ArrayList<String> {
    match (elem.get(key)) {
        case Some(elem) => getStringVectorVal(elem)
        case None => ArrayList<String>()
    }
}

public func getValidStringVectorKey(elem: JsonValue, key: String): ArrayList<String> {
    match (elem.get(key)) {
        case Some(elem) => getValidStringVectorVal(elem)
        case None => ArrayList<String>()
    }
}

public func getIgnoreResourceKey(elem: JsonValue, key: String, default!: IgnoreResource = IgnoreResource.None): IgnoreResource {
    match (elem.get(key)) {
        case Some(elem) => getIgnoreResourceVal(elem, default: default)
        case None => default
    }
}

public func getInputEventTypeKey(elem: JsonValue, key: String, default!: InputEventType = InputEventType.None): InputEventType {
    match (elem.get(key)) {
        case Some(elem) => getInputEventTypeVal(elem, default: default)
        case None => default
    }
}

@Template[T: Int32, UInt32, Float32](
public func getMinMaxIntKey(elem: JsonValue, key: String, default!: T): T {
    match (elem.get(key)) {
        case Some(elem) => getMinMaxIntVal(elem, default: default)
        case None => default
    }
})

public func getMinMaxNumber32Key(elem: JsonValue, key: String, default!: Number32 = NumberInt(0)): Number32 {
    match (elem.get(key)) {
        case Some(elem) => getMinMaxNumber32Val(elem, default: default)
        case None => default
    }
}

public func getPrimitiveTypeKey(elem: JsonValue, key: String, default!: PrimitiveType = PrimitiveType.TriangleStrip): PrimitiveType {
    match (elem.get(key)) {
        case Some(elem) => getPrimitiveTypeVal(elem, default: default)
        case None => default
    }
}

public func getReplaceVarsKey(elem: JsonValue, key: String, default!: ReplaceVars = ReplaceNone): ReplaceVars {
    match (elem.get(key)) {
        case Some(elem) => getReplaceVarsVal(elem, default: default)
        case None => default
    }
}

public func getVariableKey(elem: JsonValue, key: String): ?Variable {
    match (elem.get(key)) {
        case Some(elem) => getVariableVal(elem)
        case None => None
    }
}

public func getVariablesKey(elem: JsonValue, key: String): ArrayList<(String, Variable)> {
    match (elem.get(key)) {
        case Some(elem) => getVariables(elem)
        case None => ArrayList<(String, Variable)>()
    }
}

public func getVariablesMapKey(elem: JsonValue, key: String): HashMap<String, Variable> {
    match (elem.get(key)) {
        case Some(elem) => getVariablesMap(elem)
        case None => HashMap<String, Variable>()
    }
}

public func getVarOrPredicateKey(game: Game, elem: JsonValue, key: String): VarOrPredicate {
    match (elem.get(key)) {
        case Some(elem) => getVarOrPredicateVal(game, elem)
        case None => VaVariable(VaString(String.empty))
    }
}
