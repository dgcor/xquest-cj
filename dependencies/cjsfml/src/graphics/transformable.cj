package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

/**
 * Decomposed transform defined by a position, a rotation and a scale.
 *
 * This class is provided for convenience, on top of `Transform`.
 *
 * `Transform`, as a low-level class, offers a great level of
 * flexibility but it is not always convenient to manage. Indeed,
 * one can easily combine any kind of operation, such as a translation
 * followed by a rotation followed by a scaling, but once the result
 * transform is built, there's no way to go backward and, let's say,
 * change only the rotation without modifying the translation and scaling.
 * The entire transform must be recomputed, which means that you
 * need to retrieve the initial translation and scale factors as
 * well, and combine them the same way you did before updating the
 * rotation. This is a tedious operation, and it requires to store
 * all the individual components of the final transform.
 *
 * That's exactly what `Transformable` was written for: it hides
 * these variables and the composed transform behind an easy to use
 * interface. You can set or get any of the individual components
 * without worrying about the others. It also provides the composed
 * transform (as a `Transform`), and keeps it up-to-date.
 *
 * In addition to the position, rotation and scale, `Transformable`
 * provides an "origin" component, which represents the local origin
 * of the three other components. Let's take an example with a 10x10
 * pixels sprite. By default, the sprite is positioned/rotated/scaled
 * relative to its top-left corner, because it is the local point
 * (0, 0). But if we change the origin to be (5, 5), the sprite will
 * be positioned/rotated/scaled around its center instead. And if
 * we set the origin to (10, 10), it will be transformed around its
 * bottom-right corner.
 *
 * To keep the `Transformable` class simple, there's only one
 * origin for all the components. You cannot position the sprite
 * relative to its top-left corner while rotating it around its
 * center, for example. To do such things, use `Transform` directly.
 *
 * `Transformable` can be used as a base class. It is often
 * combined with `Drawable` -- that's what SFML's sprites,
 * texts and shapes do.
 * ```
 * class MyEntity <: Transformable & RenderTargetDrawable {
 *     public func draw(window: RenderWindow, states: RenderStates): Unit {
 *         var states2 = states
 *         states2.transform = states2.transform * transform
 *         // ... draw children ...
 *     }
 * }
 *
 * let entity = MyEntity();
 * entity.position = Vector2f(10.0, 20.0);
 * entity.rotation = 45.0;
 * window.draw(entity);
 * ```
 *
 * A note on coordinates and undistorted rendering:
 * By default, SFML (or more exactly, OpenGL) may interpolate drawable objects
 * such as sprites or texts when rendering. While this allows transitions
 * like slow movements or rotations to appear smoothly, it can lead to
 * unwanted results in some cases, for example blurred or distorted objects.
 * In order to render a `Drawable` object pixel-perfectly, make sure
 * the involved coordinates allow a 1:1 mapping of pixels in the window
 * to texels (pixels in the texture). More specifically, this means:
 * - The object's position, origin and scale have no fractional part
 * - The object's and the view's rotation are a multiple of 90 degrees
 * - The view's center and size have no fractional part
 *
 * @see `Transform`
 */
public interface Transformable {
    /**
     * Set the position of the object.
     *
     * This function completely overwrites the previous position.
     * See the move function to apply an offset based on the previous position instead.
     * The default position of a transformable object is (0, 0).
     */
    mut prop position: Vector2f

    /**
     * Set the orientation of the object.
     *
     * This function completely overwrites the previous rotation.
     * See the rotate function to add an angle based on the previous rotation instead.
     * The default rotation of a transformable object is 0.
     */
    mut prop rotation: Float32

    /**
     * Set the scale factors of the object.
     *
     * This function completely overwrites the previous scale.
     * See the scale function to add a factor based on the previous scale instead.
     * The default scale of a transformable object is (1, 1).
     */
    mut prop scaleVal: Vector2f

    /**
     * Set the local origin of the object.
     *
     * The origin of an object defines the center point for
     * all transformations (position, scale, rotation).
     * The coordinates of this point must be relative to the
     * top-left corner of the object, and ignore all
     * transformations (position, scale, rotation).
     * The default origin of a transformable object is (0, 0).
     */
    mut prop origin: Vector2f

    /**
     * Move the object by a given offset.
     *
     * This function adds to the current position of the object,
     * unlike `position` which overwrites it.
     *
     * @param offset Offset
     */
    func move(offset: Vector2f): Unit

    /**
     * Rotate the object.
     *
     * This function adds to the current rotation of the object,
     * unlike `rotation` which overwrites it.
     *
     * @param angle Angle of rotation
     */
    func rotate(angle: Float32): Unit

