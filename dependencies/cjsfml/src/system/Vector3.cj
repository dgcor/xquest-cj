package cjsfml.system

import ctemplate.*

@Template[ClassName, NumType, DefaultValue: Vector3f, Float32, 0.0 ; Vector3i, Int32, 0](
@C
public struct ClassName {
    public var x: NumType = DefaultValue
    public var y: NumType = DefaultValue
    public var z: NumType = DefaultValue

    public const init() {}
    public const init(x: NumType, y: NumType, z: NumType) {
        this.x = x
        this.y = y
        this.z = z
    }

    public const init(tuple: (NumType, NumType, NumType)) {
        x = tuple[0]
        y = tuple[1]
        z = tuple[2]
    }

    public static func create(tuple: (Int64, Int64, Int64)): ClassName {
        ClassName(NumType(tuple[0]), NumType(tuple[1]), NumType(tuple[2]))
    }

    public static func create(tuple: (Float64, Float64, Float64)): ClassName {
        ClassName(NumType(tuple[0]), NumType(tuple[1]), NumType(tuple[2]))
    }

    public operator const func ==(right: ClassName): Bool {
        return x == right.x && y == right.y && z == right.z
    }

    public operator const func !=(right: ClassName): Bool {
        return x != right.x || y != right.y || z != right.z
    }

    public operator const func ==(right: (NumType, NumType, NumType)): Bool {
        return x == right[0] && y == right[1] && z == right[2]
    }

    public operator const func !=(right: (NumType, NumType, NumType)): Bool {
        return x != right[0] || y != right[1] || z != right[2]
    }

    public operator const func -(): ClassName {
        return ClassName(-x, -y, -z)
    }

    public operator const func +(right: ClassName): ClassName {
        return ClassName(x + right.x, y + right.y, z + right.z)
    }

    public operator const func -(right: ClassName): ClassName {
        return ClassName(x - right.x, y - right.y, z - right.z)
    }

    public operator const func +(right: (NumType, NumType, NumType)): ClassName {
        return ClassName(x + right[0], y + right[1], z + right[2])
    }

    public operator const func -(right: (NumType, NumType, NumType)): ClassName {
        return ClassName(x - right[0], y - right[1], z - right[2])
    }

    public operator const func *(right: NumType): ClassName {
        return ClassName(x * right, y * right, z * right)
    }

    public operator const func /(right: NumType): ClassName {
        return ClassName(x / right, y / right, z / right)
    }

    public func toTuple(): (NumType, NumType) {
        (x, y)
    }
})
