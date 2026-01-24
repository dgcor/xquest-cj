package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import std.math.*

public class Surface <: Resource {
    protected let m_sprite: RectangleShape = RectangleShape()
    protected var m_texture: ?RenderTexture = None
    protected let m_mapView: View
    protected let m_drawView: View
    protected var m_isometricZoom: Bool
    protected var m_supportsBigTextures: Bool = false
    protected var m_visibleRect: FloatRect = FloatRect()
    protected var m_visible: Bool = true

    public static const ZOOM_MIN: Float32 = 0.5f32
    public static const ZOOM_MAX: Float32 = 2.0f32

    public init() {
        m_mapView = View(forceEvenSize: true)
        m_drawView = View(forceEvenSize: true)
        m_isometricZoom = false
    }

    public init(forceEvenSize!: Bool, isometricZoom!: Bool) {
        m_mapView = View(forceEvenSize: forceEvenSize)
        m_drawView = View(forceEvenSize: forceEvenSize)
        m_isometricZoom = isometricZoom
    }

    // Resource

    public func isClosed(): Bool {
        m_sprite.isClosed()
    }

    public func close(): Unit {
        m_sprite.close()
        m_texture?.close()
        m_mapView.close()
        m_drawView.close()
    }

    // Surface

    public mut prop anchor: Anchor {
        get() {
            m_mapView.anchor
        }
        set(value) {
            m_mapView.anchor = value
            m_drawView.anchor = value
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_mapView.position
        }
        set(value) {
            m_mapView.position = value
            m_drawView.position = value
            m_sprite.position = value
        }
    }

    public func getPosition(point: Vector2f): Vector2f {
        m_mapView.getPosition(point)
    }

    public func getDrawPosition(point: Vector2f): Unit {
        m_mapView.getDrawPosition(point)
    }

    public mut prop size: Vector2f {
        get() {
            m_mapView.size
        }
        set(value) {
            m_mapView.size = value
            m_drawView.size = value
            m_sprite.size = m_drawView.roundedSize
        }
    }

    public func updateSize(game: Game): Unit {
        m_mapView.updateSize(game, dontUpdateViewport: true)
        m_drawView.updateSize(game, dontUpdateViewport: true)
        m_sprite.position = m_drawView.position
        m_sprite.size = m_drawView.roundedSize

        updateVisibleArea()
        recreateRenderTexture(game.smoothScreen)
        stretchSpriteToZoom(m_mapView.zoom)
    }

    public mut prop center: Vector2f {
        get() {
            m_mapView.center
        }
        set(value) {
            m_mapView.center = value
            m_drawView.center = value
            updateVisibleArea()
        }
    }

    public func setCenter(): Unit {
        let size = m_mapView.roundedSize
        center = Vector2f(
            round(size.x / 2.0),
            round(size.y / 2.0)
        )
    }

    public mut prop isometricZoom: Bool {
        get() {
            m_isometricZoom
        }
        set(value) {
            m_isometricZoom = value
        }
    }

    public mut prop visibleRect: FloatRect {
        get() {
            m_visibleRect
        }
        set(value) {
            m_visibleRect = value
        }
    }

    public mut prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public prop zoom: Float32 {
        get() {
            m_mapView.zoom
        }
    }

    protected func recreateRenderTexture(smoothTexture: Bool): Unit {
        let size = m_drawView.size
        if (m_supportsBigTextures == true && m_mapView.zoom > 1.0) {
            recreateRenderTexture(
                UInt32(size.x * ZOOM_MAX),
                UInt32(size.y * ZOOM_MAX),
                smoothTexture
            )
        } else {
            recreateRenderTexture(
                UInt32(size.x),
                UInt32(size.y),
                smoothTexture
            )
        }
    }

    protected func recreateRenderTexture(newWidth: UInt32, newHeight: UInt32, smoothTexture: Bool): Unit {
        let texSize = m_texture?.size ?? Vector2u()
        if ((texSize.x != newWidth || texSize.y != newHeight) && newWidth > 0 && newHeight > 0) {
            if (let Some(texture) <- m_texture) {
                m_sprite.texture = None
                texture.close()
                m_texture = None
            }
            let texture = RenderTexture(Vector2u(newWidth, newHeight))
            texture.smooth = smoothTexture
            texture.repeated = true
            m_texture = texture
            m_sprite.setTexture(texture.texture, resetRect: true)
        }
    }

    protected func updateVisibleArea(): Unit {
        let viewCenter = m_mapView.center
        let viewSize = m_mapView.visibleSize
        m_visibleRect.position.x = viewCenter.x - round(viewSize.x / 2.0)
        m_visibleRect.position.y = viewCenter.y - round(viewSize.y / 2.0)
        m_visibleRect.size.x = round(viewSize.x)
        m_visibleRect.size.y = round(viewSize.y)
    }

    public func draw(target: RenderTarget, states!: RenderStates = RenderStates.DEFAULT): Unit {
        if (m_visible == true) {
            m_texture?.display()
            target.draw(m_sprite, states)
        }
    }

    public func draw(game: Game, obj: Panel): Unit {
        if (let Some(texture) <- m_texture) {
            obj.draw(game, texture, visibleRect)
        }
    }

