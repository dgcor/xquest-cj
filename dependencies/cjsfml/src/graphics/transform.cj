package cjsfml.graphics

import cjsfml.system.{Vector2f}

foreign {
    func sfTransform_getMatrix(transform: CPointer<Transform>, matrix: CPointer<Float32>): Unit

    func sfTransform_getInverse(transform: CPointer<Transform>): Transform

    func sfTransform_transformPoint(transform: CPointer<Transform>, point: Vector2f): Vector2f

    func sfTransform_transformRect(transform: CPointer<Transform>, rect: FloatRect): FloatRect

    func sfTransform_combine(transform: CPointer<Transform>, other: CPointer<Transform>): Unit

    func sfTransform_translate(transform: CPointer<Transform>, offset: Vector2f): Unit

    func sfTransform_rotate(transform: CPointer<Transform>, angle: Float32): Unit

    func sfTransform_rotateWithCenter(transform: CPointer<Transform>, angle: Float32, center: Vector2f): Unit

    func sfTransform_scale(transform: CPointer<Transform>, scale: Vector2f): Unit

    func sfTransform_scaleWithCenter(transform: CPointer<Transform>, scale: Vector2f, center: Vector2f): Unit
}

// cjlint-ignore -start !G.EXP.02 comparing floats

/**
 * @brief 3x3 transform matrix
 *
 * A `Transform` specifies how to translate, rotate, scale,
 * shear, project, whatever things. In mathematical terms, it defines
 * how to transform a coordinate system into another.
 *
 * For example, if you apply a rotation transform to a sprite, the
 * result will be a rotated sprite. And anything that is transformed
 * by this rotation transform will be rotated the same way, according
 * to its initial position.
 *
 * Transforms are typically used for drawing. But they can also be
 * used for any computation that requires to transform points between
 * the local and global coordinate systems of an entity (like collision
 * detection).
 *
 * Example:
 * ```
 * // define a translation transform
 * let translation = Transform()
 * translation.translate(Vector2f(20, 50))
 *
 * // define a rotation transform
 * let rotation = Transform()
 * rotation.rotate(45)
 *
 * // combine them
 * let transform = translation.combine(rotation)
 *
 * // use the result to transform stuff...
 * let point = transform.transform(Vector2f(10, 20))
 * let rect = transform.transform(FloatRect(Vector2f(0, 0), Vector2f(10, 100)))
 * ```
 */
@C
public struct Transform {
    public var matrix: VArray<Float32, $9> = VArray<Float32, $9>(repeat: 0.0)

    /**
     * @brief Default constructor
     *
     * Creates an identity transform (a transform that does nothing).
     */
    public init() {
        matrix[0] = 1.0
        matrix[4] = 1.0
        matrix[8] = 1.0
    }

    /**
     * @brief Construct a transform from a 3x3 matrix
     *
     * @param a00 Element (0, 0) of the matrix
     * @param a01 Element (0, 1) of the matrix
     * @param a02 Element (0, 2) of the matrix
     * @param a10 Element (1, 0) of the matrix
     * @param a11 Element (1, 1) of the matrix
     * @param a12 Element (1, 2) of the matrix
     * @param a20 Element (2, 0) of the matrix
     * @param a21 Element (2, 1) of the matrix
     * @param a22 Element (2, 2) of the matrix
     */
    public init(a00: Float32, a01: Float32, a02: Float32, a10: Float32, a11: Float32, a12: Float32, a20: Float32,
        a21: Float32, a22: Float32) {
        matrix[0] = a00
        matrix[1] = a01
        matrix[2] = a02
        matrix[3] = a10
        matrix[4] = a11
        matrix[5] = a12
        matrix[6] = a20
        matrix[7] = a21
        matrix[8] = a22
    }

    public operator func ==(right: Transform): Bool {
        (matrix[0] == right.matrix[0] && matrix[1] == right.matrix[1] && matrix[2] == right.matrix[2] && matrix[3] == right
            .matrix[3] && matrix[4] == right.matrix[4] && matrix[5] == right.matrix[5] && matrix[6] == right.matrix[6] &&
            matrix[7] == right.matrix[7] && matrix[8] == right.matrix[8])
    }

    public operator func !=(right: Transform): Bool {
        (matrix[0] != right.matrix[0] || matrix[1] != right.matrix[1] || matrix[2] != right.matrix[2] || matrix[3] != right
            .matrix[3] || matrix[4] != right.matrix[4] || matrix[5] != right.matrix[5] || matrix[6] != right.matrix[6] ||
            matrix[7] != right.matrix[7] || matrix[8] != right.matrix[8])
    }

    // cjlint-ignore -start !G.OPR.01 uncommon operator overloading

    public operator func [](index: Int64): Float32 {
        matrix[index]
    }

    public operator func [](x: Int64, y: Int64): Float32 {
        matrix[x * 3 + y]
    }

    // these 2 functions cause a compiler error in Cangjie 1.0.0

    // public operator func [](index: Int64, value!: Float32): Unit {
    //     matrix[index] = value
    // }

    // public operator func [](x: Int64, y: Int64, value!: Float32): Unit {
    //     matrix[x * 3 + y] = value
    // }

    // cjlint-ignore -end uncommon operator overloading

