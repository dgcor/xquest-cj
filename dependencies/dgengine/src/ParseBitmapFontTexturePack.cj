package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func parseBitmapFontTexturePack(game: Game, elem: JsonValue): ?TexturePack {
    var texture = Option<Texture>.None
    if (let Some(id) <- getValidString(elem, "texture")) {
        texture = game.resources.getTexture(id)
    }

    var imgContainer = Option<ImageContainer>.None
    if (texture.isNone()) {
        if (let Some(id) <- getValidString(elem, "imageContainer")) {
            imgContainer = game.resources.getImageContainer(id)
            if (imgContainer.isNone()) {
                return None
            }
        } else {
            return None
        }
    }

    var palette = Option<Palette>.None
    if (let Some(id) <- getValidString(elem, "palette")) {
        palette = game.resources.getPalette(id)
    }

    if (let Some(imgContainer) <- imgContainer) {
        let (img, charRects) = ImageUtils.packImages(imgContainer, None)
        if (let Some(img) <- img) {
            try (img = img) {
                let texture = Texture(img)
                return BitmapFontTexturePack(texture, palette, charRects)
            }
        }
        return None
    }

    let rows = getIntKey(elem, "rows", default: 16)
    let cols = getIntKey(elem, "cols", default: 16)
    let newLine = Int16(getIntKey(elem, "newLine", default: 0))
    let space = Int16(getIntKey(elem, "space", default: 0))
    let tab = Int16(getIntKey(elem, "tab", default: 0))
    let isVertical = getStringCharKey(elem, "direction") == "vertical"

    var texturePack = Option<BitmapFontTexturePack>.None

    if (let Some(charSizeFile) <- getValidString(elem, "charSizeFile")) {
        let charSizes = NumberVector<UInt8>(charSizeFile, default: 0, maxNumElements: 0x7FFF)
        let startPos = getUIntKey(elem, "charSizeFileStart", default: 0)
        let stepNBytes = getUIntKey(elem, "charSizeFileStep", default: 1)
        texturePack = BitmapFontTexturePack(texture.getOrThrow(), palette, rows, cols, newLine, space, tab, isVertical,
            charSizes.data, startPos, stepNBytes)
    } else {
        texturePack = BitmapFontTexturePack(texture.getOrThrow(), palette, rows, cols, newLine, space, tab, isVertical)
    }

    if (let Some(texturePack) <- texturePack) {
        if (texturePack.size > 0) {
            return texturePack
        }
    }
    return None
}
