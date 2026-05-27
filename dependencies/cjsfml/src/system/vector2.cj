package cjsfml.system

import ctemplate.Template

/**
 * Class template for manipulating 2-dimensional vectors.
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
@Template[ClassName, NumType, DefaultValue: Vector2i, Int32, 0 ; Vector2u, UInt32, 0](
@C
public struct ClassName {
    public var x: NumType
    public var y: NumType

    /**
     * Default constructor
     */
    public const init() {
        x = DefaultValue
        y = DefaultValue
    }

    /**
     * Construct the vector from cartesian coordinates
     *
     * @param x X coordinate
     * @param y Y coordinate
     */
    public const init(x: NumType, y: NumType) {
        this.x = x
        this.y = y
    }

    /**
     * Construct the vector from a tuple.
     *
     * @param tuple Tuple containing x and y coordinates
     */
    public const init(tuple: (NumType, NumType)) {
        x = tuple[0]
        y = tuple[1]
    }

    /**
     * Create a vector from a tuple of Int64.
     *
     * @param tuple Tuple containing x and y coordinates
     * @return Vector constructed from the tuple
     */
    public static func create(tuple: (Int64, Int64)): ClassName {
        ClassName(NumType(tuple[0]), NumType(tuple[1]))
    }

    /**
     * Create a vector from a tuple of Float64.
     *
     * @param tuple Tuple containing x and y coordinates
     * @return Vector constructed from the tuple
     */
    public static func create(tuple: (Float64, Float64)): ClassName {
        ClassName(NumType(tuple[0]), NumType(tuple[1]))
    }

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
    public const operator func ==(right: ClassName): Bool {
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
    public const operator func !=(right: ClassName): Bool {
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
    public const operator func ==(right: (NumType, NumType)): Bool {
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
    public const operator func !=(right: (NumType, NumType)): Bool {
        return x != right[0] || y != right[1]
    }

    /**
     * Overload of unary `operator-` to negate a vector
     *
     * @param right Vector to negate
     *
     * @return Member-wise opposite of the vector
     */
    public const operator func -(): ClassName {
        return ClassName(-x, -y)
    }

    /**
     * @brief Overload of binary `operator+` to add two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise addition of both vectors
     */
    public const operator func +(right: ClassName): ClassName {
        return ClassName(x + right.x, y + right.y)
    }

    /**
     * @brief Overload of binary `operator-` to subtract two vectors
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a vector)
     *
     * @return Member-wise subtraction of both vectors
     */
    public const operator func -(right: ClassName): ClassName {
        return ClassName(x - right.x, y - right.y)
    }

    /**
     * @brief Overload of binary `operator+` to add a vector and a tuple
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise addition of the vector and tuple
     */
    public const operator func +(right: (NumType, NumType)): ClassName {
        return ClassName(x + right[0], y + right[1])
    }

    /**
     * @brief Overload of binary `operator-` to subtract a tuple from a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a tuple)
     *
     * @return Member-wise subtraction of the tuple from the vector
     */
    public const operator func -(right: (NumType, NumType)): ClassName {
        return ClassName(x - right[0], y - right[1])
    }

    /**
     * @brief Overload of binary `operator*` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise multiplication by `right`
     */
    public const operator func *(right: NumType): ClassName {
        return ClassName(x * right, y * right)
    }

    /**
     * @brief Overload of binary `operator/` to scale a vector
     *
     * @param left  Left operand (a vector)
     * @param right Right operand (a scalar value)
     *
     * @return Member-wise division by `right`
     */
    public const operator func /(right: NumType): ClassName {
        return ClassName(x / right, y / right)
    }

    /**
     * Convert the vector to a tuple.
     *
     * @return A tuple containing the x and y coordinates
     */
    public func toTuple(): (NumType, NumType) {
        (x, y)
    }

    /**
     * @brief Dot product of two 2D vectors.
     */
    public const func dot(right: ClassName): NumType {
        return x * right.x + y * right.y
    }

    /**
     * @brief Z component of the cross product of two 2D vectors.
     *
     * Treats the operands as 3D vectors, computes their cross product
     * and returns the result's Z component (X and Y components are always zero).
     */
    public const func cross(right: ClassName): NumType {
        return x * right.y - y * right.x
    }

    /**
     * @brief Square of vector's length.
     *
     * Suitable for comparisons, more efficient than `length()`.
     */
    public const func lengthSquared(): NumType {
        return x * x + y * y
    }

    /**
     * @brief Component-wise multiplication of `this` and `rhs`.
     *
     * Computes `(lhs.x*rhs.x, lhs.y*rhs.y)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     * This operation is also known as the Hadamard or Schur product.
     */
    public const func componentWiseMul(right: ClassName): ClassName {
        return ClassName(x * right.x, y * right.y)
    }

    /**
     * @brief Component-wise division of `this` and `rhs`.
     *
     * Computes `(lhs.x/rhs.x, lhs.y/rhs.y)`.
     *
     * Scaling is the most common use case for component-wise multiplication/division.
     */
    public const func componentWiseDiv(right: ClassName): ClassName {
        return ClassName(x / right.x, y / right.y)
    }

    /**
     * @brief Returns a perpendicular vector.
     *
     * Returns `this` rotated by +90 degrees; (x,y) becomes (-y,x).
     * For example, the vector (1,0) is transformed to (0,1).
     */
    public const func perpendicular(): ClassName {
        return ClassName(-y, x)
    }
})
