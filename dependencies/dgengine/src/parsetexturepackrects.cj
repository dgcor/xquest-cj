package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

/**
 * @throws NoneValueException
 */
public func parseTexturePackRects(texturePack: Box<?TexturePack>, elem: JsonValue): Unit {
    if (let Some(rectsElem) <- getValidArray(elem, "rects")) {
        let origTexturePack = match (texturePack.value) {
            case Some(tex) => tex
            case None => throw NoneValueException("texturePack is None")
        }
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
                        if (rect.size.x > 0 && rect.size.y > 0) {
                            texturePack.addRect(0, rect, Vector2f())
                        }
                    case JsObject =>
                        let rect = getIntRectKey(elem, "rect")
                        if (rect.size.x > 0 && rect.size.y > 0) {
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
