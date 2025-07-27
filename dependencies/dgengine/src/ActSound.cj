package dgengine

import cjsfml.audio.*
import cjsfml.system.*

public class ActSoundLoadPlay <: Action {
    private let id: String

    public ActSoundLoadPlay(
        private let file: String,
        private let volume: Variable,
        private let seek: Time,
        private let unique: Bool
    ) {
        id = getIdFromFile(file) ?? String.empty
    }

    public operator func ()(game: Game): Bool {
        var sndBuffer = game.resources.getSoundBuffer(id)

        if (sndBuffer.isNone() && id.isEmpty() == false) {
            sndBuffer = parseSoundObj(game, id, file, String.empty)
        }
        if (let Some(sndBuffer) <- sndBuffer) {
            let sound = Sound(sndBuffer)
            var vol = clamp(game.getVarOrProp(volume, default: Int64(game.soundVolume)), 0, 100)
            if (vol > 0) {
                sound.volume = Float32(vol)
                game.resources.addPlayingSound(sound, unique: unique, seek: seek)
            }
        }
        return true
    }
}

public class ActSoundPlay <: Action {
    public ActSoundPlay(
        private let id: String,
        private let volume: Variable,
        private let seek: Time,
        private let unique: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        var sndBuffer = game.resources.getSoundBuffer(id)
        if (let Some(sndBuffer) <- sndBuffer) {
            let sound = Sound(sndBuffer)
            var vol = clamp(game.getVarOrProp(volume, default: Int64(game.soundVolume)), 0, 100)
            if (vol > 0) {
                sound.volume = Float32(vol)
                game.resources.addPlayingSound(sound, unique: unique, seek: seek)
            }
        }
        return true
    }
}
