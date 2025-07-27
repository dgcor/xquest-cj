package dgengine

import cjsfml.audio.*
import stdx.encoding.json.*

public func openMusicFromFile(game: Game, music: Music, audioSource: AudioSource, id: String, resource: String): Bool {
    if (game.resources.hasSong(id, checkTopOnly: true) == false) {
        if (game.resources.addAudioSource(id, audioSource, resourceId: resource) == true) {
            return game.resources.addSong(id, music, resourceId: resource)
        }
    }
    return false
}

public func parseAudioObjFromFile(game: Game, elem: JsonValue, id: String, file: String): ?Music {
    try {
        let stream = PhysFSStream(file)
        let music = Music(stream)
        let resource = getStringCharKey(elem, "resource")
        if (openMusicFromFile(game, music, AuInputStream(stream), id, resource) == true) {
            return music
        }
        music.close()
        stream.close()
    } catch (ex: Exception) {
        logger.error(ex.toString())
    }
    return None
}

public func parseAudioObj(game: Game, elem: JsonValue): ?Music {
    if (let Some(id) <- getValidString(elem, "id")) {
        if (let Some(file) <- getValidString(elem, "file")) {
            if (isValidId(id)) {
                return parseAudioObjFromFile(game, elem, id, file)
            }
            if (let Some(id) <- getIdFromFile(file)) {
                if (isValidId(id)) {
                    return parseAudioObjFromFile(game, elem, id, file)
                }
            }
        }
    }
    return None
}

public func parseAudioFromId(game: Game, elem: JsonValue): Bool {
    if (let Some(fromId) <- getValidString(elem, "fromId")) {
        if (let Some(id) <- getValidString(elem, "id")) {
            if (fromId != id && isValidId(id) == true) {
                if (let Some(obj) <- game.resources.getSong(fromId)) {
                    game.resources.addSong(id, obj, resourceId: getStringCharKey(elem, "resource"))
                }
            }
        }
        return true
    }
    return false
}

public func parseAudioF(game: Game, elem: JsonValue, parseAudioObj: (game: Game, elem: JsonValue) -> ?Music): Unit {
    if (parseAudioFromId(game, elem) == true) {
        return
    }
    if (let Some(music) <- parseAudioObj(game, elem)) {
        if (getBoolKey(elem, "play") == true) {
            music.loop = getBoolKey(elem, "loop")
            if (let Some(volume) <- getVariableKey(elem, "volume")) {
                var vol = clamp(game.getVarOrProp(volume, default: Int64(game.musicVolume)), 0, 100)
                music.volume = Float32(vol)
            }
            if (getBoolKey(elem, "play") == true) {
                music.play()
            }
        }
    }
}

public func parseAudio(game: Game, elem: JsonValue): Unit {
    parseAudioF(game, elem, parseAudioObj)
}
