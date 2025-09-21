package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func parseTexturePackIndexes(texturePack: Box<?TexturePack>, elem: JsonValue): Unit {
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("textureIndexes") == false && elem.containsKey("textureIndexRange") == false &&
            elem.containsKey("utf8Indexes") == false && elem.containsKey("utf8IndexFile") == false) {
            return
        }
        let origTexturePack = texturePack.value.getOrThrow()
        var texturePack2 = origTexturePack as IndexedTexturePack
        if (texturePack2.isNone()) {
            let newTexturePack = IndexedTexturePack(
                origTexturePack,
                onlyUseIndexed: getBoolKey(elem, "onlyUseIndexed", default: true)
            )
            texturePack2 = newTexturePack
            texturePack.value = newTexturePack
        }
        if (let Some(texturePack) <- texturePack2) {
            let reverseMapIndex = getBoolKey(elem, "reverseMapIndex")
            var strIndexes = String.empty
            if (let Some(str) <- getValidString(elem, "utf8Indexes")) {
                strIndexes = str
            } else if (let Some(str) <- getValidString(elem, "utf8IndexFile")) {
                strIndexes = FileUtils.readText(str)
            }
            for (ch in strIndexes.runes()) {
                texturePack.mapTextureIndex(UInt32(ch), reverseMap: reverseMapIndex)
            }
            if (let Some(elem) <- getValidArray(elem, "textureIndexes")) {
                for (elem in elem.getItems()) {
                    match (elem.kind()) {
                        case JsInt =>
                            let value = elem.asInt().getValue()
                            if (value >= 0 && value < Int64(UInt32.Max)) {
                                texturePack.mapTextureIndex(UInt32(value), reverseMap: reverseMapIndex)
                            }
                        case JsArray =>
                            let value = elem.asArray().getItems()
                            if (value.size == 2 && value[0].isUInt() && value[1].isUInt()) {
                                texturePack.mapTextureIndex(getUIntVal(value[0]), getUIntVal(value[1]))
                            }
                        case _ => ()
                    }
                }
            } else if (let Some(indexElem) <- getValidArray(elem, "textureIndexRange")) {
                let indexRangeStart = getIntKey(elem, "textureIndexRangeStart", default: -1)
                let indexRange = getVector2iVal(indexElem)
                texturePack.mapTextureIndexRange(
                    (indexRange.x, indexRange.y),
                    indexRangeStart: indexRangeStart,
                    reverseMap: reverseMapIndex
                )
            }
        }
    }
}