    public func draw(game: Game, obj: UIObject): Unit {
        if (let Some(texture) <- m_texture) {
            obj.draw(game, texture)
        }
    }

    public func draw(obj: Drawable, states!: RenderStates = RenderStates.DEFAULT): Unit { // cjlint-ignore !G.DCL.01 function name already exists
        if (let Some(texture) <- m_texture) {
            texture.draw(obj, states)
        }
    }

    public func draw(obj: Sprite2, spriteShader: GameShader, cache: SpriteShaderCache): Unit {
        if (let Some(texture) <- m_texture) {
            obj.draw(texture, spriteShader, cache)
        }
    }

    public func draw(obj: VertexArray2, vertexTexture: Texture, palette: ?Palette, spriteShader: ?GameShader): Unit {
        if (let Some(texture) <- m_texture) {
            obj.draw(vertexTexture, palette, spriteShader, texture)
        }
    }

    public func initialize(game: Game): Unit {
        let desktopMode = VideoMode.desktopMode
        let maxTexSize = max(
            desktopMode.size.x * 2,
            desktopMode.size.y * 2
        )
        m_supportsBigTextures = (Texture.maximumSize >= maxTexSize)
        updateVisibleArea()
        recreateRenderTexture(game.smoothScreen)
    }

    public func clear(color: Color): Unit {
        m_texture?.clear(color)
    }

    // newZoom is inverted. numbers < 1 = zoom in and numbers > 1 = zoom out
    public func updateZoom(game: Game, newZoom: Float32): Bool {
        let newZoom2 = round(newZoom, 4)
        if (newZoom2 != m_mapView.zoom) {
            m_mapView.zoom = newZoom2
            if (newZoom2 <= 1.0 || m_supportsBigTextures == false) {
                m_drawView.zoom = max(newZoom2, 1.0)
            } else {
                // zoom is inverted in views, so max = min
                m_drawView.zoom = ZOOM_MAX
            }
            updateView(game)
            return true
        }
        return false
    }

    protected func stretchSpriteToZoom(zoom: Float32): Unit {
        if (let Some(texture) <- m_texture) {
            let size = texture.size
            if (zoom > 1.0) {
                if (m_supportsBigTextures == false) {
                    m_sprite.textureRect = IntRect(0, 0, Int32(size.x), Int32(size.y))
                    return
                }
                let factor: Float32 = match (m_isometricZoom) {
                    case true => 0.5
                    case false => 0.0
                }
                let drawSize = m_drawView.size
                m_sprite.textureRect = IntRect(
                    Int32(round((Float32(size.x) * factor) - (drawSize.x * factor) * zoom)), // cjlint-ignore !G.EXP.05 parentheses
                    Int32(round((Float32(size.y) * factor) - (drawSize.y * factor) * zoom)), // cjlint-ignore !G.EXP.05 parentheses
                    Int32(round(drawSize.x * zoom)),
                    Int32(round(drawSize.y * zoom))
                )
            } else {
                let factor: Float32 = match (m_isometricZoom) {
                    case true => 0.5
                    case false => 0.0
                }
                let drawSize = m_drawView.size
                let sizeDiffX = (Float32(size.x) - drawSize.x) * factor * zoom
                let sizeDiffY = (Float32(size.y) - drawSize.y) * factor * zoom
                m_sprite.textureRect = IntRect(
                    Int32(round(((Float32(size.x) - m_visibleRect.size.x) * factor) - sizeDiffX)),
                    Int32(round(((Float32(size.y) - m_visibleRect.size.y) * factor) - sizeDiffY)),
                    Int32(round(m_visibleRect.size.x * (Float32(size.x) / drawSize.x))),
                    Int32(round(m_visibleRect.size.y * (Float32(size.y) / drawSize.y)))
                )
            }
        }
    }

    public func updateView(game: Game): Unit {
        m_mapView.update(game, dontUpdateViewport: true)
        m_drawView.update(game, dontUpdateViewport: true)

        updateVisibleArea()
        recreateRenderTexture(game.smoothScreen)
        stretchSpriteToZoom(m_mapView.zoom)
    }

    public func updateDrawView(): Unit {
        m_texture?.view = m_drawView.view
    }

    public func updateDrawView(viewportOffset: FloatRect): Unit {
        if (viewportOffset == FloatRect(0.0, 0.0, 0.0, 0.0) || m_mapView.zoom != 1.0) {
            m_texture?.view = m_drawView.view
        } else {
            let newView = m_drawView.view.clone()
            let newPosition = m_drawView.position + viewportOffset.position
            let newViewSize = newView.size + viewportOffset.size
            newView.size = newViewSize

            let drawViewPosition = m_drawView.position
            let drawViewSize = m_drawView.size
            let top = ((newPosition.x - drawViewPosition.x) / drawViewSize.x)
            let left = ((newPosition.y - drawViewPosition.y) / drawViewSize.y)
            let width = (newViewSize.x / drawViewSize.x)
            let height = (newViewSize.y / drawViewSize.y)

            newView.viewport = FloatRect(top, left, width, height)
            m_texture?.view = newView
        }
    }
}
