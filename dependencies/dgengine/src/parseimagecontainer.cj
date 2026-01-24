package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func getImageContainerObj(game: Game, elem: JsonValue): ?ImageContainer {
    var fileBytes: ?Array<Byte> = None
    var fileName = String.empty

    if (let Some(id) <- getValidString(elem, "fileBytes")) {
        fileBytes = game.resources.getFileBytes(id)
    } else if (let Some(file) <- getValidString(elem, "file")) {
        fileName = file
        fileBytes = FileUtils.readBytes(file)
    }
    if (let Some(fileBytes) <- fileBytes) {
        if (fileBytes.isEmpty() == true) {
            return None
        }
        var imgContainer: ?ImageContainer = None
        if (let Some(getImageContainerObj) <- Hooks.getImageContainerObj) {
            imgContainer = getImageContainerObj(fileBytes, fileName, elem)
        }
        if (imgContainer.isNone()) {
            try (inputStream = MemoryInputStream(fileBytes)) {
                let (xFrames, yFrames) = getRange1Key(elem, "frames", default: (0u32, 0u32))
                let directions = getUIntKey(elem, "directions")
                let isVertical = getStringCharKey(elem, "direction") == "vertical"
                imgContainer = SimpleImageContainer(
                    file: inputStream,
                    xFrames: xFrames,
                    yFrames: yFrames,
                    directions: directions,
                    verticalDirection: isVertical
                )
            } catch (ex: Exception) {
                logger.error(ex.toString())
            }
        }
        if (let Some(imgContainer) <- imgContainer) {
            if (imgContainer.size == 0) {
                return None
            }
            imgContainer.blendMode = getBlendModeKey(elem, "blendMode")
        }
        return imgContainer
    }
    return None
}

public func parseImageContainerF(game: Game, elem: JsonValue,
    getImageContainerObj: (game: Game, elem: JsonValue) -> ?ImageContainer): Unit {
    if (parseResourceFromId<ImageContainer>(game.resources, elem) == true) {
        return
    }
    let id = parseValidIdOrFile(elem)
    if (id.isEmpty() == true) {
        return
    }
    if (game.resources.hasImageContainer(id) == true) {
        return
    }
    if (let Some(imageContainer) <- getImageContainerObj(game, elem)) {
        game.resources.addImageContainer(id, imageContainer, resourceId: getStringCharKey(elem, "resource"))
    }
}

public func parseImageContainer(game: Game, elem: JsonValue): Unit {
    parseImageContainerF(game, elem, getImageContainerObj)
}
