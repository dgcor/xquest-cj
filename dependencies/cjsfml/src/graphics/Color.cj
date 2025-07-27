package cjsfml.graphics

@C
public struct Color {
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8
    public var a: UInt8

    public const init() {
        r = 0
        g = 0
        b = 0
        a = 255
    }

    public const init(red: UInt8, green: UInt8, blue: UInt8) {
        r = red
        g = green
        b = blue
        a = 255
    }

    public const init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        r = red
        g = green
        b = blue
        a = alpha
    }

    public init(color: UInt32) {
        r = UInt8((color & 0xFF000000) >> 24)
        g = UInt8((color & 0x00FF0000) >> 16)
        b = UInt8((color & 0x0000FF00) >> 8)
        a = UInt8((color & 0x000000FF) >> 0)
    }

    public const init(rgb: (UInt8, UInt8, UInt8)) {
        r = rgb[0]
        g = rgb[1]
        b = rgb[2]
        a = 255
    }

    public const init(rgba: (UInt8, UInt8, UInt8, UInt8)) {
        r = rgba[0]
        g = rgba[1]
        b = rgba[2]
        a = rgba[3]
    }

    public operator const func ==(right: Color): Bool {
        (r == right.r && g == right.g && b == right.b && a == right.a)
    }

    public operator const func !=(right: Color): Bool {
        (r != right.r || g != right.g || b != right.b || a != right.a)
    }

    public operator func +(right: Color): Color {
        Color(
            UInt8(min(Int32(r) + Int32(right.r), 255)),
            UInt8(min(Int32(g) + Int32(right.g), 255)),
            UInt8(min(Int32(b) + Int32(right.b), 255)),
            UInt8(min(Int32(a) + Int32(right.a), 255))
        )
    }

    public operator func -(right: Color): Color {
        Color(
            UInt8(max(Int32(r) - Int32(right.r), 0)),
            UInt8(max(Int32(g) - Int32(right.g), 0)),
            UInt8(max(Int32(b) - Int32(right.b), 0)),
            UInt8(max(Int32(a) - Int32(right.a), 0))
        )
    }

    public operator func *(right: Color): Color {
        Color(
            UInt8((Int32(r) * Int32(right.r)) / 255),
            UInt8((Int32(g) * Int32(right.g)) / 255),
            UInt8((Int32(b) * Int32(right.b)) / 255),
            UInt8((Int32(a) * Int32(right.a)) / 255)
        )
    }

    public func toUInt32(): UInt32 {
        UInt32((UInt32(r) << 24) | (UInt32(g) << 16) | (UInt32(b) << 8) | UInt32(a))
    }

    public static const black = Color(0, 0, 0)
    public static const white = Color(255, 255, 255)
    public static const red = Color(255, 0, 0)
    public static const green = Color(0, 255, 0)
    public static const blue = Color(0, 0, 255)
    public static const yellow = Color(255, 255, 0)
    public static const magenta = Color(255, 0, 255)
    public static const cyan = Color(0, 255, 255)
    public static const transparent = Color(0, 0, 0, 0)
}
