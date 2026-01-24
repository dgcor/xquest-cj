package dgengine

public enum ReplaceVars <: Equatable<ReplaceVars> & ToString {
    | ReplaceNone
    | ReplaceString
    | ReplaceValue

    public operator func ==(right: ReplaceVars): Bool {
        match ((this, right)) {
            case (ReplaceNone, ReplaceNone) => true
            case (ReplaceString, ReplaceString) => true
            case (ReplaceValue, ReplaceValue) => true
            case (_, _) => false
        }
    }

    public operator func !=(right: ReplaceVars): Bool {
        !(this == right)
    }

    public func toString(): String {
        match (this) {
            case ReplaceNone => "none"
            case ReplaceString => "string"
            case ReplaceValue => "value"
        }
    }

    public static func get(str: String, default!: ReplaceVars = ReplaceNone): ReplaceVars {
        match (str.toAsciiLower()) {
            case "none" => ReplaceNone
            case "string" => ReplaceString
            case "value" => ReplaceValue
            case _ => default
        }
    }
}
