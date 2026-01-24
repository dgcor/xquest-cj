package dgengine

import cenum.*
import cjsfml.system.*
import std.math.*

@FlagEnum[public Anchor](
    None
    Top
    Bottom
    Left
    Right
    All = 0xF
)

extend Anchor {
    public static func get(str: String, default!: Anchor = Top | Left): Anchor {
        match (str.toAsciiLower()) {
            case "none" => None
            case "top" => Top
            case "topleft" => Top | Left
            case "topright" => Top | Right
            case "bottom" => Bottom
            case "bottomleft" => Bottom | Left
            case "bottomright" => Bottom | Right
            case "left" => Left
            case "right" => Right
            case "all" => All
            case _ => default
        }
    }

    public func getPosition(srcSize: Vector2f, srcPos: Vector2f, anchorToSize: Vector2f): Vector2f {
        var pos = srcPos
        if (this == (Anchor.Bottom | Anchor.Left)) {
            pos.x -= srcSize.x
            pos.y += anchorToSize.y
            return pos
        } else if (this == (Bottom)) {
            pos.x += round((anchorToSize.x / 2.0) - (srcSize.x / 2.0))
            pos.y += anchorToSize.y
            return pos
        } else if (this == (Bottom | Right)) {
            pos.x += anchorToSize.x
            pos.y += anchorToSize.y
            return pos
        } else if (this == (Left)) {
            pos.x -= srcSize.x
            pos.y += round((anchorToSize.y / 2.0) - (srcSize.y / 2.0))
            return pos
        } else if (this == (None)) {
            pos.x += round((anchorToSize.x / 2.0) - (srcSize.x / 2.0))
            pos.y += round((anchorToSize.y / 2.0) - (srcSize.y / 2.0))
            return pos
        } else if (this == (Right)) {
            pos.x += anchorToSize.x
            pos.y += round((anchorToSize.y / 2.0) - (srcSize.y / 2.0))
            return pos
        } else if (this == (Top | Left)) {
            pos.x -= srcSize.x
            pos.y -= srcSize.y
            return pos
        } else if (this == (Top)) {
            pos.x += round((anchorToSize.x / 2.0) - (srcSize.x / 2.0))
            pos.y -= srcSize.y
            return pos
        } else if (this == (Top | Right)) {
            pos.x += anchorToSize.x
            pos.y -= srcSize.y
            return pos
        } else {
            return pos
        }
    }

    public func getPosSize(pos: Box<Vector2f>, size: Box<Vector2f>, oldWindowSize: Vector2u, newWindowSize: Vector2u): Unit {
        if (isSet(Top)) {
            if (isSet(Bottom)) {
                size.value.y = round(size.value.y + Float32(newWindowSize.y) - Float32(oldWindowSize.y))
            }
        } else {
            if (isSet(Bottom)) {
                pos.value.y = round(pos.value.y + Float32(newWindowSize.y) - Float32(oldWindowSize.y))
            } else {
                pos.value.y = round(pos.value.y + (Float32(newWindowSize.y) - Float32(oldWindowSize.y)) / 2.0)
            }
        }
        if (isSet(Left)) {
            if (isSet(Right)) {
                size.value.x = round(size.value.x + Float32(newWindowSize.x) - Float32(oldWindowSize.x))
            }
        } else {
            if (isSet(Right)) {
                pos.value.x = round(pos.value.x + Float32(newWindowSize.x) - Float32(oldWindowSize.x))
            } else {
                pos.value.x = round(pos.value.x + (Float32(newWindowSize.x) - Float32(oldWindowSize.x)) / 2.0)
            }
        }
    }
}
