package cjsfml.system

import std.math.{FloatingPoint, floor}

/**
 * Represents an angle value.
 *
 * `Angle` encapsulates an angle value in a flexible way.
 * It allows for defining an angle value either as a number
 * of degrees or radians. It also works the other way
 * around. You can read an angle value as either a number
 * of degrees or radians.
 *
 * By using such a flexible interface, the API doesn't
 * impose any fixed type or unit for angle values and lets
 * the user choose their own preferred representation.
 *
 * Angle values support the usual mathematical operations.
 * You can add or subtract two angles, multiply or divide
 * an angle by a number, compare two angles, etc.
 *
 * Usage example:
 * ```
 * let a1 = Angle.degrees(90.0)
 * let radians = a1.asRadians() // 1.5708
 *
 * let a2 = Angle.radians(3.141592654)
 * let degrees = a2.asDegrees() // 180.0
 * ```
 */
@C
public struct Angle {
    /**
     * Angle value stored as radians.
     */
    public var value: Float32 = 0.0

    /**
     * Default constructor
     *
     * Sets the angle value to zero.
     */
    public const init() {}

    /**
     * Construct from a raw radians value
     *
     * @param radians Angle in radians
     */
    public const init(radians: Float32) {
        this.value = radians
    }

    /**
     * Construct an angle value from a number of degrees
     *
     * @param angle Number of degrees
     *
     * @return Angle value constructed from the number of degrees
     *
     * @see `radians`
     */
    public static func degrees(angle: Float32): Angle {
        return Angle(angle * (Float32.getPI() / 180.0))
    }

    /**
     * Construct an angle value from a number of radians
     *
     * @param angle Number of radians
     *
     * @return Angle value constructed from the number of radians
     *
     * @see `degrees`
     */
    public static const func radians(angle: Float32): Angle {
        return Angle(angle)
    }

    /**
     * Return the angle's value in degrees
     *
     * @return Angle in degrees
     *
     * @see `asRadians`
     */
    public func asDegrees(): Float32 {
        return value * (180.0 / Float32.getPI())
    }

    /**
     * Return the angle's value in radians
     *
     * @return Angle in radians
     *
     * @see `asDegrees`
     */
    public func asRadians(): Float32 {
        return value
    }

    /**
     * @brief Wrap to a range such that -180° <= angle < 180°
     *
     * Similar to a modulo operation, this returns a copy of the angle
     * constrained to the range [-180°, 180°) == [-Pi, Pi).
     * The resulting angle represents a rotation which is equivalent to `this`.
     *
     * The name "signed" originates from the similarity to signed integers:
     * | Type | signed | unsigned |
     * |---|---|---|
     * | char | [-128, 128) | [0, 256) |
     * | Angle | [-180°, 180°) | [0°, 360°) |
     *
     * @return Signed angle, wrapped to [-180°, 180°)
     *
     * @see `wrapUnsigned`
     */
    public func wrapSigned(): Angle {
        let pi = Float32.getPI()
        let tau = 2.0 * pi
        var shifted = value + pi

        // Manual modulo for positive remainder
        shifted = shifted - tau * Float32(floor(shifted / tau))

        return Angle(shifted - pi)
    }

    /**
     * @brief Wrap to a range such that 0° <= angle < 360°
     *
     * Similar to a modulo operation, this returns a copy of the angle
     * constrained to the range [0°, 360°) == [0, Tau) == [0, 2*Pi).
     * The resulting angle represents a rotation which is equivalent to `this`.
     *
     * The name "unsigned" originates from the similarity to unsigned integers:
     * | Type | signed | unsigned |
     * |---|---|---|
     * | char | [-128, 128) | [0, 256) |
     * | Angle | [-180°, 180°) | [0°, 360°) |
     *
     * @return Unsigned angle, wrapped to [0°, 360°)
     *
     * @see `wrapSigned`
     */
    public func wrapUnsigned(): Angle {
        let tau = 2.0 * Float32.getPI()
        var val = value

        // Manual modulo for positive remainder
        val = val - tau * Float32(floor(val / tau))

        return Angle(val)
    }

