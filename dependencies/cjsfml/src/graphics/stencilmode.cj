package cjsfml.graphics

import cenum.CEnum

@CEnum[public StencilComparison](
    Never
    Less
    LessEqual
    Greater
    GreaterEqual
    Equal
    NotEqual
    Always
)

@CEnum[public StencilUpdateOperation](
    Keep
    Zero
    Replace
    Increment
    Decrement
    Invert
)

@C
public struct StencilMode {
    public const StencilMode(
        public let stencilComparison!: StencilComparison = StencilComparison.Always,
        public let stencilUpdateOperation!: StencilUpdateOperation = StencilUpdateOperation.Keep,
        public let stencilReference!: UInt32 = 0,
        public let stencilMask!: UInt32 = 0xFFFFFFFF,
        public let stencilOnly!: Bool = false
    ) {}

    public operator const func ==(right: StencilMode): Bool {
        (stencilComparison.value == right.stencilComparison.value && stencilUpdateOperation.value == right
            .stencilUpdateOperation.value && stencilReference == right.stencilReference && stencilMask == right
            .stencilMask && stencilOnly == right.stencilOnly)
    }

    public operator const func !=(right: StencilMode): Bool {
        (stencilComparison.value != right.stencilComparison.value || stencilUpdateOperation.value != right
            .stencilUpdateOperation.value || stencilReference != right.stencilReference || stencilMask != right
            .stencilMask || stencilOnly != right.stencilOnly)
    }

    public static const DEFAULT: StencilMode = StencilMode()
}
