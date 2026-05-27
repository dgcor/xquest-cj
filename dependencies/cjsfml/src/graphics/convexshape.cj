package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

foreign {
    func sfConvexShape_create(): CPointer<Unit>

    func sfConvexShape_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfConvexShape_destroy(handle: CPointer<Unit>): Unit

    // Transformable

    func sfConvexShape_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfConvexShape_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfConvexShape_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfConvexShape_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfConvexShape_getPosition(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_getRotation(handle: CPointer<Unit>): Float32

    func sfConvexShape_getScale(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfConvexShape_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfConvexShape_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfConvexShape_getTransform(handle: CPointer<Unit>): Transform

    func sfConvexShape_getInverseTransform(handle: CPointer<Unit>): Transform

    // Shape

    func sfConvexShape_setTexture(handle: CPointer<Unit>, texture: CPointer<Unit>, resetRect: Bool): Unit

    func sfConvexShape_setTextureRect(handle: CPointer<Unit>, rect: IntRect): Unit

    func sfConvexShape_setFillColor(handle: CPointer<Unit>, color: Color): Unit

    func sfConvexShape_setOutlineColor(handle: CPointer<Unit>, color: Color): Unit

    func sfConvexShape_setOutlineThickness(handle: CPointer<Unit>, thickness: Float32): Unit

    func sfConvexShape_getTexture(handle: CPointer<Unit>): CPointer<Unit>

    func sfConvexShape_getTextureRect(handle: CPointer<Unit>): IntRect

    func sfConvexShape_getFillColor(handle: CPointer<Unit>): Color

    func sfConvexShape_getOutlineColor(handle: CPointer<Unit>): Color

    func sfConvexShape_getOutlineThickness(handle: CPointer<Unit>): Float32

    func sfConvexShape_getPointCount(handle: CPointer<Unit>): UIntNative

    func sfConvexShape_getPoint(handle: CPointer<Unit>, index: UIntNative): Vector2f

    func sfConvexShape_getGeometricCenter(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_setPointCount(handle: CPointer<Unit>, count: UIntNative): Unit

    func sfConvexShape_setPoint(handle: CPointer<Unit>, index: UIntNative, point: Vector2f): Unit

    func sfConvexShape_getLocalBounds(handle: CPointer<Unit>): FloatRect

    func sfConvexShape_getGlobalBounds(handle: CPointer<Unit>): FloatRect
}

/**
 * Specialized shape representing a convex polygon.
 *
 * This class inherits all the functions of `Transformable`
 * (position, rotation, scale, bounds, ...) as well as the
 * functions of `Shape` (outline, color, texture, ...).
 *
 * It is important to keep in mind that a convex shape must
 * always be... convex, otherwise it may not be drawn correctly.
 * Moreover, the points must be defined in order; using a random
 * order would result in an incorrect shape.
 *
 * Usage example:
 * ```
 * let polygon = ConvexShape(3);
 * polygon.setPoint(0, Vector2f(0.0, 0.0));
 * polygon.setPoint(1, Vector2f(0.0, 10.0));
 * polygon.setPoint(2, Vector2f(25.0, 5.0));
 * polygon.outlineColor = Color.RED;
 * polygon.outlineThickness = 5.0;
 * polygon.position = Vector2f(10.0, 20.0);
 * ...
 * window.draw(polygon);
 * ```
 *
 * @see `Shape`, `RectangleShape`, `CircleShape`
 */
public class ConvexShape <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<ConvexShape> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Default constructor.
     *
     * @throws SFMLNullHandleException
     */
    public init() {
        this(0)
    }

    /**
     * Construct the shape with a point count.
     *
     * @param pointCount Number of points of the polygon
     *
     * @throws SFMLNullHandleException
     */
    public init(pointCount: UInt32) {
        m_handle = unsafe { sfConvexShape_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        if (pointCount > 0) {
            unsafe { sfConvexShape_setPointCount(m_handle, UIntNative(pointCount)) }
        }
    }

    /**
     * Construct the shape from an existing handle.
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
            unsafe { sfConvexShape_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the shape.
     *
     * @return A new shape instance that is a copy of this one.
     */
    public func clone(): ConvexShape {
        ConvexShape(unsafe { sfConvexShape_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfConvexShape_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public override operator func ==(right: ConvexShape): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: ConvexShape): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawConvexShape(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawConvexShape(window.handle, m_handle, inout states2)
        }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfConvexShape_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfConvexShape_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfConvexShape_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfConvexShape_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfConvexShape_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfConvexShape_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfConvexShape_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfConvexShape_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfConvexShape_getInverseTransform(m_handle) }
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
            let texturePtr = unsafe { sfConvexShape_getTexture(m_handle) }
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
        unsafe { sfConvexShape_setTexture(m_handle, texture?.handle ?? CPointer(), resetRect) }
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
            unsafe { sfConvexShape_getTextureRect(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setTextureRect(m_handle, value) }
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
            unsafe { sfConvexShape_getFillColor(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setFillColor(m_handle, value) }
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
            unsafe { sfConvexShape_getOutlineColor(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setOutlineColor(m_handle, value) }
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
            unsafe { sfConvexShape_getOutlineThickness(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setOutlineThickness(m_handle, value) }
        }
    }

    /**
     * Get the number of points of the polygon.
     *
     * @return Number of points of the polygon
     */
    public mut prop pointCount: UInt32 {
        get() {
            unsafe { UInt32(sfConvexShape_getPointCount(m_handle)) }
        }
        set(value) {
            unsafe { sfConvexShape_setPointCount(m_handle, UIntNative(value)) }
        }
    }

    /**
     * Get the position of a point.
     *
     * The returned point is in local coordinates, that is,
     * the shape's transforms (position, rotation, scale) are
     * not taken into account.
     * The result is undefined if `index` is out of the valid range.
     *
     * @param index Index of the point to get, in range [0 .. `pointCount` - 1]
     *
     * @return Position of the `index`-th point of the polygon
     */
    public func getPoint(index: UInt32): Vector2f {
        unsafe { sfConvexShape_getPoint(m_handle, UIntNative(index)) }
    }

    /**
     * Set the position of a point.
     *
     * Don't forget that the shape must be convex and the
     * order of points matters. Points should not overlap.
     * This applies to rendering; it is explicitly allowed
     * to temporarily have non-convex or degenerate shapes
     * when not drawn (e.g. during shape initialization).
     *
     * Point count must be specified beforehand. The behavior is
     * undefined if `index` is greater than or equal to getPointCount.
     *
     * @param index Index of the point to change, in range [0 .. `pointCount` - 1]
     * @param point New position of the point
     */
    public func setPoint(index: UInt32, point: Vector2f): Unit {
        unsafe { sfConvexShape_setPoint(m_handle, UIntNative(index), point) }
    }

    /**
     * Get the geometric center of the shape.
     *
     * The center is defined as the average of all points.
     *
     * @return The geometric center of the shape
     */
    public prop geometricCenter: Vector2f {
        get() {
            unsafe { sfConvexShape_getGeometricCenter(m_handle) }
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
            unsafe { sfConvexShape_getLocalBounds(m_handle) }
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
            unsafe { sfConvexShape_getGlobalBounds(m_handle) }
        }
    }
}
