package cjsfml.system

import std.math.{atan2, cos, FloatingPoint, sin, sqrt}

// cjlint-ignore -start !G.EXP.02 float precision

/**
 * Class for manipulating 2-dimensional vectors.
 *
 * `Vector2` is a simple class that defines a mathematical
 * vector with two coordinates (x and y). It can be used to
 * represent anything that has two dimensions: a size, a point,
 * a velocity, a scale, etc.
 *
 * The API provides basic arithmetic (addition, subtraction, scale), as
 * well as more advanced geometric operations, such as dot/cross products,
 * length and angle computations, projections, rotations, etc.
 *
 * You generally don't have to care about the templated form (`Vector2`),
 * the most common specializations have special type aliases:
 * - `Vector2<Float32>` is `Vector2f`
 * - `Vector2<Int32>` is `Vector2i`
 * - `Vector2<UInt32>` is `Vector2u`
 *
 * The `Vector2` class has a simple interface, its x and y members
 * can be accessed directly (there are no accessors like setX(), getX()).
 *
 * Usage example:
 * ```
 * var v = Vector2f(16.5f32, 24.f32)
 * v.x = 18.2f32
 * let y = v.y
 *
 * var w = v * 5.f32
 * var u = Vector2f()
 * u = v + w
 *
 * let s = v.dot(w)
 *
 * let different = (v != u)
 * ```
 *
 * Note: for 3-dimensional vectors, see `Vector3`.
 */
@C
public struct Vector2f {
    public var x: Float32
    public var y: Float32

    /**
     * Default constructor
     *
     * Creates a `Vector2f(0.0, 0.0)`.
     */
    public const init() {
        x = 0.0
        y = 0.0
    }

    /**
     * Construct the vector from cartesian coordinates
     *
     * @param x X coordinate
     * @param y Y coordinate
     */
    public const init(x: Float32, y: Float32) {
        this.x = x
        this.y = y
    }

    /**
     * Construct the vector from a tuple.
     *
     * @param tuple Tuple containing x and y coordinates
     */
    public const init(tuple: (Float32, Float32)) {
        x = tuple[0]
        y = tuple[1]
    }

    /**
     * Create a vector from a tuple of Int64.
     *
     * @param tuple Tuple containing x and y coordinates
     * @return Vector constructed from the tuple
     */
    public static func create(tuple: (Int64, Int64)): Vector2f {
        Vector2f(Float32(tuple[0]), Float32(tuple[1]))
    }

    /**
     * Create a vector from a tuple of Float64.
     *
     * @param tuple Tuple containing x and y coordinates
     * @return Vector constructed from the tuple
     */
    public static func create(tuple: (Float64, Float64)): Vector2f {
        Vector2f(Float32(tuple[0]), Float32(tuple[1]))
    }

    /**
     * Construct the vector from polar coordinates
     *
     * Note that this constructor is lossy: calling `length()` and `angle()`
     * may return values different to those provided in this constructor.
     *
     * @param r   Length of vector (can be negative)
     * @param phi Angle from X axis
     */
    public init(r: Float32, phi: Angle) {
        this.x = r * cos(phi.value)
        this.y = r * sin(phi.value)
    }

    // cjlint-ignore -start !G.OPR.01 uncommon operator overloading

    /**
     * @brief Overload of binary `operator==` to compare two vectors
     *
     * This operator compares strict equality between two vectors.
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return `true` if `left` is equal to `right`
     */
    public const operator func ==(right: Vector2f): Bool {
        return x == right.x && y == right.y
    }

    /**
     * @brief Overload of binary `operator!=` to compare two vectors
     *
     * This operator compares strict difference between two vectors.
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return `true` if `left` is not equal to `right`
     */
    public const operator func !=(right: Vector2f): Bool {
        return x != right.x || y != right.y
    }

    /**
     * @brief Overload of binary `operator==` to compare a vector and a tuple
     *
     * This operator compares strict equality between a vector and a tuple.
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return `true` if `left` is equal to `right`
     */
    public const operator func ==(right: (Float32, Float32)): Bool {
        return x == right[0] && y == right[1]
    }

    /**
     * @brief Overload of binary `operator!=` to compare a vector and a tuple
     *
     * This operator compares strict difference between a vector and a tuple.
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return `true` if `left` is not equal to `right`
     */
    public const operator func !=(right: (Float32, Float32)): Bool {
        return x != right[0] || y != right[1]
    }

    /**
     * Overload of unary `operator-` to negate a vector
     *
     * @param right Vector to negate
     *
     * @return Member-wise opposite of the vector
     */
    public const operator func -(): Vector2f {
        return Vector2f(-x, -y)
    }

    /**
     * @brief Overload of binary `operator+` to add two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise addition of both vectors
     */
    public const operator func +(right: Vector2f): Vector2f {
        return Vector2f(x + right.x, y + right.y)
    }

    /**
     * @brief Overload of binary `operator-` to subtract two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise subtraction of both vectors
     */
    public const operator func -(right: Vector2f): Vector2f {
        return Vector2f(x - right.x, y - right.y)
    }

