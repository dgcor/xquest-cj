package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

foreign {
    func sfView_create(): CPointer<Unit>

    func sfView_createFromRect(rectangle: FloatRect): CPointer<Unit>

    func sfView_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfView_destroy(handle: CPointer<Unit>): Unit

    // View

    @FastNative
    func sfView_setCenter(handle: CPointer<Unit>, center: Vector2f): Unit

    @FastNative
    func sfView_setSize(handle: CPointer<Unit>, size: Vector2f): Unit

    @FastNative
    func sfView_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    @FastNative
    func sfView_setViewport(handle: CPointer<Unit>, viewport: FloatRect): Unit

    @FastNative
    func sfView_setScissor(handle: CPointer<Unit>, scissor: FloatRect): Unit

    @FastNative
    func sfView_getCenter(handle: CPointer<Unit>): Vector2f

    @FastNative
    func sfView_getSize(handle: CPointer<Unit>): Vector2f

    @FastNative
    func sfView_getRotation(handle: CPointer<Unit>): Float32

    @FastNative
    func sfView_getViewport(handle: CPointer<Unit>): FloatRect

    @FastNative
    func sfView_getScissor(handle: CPointer<Unit>): FloatRect

    @FastNative
    func sfView_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    @FastNative
    func sfView_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    @FastNative
    func sfView_zoom(handle: CPointer<Unit>, factor: Float32): Unit
}

/**
 * 2D camera that defines what region is shown on screen.
 *
 * `View` defines a camera in the 2D scene. This is a
 * very powerful concept: you can scroll, rotate or zoom
 * the entire scene without altering the way that your
 * drawable objects are drawn.
 *
 * A view is composed of a source rectangle, which defines
 * what part of the 2D scene is shown, and a target viewport,
 * which defines where the contents of the source rectangle
 * will be displayed on the render target (window or texture).
 *
 * The viewport allows to map the scene to a custom part
 * of the render target, and can be used for split-screen
 * or for displaying a minimap, for example. If the source
 * rectangle doesn't have the same size as the viewport, its
 * contents will be stretched to fit in.
 *
 * The scissor rectangle allows for specifying regions of the
 * render target to which modifications can be made by draw
 * and clear operations. Only pixels that are within the region
 * will be able to be modified. Pixels outside of the region will
 * not be modified by draw or clear operations.
 *
 * Certain effects can be created by either using the viewport or
 * scissor rectangle. While the results appear identical, there
 * can be times where one method should be preferred over the other.
 * Viewport transformations are applied during the vertex processing
 * stage of the graphics pipeline, before the primitives are
 * rasterized into fragments for fragment processing. Since
 * viewport processing has to be performed and cannot be disabled,
 * effects that are performed using the viewport transform are
 * basically free performance-wise. Scissor testing is performed in
 * the per-sample processing stage of the graphics pipeline, after
 * fragment processing has been performed. Because per-sample
 * processing is performed at the last stage of the pipeline,
 * fragments that are discarded at this stage will cause the
 * highest waste of GPU resources compared to any method that
 * would have discarded vertices or fragments earlier in the
 * pipeline. There are situations in which scissor testing has
 * to be used to control whether fragments are discarded or not.
 * An example of such a situation is when performing the viewport
 * transform on vertices is necessary but a subset of the generated
 * fragments should not have an effect on the stencil buffer or
 * blend with the color buffer.
 *
 * To apply a view, you have to assign it to the render target.
 * Then, objects drawn in this render target will be
 * affected by the view until you use another view.
 *
 * Usage example:
 * ```
 * // Initialize the view to a rectangle located at (100, 100) and with a size of 400x200
 * let view = View(FloatRect(Vector2f(100.0, 100.0), Vector2f(400.0, 200.0)));
 *
 * // Rotate it by 45 degrees
 * view.rotate(45.0);
 *
 * // Set its target viewport to be half of the window
 * view.viewport = FloatRect(Vector2f(0.0, 0.0), Vector2f(0.5, 1.0));
 *
 * // Apply it
 * window.view = view;
 *
 * // Render stuff
 * window.draw(someSprite);
 *
 * // Set the default view back
 * window.view = window.defaultView;
 *
 * // Render stuff not affected by the view
 * window.draw(someText);
 * ```
 *
 * @see `RenderWindow`, `RenderTexture`
 */
