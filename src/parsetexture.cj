package xquest

import cjsfml.graphics.Image as SFMLImage
import dgengine.*
import stdjson2.*

func parseTextureImg(game: Game, elem: JsonValue, img: Box<?SFMLImage>): Bool {
    let path = getStringCharKey(elem, "file")
    let pathLower = path.toAsciiLower()

    if (pathLower.endsWith(".fnt") == true || pathLower.endsWith(".gfx") == true || pathLower.endsWith(".pbm") == true) {
        var pal = game.resources.getPalette(getStringKey(elem, "palette"))
        if (getBoolKey(elem, "indexed") == true && game.shaders.sprite.isSome() == true) {
            pal = None
        }
        let imgContainer = getImageContainerObj(game, elem)
        if (let Some(imgContainer) <- imgContainer) {
            if (let Some(elem) <- elem.get("frame")) {
                let frameIdx = getUIntVal(elem)
                img.value = ImageUtils.loadImageFrame(imgContainer, pal, frameIdx)
            } else {
                img.value = ImageUtils.loadImage(imgContainer, pal)
            }
        }
        return true
    }
    return false
}
