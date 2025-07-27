package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func parseTexturePackRects(texturePack: Box<?TexturePack>, elem: JsonValue): Unit {
    if (let Some(rectsElem) <- getValidArray(elem, "rects")) {
        let origTexturePack = texturePack.value.getOrThrow()
        var texturePack2 = origTexturePack as RectTexturePack
        if (texturePack2.isNone()) {
            let newTexturePack = RectTexturePack(
                origTexturePack,
                absoluteOffsets: getBoolKey(elem, "absoluteOffsets")
            )
            texturePack2 = newTexturePack
            texturePack.value = newTexturePack
        }
        if (let Some(texturePack) <- texturePack2) {
            let globalOffset = getVector2fKey(elem, "offset")
            let invertOffsets = getBoolKey(elem, "invertOffsets")

            for (elem in rectsElem.getItems()) {
                match (elem.kind()) {
                    case JsArray =>
                        let rect = getIntRectVal(elem)
                        if (rect.width > 0 && rect.height > 0) {
                            texturePack.addRect(0, rect, Vector2f())
                        }
                    case JsObject =>
                        let rect = getIntRectKey(elem, "rect")
                        if (rect.width > 0 && rect.height > 0) {
                            let index = getUIntKey(elem, "index")
                            var offset = globalOffset + getVector2fKey(elem, "offset")
                            if (invertOffsets == true) {
                                offset.x = -offset.x
                                offset.y = -offset.y
                            }
                            texturePack.addRect(index, rect, offset)
                        }
                    case _ => ()
                }
            }
        }
    }
}
