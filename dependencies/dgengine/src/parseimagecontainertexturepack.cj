package dgengine

import std.collection.*
import stdjson2.*

private func getImageContainers(game: Game, elem: JsonValue): ArrayList<ImageContainer> {
    let imgContainers = ArrayList<ImageContainer>()
    if (let Some(elem) <- getValidObject(elem)) {
        if (let Some(elem) <- elem.get("imageContainer")) {
            match {
                case elem.isString() => if (let Some(imgCont) <- game.resources.getImageContainer(getStringChar(elem))) {
                    imgContainers.add(imgCont)
                }
                case elem.isArray() => for (val in elem) {
                    if (let Some(imgCont) <- game.resources.getImageContainer(getStringChar(val))) {
                        imgContainers.add(imgCont)
                    }
                }
                case _ => ()
            }
        }
    }
    return imgContainers
}

public func parseImageContainerTexturePack(game: Game, elem: JsonValue): ?TexturePack {
    let imgContainers = getImageContainers(game, elem)
    if (imgContainers.isEmpty() == true) {
        return None
    }

    var pal = Option<Palette>.None
    if (let Some(id) <- getValidString(elem, "palette")) {
        pal = game.resources.getPalette(id)
    }

    let useIndexedImages = pal.isSome() && game.shaders.sprite.isSome()
    let offset = getVector2fKey(elem, "offset")

    return ImageContainerTexturePack(imgContainers.toArray(), offset, pal, useIndexedImages)
}
