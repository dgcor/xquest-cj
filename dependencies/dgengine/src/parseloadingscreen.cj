package dgengine

import stdjson2.*

public func parseLoadingScreen(game: Game, elem: JsonValue): Unit {
    var loadingScreen = Option<LoadingScreen>.None

    if (let Some(id) <- getValidString(elem, "texture")) {
        if (let Some(texture) <- game.resources.getTexture(id)) {
            loadingScreen = LoadingScreen(texture)
        }
    } else if (let Some(id) <- getValidString(elem, "texturePack")) {
        if (let Some(texPack) <- game.resources.getTexturePack(id)) {
            var animInfo = texPack.getAnimation(-1, -1)
            animInfo.indexRange = getRange1Key(elem, "frames", default: animInfo.indexRange)
            loadingScreen = LoadingScreen(texPack, animInfo)
        }
    }

    if (loadingScreen.isNone()) {
        loadingScreen = LoadingScreen()
    }

    if (let Some(loadingScreen) <- loadingScreen) {
        if (let Some(elem) <- getValidObject(elem)) {
            if (let Some(elem) <- elem.get("textureRect")) {
                let rect = loadingScreen.textureRect
                loadingScreen.textureRect = getIntRectVal(elem, default: rect)
            }

            parseDrawableProperties(game, elem, loadingScreen)

            loadingScreen.progressBarColor = getColorKey(elem, "color")
            loadingScreen.progressBarPositionOffset = getVector2fKey(elem, "progressBarOffset")
            loadingScreen.progressBarSize = getVector2fKey(elem, "size")

            if (let Some(elem) <- elem.get("onComplete")) {
                loadingScreen.setAction("complete", getActionVal(game, elem))
            }
        }
    }
    game.loadingScreen = loadingScreen
}
