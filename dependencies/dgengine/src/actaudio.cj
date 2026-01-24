package dgengine

import cjsfml.audio.*
import cjsfml.system.*

public class ActAudioDelete <: Action {
    public ActAudioDelete(private let id: String) {}

    public operator func ()(game: Game): Bool {
        game.resources.deleteSong(id)
        return true
    }
}

public class ActAudioPause <: Action {
    public ActAudioPause(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(song) <- game.resources.getSong(id)) {
            song.pause()
        }
        return true
    }
}

public class ActAudioPauseAll <: Action {
    public operator func ()(game: Game): Bool {
        game.resources.pauseSongs()
        return true
    }
}

public class ActAudioPlay <: Action {
    public ActAudioPlay(
        private let id: String,
        private let volume: Variable,
        private let clear: Bool,
        private var loop!: ?Bool = None
    ) {}

    public func setLoop(loop: Bool): Unit {
        this.loop = loop
    }

    public operator func ()(game: Game): Bool {
        if (clear == true) {
            game.resources.stopSongs()
        }
        if (let Some(song) <- game.resources.getSong(id)) {
            if (let Some(loop) <- loop) {
                song.loop = loop
            }
            var vol = clamp(game.getVarOrProp(volume, default: Int64(game.musicVolume)), 0, 100)
            song.volume = Float32(vol)

            if (song.status != SoundStatus.Playing || song.playingOffset == Time.ZERO || song.playingOffset >= song
                .duration) {
                song.stop()
                song.play()
            }
        }
        return true
    }
}

public class ActAudioResumeAll <: Action {
    public ActAudioResumeAll(private let restart: Bool) {}

    public operator func ()(game: Game): Bool {
        game.resources.playPaused(restart: restart)
        return true
    }
}

public class ActAudioSeek <: Action {
    public ActAudioSeek(
        private let id: String,
        private let time: Time
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(song) <- game.resources.getSong(id)) {
            song.playingOffset = time
        }
        return true
    }
}

public class ActAudioSetVolume <: Action {
    public ActAudioSetVolume(
        private let id: String,
        private let volume: Variable
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(song) <- game.resources.getSong(id)) {
            var vol = clamp(game.getVarOrProp(volume, default: Int64(game.musicVolume)), 0, 100)
            song.volume = Float32(vol)
        }
        return true
    }
}

public class ActAudioStop <: Action {
    public ActAudioStop(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(song) <- game.resources.getSong(id)) {
            song.stop()
        }
        return true
    }
}

public class ActAudioStopAll <: Action {
    public operator func ()(game: Game): Bool {
        game.resources.stopSongs()
        return true
    }
}
