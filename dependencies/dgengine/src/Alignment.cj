package dgengine

public enum HorizontalAlign <: Equatable<HorizontalAlign> {
    | AlignLeft
    | AlignCenter
    | AlignRight

    public operator func ==(right: HorizontalAlign): Bool {
        match ((this, right)) {
            case (AlignLeft, AlignLeft) => true
            case (AlignCenter, AlignCenter) => true
            case (AlignRight, AlignRight) => true
            case _ => false
        }
    }

    public operator func !=(right: HorizontalAlign): Bool {
        !(this == right)
    }

    public static func get(str: String, default!: HorizontalAlign = AlignLeft): HorizontalAlign {
        match (str.toAsciiLower()) {
            case "left" => AlignLeft
            case "center" => AlignCenter
            case "right" => AlignRight
            case _ => default
        }
    }
}

public enum VerticalAlign <: Equatable<VerticalAlign> {
    | AlignTop
    | AlignCenter
    | AlignBottom

    public operator func ==(right: VerticalAlign): Bool {
        match ((this, right)) {
            case (AlignTop, AlignTop) => true
            case (AlignCenter, AlignCenter) => true
            case (AlignBottom, AlignBottom) => true
            case _ => false
        }
    }

    public operator func !=(right: VerticalAlign): Bool {
        !(this == right)
    }

    public static func get(str: String, default!: VerticalAlign = AlignTop): VerticalAlign {
        match (str.toAsciiLower()) {
            case "top" => AlignTop
            case "center" => AlignCenter
            case "bottom" => AlignBottom
            case _ => default
        }
    }
}
