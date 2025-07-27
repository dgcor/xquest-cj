package cjsfml.audio

import cjsfml.system.*

foreign {
    func sfListener_setGlobalVolume(volume: Float32): Unit

    func sfListener_getGlobalVolume(): Float32

    func sfListener_setPosition(position: Vector3f): Unit

    func sfListener_getPosition(): Vector3f

    func sfListener_setDirection(direction: Vector3f): Unit

    func sfListener_getDirection(): Vector3f

    func sfListener_setUpVector(upVector: Vector3f): Unit

    func sfListener_getUpVector(): Vector3f
}

public class Listener {
    public mut static prop globalVolume: Float32 {
        get() {
            unsafe { sfListener_getGlobalVolume() }
        }
        set(value) {
            unsafe { sfListener_setGlobalVolume(value) }
        }
    }

    public mut static prop position: Vector3f {
        get() {
            unsafe { sfListener_getPosition() }
        }
        set(value) {
            unsafe { sfListener_setPosition(value) }
        }
    }

    public mut static prop direction: Vector3f {
        get() {
            unsafe { sfListener_getDirection() }
        }
        set(value) {
            unsafe { sfListener_setDirection(value) }
        }
    }

    public mut static prop upVector: Vector3f {
        get() {
            unsafe { sfListener_getUpVector() }
        }
        set(value) {
            unsafe { sfListener_setUpVector(value) }
        }
    }
}
