package cjsfml.window

import cjsfml.system.Vector2u

foreign {
    func sfVideoMode_getDesktopMode(): VideoMode

    func sfVideoMode_getFullscreenModes(count: CPointer<UIntNative>): CPointer<VideoMode>

    func sfVideoMode_isValid(mode: VideoMode): Bool
}

@C
public struct VideoMode {
    public let size: Vector2u
    public let bitsPerPixel: UInt32

    public const init() {
        size = Vector2u()
        bitsPerPixel = 0
    }

    public const init(size: Vector2u, bitsPerPixel!: UInt32 = 32) {
        this.size = size
        this.bitsPerPixel = bitsPerPixel
    }

    // cjlint-ignore -start !G.NAM.05 use all capital letters for static variable

    public static prop desktopMode: VideoMode {
        get() {
            unsafe { sfVideoMode_getDesktopMode() }
        }
    }

    public static prop fullscreenModes: Array<VideoMode> {
        get() {
            var count: UIntNative = 0
            let modesPtr = unsafe { sfVideoMode_getFullscreenModes(inout count) }
            return Array<VideoMode>(Int64(count), {
                i => unsafe { modesPtr.read(i) }
            })
        }
    }

    // cjlint-ignore -end use all capital letters for static variable

    public static func isValid(mode: VideoMode): Bool {
        unsafe { sfVideoMode_isValid(mode) }
    }
}
