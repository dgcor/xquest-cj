package dgengine.test

import cjsfml.graphics.Texture
import dgengine.*

protected func makeBitmapButton(game: Game, idButton: String, idTexture: String): BitmapButton {
    let tex = game.resources.getTexture(idTexture).getOrThrow()
    return makeBitmapButton(game, idButton, tex)
}

protected func makeBitmapButton(game: Game, idButton: String, tex: Texture): BitmapButton {
    let button = BitmapButton(tex)
    game.resources.addDrawable(idButton, button, manageObjDrawing: true)
    return button
}

protected func makeTextButton(game: Game, idButton: String, idFont: String): TextButton {
    let font = game.resources.getFont(idFont).getOrThrow()
    return makeTextButton(game, idButton, font)
}

protected func makeTextButton(game: Game, idButton: String, font: Font): TextButton {
    let button = TextButton(font)
    game.resources.addDrawable(idButton, button, manageObjDrawing: true)
    return button
}