    /**
     * @brief Overload of binary `operator+` to add a vector and a tuple
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise addition of the vector and tuple
     */
    public const operator func +(right: (Float32, Float32)): Vector2f {
        return Vector2f(x + right[0], y + right[1])
    }

    /**
     * @brief Overload of binary `operator-` to subtract a tuple from a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise subtraction of the tuple from the vector
     */
    public const operator func -(right: (Float32, Float32)): Vector2f {
        return Vector2f(x - right[0], y - right[1])
    }

    /**
     * @brief Overload of binary `operator*` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise multiplication by `right`
     */
    public const operator func *(right: Float32): Vector2f {
        return Vector2f(x * right, y * right)
    }

    /**
     * @brief Overload of binary `operator/` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise division by `right`
     */
    public const operator func /(right: Float32): Vector2f {
        return Vector2f(x / right, y / right)
    }

    // cjlint-ignore -end uncommon operator overloading

    /**
     * Convert the vector to a tuple.
     *
     * @return A tuple containing the x and y coordinates
     */
    public func toTuple(): (Float32, Float32) {
        (x, y)
    }

    /**
     * @brief Dot product of two 2D vectors.
     */
    public const func dot(right: Vector2f): Float32 {
        return x * right.x + y * right.y
    }

    /**
     * @brief Z component of the cross product of two 2D vectors.
     *
     * Treats the operands as 3D vectors, computes their cross product
     * and returns the result's Z component (X and Y components are always zero).
     */
    public const func cross(right: Vector2f): Float32 {
        return x * right.y - y * right.x
    }

    /**
     * @brief Square of vector's length.
     *
     * Suitable for comparisons, more efficient than `length()`.
     */
    public const func lengthSquared(): Float32 {
        return x * x + y * y
    }

    /**
     * @brief Length of the vector.
     *
     * If you are not interested in the actual length, but only in comparisons, consider using `lengthSquared()`.
     */
    public func length(): Float32 {
        return Float32(sqrt(Float64(x * x + y * y)))
    }

    /**
     * @brief Vector with same direction but length 1.
     *
     * @pre `this` is no zero vector.
     */
    public func normalized(): Vector2f {
        let len = length()
        if (len != Float32(0)) {
            return Vector2f(x / len, y / len)
        }
        return Vector2f()
    }

    /**
     * @brief Component-wise multiplication of `this` and `rhs`.
     *
     * Computes `(lhs.x*rhs.x, lhs.y*rhs.y)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     * This operation is also known as the Hadamard or Schur product.
     */
    public const func componentWiseMul(right: Vector2f): Vector2f {
        return Vector2f(x * right.x, y * right.y)
    }

    /**
     * @brief Component-wise division of `this` and `rhs`.
     *
     * Computes `(lhs.x/rhs.x, lhs.y/rhs.y)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     */
    public const func componentWiseDiv(right: Vector2f): Vector2f {
        return Vector2f(x / right.x, y / right.y)
    }

    /**
     * @brief Signed angle from `this` to `rhs`.
     *
     * @return The smallest angle which rotates `this` in positive
     * or negative direction, until it has the same direction as `rhs`.
     * The result has a sign and lies in the range [-180, 180) degrees.
     * @pre Neither `this` nor `rhs` is a zero vector.
     */
    public func angleTo(rhs: Vector2f): Angle {
        return Angle(atan2(cross(rhs), dot(rhs)))
    }

    /**
     * @brief Signed angle from +X or (1,0) vector.
     *
     * For example, the vector (1,0) corresponds to 0 degrees, (0,1) corresponds to 90 degrees.
     *
     * @return Angle in the range [-180, 180) degrees.
     */
    public func angle(): Angle {
        let angle = Float32(atan2(Float64(y), Float64(x)) * (180.0 / Float64.getPI()))
        return Angle(angle)
    }

    /**
     * @brief Rotate by angle \c phi.
     *
     * Returns a vector with same length but different direction.
     */
    public func rotatedBy(phi: Angle): Vector2f {
        let cos_val = cos(phi.value)
        let sin_val = sin(phi.value)
        return Vector2f(
            x * cos_val - y * sin_val,
            x * sin_val + y * cos_val
        )
    }

    /**
     * @brief Projection of this vector onto `axis`.
     *
     * @param axis Vector being projected onto. Need not be normalized.
     * @pre `axis` must not have length zero.
     */
    public func projectedOnto(right: Vector2f): Vector2f {
        let dot_val = this.dot(right)
        let len_sq = right.lengthSquared()
        if (len_sq == Float32(0)) {
            return Vector2f()
        }
        let scalar = dot_val / len_sq
        return right * scalar
    }

    /**
     * @brief Returns a perpendicular vector.
     *
     * Returns `this` rotated by +90 degrees; (x,y) becomes (-y,x).
     * For example, the vector (1,0) is transformed to (0,1).
     */
    public const func perpendicular(): Vector2f {
        return Vector2f(-y, x)
    }
}

// cjlint-ignore -end float precision
