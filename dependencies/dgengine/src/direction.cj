package dgengine

import cenum.*

@Enum[public Direction](
    Up
    Down
    Left
    Right
    Size
)

extend Direction {
    public static func get(str: String, default!: Direction): Direction {
        match (str.toAsciiLower()) {
            case "up" => Up
            case "down" => Down
            case "left" => Left
            case "right" => Right
            case _ => default
        }
    }
}
