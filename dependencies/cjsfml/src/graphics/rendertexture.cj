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

public class RenderTexture <: RenderTarget & Equatable<RenderTexture> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
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

    public operator override func ==(right: RenderTexture): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: RenderTexture): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTarget

    public func clear(color: Color): Unit {
        unsafe { sfRenderTexture_clear(m_handle, color) }
    }

    public func clearStencil(stencilValue: UInt32): Unit {
        unsafe { sfRenderTexture_clearStencil(m_handle, stencilValue) }
    }

    public func clear(color: Color, stencilValue: UInt32): Unit {
        unsafe { sfRenderTexture_clearColorAndStencil(m_handle, color, stencilValue) }
    }

    public mut prop view: View {
        get() {
            unsafe { View(sfRenderTexture_getView(m_handle), isOwner: false) }
        }
        set(value) {
            unsafe { sfRenderTexture_setView(m_handle, value.handle) }
        }
    }

    public prop defaultView: View {
        get() {
            unsafe { View(sfRenderTexture_getDefaultView(m_handle), isOwner: false) }
        }
    }

    public func getViewport(view: View): IntRect {
        unsafe { sfRenderTexture_getViewport(m_handle, view.handle) }
    }

    public func getScissor(view: View): IntRect {
        unsafe { sfRenderTexture_getScissor(m_handle, view.handle) }
    }

    public func mapPixelToCoords(point: Vector2i, view: View): Vector2f {
        unsafe { sfRenderTexture_mapPixelToCoords(m_handle, point, view.handle) }
    }

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

    public func draw(vertexBuffer: VertexBuffer, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawVertexBuffer(m_handle, vertexBuffer.handle, inout states2)
        }
    }

    public func draw(vertexBuffer: VertexBuffer, firstVertex: Int64, vertexCount: Int64, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawVertexBufferRange(m_handle, vertexBuffer.handle, UIntNative(firstVertex),
                UIntNative(vertexCount), inout states2)
        }
    }

    public prop size: Vector2u {
        get() {
            unsafe { sfRenderTexture_getSize(m_handle) }
        }
    }

    public prop isSrgb: Bool {
        get() {
            unsafe { sfRenderTexture_isSrgb(m_handle) }
        }
    }

    public func setActive(active: Bool): Bool {
        unsafe { sfRenderWindow_setActive(m_handle, active) }
    }

    public func pushGLStates(): Unit {
        unsafe { sfRenderTexture_pushGLStates(m_handle) }
    }

    public func popGLStates(): Unit {
        unsafe { sfRenderTexture_popGLStates(m_handle) }
    }

    public func resetGLStates(): Unit {
        unsafe { sfRenderTexture_resetGLStates(m_handle) }
    }

    // RenderTexture

    public func display(): Unit {
        unsafe { sfRenderTexture_display(m_handle) }
    }

    public prop texture: Texture {
        get() {
            unsafe { Texture(sfRenderTexture_getTexture(m_handle), isOwner: false) }
        }
    }

    public static prop maximumAntiAliasingLevel: UInt32 { // cjlint-ignore !G.NAM.05 use all capital letters for static variable
        get() {
            unsafe { sfRenderTexture_getMaximumAntiAliasingLevel() }
        }
    }

    public mut prop smooth: Bool {
        get() {
            unsafe { sfRenderTexture_isSmooth(m_handle) }
        }
        set(value) {
            unsafe { sfRenderTexture_setSmooth(m_handle, value) }
        }
    }

    public mut prop repeated: Bool {
        get() {
            unsafe { sfRenderTexture_isRepeated(m_handle) }
        }
        set(value) {
            unsafe { sfRenderTexture_setRepeated(m_handle, value) }
        }
    }

    public func generateMipmap(): Bool {
        unsafe { sfRenderTexture_generateMipmap(m_handle) }
    }
}
