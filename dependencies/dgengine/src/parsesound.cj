package dgengine

import cjsfml.audio.*
import stdx.encoding.json.*

public func parseSoundObj(game: Game, id: String, file: String, resource: String): ?SoundBuffer {
    try {
        let stream = PhysFSStream(file)
        let sndBuffer = SoundBuffer(stream)
        if (game.resources.addAudioSource(id, AuSoundBuffer(sndBuffer), resourceId: resource) == true) {
            return sndBuffer
        }
        sndBuffer.close()
        stream.close()
    } catch (ex: Exception) {
        logger.error(ex.toString())
    }
    return None
}

public func parseSingleSoundObj(game: Game, elem: JsonValue): ?SoundBuffer {
    let file = getStringCharKey(elem, "file")
    let id = parseValidIdOrFilePath(elem, file)
    if (id.isEmpty() == true) {
        return None
    }
    return parseSoundObj(game, id, file, getStringCharKey(elem, "resource"))
}

public func parseSoundFromId(game: Game, elem: JsonValue): Bool {
    if (let Some(fromId) <- getValidString(elem, "fromId")) {
        if (let Some(id) <- getValidString(elem, "id")) {
            if (fromId != id && isValidId(id) == true) {
                if (let Some(obj) <- game.resources.getAudioSource(fromId)) {
                    game.resources.addAudioSource(id, obj, resourceId: getStringCharKey(elem, "resource"))
                }
            }
        }
        return true
    }
    return false
}

public func getSoundObj(game: Game, elem: JsonValue): ?SoundBuffer {
    if (isValidString(elem, "file") == true) {
        return parseSingleSoundObj(game, elem)
    }
    return None
}

public func parseSoundF(game: Game, elem: JsonValue, getSoundObj: (game: Game, elem: JsonValue) -> ?SoundBuffer): Unit {
    if (parseSoundFromId(game, elem) == true) {
        return
    }
    if (let Some(sndBuffer) <- getSoundObj(game, elem)) {
        if (getBoolKey(elem, "play") == true) {
            let sound = Sound(sndBuffer)

            if (let Some(volume) <- getVariableKey(elem, "volume")) {
                var vol = clamp(game.getVarOrProp(volume, default: Int64(game.soundVolume)), 0, 100)
                sound.volume = Float32(vol)
            }
            game.resources.addPlayingSound(sound)
        }
    }
}

public func parseSound(game: Game, elem: JsonValue): Unit {
    parseSoundF(game, elem, getSoundObj)
}
