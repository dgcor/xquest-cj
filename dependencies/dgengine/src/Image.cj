package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*
import std.math.*

public open class Image <: UIObject {
    protected var m_sprite: CompositeSprite
    protected var m_anchor: Anchor = Anchor.Top | Anchor.Left
    protected var m_resizable: Bool = false
    protected var m_stretch: Bool = false
    protected var m_background: Bool = false
    protected var m_visible: Bool = true

    public init() {
        m_sprite = CompositeSprite()
        m_sprite.outlineEnabled = true
    }

    public init(texture: Texture, palette!: ?Palette = None) {
        m_sprite = CompositeSprite(texture, palette: palette)
        m_sprite.outlineEnabled = true
    }

    public init(ti: TextureInfo) {
        m_sprite = CompositeSprite(ti)
        m_sprite.outlineEnabled = true
    }

    public init(ti: ArrayList<TextureInfo>, drawAfter!: Bool = false) {
        m_sprite = CompositeSprite(ti, drawAfter: drawAfter)
        m_sprite.outlineEnabled = true
    }

    // Resource

    public func isClosed(): Bool {
        m_sprite.isClosed()
    }

    public func close(): Unit {
        m_sprite.close()
    }

    // UIObject

    public mut open prop anchor: Anchor {
        get() {
            m_anchor
        }
        set(value) {
            m_anchor = value
        }
    }

    public open func updateSize(game: Game): Unit {
        if (background == false) {
            var pos = Box(m_sprite.position)
            var size2 = Box(size)
            m_anchor.getPosSize(pos, size2, game.oldDrawRegionSize, game.drawRegionSize)
            m_sprite.position = pos.value
            size = size2.value
        } else {
            // stretch to fill and keep aspect ratio
            let scale = SFMLUtils.getScaleToStretchAndKeepAR(
                Vector2u(UInt32(m_sprite.textureRect.width), UInt32(m_sprite.textureRect.height)),
                game.drawRegionSize
            )
            m_sprite.setScale(Vector2f(scale, scale))

            // center image
            let newSize = size
            m_sprite.position = Vector2f(
                -round(abs(newSize.x - Float32(game.drawRegionSize.x)) / 2.0),
                -round(abs(newSize.y - Float32(game.drawRegionSize.y)) / 2.0)
            )
        }
    }

    public open prop drawPosition: Vector2f {
        get() {
            m_sprite.drawPosition
        }
    }

    public mut open prop position: Vector2f {
        get() {
            m_sprite.position
        }
        set(value) {
            m_sprite.position = value
        }
    }

    public mut open prop size: Vector2f {
        get() {
            m_sprite.globalBounds.size
        }
        set(value) {
            if (m_background == true || m_resizable == false) {
                return
            }
            if (m_stretch == true) {
                let rect = m_sprite.textureRect
                m_sprite.setScale(Vector2f(value.x / Float32(rect.width), value.y / Float32(rect.height)))
            } else {
                var rect = m_sprite.textureRect
                rect.width = Int32(value.x)
                rect.height = Int32(value.y)
                m_sprite.textureRect = rect
            }
        }
    }

    public mut open prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public open func draw(game: Game, target: RenderTarget): Unit {
        if (m_visible) {
            m_sprite.draw(target, game.shaders.sprite)
        }
    }

    public open func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        getProperty(props[0], props[1])
    }

    // CompositeSprite

    public mut prop palette: ?Palette {
        get() {
            m_sprite.palette
        }
        set(value) {
            m_sprite.palette = value
        }
    }

    public prop outline: Color {
        get() {
            m_sprite.outline
        }
    }

    public func setOutline(outline: Color, ignore: Color): Unit {
        m_sprite.setOutline(outline, ignore)
    }

    public prop outlineIgnore: Color {
        get() {
            m_sprite.outlineIgnore
        }
    }

    public prop hasOutline: Bool {
        get() {
            m_sprite.hasOutline
        }
    }

    public mut prop outlineEnabled: Bool {
        get() {
            m_sprite.outlineEnabled
        }
        set(value) {
            m_sprite.outlineEnabled = value
        }
    }

    public func setTexture(texture: Texture, resetRect!: Bool = false): Unit {
        m_sprite.setTexture(texture, resetRect: resetRect)
    }

    public func setTexture(ti: TextureInfo): Unit {
        m_sprite.setTexture(ti)
    }

    public func setTexture(ti: ArrayList<TextureInfo>, drawAfter!: Bool = false): Unit {
        m_sprite.setTexture(ti, drawAfter: drawAfter)
    }

    public func setTexture(ti: TextureInfoVar): Unit {
        m_sprite.setTexture(ti)
    }

    public prop texture: Texture {
        get() {
            m_sprite.texture
        }
    }

    public mut prop textureRect: IntRect {
        get() {
            m_sprite.textureRect
        }
        set(value) {
            m_sprite.textureRect = value
        }
    }

    public mut prop color: Color {
        get() {
            m_sprite.color
        }
        set(value) {
            m_sprite.color = value
        }
    }

    public func setOrigin(origin: Vector2f): Unit {
        m_sprite.setOrigin(origin)
    }

    public func setOrigin(): Unit {
        m_sprite.setOrigin(
            Vector2f(
                round(Float32(m_sprite.textureRect.width) / 2.0),
                round(Float32(m_sprite.textureRect.height) / 2.0)
            )
        )
    }

    // Image

    public mut prop resizable: Bool {
        get() {
            m_resizable
        }
        set(value) {
            m_resizable = value
        }
    }

    public mut prop stretch: Bool {
        get() {
            m_stretch
        }
        set(value) {
            m_stretch = value
        }
    }

    public mut prop background: Bool {
        get() {
            m_background
        }
        set(value) {
            m_background = value
        }
    }
}
