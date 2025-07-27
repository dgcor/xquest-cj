package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func getAnimationObj(game: Game, elem: JsonValue): ?Animation {
    var animation = Option<Animation>.None

    if (let Some(id) <- getValidString(elem, "texture")) {
        if (let Some(texture) <- game.resources.getTexture(id)) {
            let frames = getRange1Key(elem, "frames", default: (0u32, 0u32))
            if ((frames[0] == 0 || frames[1] == 0) || (frames[0] <= 1 && frames[1] <= 1)) {
                animation = Animation(texture)
            } else {
                var textureGroup = TextureGroup(texture: texture)
                textureGroup.makeTexturePack(frames)
                let texPack = MultiTexturePack(textureGroup, None)
                if (texPack.size > 0) {
                    let animInfo = AnimationInfo(
                        indexRange: frames,
                        animType: getAnimationTypeKey(elem, "animationType")
                    )
                    animation = Animation(texPack, animInfo)
                } else {
                    animation = Animation(texture)
                }
            }
        }
    } else if (let Some(id) <- getValidString(elem, "texturePack")) {
        if (let Some(texPack) <- game.resources.getTexturePack(id)) {
            let groupIdx = getIntKey(elem, "groupIndex", default: -1)
            let directionIdx = getIntKey(elem, "directionIndex", default: -1)
            var animInfo = texPack.getAnimation(groupIdx, directionIdx)
            animInfo.indexRange = getRange1Key(elem, "frames", default: animInfo.indexRange)
            animInfo.animType = getAnimationTypeKey(elem, "animationType", default: animInfo.animType)
            animation = Animation(texPack, animInfo)
        }
    }

    if (let Some(animation) <- animation) {
        parseDrawableProperties(game, elem, animation)
        parseImageOutlineProperties(elem, animation)

        animation.pause = getBoolKey(elem, "pause")
        var refresh = animation.frameTime
        if (refresh == Time.zero) {
            refresh = Time(milliseconds: 50)
        }
        animation.frameTime = getTimeUKey(elem, "refresh", default: refresh)
    }

    return animation
}

public func parseAnimation(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem =>
            if (let Some(img) <- getAnimationObj(game, elem)) {
                return img
            }
            return None
        }
    )
}
