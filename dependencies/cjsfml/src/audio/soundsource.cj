package cjsfml.audio

import cjsfml.system.{ResourceHandle, Vector3f}

public interface SoundSource<T> <: ResourceHandle & Equatable<T> {
    func play(): Unit

    func pause(): Unit

    func stop(): Unit

    prop status: SoundStatus

    mut prop pitch: Float32

    mut prop pan: Float32

    mut prop volume: Float32

    mut prop spatializationEnabled: Bool

    mut prop position: Vector3f

    mut prop direction: Vector3f

    mut prop cone: SoundSourceCone

    mut prop velocity: Vector3f

    mut prop dopplerFactor: Float32

    mut prop directionalAttenuationFactor: Float32

    mut prop relativeToListener: Bool

    mut prop minDistance: Float32

    mut prop maxDistance: Float32

    mut prop minGain: Float32

    mut prop maxGain: Float32

    mut prop attenuation: Float32

    func setEffectProcessor(effectProcessor: ?EffectProcessor): Unit
}
