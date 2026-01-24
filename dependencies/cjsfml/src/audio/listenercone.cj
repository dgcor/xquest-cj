package cjsfml.audio

@C
public struct ListenerCone {
    public const ListenerCone(
        public var innerAngle!: Float32 = 0.0, // Inner angle, in degrees
        public var outerAngle!: Float32 = 0.0, // Outer angle, in degrees
        public var outerGain!: Float32 = 0.0 // Outer gain
    ) {}
}

public type SoundSourceCone = ListenerCone
