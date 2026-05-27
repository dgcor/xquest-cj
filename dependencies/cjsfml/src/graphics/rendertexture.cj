package cjsfml.graphics

import cjsfml.system.{SFMLNullHandleException, Vector2f, Vector2i, Vector2u}
import cjsfml.window.ContextSettings

foreign {
    func sfRenderTexture_create(size: Vector2u, settings: CPointer<ContextSettings>): CPointer<Unit>

    func sfRenderTexture_destroy(handle: CPointer<Unit>): Unit

    // RenderTarget

    func sfRenderTexture_clear(handle: CPointer<Unit>, color: Color): Unit

    func sfRenderTexture_clearStencil(handle: CPointer<Unit>, stencilValue: UInt32): Unit

    func sfRenderTexture_clearColorAndStencil(handle: CPointer<Unit>, color: Color, stencilValue: UInt32): Unit

    func sfRenderTexture_setView(handle: CPointer<Unit>, view: CPointer<Unit>): Unit

    func sfRenderTexture_getView(handle: CPointer<Unit>): CPointer<Unit>

    func sfRenderTexture_getDefaultView(handle: CPointer<Unit>): CPointer<Unit>

    func sfRenderTexture_getViewport(handle: CPointer<Unit>, view: CPointer<Unit>): IntRect

    func sfRenderTexture_getScissor(handle: CPointer<Unit>, view: CPointer<Unit>): IntRect

    func sfRenderTexture_mapPixelToCoords(handle: CPointer<Unit>, point: Vector2i, view: CPointer<Unit>): Vector2f

    func sfRenderTexture_mapCoordsToPixel(handle: CPointer<Unit>, point: Vector2f, view: CPointer<Unit>): Vector2i

    func sfRenderTexture_drawSprite(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawText(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>, states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawCircleShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawConvexShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawRectangleShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawVertexArray(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawVertexBuffer(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawVertexBufferRange(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        firstVertex: UIntNative, vertexCount: UIntNative, states: CPointer<RenderStates>): Unit

    func sfRenderTexture_drawPrimitives(handle: CPointer<Unit>, vertices: CPointer<Vertex>, vertexCount: UIntNative,
        primitiveType: PrimitiveType, states: CPointer<RenderStates>): Unit

    func sfRenderTexture_getSize(handle: CPointer<Unit>): Vector2u

    func sfRenderTexture_isSrgb(handle: CPointer<Unit>): Bool

    func sfRenderTexture_setActive(handle: CPointer<Unit>, active: Bool): Bool

    func sfRenderTexture_pushGLStates(handle: CPointer<Unit>): Unit

    func sfRenderTexture_popGLStates(handle: CPointer<Unit>): Unit

    func sfRenderTexture_resetGLStates(handle: CPointer<Unit>): Unit

    // RenderTexture

    func sfRenderTexture_display(handle: CPointer<Unit>): Unit

    func sfRenderTexture_getTexture(handle: CPointer<Unit>): CPointer<Unit>

    func sfRenderTexture_getMaximumAntiAliasingLevel(): UInt32

    func sfRenderTexture_setSmooth(handle: CPointer<Unit>, smooth: Bool): Unit

    func sfRenderTexture_isSmooth(handle: CPointer<Unit>): Bool

    func sfRenderTexture_setRepeated(handle: CPointer<Unit>, repeated: Bool): Unit

    func sfRenderTexture_isRepeated(handle: CPointer<Unit>): Bool

    func sfRenderTexture_generateMipmap(handle: CPointer<Unit>): Bool
}

/**
 * Target for off-screen 2D rendering into a texture.
 *
 * `RenderTexture` is the little brother of `RenderWindow`.
 * It implements the same 2D drawing and OpenGL-related functions
 * (see their base class `RenderTarget` for more details),
 * the difference is that the result is stored in an off-screen
 * texture rather than being show in a window.
 *
 * Rendering to a texture can be useful in a variety of situations:
 * - precomputing a complex static texture (like a level's background from multiple tiles)
 * - applying post-effects to the whole scene with shaders
 * - creating a sprite from a 3D object rendered with OpenGL
 * - etc.
 *
 * Usage example:
 *
 * ```
 * // Create a new render-window
 * let window = RenderWindow(VideoMode(Vector2u(800, 600)), "SFML window");
 *
 * // Create a new render-texture
 * let texture = RenderTexture(Vector2u(500, 500));
 *
 * // The main loop
 * while (window.isOpen) {
 *    // Event processing
 *    // ...
 *
 *    // Clear the whole texture with red color
 *    texture.clear(Color.RED);
 *
 *    // Draw stuff to the texture
 *    texture.draw(sprite);  // sprite is a Sprite
 *    texture.draw(shape);   // shape is a Shape
 *    texture.draw(text);    // text is a Text
 *
 *    // We're done drawing to the texture
 *    texture.display();
 *
 *    // Now we start rendering to the window, clear it first
 *    window.clear();
 *
 *    // Draw the texture
 *    let sprite = Sprite(texture.texture);
 *    window.draw(sprite);
 *
 *    // End the current frame and display its contents on screen
 *    window.display();
 * }
 * ```
 *
 * Like `RenderWindow`, `RenderTexture` is still able to render direct
 * OpenGL stuff. It is even possible to mix together OpenGL calls
 * and regular SFML drawing commands. If you need a depth buffer for
 * 3D rendering, don't forget to request it when calling `init`.
 *
 * @see `RenderTarget`, `RenderWindow`, `View`, `Texture`
 */
public class RenderTexture <: RenderTarget & Equatable<RenderTexture> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct a render-texture.
     *
     * The last parameter, `settings`, is useful if you want to enable
     * multi-sampling or use the render-texture for OpenGL rendering that
     * requires a depth or stencil buffer. Otherwise it is unnecessary, and
     * you should leave this parameter at its default value.
     *
     * After creation, the contents of the render-texture are undefined.
     * Call `clear` first to ensure a single color fill.
     *
     * @param size     Width and height of the render-texture
     * @param settings Additional settings for the underlying OpenGL texture and context
     *
     * @throws SFMLNullHandleException
     */
    public init(size: Vector2u, settings!: ContextSettings = ContextSettings()) {
        var settings2 = settings
        m_handle = unsafe { sfRenderTexture_create(size, inout settings2) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfRenderTexture_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfRenderTexture_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    public prop isOwner: Bool {
        get() {
            true
        }
    }

    // Equatable

    public override operator func ==(right: RenderTexture): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: RenderTexture): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTarget

    /**
     * Clear the entire target with a single color.
     *
     * This function is usually called once every frame,
     * to clear the previous contents of the target.
     *
     * @param color Fill color to use to clear the render target
     */
    public func clear(color: Color): Unit {
        unsafe { sfRenderTexture_clear(m_handle, color) }
    }

    /**
     * Clear the stencil buffer.
     *
     * @param stencilValue Value to use to clear the stencil buffer
     */
    public func clearStencil(stencilValue: UInt32): Unit {
        unsafe { sfRenderTexture_clearStencil(m_handle, stencilValue) }
    }

    /**
     * Clear the entire target with a single color and clear the stencil buffer.
     *
     * @param color        Fill color to use to clear the render target
     * @param stencilValue Value to use to clear the stencil buffer
     */
    public func clear(color: Color, stencilValue: UInt32): Unit {
        unsafe { sfRenderTexture_clearColorAndStencil(m_handle, color, stencilValue) }
    }

    /**
     * Change the current active view.
     *
     * The view is like a 2D camera, it controls which part of
     * the 2D scene is visible, and how it is viewed by the target.
     *
     * @param value New view to use
     */
    public mut prop view: View {
        get() {
            unsafe { View(sfRenderTexture_getView(m_handle), isOwner: false) }
        }
        set(value) {
            unsafe { sfRenderTexture_setView(m_handle, value.handle) }
        }
    }

    /**
     * Get the default view of the render target.
     *
     * The default view has the initial size of the render target,
     * and never changes after the target has been created.
     *
     * @return The default view of the render target
     */
    public prop defaultView: View {
        get() {
            unsafe { View(sfRenderTexture_getDefaultView(m_handle), isOwner: false) }
        }
    }

    /**
     * Get the viewport of a view, applied to this render target.
     *
     * The viewport is defined in the view as a ratio, this function
     * simply converts this ratio into pixels.
     *
     * @param view The view for which we want to compute the viewport
     *
     * @return Viewport rectangle, expressed in pixels
     */
    public func getViewport(view: View): IntRect {
        unsafe { sfRenderTexture_getViewport(m_handle, view.handle) }
    }

    /**
     * Get the scissor rectangle of a view, applied to this render target.
     *
     * The scissor rectangle is defined in the view as a ratio, this function
     * simply converts this ratio into pixels.
     *
     * @param view The view for which we want to compute the scissor rectangle
     *
     * @return Scissor rectangle, expressed in pixels
     */
    public func getScissor(view: View): IntRect {
        unsafe { sfRenderTexture_getScissor(m_handle, view.handle) }
    }

    /**
     * Convert a point from target coordinates to world coordinates.
     *
     * This function uses the current view.
     *
     * @param point Pixel to convert
     * @param view  The view to use for converting the point
     *
     * @return The converted point, in "world" coordinates
     */
    public func mapPixelToCoords(point: Vector2i, view: View): Vector2f {
        unsafe { sfRenderTexture_mapPixelToCoords(m_handle, point, view.handle) }
    }

    /**
     * Convert a point from world coordinates to target coordinates.
     *
     * This function uses the current view.
     *
     * @param point Point to convert
     * @param view  The view to use for converting the point
     *
     * @return The converted point, in target coordinates (pixels)
     */
    public func mapCoordsToPixel(point: Vector2f, view: View): Vector2i {
        unsafe { sfRenderTexture_mapCoordsToPixel(m_handle, point, view.handle) }
    }

    // cjlint-ignore -start !G.ITF.04 using interface as type parameter

    public func drawRenderTarget(drawable: RenderTargetDrawable, states: RenderStates): Unit {
        drawable.draw(this, states)
    }

    public func draw(drawable: Drawable, states: RenderStates): Unit {
        drawable.draw(this, states)
    }

    // cjlint-ignore -end using interface as type parameter

    /**
     * Draw primitives defined by an array of vertices.
     *
     * @param vertices      Array of vertices to draw
     * @param primitiveType Type of primitives to draw
     * @param states        Render states to use for drawing
     */
    public func draw(vertices: Array<Vertex>, primitiveType: PrimitiveType, states: RenderStates): Unit {
        unsafe {
            let rawData = acquireArrayRawData(vertices) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                var states2 = states
                sfRenderTexture_drawPrimitives(m_handle, rawData.pointer, UIntNative(vertices.size), primitiveType,
                    inout states2)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Draw a vertex buffer.
     *
     * @param vertexBuffer Vertex buffer to draw
     * @param states       Render states to use for drawing
     */
    public func draw(vertexBuffer: VertexBuffer, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawVertexBuffer(m_handle, vertexBuffer.handle, inout states2)
        }
    }

    /**
     * Draw a range of a vertex buffer.
     *
     * @param vertexBuffer Vertex buffer to draw
     * @param firstVertex  Index of the first vertex to draw
     * @param vertexCount  Number of vertices to draw
     * @param states       Render states to use for drawing
     */
    public func draw(vertexBuffer: VertexBuffer, firstVertex: Int64, vertexCount: Int64, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawVertexBufferRange(m_handle, vertexBuffer.handle, UIntNative(firstVertex),
                UIntNative(vertexCount), inout states2)
        }
    }

    /**
     * Return the size of the rendering region of the texture.
     *
     * The returned value is the size that you passed to
     * the create function.
     *
     * @return Size in pixels
     */
    public prop size: Vector2u {
        get() {
            unsafe { sfRenderTexture_getSize(m_handle) }
        }
    }

    /**
     * Tell if the render-texture will use sRGB encoding when drawing on it.
     *
     * You can request sRGB encoding for a render-texture
     * by having the sRgbCapable flag set for the context parameter of `create()` method
     *
     * @return `true` if the render-texture use sRGB encoding, `false` otherwise
     */
    public prop isSrgb: Bool {
        get() {
            unsafe { sfRenderTexture_isSrgb(m_handle) }
        }
    }

    /**
     * Activate or deactivate the render-texture for rendering.
     *
     * This function makes the render-texture's context current for
     * future OpenGL rendering operations (so you shouldn't care
     * about it if you're not doing direct OpenGL stuff).
     * Only one context can be current in a thread, so if you
     * want to draw OpenGL geometry to another render target
     * (like a RenderWindow) don't forget to activate it again.
     *
     * @param active `true` to activate, `false` to deactivate
     *
     * @return `true` if operation was successful, `false` otherwise
     */
    public func setActive(active: Bool): Bool {
        unsafe { sfRenderWindow_setActive(m_handle, active) }
    }

    /**
     * Save the current OpenGL render states.
     *
     * This function is for users who need to mix SFML drawing
     * and raw OpenGL rendering.
     */
    public func pushGLStates(): Unit {
        unsafe { sfRenderTexture_pushGLStates(m_handle) }
    }

    /**
     * Restore the previously saved OpenGL render states.
     *
     * This function is for users who need to mix SFML drawing
     * and raw OpenGL rendering.
     */
    public func popGLStates(): Unit {
        unsafe { sfRenderTexture_popGLStates(m_handle) }
    }

    /**
     * Reset the internal OpenGL states so that the target is ready for drawing.
     *
     * This function is for users who need to mix SFML drawing
     * and raw OpenGL rendering.
     */
    public func resetGLStates(): Unit {
        unsafe { sfRenderTexture_resetGLStates(m_handle) }
    }

    // RenderTexture

    /**
     * Update the contents of the target texture.
     *
     * This function updates the target texture with what
     * has been drawn so far. Like for windows, calling this
     * function is mandatory at the end of rendering. Not calling
     * it may leave the texture in an undefined state.
     */
    public func display(): Unit {
        unsafe { sfRenderTexture_display(m_handle) }
    }

    /**
     * Get a read-only reference to the target texture.
     *
     * After drawing to the render-texture and calling Display,
     * you can retrieve the updated texture using this function,
     * and draw it using a sprite (for example).
     * The internal `Texture` of a render-texture is always the
     * same instance, so that it is possible to call this function
     * once and keep a reference to the texture even after it is
     * modified.
     *
     * @return Const reference to the texture
     */
    public prop texture: Texture {
        get() {
            unsafe { Texture(sfRenderTexture_getTexture(m_handle), isOwner: false) }
        }
    }

    /**
     * Get the maximum anti-aliasing level supported by the system.
     *
     * @return The maximum anti-aliasing level supported by the system
     */
    public static prop maximumAntiAliasingLevel: UInt32 { // cjlint-ignore !G.NAM.05 use all capital letters for static variable
        get() {
            unsafe { sfRenderTexture_getMaximumAntiAliasingLevel() }
        }
    }

    /**
     * Enable or disable texture smoothing.
     *
     * This function is similar to `Texture.smooth`.
     * This parameter is disabled by default.
     *
     * @param value `true` to enable smoothing, `false` to disable it
     */
    public mut prop smooth: Bool {
        get() {
            unsafe { sfRenderTexture_isSmooth(m_handle) }
        }
        set(value) {
            unsafe { sfRenderTexture_setSmooth(m_handle, value) }
        }
    }

    /**
     * Enable or disable texture repeating.
     *
     * This function is similar to `Texture.repeated`.
     * This parameter is disabled by default.
     *
     * @param value `true` to enable repeating, `false` to disable it
     */
    public mut prop repeated: Bool {
        get() {
            unsafe { sfRenderTexture_isRepeated(m_handle) }
        }
        set(value) {
            unsafe { sfRenderTexture_setRepeated(m_handle, value) }
        }
    }

    /**
     * Generate a mipmap using the current texture data.
     *
     * This function is similar to `Texture.generateMipmap` and operates
     * on the texture used as the target for drawing.
     * Be aware that any draw operation may modify the base level image data.
     * For this reason, calling this function only makes sense after all
     * drawing is completed and display has been called. Not calling display
     * after subsequent drawing will lead to undefined behavior if a mipmap
     * had been previously generated.
     *
     * @return `true` if mipmap generation was successful, `false` if unsuccessful
     */
    public func generateMipmap(): Bool {
        unsafe { sfRenderTexture_generateMipmap(m_handle) }
    }
}
