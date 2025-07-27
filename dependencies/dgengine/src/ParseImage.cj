package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import stdx.encoding.json.*

public func getImageObj(game: Game, elem: JsonValue): ?Image {
    var image = Option<Image>.None

    if (let Some(id) <- getValidString(elem, "texture")) {
        if (let Some(texture) <- game.resources.getTexture(id)) {
            image = Image(texture)
        }
    } else if (let Some(id) <- getValidString(elem, "texturePack")) {
        if (let Some(texPack) <- game.resources.getTexturePack(id)) {
            if (let Some(tiVar) <- texPack.getAll(getUIntKey(elem, "textureIndex"))) {
                match (tiVar) {
                    case TextureInfoSingle(ti) => image = Image(ti)
                    case TextureInfoMulti(ti) => image = Image(ti)
                }
            }
        }
    }

    if (let Some(img) <- image) {
        parseImageProperties(game, elem, img)
    }

    return image
}

public func parseImageProperties(game: Game, elem: JsonValue, image: Image): Unit {
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("textureRect")) {
            let rect = IntRect(0, 0, Int32(game.drawRegionSize.x), Int32(game.drawRegionSize.y))
            image.textureRect = getIntRectVal(elem["textureRect"], default: rect)
        }
    }

    if (getBoolKey(elem, "background") == false) {
        image.resizable = getBoolKey(elem, "resizable", default: true)
        image.stretch = getBoolKey(elem, "stretch")

        parseDrawableProperties(game, elem, image)
    } else {
        image.background = true
        image.updateSize(game)

        image.visible = getBoolKey(elem, "visible", default: true)
    }

    parseImageOutlineProperties(elem, image)
}

public func parseImageOutlineProperties(elem: JsonValue, image: Image): Unit {
    image.color = getColorKey(elem, "color", default: Color.white)

    let outline = getColorKey(elem, "outline", default: Color.transparent)
    let outlineIgnore = getColorKey(elem, "outlineIgnore", default: Color.transparent)
    image.setOutline(outline, outlineIgnore)
    image.outlineEnabled = getBoolKey(elem, "enableOutline")
}

public func parseImage(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem =>
            if (let Some(img) <- getImageObj(game, elem)) {
                return img
            }
            return None
        }
    )
}
