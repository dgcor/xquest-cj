package dgengine

import cenum.*

@Enum[public AnimationType](
    Looped
    BackAndForth
    PlayOnce
    Size
)

extend AnimationType {
    public static func get(str: String, default!: AnimationType = AnimationType.Looped): AnimationType {
        match (str.toAsciiLower()) {
            case "looped" => Looped
            case "backandforth" => BackAndForth
            case "playonce" => PlayOnce
            case _ => default
        }
    }
}
