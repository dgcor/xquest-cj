package cjsfml.audio

/**
 * Structure defining the properties of a directional cone.
 *
 * Sounds will play at gain 1 when they are positioned
 * within the inner angle of the cone. Sounds will play
 * at `outerGain` when they are positioned outside the
 * outer angle of the cone. The gain declines linearly
 * from 1 to `outerGain` as the sound moves from the inner
 * angle to the outer angle.
 */
@C
public struct ListenerCone {
    /**
     * Construct a ListenerCone.
     *
     * @param innerAngle Inner angle, in degrees.
     * @param outerAngle Outer angle, in degrees.
     * @param outerGain Outer gain.
     */
    public const ListenerCone(
        public var innerAngle!: Float32 = 0.0, // Inner angle, in degrees
        public var outerAngle!: Float32 = 0.0, // Outer angle, in degrees
        public var outerGain!: Float32 = 0.0 // Outer gain
    ) {}
}

/**
 * Type alias for a sound source cone, equivalent to `ListenerCone`.
 */
public type SoundSourceCone = ListenerCone