public class View <: ResourceHandle & Equatable<View> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    /**
     * Default constructor.
     *
     * This constructor creates a default view of (0, 0, 1000, 1000).
     *
     * @throws SFMLNullHandleException
     */
    public init() {
        m_handle = unsafe { sfView_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * Construct the view from a rectangle.
     *
     * @param rectangle Rectangle defining the zone to display
     *
     * @throws SFMLNullHandleException
     */
    public init(rectangle: FloatRect) {
        m_handle = unsafe { sfView_createFromRect(rectangle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * Construct the view from an existing handle.
     *
     * @param handle  The handle to use.
     * @param isOwner Whether this instance owns the handle.
     *
     * @throws SFMLNullHandleException
     */
    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    ~init() {
        if (m_handle.isNotNull() && m_isOwner) {
            unsafe { sfView_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the view.
     *
     * @return A new view instance that is a copy of this one.
     */
    public func clone(): View {
        View(unsafe { sfView_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || !m_isOwner) {
            return
        }
        unsafe { sfView_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    public override prop isOwner: Bool {
        get() {
            m_isOwner
        }
    }

    // Equatable

    public override operator func ==(right: View): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: View): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // View

    /**
     * Set the center of the view.
     *
     * @param value New center
     *
     * @see `size`, `center`
     */
    public mut prop center: Vector2f {
        get() {
            unsafe { sfView_getCenter(m_handle) }
        }
        set(value) {
            unsafe { sfView_setCenter(m_handle, value) }
        }
    }

    /**
     * Set the size of the view.
     *
     * @param value New size
     *
     * @see `center`, `center`
     */
    public mut prop size: Vector2f {
        get() {
            unsafe { sfView_getSize(m_handle) }
        }
        set(value) {
            unsafe { sfView_setSize(m_handle, value) }
        }
    }

    /**
     * Set the orientation of the view.
     *
     * The default rotation of a view is 0 degree.
     *
     * @param value New angle, in degrees.
     *
     * @see `rotation`
     */
    public mut prop rotation: Float32 {
        get() {
            unsafe { sfView_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfView_setRotation(m_handle, value) }
        }
    }

    /**
     * Set the target viewport.
     *
     * The viewport is the rectangle into which the contents of the
     * view are displayed, expressed as a factor (between 0 and 1)
     * of the size of the RenderTarget to which the view is applied.
     * For example, a view which takes the left side of the target would
     * be defined with `view.viewport = FloatRect(Vector2f(0.0, 0.0), Vector2f(0.5, 1.0))`.
     * By default, a view has a viewport which covers the entire target.
     *
     * @param value New viewport rectangle
     *
     * @see `viewport`
     */
    public mut prop viewport: FloatRect {
        get() {
            unsafe { sfView_getViewport(m_handle) }
        }
        set(value) {
            unsafe { sfView_setViewport(m_handle, value) }
        }
    }

    /**
     * Set the target scissor rectangle.
     *
     * The scissor rectangle, expressed as a factor (between 0 and 1) of
     * the RenderTarget, specifies the region of the RenderTarget whose
     * pixels are able to be modified by draw or clear operations.
     * Any pixels which lie outside of the scissor rectangle will
     * not be modified by draw or clear operations.
     * For example, a scissor rectangle which only allows modifications
     * to the right side of the target would be defined
     * with `view.scissor = FloatRect(Vector2f(0.5, 0.0), Vector2f(0.5, 1.0))`.
     * By default, a view has a scissor rectangle which allows
     * modifications to the entire target. This is equivalent to
     * disabling the scissor test entirely. Passing the default
     * scissor rectangle to this function will also disable
     * scissor testing.
     *
     * @param value New scissor rectangle
     *
     * @see `scissor`
     */
    public mut prop scissor: FloatRect {
        get() {
            unsafe { sfView_getScissor(m_handle) }
        }
        set(value) {
            unsafe { sfView_setScissor(m_handle, value) }
        }
    }

    /**
     * Reset the view to the given rectangle.
     *
     * Note that this function resets the rotation and zoom.
     *
     * @param rectangle Rectangle defining the zone to display
     */
    public func reset(rectangle: FloatRect): Unit {
        unsafe {
            let center = Vector2f(
                rectangle.position.x + rectangle.size.x / 2.0,
                rectangle.position.y + rectangle.size.y / 2.0
            )
            let size = rectangle.size
            let defaultRect = FloatRect(0.0, 0.0, 1.0, 1.0)

            sfView_setCenter(m_handle, center)
            sfView_setSize(m_handle, size)
            sfView_setRotation(m_handle, 0.0)
            sfView_setViewport(m_handle, defaultRect)
            sfView_setScissor(m_handle, defaultRect)
        }
    }

    /**
     * Move the view relative to its current position.
     *
     * @param offset Move offset
     *
     * @see `center`, `rotate`, `zoom`
     */
    public func move(offset: Vector2f): Unit {
        unsafe { sfView_move(m_handle, offset) }
    }

    /**
     * Rotate the view relative to its current orientation.
     *
     * @param angle Angle to rotate, in degrees
     *
     * @see `rotation`, `move`, `zoom`
     */
    public func rotate(angle: Float32): Unit {
        unsafe { sfView_rotate(m_handle, angle) }
    }

    /**
     * Resize the view rectangle relative to its current size.
     *
     * Resizing the view simulates a zoom, as the zone displayed on
     * screen grows or shrinks.
     * `factor` is a multiplier:
     * - 1 keeps the size unchanged
     * - > 1 makes the view bigger (objects appear smaller)
     * - < 1 makes the view smaller (objects appear bigger)
     *
     * @param factor Zoom factor to apply
     *
     * @see `size`, `move`, `rotate`
     */
    public func zoom(factor: Float32): Unit {
        unsafe { sfView_zoom(m_handle, factor) }
    }
}
