package dgengine

import cjsfml.system.*
import stdx.encoding.json.*
import std.collection.*

private func parseAnimationGroup(elem: JsonValue, defaultAnimInfo: AnimationInfo): AnimationGroup {
    var directions = 0u32
    var directionsVec = Option<ArrayList<(UInt32, UInt32)>>.None
    if (let Some(elem) <- getValidArray(elem, "directions")) {
        let directions = ArrayList<(UInt32, UInt32)>()
        for (elem in elem.getItems()) {
            let directionRange = getVector2uVal(elem)
            if (directionRange.y < directionRange.x) {
                continue
            }
            directions.add((directionRange.x, directionRange.y))
        }
        directionsVec = directions
    } else {
        directions = getUIntKey(elem, "directions")
    }
    let indexRange = getRange0Key(elem, "range", default: defaultAnimInfo.indexRange)
    let animType = getAnimationTypeKey(elem, "animationType", default: defaultAnimInfo.animType)
    let refresh = getTimeUKey(elem, "refresh", default: defaultAnimInfo.refresh)
    return AnimationGroup(
        indexRange: indexRange,
        directions: directions,
        directionsVec: directionsVec,
        animType: animType,
        refresh: refresh
    )
}

/**
 * @throws NoneValueException
 */
public func parseTexturePackGroups(texturePack: Box<?TexturePack>, elem: JsonValue): Unit {
    if (isValidArray(elem, "groups") == false && isValidObject(elem, "groups") == false) {
        return
    }
    let origTexturePack = match (texturePack.value) {
        case Some(tex) => tex
        case None => throw NoneValueException("texturePack is None")
    }
    let defaultAnimInfo = origTexturePack.getAnimation(-1, -1)
    var texturePack2 = origTexturePack as GroupTexturePack
    if (texturePack2.isNone()) {
        let newTexturePack = GroupTexturePack(origTexturePack)
        texturePack2 = newTexturePack
        texturePack.value = newTexturePack
    }
    if (let Some(texturePack) <- texturePack2) {
        let elem = elem.asObject()
        if (let Some(elem) <- elem.get("groups")) {
            if (let Some(elem) <- getValidArray(elem)) {
                for (elem in elem.getItems()) {
                    texturePack.addGroup(parseAnimationGroup(elem, defaultAnimInfo))
                }
            } else {
                texturePack.addGroup(parseAnimationGroup(elem, defaultAnimInfo))
            }
        }
    }
}
