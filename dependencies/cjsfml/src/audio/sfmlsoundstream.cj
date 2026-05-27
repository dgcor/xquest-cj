package cjsfml.audio

import cjsfml.system.Time

/**
 * Abstract base interface for streamed audio sources.
 *
 * `SFMLSoundStream` defines the common interface for sound streams.
 * Unlike audio buffers (`SoundBuffer`), audio streams are never completely
 * loaded in memory. Instead, the audio data is acquired continuously while
 * the stream is playing. This behavior allows to play a sound with no loading
 * delay, and keeps the memory consumption very low.
 *
 * This interface corresponds to the base class `sf::SoundStream` in SFML.
 *
 * @see SoundStream
 * @see Music
 */
public interface SFMLSoundStream<T> <: SoundSource<T> {
    /**
     * Whether or not the stream should loop after reaching the end.
     *
     * If set, the stream will restart from beginning after
     * reaching the end and so on, until it is stopped or
     * `loop` is set to `false`.
     * The default looping state for streams is `false`.
     */
    mut prop loop: Bool

    /**
     * The number of channels of the stream.
     *
     * 1 channel means a mono sound, 2 means stereo, etc.
     */
    prop channelCount: UInt32

    /**
     * The stream sample rate of the stream.
     *
     * The sample rate is the number of audio samples played per
     * second. The higher, the better the quality.
     */
    prop sampleRate: UInt32

    /**
     * The map of position in sample frame to sound channel.
     *
     * This is used to map a sample in the sample stream to a
     * position during spatialization.
     */
    prop channelMap: Array<SoundChannel>

    /**
     * The current playing position of the stream.
     *
     * The playing position can be changed when the stream is
     * either paused or playing. Changing the playing position
     * when the stream is stopped has no effect, since playing
     * the stream would reset its position.
     */
    mut prop playingOffset: Time
}
