package cjsfml.audio

import cjsfml.system.Time

public interface SFMLSoundStream<T> <: SoundSource<T> {
    mut prop loop: Bool

    prop channelCount: UInt32

    prop sampleRate: UInt32

    prop channelMap: Array<SoundChannel>

    mut prop playingOffset: Time
}
