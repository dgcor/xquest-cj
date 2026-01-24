package cjsfml.window

@C
public struct ContextSettings {
    public const ContextSettings(
        public let depthBits!: UInt32 = 0,
        public let stencilBits!: UInt32 = 0,
        public let antiAliasingLevel!: UInt32 = 0,
        public let majorVersion!: UInt32 = 1,
        public let minorVersion!: UInt32 = 1,
        public let attributeFlags!: ContextAttribute = ContextAttribute.Default,
        public let sRgbCapable!: Bool = false // cjlint-ignore !G.FUN.01 too many parameters
    ) {}
}
