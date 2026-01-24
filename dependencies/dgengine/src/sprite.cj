package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class SpriteShaderCache {
    public var shader: ?Shader = None
    public var palette: ?Palette = None
    public var outline: Color = Color.TRANSPARENT
    public var ignore: Color = Color.TRANSPARENT
    public var textureSize: Vector2i = Vector2i()
}

public class Sprite2 <: Resource {
    private var m_sprite: Sprite
    private var m_position: Vector2f = Vector2f()
    private var m_offset: Vector2f = Vector2f()
    private var m_palette: ?Palette = None
    private var m_outline: Color = Color.TRANSPARENT
    private var m_ignore: Color = Color.TRANSPARENT
    private var m_outlineEnabled: Bool = false
    private var m_blendMode: BlendModeType = BlendAlpha

    private static var m_emptyTexture: ?Texture = None

    public init() {
        if (m_emptyTexture.isNone()) {
            m_emptyTexture = Texture(Vector2u(1, 1))
        }
        m_sprite = Sprite(m_emptyTexture.getOrThrow())
    }

    public init(texture: Texture, palette!: ?Palette = None) {
        m_sprite = Sprite(texture)
        m_palette = palette
    }

    public init(ti: TextureInfo) {
        m_sprite = Sprite(ti.texture)
        setTexture(ti, resetRect: true)
    }

    // Resource

    public func isClosed(): Bool {
        m_sprite.isClosed()
    }

    public func close(): Unit {
        if (m_sprite.isClosed() == false) {
            m_sprite.close()
        }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            m_position
        }
        set(value) {
            m_position = value
            m_sprite.position = value + m_offset
        }
    }

    public mut prop rotation: Float32 {
        get() {
            m_sprite.rotation
        }
        set(value) {
            m_sprite.rotation = value
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            m_sprite.scaleVal
        }
        set(value) {
            m_sprite.scaleVal = value
        }
    }

    public mut prop origin: Vector2f {
        get() {
            m_sprite.origin
        }
        set(value) {
            m_sprite.origin = value
        }
    }

    public func move(offset: Vector2f): Unit {
        m_sprite.move(offset)
    }

    public func rotate(angle: Float32): Unit {
        m_sprite.rotate(angle)
    }

    public func scale(factors: Vector2f): Unit {
        m_sprite.scale(factors)
    }

    public prop transform: Transform {
        get() {
            m_sprite.transform
        }
    }

    public prop inverseTransform: Transform {
        get() {
            m_sprite.inverseTransform
        }
    }

    // Sprite

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
            if (m_palette.isNone()) {
                m_sprite.color = value
            }
        }
    }

    public prop localBounds: FloatRect {
        get() {
            m_sprite.localBounds
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            m_sprite.globalBounds
        }
    }

    // Sprite2

    public prop drawPosition: Vector2f {
        get() {
            m_sprite.position
        }
    }

    public mut prop offset: Vector2f {
        get() {
            m_offset
        }
        set(value) {
            m_offset = value
            m_sprite.position = position + m_offset
        }
    }

    public func setPosition(position: Vector2f, offset: Vector2f): Unit {
        m_position = position
        m_offset = offset
        m_sprite.position = position + offset
    }

    public mut prop palette: ?Palette {
        get() {
            m_palette
        }
        set(value) {
            m_palette = value
        }
    }

    public prop outline: Color {
        get() {
            m_outline
        }
    }

    public func setOutline(outline: Color, ignore: Color): Unit {
        m_outline = outline
        m_ignore = ignore
    }

    public prop outlineIgnore: Color {
        get() {
            m_ignore
        }
    }

    public prop hasOutline: Bool {
        get() {
            outline.a > 0
        }
    }

    public mut prop outlineEnabled: Bool {
        get() {
            m_outlineEnabled
        }
        set(value) {
            m_outlineEnabled = value
        }
    }

    public func setTexture(texture: Texture, resetRect!: Bool = false): Unit {
        m_sprite.setTexture(texture, resetRect: resetRect)
        m_blendMode = BlendModeType.BlendAlpha
    }

    public func setTexture(ti: TextureInfo, resetRect!: Bool): Unit {
        m_sprite.setTexture(ti.texture)
        if (resetRect == true) {
            m_sprite.textureRect = ti.textureRect
        } else {
            var oldRect = m_sprite.textureRect
            oldRect.position = ti.textureRect.position
            m_sprite.textureRect = oldRect
        }
        m_blendMode = ti.blendMode
        m_palette = ti.palette
    }

    public prop texture: Texture {
        get() {
            m_sprite.texture
        }
    }

    // returns false if shader can be skipped (no palette used, no outline)
    private func needsSpriteShader(): Bool {
        if (m_palette.isNone() && (m_outlineEnabled == false || hasOutline == false)) {
            return false
        }
        return true
    }

    public func draw(target: RenderTarget, spriteShader: ?GameShader, cache: ?SpriteShaderCache): Unit {
        var states = RenderStates(blendMode: m_blendMode.toBlendMode())

        if (let Some(spriteShader) <- spriteShader) {
            if (needsSpriteShader()) {
                let shader = spriteShader.shader
                states.shader = shader

                let updateAll = match (cache) {
                    case Some(cache) => match (cache.shader) {
                        case Some(cachedshader) where cachedshader != shader => true
                        case _ => false
                    }
                    case _ => false
                }

                for (uniform in spriteShader.uniforms) {
                    match (uniform) {
                        case "pixelSize" =>
                            let textureRect = m_sprite.textureRect
                            if (updateAll == true || textureRect.size.x != (cache?.textureSize.x ?? -1) ||
                                textureRect.size.y != (cache?.textureSize.y ?? -1)) {
                                if (let Some(cache) <- cache) {
                                    cache.textureSize = textureRect.size
                                }
                                shader.setUniform(
                                    "pixelSize",
                                    GlslVec2(
                                        1.0 / Float32(textureRect.size.x),
                                        1.0 / Float32(textureRect.size.y)
                                    )
                                )
                            }
                        case "outline" =>
                            let (outline, ignore) = match (m_outlineEnabled) {
                                case true => (m_outline, m_ignore)
                                case false => (Color.TRANSPARENT, Color.TRANSPARENT)
                            }
                            var cacheUpdate = match (cache) {
                                case Some(cache) where outline != cache.outline => true
                                case _ => false
                            }
                            if (updateAll == true || cacheUpdate == true) {
                                if (let Some(cache) <- cache) {
                                    cache.outline = outline
                                }
                                shader.setUniform("outline", outline)
                            }
                            cacheUpdate = match (cache) {
                                case Some(cache) where ignore != cache.ignore => true
                                case _ => false
                            }
                            if (updateAll == true || cacheUpdate == true) {
                                if (let Some(cache) <- cache) {
                                    cache.ignore = ignore
                                }
                                shader.setUniform("ignore", ignore)
                            }
                        case "palette" =>
                            let updateUniform = match ((updateAll, cache?.palette ?? None, palette)) {
                                case (true, _, _) => true
                                case (false, Some(pal1), Some(pal2)) => isObjEq(pal1, pal2) == false
                                case (false, Some(_), None) => true
                                case (false, None, Some(_)) => true
                                case _ => false
                            }
                            if (updateUniform == true) {
                                if (let Some(cache) <- cache) {
                                    cache.palette = palette
                                }
                                shader.setUniform("hasPalette", palette.isSome())
                                if (let Some(palette) <- palette) {
                                    shader.setUniform("palette", palette.texture)
                                }
                            }
                        case _ => ()
                    }
                }
            }
        }
        target.draw(m_sprite, states)
    }
}