    /**
     * @brief The identity transform (does nothing)
     */
    public static let IDENTITY: Transform = Transform()

    /**
     * @brief Return the transform as a 4x4 matrix
     *
     * This function returns an array of 16 floats
     * containing the transform elements as a 4x4 matrix, which
     * is directly compatible with OpenGL functions.
     *
     * @return Array containing the 4x4 matrix
     */
    public func getMatrix(): Array<Float32> {
        var matrix2 = Array<Float32>(16, repeat: 0.0)
        unsafe {
            let rawData = acquireArrayRawData(matrix2)
            try {
                var transform2 = this
                sfTransform_getMatrix(inout transform2, rawData.pointer)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        return matrix2
    }

    /**
     * @brief Return the inverse of the transform
     *
     * If the inverse cannot be computed, an identity transform
     * is returned.
     *
     * @return A new transform which is the inverse of self
     */
    public func getInverse(): Transform {
        unsafe {
            var transform2 = this
            return sfTransform_getInverse(inout transform2)
        }
    }

    /**
     * @brief Transform a 2D point
     *
     * @param point Point to transform
     *
     * @return Transformed point
     */
    public func transform(point: Vector2f): Vector2f {
        unsafe {
            var transform2 = this
            return sfTransform_transformPoint(inout transform2, point)
        }
    }

    public func transform(x: Float32, y: Float32): Vector2f {
        transform(Vector2f(x, y))
    }

    /**
     * @brief Transform a rectangle
     *
     * Since SFML doesn't provide support for oriented rectangles,
     * the result of this function is always an axis-aligned
     * rectangle. Which means that if the transform contains a
     * rotation, the bounding rectangle of the transformed rectangle
     * is returned.
     *
     * @param rect Rectangle to transform
     *
     * @return Transformed rectangle
     */
    public func transform(rect: FloatRect): FloatRect { // cjlint-ignore !G.DCL.01 function name already exists
        unsafe {
            var transform2 = this
            return sfTransform_transformRect(inout transform2, rect)
        }
    }

    /**
     * @brief Combine the current transform with another one
     *
     * The result is a transform that is equivalent to applying
     * `transform` followed by `this`. Mathematically, it is
     * equivalent to a matrix multiplication `(this) * transform`.
     *
     * @param other Transform to combine with this transform
     *
     * @return Reference to `this`
     */
    public func combine(other: Transform): Transform {
        unsafe {
            var transform2 = this
            var other2 = other
            sfTransform_combine(inout transform2, inout other2)
            return transform2
        }
    }

    /**
     * @brief Combine the current transform with a translation
     *
     * This function returns a reference to `this`, so that calls
     * can be chained.
     *
     * @param offset Translation offset to apply
     *
     * @return Reference to `this`
     *
     * @see `rotate`, `scale`
     */
    public func translate(offset: Vector2f): Transform {
        unsafe {
            var transform2 = this
            sfTransform_translate(inout transform2, offset)
            return transform2
        }
    }

    /**
     * @brief Combine the current transform with a rotation
     *
     * This function returns a reference to `this`, so that calls
     * can be chained.
     *
     * @param angle Rotation angle, in degrees
     *
     * @return Reference to `this`
     *
     * @see `translate`, `scale`
     */
    public func rotate(angle: Float32): Transform {
        unsafe {
            var transform2 = this
            sfTransform_rotate(inout transform2, angle)
            return transform2
        }
    }

    /**
     * @brief Combine the current transform with a rotation
     *
     * The center of rotation is provided for convenience as a second
     * argument, so that you can build rotations around arbitrary points
     * more easily (and efficiently) than the usual
     * `translate(-center).rotate(angle).translate(center)`.
     *
     * This function returns a reference to `this`, so that calls
     * can be chained.
     *
     * @param angle Rotation angle, in degrees
     * @param center Center of rotation
     *
     * @return Reference to `this`
     *
     * @see `translate`, `scale`
     */
    public func rotate(angle: Float32, center: Vector2f): Transform {
        unsafe {
            var transform2 = this
            sfTransform_rotateWithCenter(inout transform2, angle, center)
            return transform2
        }
    }

    /**
     * @brief Combine the current transform with a scaling
     *
     * This function returns a reference to `this`, so that calls
     * can be chained.
     *
     * @param factors Scaling factors
     *
     * @return Reference to `this`
     *
     * @see `translate`, `rotate`
     */
    public func scale(factors: Vector2f): Transform {
        unsafe {
            var transform2 = this
            sfTransform_scale(inout transform2, factors)
            return transform2
        }
    }

    /**
     * @brief Combine the current transform with a scaling
     *
     * The center of scaling is provided for convenience as a second
     * argument, so that you can build scaling around arbitrary points
     * more easily (and efficiently) than the usual
     * `translate(-center).scale(factors).translate(center)`.
     *
     * This function returns a reference to `this`, so that calls
     * can be chained.
     *
     * @param factors Scaling factors
     * @param center Center of scaling
     *
     * @return Reference to `this`
     *
     * @see `translate`, `rotate`
     */
    public func scale(factors: Vector2f, center: Vector2f): Transform {
        unsafe {
            var transform2 = this
            sfTransform_scaleWithCenter(inout transform2, factors, center)
            return transform2
        }
    }
}

// cjlint-ignore -end comparing floats
