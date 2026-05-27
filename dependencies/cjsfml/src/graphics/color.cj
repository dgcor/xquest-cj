package cjsfml.graphics

/**
 * Utility class for manipulating RGBA colors.
 *
 * `Color` is a simple color class composed of 4 components:
 * - Red
 * - Green
 * - Blue
 * - Alpha (opacity)
 *
 * Each component is a public member, an unsigned integer in
 * the range [0, 255]. Thus, colors can be constructed and
 * manipulated very easily:
 *
 * ```
 * let color = Color(255, 0, 0); // red
 * color.r = 0;                  // make it black
 * color.b = 128;                // make it dark blue
 * ```
 *
 * The fourth component of colors, named "alpha", represents
 * the opacity of the color. A color with an alpha value of
 * 255 will be fully opaque, while an alpha value of 0 will
 * make a color fully transparent, whatever the value of the
 * other components is.
 *
 * The most common colors are already defined as static variables:
 * ```
 * let black       = Color.BLACK;
 * let white       = Color.WHITE;
 * let red         = Color.RED;
 * let green       = Color.GREEN;
 * let blue        = Color.BLUE;
 * let yellow      = Color.YELLOW;
 * let magenta     = Color.MAGENTA;
 * let cyan        = Color.CYAN;
 * let transparent = Color.TRANSPARENT;
 * ```
 *
 * Colors can also be added and modulated (multiplied) using the
 * overloaded operators + and *.
 */
@C
public struct Color {
    /**
     * Red component.
     */
    public var r: UInt8
    /**
     * Green component.
     */
    public var g: UInt8
    /**
     * Blue component.
     */
    public var b: UInt8
    /**
     * Alpha (opacity) component.
     */
    public var a: UInt8

    /**
     * Default constructor.
     *
     * Constructs an opaque black color. It is equivalent to
     * `Color(0, 0, 0, 255)`.
     */
    public const init() {
        r = 0
        g = 0
        b = 0
        a = 255
    }

    /**
     * Construct the color from its 4 RGBA components.
     *
     * @param red   Red component (in the range [0, 255])
     * @param green Green component (in the range [0, 255])
     * @param blue  Blue component (in the range [0, 255])
     * @param alpha Alpha (opacity) component (in the range [0, 255])
     */
    public const init(red: UInt8, green: UInt8, blue: UInt8) {
        r = red
        g = green
        b = blue
        a = 255
    }

    /**
     * Construct the color from its 4 RGBA components.
     *
     * @param red   Red component (in the range [0, 255])
     * @param green Green component (in the range [0, 255])
     * @param blue  Blue component (in the range [0, 255])
     * @param alpha Alpha (opacity) component (in the range [0, 255])
     */
    public const init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        r = red
        g = green
        b = blue
        a = alpha
    }

    /**
     * Construct the color from 32-bit unsigned integer.
     *
     * @param color Number containing the RGBA components (in that order)
     */
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

    /**
     * Compare two colors for equality.
     *
     * This operator compares two colors and check if they are equal.
     *
     * @param right Right operand
     *
     * @return `true` if colors are equal, `false` if they are different
     */
    public const operator func ==(right: Color): Bool {
        (r == right.r && g == right.g && b == right.b && a == right.a)
    }

    /**
     * Compare two colors for inequality.
     *
     * This operator compares two colors and check if they are different.
     *
     * @param right Right operand
     *
     * @return `true` if colors are different, `false` if they are equal
     */
    public const operator func !=(right: Color): Bool {
        (r != right.r || g != right.g || b != right.b || a != right.a)
    }

    /**
     * Overload of the binary `operator+`.
     *
     * This operator returns the component-wise sum of two colors.
     * Components that exceed 255 are clamped to 255.
     *
     * @param right Right operand
     *
     * @return Result of `this + right`
     */
    public operator func +(right: Color): Color {
        Color(
            UInt8(min(Int32(r) + Int32(right.r), 255)),
            UInt8(min(Int32(g) + Int32(right.g), 255)),
            UInt8(min(Int32(b) + Int32(right.b), 255)),
            UInt8(min(Int32(a) + Int32(right.a), 255))
        )
    }

    /**
     * Overload of the binary `operator-`.
     *
     * This operator returns the component-wise subtraction of two colors.
     * Components below 0 are clamped to 0.
     *
     * @param right Right operand
     *
     * @return Result of `this - right`
     */
    public operator func -(right: Color): Color {
        Color(
            UInt8(max(Int32(r) - Int32(right.r), 0)),
            UInt8(max(Int32(g) - Int32(right.g), 0)),
            UInt8(max(Int32(b) - Int32(right.b), 0)),
            UInt8(max(Int32(a) - Int32(right.a), 0))
        )
    }

    /**
     * Overload of the binary `operator*`.
     *
     * This operator returns the component-wise multiplication
     * (also called "modulation") of two colors.
     * Components are then divided by 255 so that the result is
     * still in the range [0, 255].
     *
     * @param right Right operand
     *
     * @return Result of `this * right`
     */
    public operator func *(right: Color): Color { // cjlint-ignore !G.OPR.01 uncommon operator overloading
        Color(
            UInt8((Int32(r) * Int32(right.r)) / 255),
            UInt8((Int32(g) * Int32(right.g)) / 255),
            UInt8((Int32(b) * Int32(right.b)) / 255),
            UInt8((Int32(a) * Int32(right.a)) / 255)
        )
    }

    /**
     * Retrieve the color as a 32-bit unsigned integer.
     *
     * @return Color represented as a 32-bit unsigned integer
     */
    public func toUInt32(): UInt32 {
        UInt32((UInt32(r) << 24) | (UInt32(g) << 16) | (UInt32(b) << 8) | UInt32(a))
    }

    public static const BLACK: Color = Color(0, 0, 0)
    public static const WHITE: Color = Color(255, 255, 255)
    public static const RED: Color = Color(255, 0, 0)
    public static const GREEN: Color = Color(0, 255, 0)
    public static const BLUE: Color = Color(0, 0, 255)
    public static const YELLOW: Color = Color(255, 255, 0)
    public static const MAGENTA: Color = Color(255, 0, 255)
    public static const CYAN: Color = Color(0, 255, 255)
    public static const TRANSPARENT: Color = Color(0, 0, 0, 0)
}
