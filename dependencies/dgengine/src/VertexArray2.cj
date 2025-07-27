package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public class VertexArray2 {
    public var vertices: ArrayList<Vertex> = ArrayList<Vertex>()

    private func draw(texture: Texture, palette: ?Palette, spriteShader: ?GameShader, target: RenderTarget,
        transform: Transform, pixelSize: GlslVec2): Unit {
        let shader = match (palette) {
            case None => None<GameShader>
            case _ => spriteShader
        }

        var states = RenderStates(transform: transform, texture: texture)

        if (let Some(shader) <- shader) {
            states.shader = shader.shader
            for (uniform in shader.uniforms) {
                match (uniform) {
                    case "pixelSize" => shader.shader.setUniform("pixelSize", pixelSize)
                    case "outline" => shader.shader.setUniform("outline", Color.transparent)
                    case "ignore" => shader.shader.setUniform("ignore", Color.transparent)
                    case "palette" => match (palette) {
                        case Some(palette) =>
                            shader.shader.setUniform("hasPalette", true)
                            shader.shader.setUniform("palette", palette.texture)
                        case None => shader.shader.setUniform("hasPalette", false)
                    }
                    case _ => ()
                }
            }
        }
        target.draw(vertices.toArray(), PrimitiveType.Triangles, states)
    }

    public func draw(texture: Texture, palette: ?Palette, spriteShader: ?GameShader, target: RenderTarget): Unit {
        if (vertices.isEmpty() == true) {
            return
        }
        draw(texture, palette, spriteShader, target, Transform.identity, GlslVec2())
    }

    public func draw(texture: Texture, pos: Vector2f, size: Vector2f, palette: ?Palette, spriteShader: ?GameShader,
        target: RenderTarget): Unit {
        if (vertices.isEmpty() == true) {
            return
        }
        var t = Transform()
        t.transform(FloatRect(Vector2f(), size))
        t = t.translate(pos)
        draw(
            texture,
            palette,
            spriteShader,
            target,
            t,
            GlslVec2(
                1.0 / size.x,
                1.0 / size.y
            )
        )
    }
}
