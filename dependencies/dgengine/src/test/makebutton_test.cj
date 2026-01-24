package dgengine.test

import cjsfml.graphics.Texture
import dgengine.*

protected func makeBitmapButton(game: Game, idButton: String, tex: Texture): BitmapButton {
    let button = BitmapButton(tex)
    game.resources.addDrawable(idButton, button, manageObjDrawing: true)
    return button
}

protected func makeTextButton(game: Game, idButton: String, font: Font): TextButton {
    let button = TextButton(font)
    game.resources.addDrawable(idButton, button, manageObjDrawing: true)
    return button
}
