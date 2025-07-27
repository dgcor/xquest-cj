package cjsfml.window

import cjsfml.system.*

foreign {
    func sfVideoMode_getDesktopMode(): VideoMode

    func sfVideoMode_getFullscreenModes(count: CPointer<UIntNative>): CPointer<VideoMode>

    func sfVideoMode_isValid(mode: VideoMode): SfBool
}

@C
public struct VideoMode {
    public let width: UInt32
    public let height: UInt32
    public let bitsPerPixel: UInt32

    public const init() {
        width = 0
        height = 0
        bitsPerPixel = 0
    }

    public const init(width: UInt32, height: UInt32, bitsPerPixel!: UInt32 = 32) {
        this.width = width
        this.height = height
        this.bitsPerPixel = bitsPerPixel
    }

    public const init(size: (UInt32, UInt32), bitsPerPixel!: UInt32 = 32) {
        this.width = size[0]
        this.height = size[1]
        this.bitsPerPixel = bitsPerPixel
    }

    public static prop desktopMode: VideoMode {
        get() {
            unsafe { sfVideoMode_getDesktopMode() }
        }
    }

    public static prop fullscreenModes: Array<VideoMode> {
        get() {
            unsafe {
                var count: UIntNative = 0
                var modesPtr = sfVideoMode_getFullscreenModes(inout count)
                var modes = Array<VideoMode>(Int64(count), repeat: VideoMode())
                for (i in 0..Int64(count)) {
                    modes[i] = modesPtr.read(i)
                }
                return modes
            }
        }
    }

    public static func isValid(mode: VideoMode): Bool {
        unsafe { sfVideoMode_isValid(mode).toBool() }
    }
}
