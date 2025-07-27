package cjsfml.window

@C
public struct ContextSettings {
    public const ContextSettings(
        public let depth!: UInt32 = 0,
        public let stencil!: UInt32 = 0,
        public let antialiasing!: UInt32 = 0,
        public let major!: UInt32 = 1,
        public let minor!: UInt32 = 1,
        public let attributes!: ContextAttribute = ContextAttribute.Default,
        public let sRgb!: Bool = false
    ) {}
}
