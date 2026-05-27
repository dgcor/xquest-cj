package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

foreign {
    func sfCircleShape_create(): CPointer<Unit>

    func sfCircleShape_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfCircleShape_destroy(handle: CPointer<Unit>): Unit

    // Transformable

    func sfCircleShape_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfCircleShape_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfCircleShape_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfCircleShape_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfCircleShape_getPosition(handle: CPointer<Unit>): Vector2f

    func sfCircleShape_getRotation(handle: CPointer<Unit>): Float32

    func sfCircleShape_getScale(handle: CPointer<Unit>): Vector2f

    func sfCircleShape_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfCircleShape_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfCircleShape_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfCircleShape_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfCircleShape_getTransform(handle: CPointer<Unit>): Transform

    func sfCircleShape_getInverseTransform(handle: CPointer<Unit>): Transform

    // Shape

    func sfCircleShape_setTexture(handle: CPointer<Unit>, texture: CPointer<Unit>, resetRect: Bool): Unit

    func sfCircleShape_setTextureRect(handle: CPointer<Unit>, rect: IntRect): Unit

    func sfCircleShape_setFillColor(handle: CPointer<Unit>, color: Color): Unit

    func sfCircleShape_setOutlineColor(handle: CPointer<Unit>, color: Color): Unit

    func sfCircleShape_setOutlineThickness(handle: CPointer<Unit>, thickness: Float32): Unit

    func sfCircleShape_getTexture(handle: CPointer<Unit>): CPointer<Unit>

    func sfCircleShape_getTextureRect(handle: CPointer<Unit>): IntRect

    func sfCircleShape_getFillColor(handle: CPointer<Unit>): Color

    func sfCircleShape_getOutlineColor(handle: CPointer<Unit>): Color

    func sfCircleShape_getOutlineThickness(handle: CPointer<Unit>): Float32

    func sfCircleShape_getPointCount(handle: CPointer<Unit>): UIntNative

    func sfCircleShape_getPoint(handle: CPointer<Unit>, index: UIntNative): Vector2f

    func sfCircleShape_getGeometricCenter(handle: CPointer<Unit>): Vector2f

    func sfCircleShape_setRadius(handle: CPointer<Unit>, radius: Float32): Unit

    func sfCircleShape_getRadius(handle: CPointer<Unit>): Float32

    func sfCircleShape_setPointCount(handle: CPointer<Unit>, count: UIntNative): Unit

    func sfCircleShape_getLocalBounds(handle: CPointer<Unit>): FloatRect

    func sfCircleShape_getGlobalBounds(handle: CPointer<Unit>): FloatRect
}

/**
 * Specialized shape representing a circle.
 *
 * This class inherits all the functions of `Transformable`
 * (position, rotation, scale, bounds, ...) as well as the
 * functions of `Shape` (outline, color, texture, ...).
 *
 * Usage example:
 * ```
 * let circle = CircleShape();
 * circle.radius = 150.0;
 * circle.outlineColor = Color.RED;
 * circle.outlineThickness = 5.0;
 * circle.position = Vector2f(10.0, 20.0);
 * ...
 * window.draw(circle);
 * ```
 *
 * Since the graphics card can't draw perfect circles, we have to
 * fake them with multiple triangles connected to each other. The
 * "points count" property of `CircleShape` defines how many of these
 * triangles to use, and therefore defines the quality of the circle.
 *
 * The number of points can also be used for another purpose; with
 * small numbers you can create any regular polygon shape:
 * equilateral triangle, square, pentagon, hexagon, ...
 *
 * @see `Shape`, `RectangleShape`, `ConvexShape`
 */
