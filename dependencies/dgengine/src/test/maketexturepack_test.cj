package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*

protected func makeFontTexturePack(game: Game, idTexturePack: String, idTexture: String): TexturePack {
    let tex = makeTexture(size: Vector2u(64, 64))
    game.resources.addTexture(idTexture, tex)
    return makeFontTexturePack(game, idTexturePack, tex)
}

protected func makeFontTexturePack(game: Game, idTexturePack: String, tex: Texture): TexturePack {
    let texturePack = BitmapFontTexturePack(tex, None, 16, 16, 4, 4, 8, false)
    game.resources.addTexturePack(idTexturePack, texturePack)
    return texturePack
}
