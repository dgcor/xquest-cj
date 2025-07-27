package dgengine.test

import cjsfml.graphics.{Color, Image as SFMLImage, Texture}
import cjsfml.system.*
import dgengine.*

protected func makeTexture(size!: Vector2u = Vector2u(16, 8), color!: Color = Color.red): Texture {
    try (img = SFMLImage(size.x, size.y, color)) {
        return Texture(img)
    }
    throw Exception("Failed to create Texture")
}

protected func makeTexture(game: Game, id: String, size!: Vector2u = Vector2u(16, 8), color!: Color = Color.red): Texture {
    let tex = makeTexture(size: size, color: color)
    game.resources.addTexture(id, tex)
    return tex
}
