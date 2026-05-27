package cjsfml.system

// cjlint-ignore -start !G.OPR.01 uncommon operator overloading

/**
 * Represents a time value.
 *
 * `Time` encapsulates a time value in a flexible way.
 * It allows to define a time value either as a number of
 * seconds, milliseconds or microseconds. It also works the
 * other way round: you can read a time value as either
 * a number of seconds, milliseconds or microseconds. It
 * even interoperates with the `<chrono>` header. You can
 * construct an `Time` from a `chrono::duration` and read
 * any `Time` as a chrono::duration.
 *
 * By using such a flexible interface, the API doesn't
 * impose any fixed type or resolution for time values,
 * and let the user choose its own favorite representation.
 *
 * Time values support the usual mathematical operations:
 * you can add or subtract two times, multiply or divide
 * a time by a number, compare two times, etc.
 *
 * Since they represent a time span and not an absolute time
 * value, times can also be negative.
 *
 * Usage example:
 * ```
 * var t1 = Time(seconds: 0.1f32);
 * let milli = t1.milliseconds; // 100
 *
 * var t2 = Time(milliseconds: 30);
 * let micro = t2.microseconds; // 30000
 *
 * var t3 = Time(microseconds: -800000);
 * let sec = t3.seconds; // -0.8
 *
 * var t4 = Time(milliseconds: 250);
 * let micro2 = t4.microseconds; // 250000us
 * ```
 *
 * ```
 * func update(elapsed: Time) {
 *    position += speed * elapsed.seconds;
 * }
 *
 * update(Time(milliseconds: 100));
 * ```
 *
 * @see `Clock`
 */
@C
public struct Time {
    /**
     * Time value stored as microseconds
     */
    public let microseconds: Int64

    /**
     * Default constructor
     *
     * Sets the time value to zero.
     */
    public const init() {
        microseconds = 0
    }

    /**
     * Construct a time value from a number of seconds
     *
     * @param seconds Number of seconds
     *
     * @return Time value constructed from the amount of seconds
     *
     * @see `milliseconds`, `microseconds`
     */
    public init(seconds!: Float32) {
        microseconds = Int64(Float64(seconds) * 1000000.0)
    }

    /**
     * Construct a time value from a number of seconds
     *
     * @param seconds Number of seconds
     *
     * @return Time value constructed from the amount of seconds
     *
     * @see `milliseconds`, `microseconds`
     */
    public init(seconds!: Float64) {
        microseconds = Int64(seconds * 1000000.0)
    }

    /**
     * Construct a time value from a number of milliseconds
     *
     * @param milliseconds Number of milliseconds
     *
     * @return Time value constructed from the amount of milliseconds
     *
     * @see `seconds`, `microseconds`
     */
    public init(milliseconds!: Int32) {
        microseconds = Int64(milliseconds) * 1000
    }

    /**
     * Construct a time value from a number of microseconds
     *
     * @param microseconds Number of microseconds
     *
     * @return Time value constructed from the amount of microseconds
     *
     * @see `seconds`, `milliseconds`
     */
    public const init(microseconds!: Int64) {
        this.microseconds = microseconds
    }

    /**
     * Return the time value as a number of seconds
     *
     * @return Time in seconds
     *
     * @see `asMilliseconds`, `asMicroseconds`
     */
    public prop seconds: Float32 {
        get() {
            Float32(Float64(microseconds) / 1000000.0)
        }
    }

    /**
     * Return the time value as a number of seconds
     *
     * @return Time in seconds
     *
     * @see `asMilliseconds`, `asMicroseconds`
     */
    public prop seconds64: Float64 {
        get() {
            Float64(microseconds) / 1000000.0
        }
    }

    /**
     * Return the time value as a number of milliseconds
     *
     * @return Time in milliseconds
     *
     * @see `asSeconds`, `asMicroseconds`
     */
    public prop milliseconds: Int32 {
        get() {
            Int32(microseconds / 1000)
        }
    }

    /**
     * Overload of `operator==` to compare two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `true` if both time values are equal
     */
    public const operator func ==(right: Time): Bool {
        microseconds == right.microseconds
    }

    /**
     * Overload of `operator!=` to compare two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `true` if both time values are different
     */
    public const operator func !=(right: Time): Bool {
        microseconds != right.microseconds
    }

    /**
     * Overload of `operator>` to compare two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `true` if `left` is greater than `right`
     */
    public const operator func >(right: Time): Bool {
        microseconds > right.microseconds
    }

    /**
     * Overload of `operator>=` to compare two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `true` if `left` is greater or equal than `right`
     */
    public const operator func >=(right: Time): Bool {
        microseconds >= right.microseconds
    }

    /**
     * Overload of `operator<` to compare two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `true` if `left` is lesser than `right`
     */
    public const operator func <(right: Time): Bool {
        microseconds < right.microseconds
    }

    /**
     * Overload of `operator<=` to compare two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `true` if `left` is lesser or equal than `right`
     */
    public const operator func <=(right: Time): Bool {
        microseconds <= right.microseconds
    }

    /**
     * Overload of unary `operator-` to negate a time value
     *
     * @param right Right operand (a time)
     *
     * @return Opposite of the time value
     */
    public const operator func -(): Time {
        Time(microseconds: -microseconds)
    }

    /**
     * Overload of binary `operator+` to add two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return Sum of the two times values
     */
    public const operator func +(right: Time): Time {
        Time(microseconds: microseconds + right.microseconds)
    }

    /**
     * Overload of binary `operator-` to subtract two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return Difference of the two times values
     */
    public const operator func -(right: Time): Time {
        Time(microseconds: microseconds - right.microseconds)
    }

    /**
     * Overload of binary `operator*` to scale a time value
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a number)
     *
     * @return `left` multiplied by `right`
     */
    public operator func *(right: Float64): Time {
        Time(seconds: (Float64(microseconds) / 1000000.0) * right)
    }

    /**
     * Overload of binary `operator*` to scale a time value
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a number)
     *
     * @return `left` multiplied by `right`
     */
    public operator func *(right: Int64): Time {
        Time(microseconds: microseconds * right)
    }

    /**
     * Overload of binary `operator/` to scale a time value
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a number)
     *
     * @return `left` divided by `right`
     */
    public operator func /(right: Float64): Time {
        Time(seconds: (Float64(microseconds) / 1000000.0) / right) // cjlint-ignore !G.EXP.05
    }

    /**
     * Overload of binary `operator/` to scale a time value
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a number)
     *
     * @return `left` divided by `right`
     */
    public operator func /(right: Int64): Time {
        Time(microseconds: microseconds / right)
    }

    /**
     * Overload of binary `operator/` to compute the ratio of two time values
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `left` divided by `right`
     */
    public operator func /(right: Time): Time {
        Time(seconds: (Float64(microseconds) / 1000000.0) / (Float64(right.microseconds) / 1000000.0)) // cjlint-ignore !G.EXP.05
    }

    /**
     * Overload of binary `operator%` to compute remainder of a time value
     *
     * @param left  Left operand (a time)
     * @param right Right operand (a time)
     *
     * @return `left` modulo `right`
     */
    public operator func %(right: Time): Time {
        Time(microseconds: microseconds % right.microseconds)
    }

    /**
     * Predefined "zero" time value
     */
    public static const ZERO: Time = Time()
}

// cjlint-ignore -end uncommon operator overloading
