package dgengine.test

import dgengine.*

protected func makeBitmapFont(game: Game, idFont: String, idTexturePack: String): Font {
    let texturePack = makeFontTexturePack(game, idTexturePack, idTexturePack)
    game.resources.addTexturePack(idTexturePack, texturePack)
    return makeBitmapFont(game, idFont, texturePack)
}

protected func makeBitmapFont(game: Game, idFont: String, texturePack: TexturePack): Font {
    let font = FontBitmap(BitmapFont(texturePack, newLine: 4, space: 4, tab: 8))
    game.resources.addFont(idFont, font)
    return font
}
