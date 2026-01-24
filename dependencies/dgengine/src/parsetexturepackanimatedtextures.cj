package dgengine

import cjsfml.system.*
import stdx.encoding.json.*
import std.collection.*

/**
 * @throws NoneValueException
 */
public func parseTexturePackAnimatedTextures(texturePack: Box<?TexturePack>, elem: JsonValue): Unit {
    if (let Some(elem) <- getValidArray(elem, "animatedTextures")) {
        let origTexturePack = match (texturePack.value) {
            case Some(tex) => tex
            case None => throw NoneValueException("texturePack is None")
        }
        var texturePack2 = origTexturePack as AnimatedTexturePack
        if (texturePack2.isNone()) {
            let newTexturePack = AnimatedTexturePack(origTexturePack)
            texturePack2 = newTexturePack
            texturePack.value = newTexturePack
        }
        if (let Some(texturePack) <- texturePack2) {
            for (elem in elem.getItems()) {
                if (let Some(elemIndexes) <- getValidArray(elem, "indexes")) {
                    let indexes = ArrayList<UInt32>()
                    for (elem in elemIndexes.getItems()) {
                        indexes.add(getUIntVal(elem))
                    }
                    let animIndex = getUIntKey(elem, "index", default: indexes.front)
                    let refresh = getTimeUKey(elem, "refresh", default: Time(milliseconds: 50))
                    texturePack.addAnimatedTexture(animIndex, refresh, indexes.toArray())
                }
            }
        }
    }
}