    /**
     * @brief Overload of binary `operator==` to compare two angle values
     * @note Does not automatically wrap the angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `true` if both angle values are equal
     */
    public const operator func ==(right: Angle): Bool {
        return value == right.value // cjlint-ignore !G.EXP.02 comparing floats
    }

    /**
     * @brief Overload of binary `operator!=` to compare two angle values
     * @note Does not automatically wrap the angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `true` if both angle values are different
     */
    public const operator func !=(right: Angle): Bool {
        return value != right.value // cjlint-ignore !G.EXP.02 comparing floats
    }

    /**
     * @brief Overload of binary `operator<` to compare two angle values
     * @note Does not automatically wrap the angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `true` if \a left is less than \a right
     */
    public const operator func <(right: Angle): Bool {
        return value < right.value
    }

    /**
     * @brief Overload of binary `operator>` to compare two angle values
     * @note Does not automatically wrap the angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `true` if \a left is greater than \a right
     */
    public const operator func >(right: Angle): Bool {
        return value > right.value
    }

    /**
     * @brief Overload of binary `operator<=` to compare two angle values
     * @note Does not automatically wrap the angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `true` if \a left is less than or equal to \a right
     */
    public const operator func <=(right: Angle): Bool {
        return value <= right.value
    }

    /**
     * @brief Overload of binary `operator>=` to compare two angle values
     * @note Does not automatically wrap the angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `true` if \a left is greater than or equal to \a right
     */
    public const operator func >=(right: Angle): Bool {
        return value >= right.value
    }

    // cjlint-ignore -start !G.OPR.01 uncommon operator overloading

    /**
     * @brief Overload of unary `operator-` to negate an angle value.
     *
     * Represents a rotation in the opposite direction.
     *
     * @param right Right operand (an angle)
     *
     * @return Negative of the angle value
     */
    public const operator func -(): Angle {
        return Angle(-value)
    }

    /**
     * @brief Overload of binary `operator+` to add two angle values
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return Sum of the two angle values
     */
    public const operator func +(right: Angle): Angle {
        return Angle(value + right.value)
    }

    /**
     * @brief Overload of binary `operator-` to subtract two angle values
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return Difference of the two angle values
     */
    public const operator func -(right: Angle): Angle {
        return Angle(value - right.value)
    }

    /**
     * @brief Overload of binary `operator*` to scale an angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (a number)
     *
     * @return `left` multiplied by `right`
     */
    public const operator func *(right: Float32): Angle {
        return Angle(value * right)
    }

    /**
     * @brief Overload of binary `operator/` to scale an angle value
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (a number)
     *
     * @return `left` divided by `right`
     */
    public const operator func /(right: Float32): Angle {
        return Angle(value / right)
    }

    /**
     * @brief Overload of binary `operator/` to compute the ratio of two angle values
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `left` divided by `right`
     */
    public const operator func /(right: Angle): Float32 {
        return value / right.value
    }

    /**
     * @brief Overload of binary `operator%` to compute modulo of an angle value.
     *
     * Right hand angle must be greater than zero.
     *
     * Examples:
     * ```
     * Angle.degrees(90.0) % Angle.degrees(40.0)  // 10 degrees
     * Angle.degrees(-90.0) % Angle.degrees(40.0) // 30 degrees (not -10)
     * ```
     *
     * @param left  Left operand (an angle)
     * @param right Right operand (an angle)
     *
     * @return `left` modulo `right`
     */
    public operator func %(right: Angle): Angle {
        let val = value - right.value * Float32(floor(value / right.value))
        return Angle(val)
    }

    // cjlint-ignore -end uncommon operator overloading

    /**
     * Predefined 0 degree angle value
     */
    public static const ZERO: Angle = Angle(0.0)
}
