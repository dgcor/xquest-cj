package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public class CompositeSprite <: Resource {
    private var m_sprites: ArrayList<Sprite2>
    private var m_drawAfterExtraSprites: Bool = false

    public init() {
        m_sprites = ArrayList(1, {_ => Sprite2()})
    }

    public init(texture: Texture, palette!: ?Palette = None) {
        m_sprites = ArrayList(1, {_ => Sprite2(texture, palette: palette)})
    }

    public init(ti: TextureInfo) {
        m_sprites = ArrayList(1, {_ => Sprite2(ti)})
        m_sprites[0].offset = ti.offset
    }

    public init(ti: ArrayList<TextureInfo>, drawAfter!: Bool = false) {
        m_sprites = ArrayList(1, {_ => Sprite2()})
        setTexture(ti, drawAfter: drawAfter)
    }

    // Resource

    public func isClosed(): Bool {
        if (m_sprites.isEmpty()) {
            return true
        }
        return m_sprites[0].isClosed()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        for (sprite in m_sprites) {
            sprite.close()
        }
    }

    // Transformable

    public func setOrigin(origin: Vector2f): Unit {
        m_sprites[0].origin = origin
    }

    public func setScale(factor: Vector2f): Unit {
        m_sprites[0].scaleVal = factor
    }

    // CompositeSprite

    public prop drawPosition: Vector2f {
        get() {
            m_sprites[0].drawPosition
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_sprites[0].position
        }
        set(value) {
            for (sprite in m_sprites) {
                sprite.position = value
            }
        }
    }

    public prop size: Vector2f {
        get() {
            Vector2f(Float32(m_sprites[0].textureRect.size.x), Float32(m_sprites[0].textureRect.size.y))
        }
    }

    public mut prop offset: Vector2f {
        get() {
            m_sprites[0].offset
        }
        set(value) {
            if (m_sprites.size == 1) {
                m_sprites[0].offset = value
            } else {
                let diff = value - m_sprites[0].offset
                for (sprite in m_sprites) {
                    sprite.offset += diff
                }
            }
        }
    }

    public mut prop palette: ?Palette {
        get() {
            m_sprites[0].palette
        }
        set(value) {
            m_sprites[0].palette = value
        }
    }

    public prop outline: Color {
        get() {
            m_sprites[0].outline
        }
    }

    public func setOutline(outline: Color, ignore: Color): Unit {
        for (sprite in m_sprites) {
            sprite.setOutline(outline, ignore)
        }
    }

    public prop outlineIgnore: Color {
        get() {
            m_sprites[0].outlineIgnore
        }
    }

    public prop hasOutline: Bool {
        get() {
            m_sprites[0].hasOutline
        }
    }

    public mut prop outlineEnabled: Bool {
        get() {
            m_sprites[0].outlineEnabled
        }
        set(value) {
            for (sprite in m_sprites) {
                sprite.outlineEnabled = value
            }
        }
    }

    public func setTexture(texture: Texture, resetRect!: Bool = false): Unit {
        for (sprite in m_sprites |> skip(1)) {
            sprite.close()
        }
        m_sprites.remove(1..m_sprites.size)
        m_sprites[0].offset = Vector2f()
        m_sprites[0].setTexture(texture, resetRect: resetRect)
    }

    public func setTexture(ti: TextureInfo): Unit {
        for (sprite in m_sprites |> skip(1)) {
            sprite.close()
        }
        m_sprites.remove(1..m_sprites.size)
        m_sprites[0].offset = ti.offset
        m_sprites[0].setTexture(ti, resetRect: true)
    }

    public func setTexture(ti: ArrayList<TextureInfo>, drawAfter!: Bool = false): Unit {
        if (ti.isEmpty()) {
            return
        }
        if (m_sprites.size > ti.size) {
            for (sprite in m_sprites |> skip(ti.size)) {
                sprite.close()
            }
            m_sprites.remove(ti.size..m_sprites.size)
        } else if (m_sprites.size < ti.size) {
            for (ti in ti |> skip(m_sprites.size)) {
                m_sprites.add(Sprite2(ti))
            }
        }
        m_drawAfterExtraSprites = drawAfter
        m_sprites[0].offset = ti[0].offset
        m_sprites[0].setTexture(ti[0], resetRect: true)
        for ((index, sprite) in m_sprites |> enumerate |> skip(1)) {
            sprite.setPosition(m_sprites[0].position, ti[index].offset)
            sprite.setTexture(ti[index], resetRect: true)
            sprite.color = m_sprites[0].color
            sprite.setOutline(m_sprites[0].outline, m_sprites[0].outlineIgnore)
            sprite.outlineEnabled = m_sprites[0].outlineEnabled
        }
    }

    public func setTexture(ti: TextureInfoVar): Unit {
        match (ti) {
            case TextureInfoSingle(value) => setTexture(value)
            case TextureInfoMulti(value) => setTexture(value)
        }
    }

    public prop texture: Texture {
        get() {
            m_sprites[0].texture
        }
    }

    public mut prop textureRect: IntRect {
        get() {
            m_sprites[0].textureRect
        }
        set(value) {
            m_sprites[0].textureRect = value
        }
    }

    public mut prop color: Color {
        get() {
            m_sprites[0].color
        }
        set(value) {
            for (sprite in m_sprites) {
                sprite.color = value
            }
        }
    }

    public prop localBounds: FloatRect {
        get() {
            m_sprites[0].localBounds
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            m_sprites[0].globalBounds
        }
    }

    public func draw(target: RenderTarget, spriteShader: ?GameShader, cache!: ?SpriteShaderCache = SpriteShaderCache()): Unit {
        if (m_drawAfterExtraSprites == false) {
            for (sprite in m_sprites) {
                sprite.draw(target, spriteShader, cache)
            }
        } else {
            for (sprite in m_sprites |> skip(1)) {
                sprite.draw(target, spriteShader, cache)
            }
            m_sprites[0].draw(target, spriteShader, cache)
        }
    }
}
