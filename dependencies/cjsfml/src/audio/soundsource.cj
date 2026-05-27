package cjsfml.audio

import cjsfml.system.{ResourceHandle, Vector3f}

/**
 * Base interface defining a sound's properties.
 *
 * `SoundSource` is not meant to be used directly, it only serves as a common base
 * for all audio objects that can live in the audio environment.
 *
 * It defines several properties for the sound: pitch, volume, position, attenuation, etc.
 * All of them can be changed at any time with no impact on performances.
 */
public interface SoundSource<T> <: ResourceHandle & Equatable<T> {
    /**
     * Start or resume playing the sound source.
     *
     * This function starts the source if it was stopped, resumes it if it was paused,
     * and restarts it from the beginning if it was already playing.
     *
     * @see pause
     * @see stop
     */
    func play(): Unit

    /**
     * Pause the sound source.
     *
     * This function pauses the source if it was playing, otherwise (source already
     * paused or stopped) it has no effect.
     *
     * @see play
     * @see stop
     */
    func pause(): Unit

    /**
     * Stop playing the sound source.
     *
     * This function stops the source if it was playing or paused, and does nothing if
     * it was already stopped. It also resets the playing position (unlike `pause()`).
     *
     * @see play
     * @see pause
     */
    func stop(): Unit

    /**
     * The current status of the sound (stopped, paused, playing).
     */
    prop status: SoundStatus

    /**
     * The pitch of the sound.
     *
     * The pitch represents the perceived fundamental frequency of a sound; thus you
     * can make a sound more acute or grave by changing its pitch. A side effect of
     * changing the pitch is to modify the playing speed of the sound as well.
     * The default value for the pitch is 1.
     */
    mut prop pitch: Float32

    /**
     * The pan of the sound.
     *
     * Using panning, a mono sound can be panned between stereo channels. When the pan
     * is set to -1, the sound is played only on the left channel, when the pan is set
     * to +1, the sound is played only on the right channel.
     */
    mut prop pan: Float32

    /**
     * The volume of the sound.
     *
     * The volume is a value between 0 (mute) and 100 (full volume).
     * The default value for the volume is 100.
     */
    mut prop volume: Float32

    /**
     * Whether spatialization of the sound is enabled.
     *
     * Spatialization is the application of various effects to simulate a sound being
     * emitted at a virtual position in 3D space and exhibiting various physical phenomena
     * such as directional attenuation and doppler shift.
     */
    mut prop spatializationEnabled: Bool

    /**
     * The 3D position of the sound in the audio scene.
     *
     * Only sounds with one channel (mono sounds) can be spatialized.
     * The default position of a sound is (0, 0, 0).
     */
    mut prop position: Vector3f

    /**
     * The 3D direction of the sound in the audio scene.
     *
     * The direction defines where the sound source is facing in 3D space. It will affect
     * how the sound is attenuated if facing away from the listener.
     * The default direction of a sound is (0, 0, -1).
     */
    mut prop direction: Vector3f

    /**
     * The cone properties of the sound in the audio scene.
     *
     * The cone defines how directional attenuation is applied.
     * The default cone of a sound is (2 * PI, 2 * PI, 1).
     */
    mut prop cone: SoundSourceCone

    /**
     * The 3D velocity of the sound in the audio scene.
     *
     * The velocity is used to determine how to doppler shift the sound. Sounds moving
     * towards the listener will be perceived to have a higher pitch and sounds moving
     * away from the listener will be perceived to have a lower pitch.
     */
    mut prop velocity: Vector3f

    /**
     * The doppler factor of the sound.
     *
     * The doppler factor determines how strong the doppler shift will be.
     */
    mut prop dopplerFactor: Float32

    /**
     * The directional attenuation factor of the sound.
     *
     * Depending on the virtual position of an output channel relative to the listener
     * (such as in surround sound setups), sounds will be attenuated when emitting them
     * from certain channels. This factor determines how strong the attenuation based on
     * output channel position relative to the listener is.
     */
    mut prop directionalAttenuationFactor: Float32

    /**
     * Whether the sound's position is relative to the listener or absolute.
     *
     * Making a sound relative to the listener will ensure that it will always be played
     * the same way regardless of the position of the listener. This can be useful for
     * non-spatialized sounds, sounds that are produced by the listener, or sounds attached to it.
     * The default value is `false` (position is absolute).
     */
    mut prop relativeToListener: Bool

    /**
     * The minimum distance of the sound.
     *
     * The "minimum distance" of a sound is the maximum distance at which it is heard at
     * its maximum volume. Further than the minimum distance, it will start to fade out
     * according to its attenuation factor. A value of 0 ("inside the head of the listener")
     * is an invalid value and is forbidden.
     * The default value of the minimum distance is 1.
     *
     * @see attenuation
     */
    mut prop minDistance: Float32

    /**
     * The maximum distance of the sound.
     *
     * The "maximum distance" of a sound is the minimum distance at which it is heard at
     * its minimum volume. Closer than the maximum distance, it will start to fade in
     * according to its attenuation factor.
     * The default value of the maximum distance is the maximum value a float can represent.
     *
     * @see attenuation
     */
    mut prop maxDistance: Float32

    /**
     * The minimum gain of the sound.
     *
     * When the sound is further away from the listener than the "maximum distance" the
     * attenuated gain is clamped so it cannot go below the minimum gain value.
     *
     * @see attenuation
     */
    mut prop minGain: Float32

    /**
     * The maximum gain of the sound.
     *
     * When the sound is closer from the listener than the "minimum distance" the
     * attenuated gain is clamped so it cannot go above the maximum gain value.
     *
     * @see attenuation
     */
    mut prop maxGain: Float32

    /**
     * The attenuation factor of the sound.
     *
     * The attenuation is a multiplicative factor which makes the sound more or less loud
     * according to its distance from the listener. An attenuation of 0 will produce a
     * non-attenuated sound, i.e. its volume will always be the same whether it is heard
     * from near or from far. On the other hand, an attenuation value such as 100 will make
     * the sound fade out very quickly as it gets further from the listener.
     * The default value of the attenuation is 1.
     *
     * @see minDistance
     */
    mut prop attenuation: Float32

    /**
     * Set the effect processor to be applied to the sound.
     *
     * The effect processor is a callable that will be called with sound data to be processed.
     *
     * @param effectProcessor The effect processor to attach to this sound, attach an empty processor to disable processing.
     */
    func setEffectProcessor(effectProcessor: ?EffectProcessor): Unit
}
