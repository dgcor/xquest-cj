package dgengine

import cenum.*

@FlagEnum[public IgnoreResource](
    None
    Draw
    Update
    All
)

extend IgnoreResource {
    public static func get(str: String, default!: IgnoreResource): IgnoreResource {
        match (str.toAsciiLower()) {
            case "none" => None
            case "alldraws" => Draw | All
            case "alldrawsandupdates" => Draw | Update | All
            case "allupdates" => Update | All
            case "draw" => Draw
            case "drawandupdate" => Draw | Update
            case "update" => Update
            case _ => default
        }
    }
}
