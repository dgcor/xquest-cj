package dgengine

import cjsfml.graphics.BlendMode

public enum BlendModeType <: Equatable<BlendModeType> {
    | BlendAlpha
    | BlendAdd
    | BlendMultiply
    | BlendMin
    | BlendMax
    | BlendNone

    public operator func ==(right: BlendModeType): Bool {
        match ((this, right)) {
            case (BlendAlpha, BlendAlpha) => true
            case (BlendAdd, BlendAdd) => true
            case (BlendMultiply, BlendMultiply) => true
            case (BlendMin, BlendMin) => true
            case (BlendMax, BlendMax) => true
            case (BlendNone, BlendNone) => true
            case _ => false
        }
    }

    public operator func !=(right: BlendModeType): Bool {
        !(this == right)
    }

    public func toBlendMode(): BlendMode {
        match (this) {
            case BlendAlpha => BlendMode.alpha
            case BlendAdd => BlendMode.add
            case BlendMultiply => BlendMode.multiply
            case BlendMin => BlendMode.min
            case BlendMax => BlendMode.max
            case BlendNone => BlendMode.none
        }
    }

    public static func get(str: String, default!: BlendModeType): BlendModeType {
        match (str.toAsciiLower()) {
            case "alpha" => BlendAlpha
            case "add" => BlendAdd
            case "multiply" => BlendMultiply
            case "min" => BlendMin
            case "max" => BlendMax
            case "none" => BlendNone
            case _ => default
        }
    }
}
