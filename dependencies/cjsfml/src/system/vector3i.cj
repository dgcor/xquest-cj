package cjsfml.system

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
public struct Vector3i {
    public var x: Int32
    public var y: Int32
    public var z: Int32

    /**
     * Default constructor
     *
     * Creates a `Vector3(0, 0, 0)`.
     */
    public const init() {
        x = 0
        y = 0
        z = 0
    }

    /**
     * Construct the vector from its coordinates
     *
     * @param x X coordinate
     * @param y Y coordinate
     * @param z Z coordinate
     */
    public const init(x: Int32, y: Int32, z: Int32) {
        this.x = x
        this.y = y
        this.z = z
    }

    /**
     * Construct the vector from a tuple.
     *
     * @param tuple Tuple containing x, y and z coordinates
     */
    public const init(tuple: (Int32, Int32, Int32)) {
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
    public static func create(tuple: (Int64, Int64, Int64)): Vector3i {
        Vector3i(Int32(tuple[0]), Int32(tuple[1]), Int32(tuple[2]))
    }

    /**
     * Create a vector from a tuple of Float64.
     *
     * @param tuple Tuple containing x, y and z coordinates
     * @return Vector constructed from the tuple
     */
    public static func create(tuple: (Float64, Float64, Float64)): Vector3i {
        Vector3i(Int32(tuple[0]), Int32(tuple[1]), Int32(tuple[2]))
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
    public const operator func ==(right: Vector3i): Bool {
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
    public const operator func !=(right: Vector3i): Bool {
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
    public const operator func ==(right: (Int32, Int32, Int32)): Bool {
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
    public const operator func !=(right: (Int32, Int32, Int32)): Bool {
        return x != right[0] || y != right[1] || z != right[2]
    }

    /**
     * Overload of unary `operator-` to negate a vector
     *
     * @param left Vector to negate
     *
     * @return Member-wise opposite of the vector
     */
    public const operator func -(): Vector3i {
        return Vector3i(-x, -y, -z)
    }

    /**
     * @brief Overload of binary `operator+` to add two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise addition of both vectors
     */
    public const operator func +(right: Vector3i): Vector3i {
        return Vector3i(x + right.x, y + right.y, z + right.z)
    }

    /**
     * @brief Overload of binary `operator-` to subtract two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise subtraction of both vectors
     */
    public const operator func -(right: Vector3i): Vector3i {
        return Vector3i(x - right.x, y - right.y, z - right.z)
    }

    /**
     * @brief Overload of binary `operator+` to add a vector and a tuple
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise addition of the vector and tuple
     */
    public const operator func +(right: (Int32, Int32, Int32)): Vector3i {
        return Vector3i(x + right[0], y + right[1], z + right[2])
    }

    /**
     * @brief Overload of binary `operator-` to subtract a tuple from a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise subtraction of the tuple from the vector
     */
    public const operator func -(right: (Int32, Int32, Int32)): Vector3i {
        return Vector3i(x - right[0], y - right[1], z - right[2])
    }

    /**
     * @brief Overload of binary `operator*` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise multiplication by `right`
     */
    public const operator func *(right: Int32): Vector3i {
        return Vector3i(x * right, y * right, z * right)
    }

    /**
     * @brief Overload of binary `operator/` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise division by `right`
     */
    public const operator func /(right: Int32): Vector3i {
        return Vector3i(x / right, y / right, z / right)
    }

    // cjlint-ignore -end uncommon operator overloading

    /**
     * Convert the vector to a tuple.
     *
     * @return A tuple containing the x, y and z coordinates
     */
    public func toTuple(): (Int32, Int32, Int32) {
        (x, y, z)
    }

    /**
     * @brief Dot product of two 3D vectors.
     */
    public const func dot(right: Vector3i): Int32 {
        return x * right.x + y * right.y + z * right.z
    }

    /**
     * @brief Cross product of two 3D vectors.
     */
    public const func cross(right: Vector3i): Vector3i {
        return Vector3i(
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
    public const func lengthSquared(): Int32 {
        return x * x + y * y + z * z
    }

    /**
     * @brief Component-wise multiplication of `this` and `rhs`.
     *
     * Computes `(lhs.x*rhs.x, lhs.y*rhs.y, lhs.z*rhs.z)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     * This operation is also known as the Hadamard or Schur product.
     */
    public const func componentWiseMul(right: Vector3i): Vector3i {
        return Vector3i(x * right.x, y * right.y, z * right.z)
    }

    /**
     * @brief Component-wise division of `this` and `rhs`.
     *
     * Computes `(lhs.x/rhs.x, lhs.y/rhs.y, lhs.z/rhs.z)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     */
    public const func componentWiseDiv(right: Vector3i): Vector3i {
        return Vector3i(x / right.x, y / right.y, z / right.z)
    }
}
