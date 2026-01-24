package cjsfml.system

import ctemplate.Template

@Template[ClassName, NumType, DefaultValue: Vector2f, Float32, 0.0 ; Vector2i, Int32, 0 ; Vector2u, UInt32, 0](
@C
public struct ClassName {
    public var x: NumType = DefaultValue
    public var y: NumType = DefaultValue

    public const init() {}
    public const init(x: NumType, y: NumType) {
        this.x = x
        this.y = y
    }

    public const init(tuple: (NumType, NumType)) {
        x = tuple[0]
        y = tuple[1]
    }

    public static func create(tuple: (Int64, Int64)): ClassName {
        ClassName(NumType(tuple[0]), NumType(tuple[1]))
    }

    public static func create(tuple: (Float64, Float64)): ClassName {
        ClassName(NumType(tuple[0]), NumType(tuple[1]))
    }

    public operator const func ==(right: ClassName): Bool {
        return x == right.x && y == right.y
    }

    public operator const func !=(right: ClassName): Bool {
        return x != right.x || y != right.y
    }

    public operator const func ==(right: (NumType, NumType)): Bool {
        return x == right[0] && y == right[1]
    }

    public operator const func !=(right: (NumType, NumType)): Bool {
        return x != right[0] || y != right[1]
    }

    public operator const func -(): ClassName {
        return ClassName(-x, -y)
    }

    public operator const func +(right: ClassName): ClassName {
        return ClassName(x + right.x, y + right.y)
    }

    public operator const func -(right: ClassName): ClassName {
        return ClassName(x - right.x, y - right.y)
    }

    public operator const func +(right: (NumType, NumType)): ClassName {
        return ClassName(x + right[0], y + right[1])
    }

    public operator const func -(right: (NumType, NumType)): ClassName {
        return ClassName(x - right[0], y - right[1])
    }

    public operator const func *(right: NumType): ClassName {
        return ClassName(x * right, y * right)
    }

    public operator const func /(right: NumType): ClassName {
        return ClassName(x / right, y / right)
    }

    public func toTuple(): (NumType, NumType) {
        (x, y)
    }
})
