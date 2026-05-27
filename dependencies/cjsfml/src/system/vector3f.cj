package cjsfml.system

import std.math.sqrt

// cjlint-ignore -start !G.EXP.02 float precision

/**
 * Class for manipulating 3-dimensional vectors.
 *
 * `Vector3` is a simple class that defines a mathematical
 * vector with three coordinates (x, y and z). It can be used to
 * represent anything that has three dimensions: a size, a point,
 * a velocity, a scale, etc.
 *
 * The API provides basic arithmetic (addition, subtraction, scale), as
 * well as more advanced geometric operations, such as dot/cross products,
 * length computations, etc.
 *
 * You generally don't have to care about the templated form (`Vector3`),
 * the most common specializations have special type aliases:
 * - `Vector3<Float32>` is `Vector3f`
 * - `Vector3<Int32>` is `Vector3i`
 *
 * The `Vector3` class has a simple interface, its x, y and z members
 * can be accessed directly (there are no accessors like setX(), getX()).
 *
 * Usage example:
 * ```
 * var v = Vector3f(16.5f32, 24.f32, -3.2f32)
 * v.x = 18.2f32
 * let y = v.y
 *
 * var w = v * 5.f32
 * var u = Vector3f()
 * u = v + w
 *
 * let s = v.dot(w)
 *
 * let different = (v != u)
 * ```
 *
 * Note: for 2-dimensional vectors, see `Vector2`.
 */
@C
public struct Vector3f {
    public var x: Float32
    public var y: Float32
    public var z: Float32

    /**
     * Default constructor
     *
     * Creates a `Vector3(0.0, 0.0, 0.0)`.
     */
    public const init() {
        x = 0.0
        y = 0.0
        z = 0.0
    }

    /**
     * Construct the vector from its coordinates
     *
     * @param x X coordinate
     * @param y Y coordinate
     * @param z Z coordinate
     */
    public const init(x: Float32, y: Float32, z: Float32) {
        this.x = x
        this.y = y
        this.z = z
    }

    /**
     * Construct the vector from a tuple.
     *
     * @param tuple Tuple containing x, y and z coordinates
     */
    public const init(tuple: (Float32, Float32, Float32)) {
        x = tuple[0]
        y = tuple[1]
        z = tuple[2]
    }

    /**
     * Create a vector from a tuple of Int64.
     *
     * @param tuple Tuple containing x, y and z coordinates
     * @return Vector constructed from the tuple
     */
    public static func create(tuple: (Int64, Int64, Int64)): Vector3f {
        Vector3f(Float32(tuple[0]), Float32(tuple[1]), Float32(tuple[2]))
    }

    /**
     * Create a vector from a tuple of Float64.
     *
     * @param tuple Tuple containing x, y and z coordinates
     * @return Vector constructed from the tuple
     */
    public static func create(tuple: (Float64, Float64, Float64)): Vector3f {
        Vector3f(Float32(tuple[0]), Float32(tuple[1]), Float32(tuple[2]))
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
    public const operator func ==(right: Vector3f): Bool {
        return x == right.x && y == right.y && z == right.z
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
    public const operator func !=(right: Vector3f): Bool {
        return x != right.x || y != right.y || z != right.z
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
    public const operator func ==(right: (Float32, Float32, Float32)): Bool {
        return x == right[0] && y == right[1] && z == right[2]
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
    public const operator func !=(right: (Float32, Float32, Float32)): Bool {
        return x != right[0] || y != right[1] || z != right[2]
    }

    /**
     * Overload of unary `operator-` to negate a vector
     *
     * @param left Vector to negate
     *
     * @return Member-wise opposite of the vector
     */
    public const operator func -(): Vector3f {
        return Vector3f(-x, -y, -z)
    }

    /**
     * @brief Overload of binary `operator+` to add two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise addition of both vectors
     */
    public const operator func +(right: Vector3f): Vector3f {
        return Vector3f(x + right.x, y + right.y, z + right.z)
    }

    /**
     * @brief Overload of binary `operator-` to subtract two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise subtraction of both vectors
     */
    public const operator func -(right: Vector3f): Vector3f {
        return Vector3f(x - right.x, y - right.y, z - right.z)
    }

    /**
     * @brief Overload of binary `operator+` to add a vector and a tuple
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise addition of the vector and tuple
     */
    public const operator func +(right: (Float32, Float32, Float32)): Vector3f {
        return Vector3f(x + right[0], y + right[1], z + right[2])
    }

    /**
     * @brief Overload of binary `operator-` to subtract a tuple from a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise subtraction of the tuple from the vector
     */
    public const operator func -(right: (Float32, Float32, Float32)): Vector3f {
        return Vector3f(x - right[0], y - right[1], z - right[2])
    }

    /**
     * @brief Overload of binary `operator*` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise multiplication by `right`
     */
    public const operator func *(right: Float32): Vector3f {
        return Vector3f(x * right, y * right, z * right)
    }

    /**
     * @brief Overload of binary `operator/` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise division by `right`
     */
    public const operator func /(right: Float32): Vector3f {
        return Vector3f(x / right, y / right, z / right)
    }

    // cjlint-ignore -end uncommon operator overloading

    /**
     * Convert the vector to a tuple.
     *
     * @return A tuple containing the x, y and z coordinates
     */
    public func toTuple(): (Float32, Float32, Float32) {
        (x, y, z)
    }

    /**
     * @brief Dot product of two 3D vectors.
     */
    public const func dot(right: Vector3f): Float32 {
        return x * right.x + y * right.y + z * right.z
    }

    /**
     * @brief Cross product of two 3D vectors.
     */
    public const func cross(right: Vector3f): Vector3f {
        return Vector3f(
            y * right.z - z * right.y,
            z * right.x - x * right.z,
            x * right.y - y * right.x
        )
    }

    /**
     * @brief Square of vector's length.
     *
     * Suitable for comparisons, more efficient than `length()`.
     */
    public const func lengthSquared(): Float32 {
        return x * x + y * y + z * z
    }

    /**
     * @brief Length of the vector.
     *
     * If you are not interested in the actual length, but only in comparisons, consider using `lengthSquared()`.
     */
    public func length(): Float32 {
        return Float32(sqrt(Float64(x * x + y * y + z * z)))
    }

    /**
     * @brief Vector with same direction but length 1.
     *
     * @pre `this` is no zero vector.
     */
    public func normalized(): Vector3f {
        let len = length()
        if (len != Float32(0)) {
            return Vector3f(x / len, y / len, z / len)
        }
        return Vector3f()
    }

    /**
     * @brief Component-wise multiplication of `this` and `rhs`.
     *
     * Computes `(lhs.x*rhs.x, lhs.y*rhs.y, lhs.z*rhs.z)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     * This operation is also known as the Hadamard or Schur product.
     */
    public const func componentWiseMul(right: Vector3f): Vector3f {
        return Vector3f(x * right.x, y * right.y, z * right.z)
    }

    /**
     * @brief Component-wise division of `this` and `rhs`.
     *
     * Computes `(lhs.x/rhs.x, lhs.y/rhs.y, lhs.z/rhs.z)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     */
    public const func componentWiseDiv(right: Vector3f): Vector3f {
        return Vector3f(x / right.x, y / right.y, z / right.z)
    }
}

// cjlint-ignore -end float precision