    /**
     * Scale the object.
     *
     * This function multiplies the current scale of the object,
     * unlike `scaleVal` which overwrites it.
     *
     * @param factor Scale factors
     */
    func scale(factor: Vector2f): Unit

    /**
     * Get the combined transform of the object.
     *
     * @return Transform combining the position/rotation/scale/origin of the object
     */
    prop transform: Transform

    /**
     * Get the inverse of the combined transform of the object.
     *
     * @return Inverse of the combined transformations applied to the object
     */
    prop inverseTransform: Transform
}

foreign {
    func sfTransformable_create(): CPointer<Unit>

    func sfTransformable_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfTransformable_destroy(handle: CPointer<Unit>): Unit

    func sfTransformable_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfTransformable_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfTransformable_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfTransformable_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfTransformable_getPosition(handle: CPointer<Unit>): Vector2f

    func sfTransformable_getRotation(handle: CPointer<Unit>): Float32

    func sfTransformable_getScale(handle: CPointer<Unit>): Vector2f

    func sfTransformable_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfTransformable_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfTransformable_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfTransformable_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfTransformable_getTransform(handle: CPointer<Unit>): Transform

    func sfTransformable_getInverseTransform(handle: CPointer<Unit>): Transform
}

public class TransformableImpl <: ResourceHandle & Transformable & Equatable<TransformableImpl> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Default constructor.
     *
     * @throws SFMLNullHandleException
     */
    public init() {
        m_handle = unsafe { sfTransformable_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the transformable from an existing handle.
     *
     * @param handle The handle to use.
     *
     * @throws SFMLNullHandleException
     */
    private init(handle: CPointer<Unit>) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfTransformable_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the transformable.
     *
     * @return A new transformable instance that is a copy of this one.
     */
    public func clone(): TransformableImpl {
        TransformableImpl(unsafe { sfTransformable_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfTransformable_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public override operator func ==(right: TransformableImpl): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: TransformableImpl): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Transformable

    /**
     * Set the position of the object.
     *
     * This function completely overwrites the previous position.
     * See the move function to apply an offset based on the previous position instead.
     * The default position of a transformable object is (0, 0).
     */
    public mut prop position: Vector2f {
        get() {
            unsafe { sfTransformable_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setPosition(m_handle, value) }
        }
    }

    /**
     * Set the orientation of the object.
     *
     * This function completely overwrites the previous rotation.
     * See the rotate function to add an angle based on the previous rotation instead.
     * The default rotation of a transformable object is 0.
     */
    public mut prop rotation: Float32 {
        get() {
            unsafe { sfTransformable_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setRotation(m_handle, value) }
        }
    }

    /**
     * Set the scale factors of the object.
     *
     * This function completely overwrites the previous scale.
     * See the scale function to add a factor based on the previous scale instead.
     * The default scale of a transformable object is (1, 1).
     */
    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfTransformable_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setScale(m_handle, value) }
        }
    }

    /**
     * Set the local origin of the object.
     *
     * The origin of an object defines the center point for
     * all transformations (position, scale, rotation).
     * The coordinates of this point must be relative to the
     * top-left corner of the object, and ignore all
     * transformations (position, scale, rotation).
     * The default origin of a transformable object is (0, 0).
     */
    public mut prop origin: Vector2f {
        get() {
            unsafe { sfTransformable_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setOrigin(m_handle, value) }
        }
    }

    /**
     * Move the object by a given offset.
     *
     * This function adds to the current position of the object,
     * unlike `position` which overwrites it.
     *
     * @param offset Offset
     */
    public func move(offset: Vector2f): Unit {
        unsafe { sfTransformable_move(m_handle, offset) }
    }

    /**
     * Rotate the object.
     *
     * This function adds to the current rotation of the object,
     * unlike `rotation` which overwrites it.
     *
     * @param angle Angle of rotation
     */
    public func rotate(angle: Float32): Unit {
        unsafe { sfTransformable_rotate(m_handle, angle) }
    }

    /**
     * Scale the object.
     *
     * This function multiplies the current scale of the object,
     * unlike `scaleVal` which overwrites it.
     *
     * @param factor Scale factors
     */
    public func scale(factors: Vector2f): Unit {
        unsafe { sfTransformable_scale(m_handle, factors) }
    }

    /**
     * Get the combined transform of the object.
     *
     * @return Transform combining the position/rotation/scale/origin of the object
     */
    public prop transform: Transform {
        get() {
            unsafe { sfTransformable_getTransform(m_handle) }
        }
    }

    /**
     * Get the inverse of the combined transform of the object.
     *
     * @return Inverse of the combined transformations applied to the object
     */
    public prop inverseTransform: Transform {
        get() {
            unsafe { sfTransformable_getInverseTransform(m_handle) }
        }
    }
}