public class CircleShape <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<CircleShape> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Default constructor.
     *
     * @throws SFMLNullHandleException
     */
    public init() {
        this(0.0)
    }

    /**
     * Construct the circle shape with a radius.
     *
     * @param radius     Radius of the circle
     * @param pointCount Number of points composing the circle
     *
     * @throws SFMLNullHandleException
     */
    public init(radius: Float32, pointCount!: UInt32 = 30) {
        m_handle = unsafe { sfCircleShape_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        if (radius > 0.0) {
            unsafe { sfCircleShape_setRadius(m_handle, radius) }
        }
        if (pointCount > 0 && pointCount != 30) {
            unsafe { sfCircleShape_setPointCount(m_handle, UIntNative(pointCount)) }
        }
    }

    /**
     * Construct the circle shape from an existing handle.
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
            unsafe { sfCircleShape_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the shape.
     *
     * @return A new shape instance that is a copy of this one.
     */
    public func clone(): CircleShape {
        CircleShape(unsafe { sfCircleShape_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfCircleShape_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public override operator func ==(right: CircleShape): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: CircleShape): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawCircleShape(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawCircleShape(window.handle, m_handle, inout states2)
        }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfCircleShape_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfCircleShape_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfCircleShape_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfCircleShape_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfCircleShape_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfCircleShape_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfCircleShape_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfCircleShape_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfCircleShape_getInverseTransform(m_handle) }
        }
    }

    // Shape

    /**
     * Get the source texture of the shape.
     *
     * If the shape has no source texture, a `None` is returned.
     * The returned reference is const, which means that you can't
     * modify the texture when you retrieve it with this function.
     *
     * @return Reference to the shape's texture
     */
    public mut prop texture: ?Texture {
        get() {
            let texturePtr = unsafe { sfCircleShape_getTexture(m_handle) }
            if (texturePtr.isNull()) {
                return None
            }
            Texture(texturePtr, isOwner: false)
        }
        set(value) {
            setTexture(value)
        }
    }

    /**
     * Change the source texture of the shape.
     *
     * The `texture` argument refers to a texture that must
     * exist as long as the shape uses it. Indeed, the shape
     * doesn't store its own copy of the texture, but rather keeps
     * a pointer to the one that you passed to this function.
     * If the source texture is destroyed and the shape tries to
     * use it, the behavior is undefined.
     * `resetRect` automatically adjusts the texture rectangle
     * to the size of the new texture.
     *
     * @param texture   New texture
     * @param resetRect Should the texture rect be reset to the size of the new texture?
     */
    public func setTexture(texture: ?Texture, resetRect!: Bool = false): Unit {
        unsafe { sfCircleShape_setTexture(m_handle, texture?.handle ?? CPointer(), resetRect) }
    }

    /**
     * Set the sub-rectangle of the texture that the shape will display.
     *
     * By default, the texture rect covers the entire texture.
     *
     * @param value Rectangle defining the region of the texture to display
     */
    public mut prop textureRect: IntRect {
        get() {
            unsafe { sfCircleShape_getTextureRect(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setTextureRect(m_handle, value) }
        }
    }

    /**
     * Set the fill color of the shape.
     *
     * This color is modulated (multiplied) with the shape's
     * texture if any. It can be used to colorize the shape,
     * or change its global opacity.
     * By default, the shape's fill color is opaque white.
     *
     * @param value New fill color of the shape
     */
    public mut prop fillColor: Color {
        get() {
            unsafe { sfCircleShape_getFillColor(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setFillColor(m_handle, value) }
        }
    }

    /**
     * Set the outline color of the shape.
     *
     * By default, the shape's outline color is opaque white.
     *
     * @param value New outline color of the shape
     */
    public mut prop outlineColor: Color {
        get() {
            unsafe { sfCircleShape_getOutlineColor(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setOutlineColor(m_handle, value) }
        }
    }

    /**
     * Set the thickness of the shape's outline.
     *
     * By default, the outline thickness is 0.
     *
     * Be aware that using a negative value for the outline
     * thickness will cause distorted rendering.
     *
     * @param value New outline thickness, in pixels
     */
    public mut prop outlineThickness: Float32 {
        get() {
            unsafe { sfCircleShape_getOutlineThickness(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setOutlineThickness(m_handle, value) }
        }
    }

    /**
     * Get the number of points of the circle.
     *
     * @return Number of points of the circle
     */
    public mut prop pointCount: UInt32 {
        get() {
            unsafe { UInt32(sfCircleShape_getPointCount(m_handle)) }
        }
        set(value) {
            unsafe { sfCircleShape_setPointCount(m_handle, UIntNative(value)) }
        }
    }

    /**
     * Get a point of the circle.
     *
     * The returned point is in local coordinates, that is,
     * the shape's transforms (position, rotation, scale) are
     * not taken into account.
     * The result is undefined if `index` is out of the valid range.
     *
     * @param index Index of the point to get, in range [0 .. `pointCount` - 1]
     *
     * @return `index`-th point of the shape
     */
    public func getPoint(index: UInt32): Vector2f {
        unsafe { sfCircleShape_getPoint(m_handle, UIntNative(index)) }
    }

    /**
     * Get the geometric center of the circle.
     *
     * The returned point is in local coordinates, that is,
     * the shape's transforms (position, rotation, scale) are
     * not taken into account.
     *
     * @return The geometric center of the shape
     */
    public prop geometricCenter: Vector2f {
        get() {
            unsafe { sfCircleShape_getGeometricCenter(m_handle) }
        }
    }

    /**
     * Set the radius of the circle.
     *
     * @param value New radius of the circle
     */
    public mut prop radius: Float32 {
        get() {
            unsafe { sfCircleShape_getRadius(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setRadius(m_handle, value) }
        }
    }

    /**
     * Get the local bounding rectangle of the entity.
     *
     * The returned rectangle is in local coordinates, which means
     * that it ignores the transformations (translation, rotation,
     * scale, ...) that are applied to the entity.
     * In other words, this function returns the bounds of the
     * entity in the entity's coordinate system.
     *
     * @return Local bounding rectangle of the entity
     */
    public prop localBounds: FloatRect {
        get() {
            unsafe { sfCircleShape_getLocalBounds(m_handle) }
        }
    }

    /**
     * Get the global bounding rectangle of the entity.
     *
     * The returned rectangle is in global coordinates, which means
     * that it takes into account the transformations (translation,
     * rotation, scale, ...) that are applied to the entity.
     * In other words, this function returns the bounds of the
     * shape in the global 2D world's coordinate system.
     *
     * @return Global bounding rectangle of the entity
     */
    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfCircleShape_getGlobalBounds(m_handle) }
        }
    }
}
