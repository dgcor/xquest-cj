package dgengine

import cenum.*

@FlagEnum[public BindingFlags](
    OnChange
    Once
    Always
    WhenHidden
)

extend BindingFlags {
    public static func get(str: String, default!: BindingFlags): BindingFlags {
        match (str.toAsciiLower()) {
            case "onchange" => OnChange
            case "once" => Once
            case "always" => Always
            case "whenhidden" => WhenHidden
            case _ => default
        }
    }
}
