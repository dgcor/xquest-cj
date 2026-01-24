package dgengine

import cjsfml.system.*

public struct AnimationInfo {
    public AnimationInfo(
        public var indexRange!: (UInt32, UInt32) = (0, 0),
        public var animType!: AnimationType = AnimationType.Looped,
        public var flags!: AnimationFlags = AnimationFlags.Invalid,
        public var refresh!: Time = Time()
    ) {}

    public prop valid: Bool {
        get() {
            flags.isSet(AnimationFlags.Valid)
        }
    }

    public prop overflow: Bool {
        get() {
            flags.isSet(AnimationFlags.Overflow)
        }
    }
}
