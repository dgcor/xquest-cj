package dgengine

import cjsfml.system.*
import stdjson2.*

/**
 * @throws NoneValueException
 */
public func parseTexturePackIndexes(texturePack: Box<?TexturePack>, elem: JsonValue): Unit {
    if (elem.hasMember("textureIndexes") == false && elem.hasMember("textureIndexRange") == false &&
        elem.hasMember("utf8Indexes") == false && elem.hasMember("utf8IndexFile") == false) {
        return
    }
    let origTexturePack = match (texturePack.value) {
        case Some(tex) => tex
        case None => throw NoneValueException("texturePack is None")
    }
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
            for (elem in elem) {
                match {
                    case elem.isInt64() =>
                        let value = elem.getInt64() ?? 0
                        if (value >= 0 && value < Int64(UInt32.Max)) {
                            texturePack.mapTextureIndex(UInt32(value), reverseMap: reverseMapIndex)
                        }
                    case elem.isArray() => if (elem.size == 2) {
                        match ((elem.getUInt32(0), elem.getUInt32(1))) {
                            case (Some(value0), Some(value1)) => texturePack.mapTextureIndex(value0, value1)
                            case _ => ()
                        }
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
