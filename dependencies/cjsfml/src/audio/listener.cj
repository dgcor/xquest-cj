package cjsfml.audio

import cjsfml.system.Vector3f

foreign {
    func sfListener_setGlobalVolume(volume: Float32): Unit

    func sfListener_getGlobalVolume(): Float32

    func sfListener_setPosition(position: Vector3f): Unit

    func sfListener_getPosition(): Vector3f

    func sfListener_setDirection(direction: Vector3f): Unit

    func sfListener_getDirection(): Vector3f

    func sfListener_setVelocity(velocity: Vector3f): Unit

    func sfListener_getVelocity(): Vector3f

    func sfListener_setCone(cone: ListenerCone): Unit

    func sfListener_getCone(): ListenerCone

    func sfListener_setUpVector(upVector: Vector3f): Unit

    func sfListener_getUpVector(): Vector3f
}

/**
 * The audio listener is the point in the scene from where all the sounds are heard.
 *
 * The audio listener defines the global properties of the
 * audio environment, it defines where and how sounds and musics
 * are heard. If `View` is the eyes of the user, then
 * `Listener` are their ears (by the way, they are often linked
 * together -- same position, orientation, etc.).
 *
 * `Listener` is a simple interface, which allows to setup the
 * listener in the 3D audio environment (position, direction and
 * up vector), and to adjust the global volume.
 *
 * Usage example:
 * ```
 * // Move the listener to the position (1, 0, -5)
 * Listener.position = Vector3f(1, 0, -5)
 *
 * // Make it face the right axis (1, 0, 0)
 * Listener.direction = Vector3f(1, 0, 0)
 *
 * // Reduce the global volume
 * Listener.globalVolume = 50
 * ```
 */
public class Listener {
    /**
     * The global volume of all the sounds and musics.
     *
     * The volume is a number between 0 and 100; it is combined
     * with the individual volume of each sound / music.
     * The default value for the volume is 100 (maximum).
     *
     * @see globalVolume
     */
    public static mut prop globalVolume: Float32 {
        get() {
            unsafe { sfListener_getGlobalVolume() }
        }
        set(value) {
            unsafe { sfListener_setGlobalVolume(value) }
        }
    }

    /**
     * The position of the listener in the scene.
     *
     * The default listener's position is (0, 0, 0).
     *
     * @see position
     * @see direction
     */
    public static mut prop position: Vector3f {
        get() {
            unsafe { sfListener_getPosition() }
        }
        set(value) {
            unsafe { sfListener_setPosition(value) }
        }
    }

    /**
     * The forward vector of the listener in the scene.
     *
     * The direction (also called "at vector") is the vector
     * pointing forward from the listener's perspective. Together
     * with the up vector, it defines the 3D orientation of the
     * listener in the scene. The direction vector doesn't
     * have to be normalized.
     * The default listener's direction is (0, 0, -1).
     *
     * @see direction
     * @see upVector
     * @see position
     */
    public static mut prop direction: Vector3f {
        get() {
            unsafe { sfListener_getDirection() }
        }
        set(value) {
            unsafe { sfListener_setDirection(value) }
        }
    }

    /**
     * The velocity of the listener in the scene.
     *
     * The default listener's velocity is (0, 0, -1).
     *
     * @see velocity
     * @see direction
     * @see upVector
     * @see position
     */
    public static mut prop velocity: Vector3f {
        get() {
            unsafe { sfListener_getVelocity() }
        }
        set(value) {
            unsafe { sfListener_setVelocity(value) }
        }
    }

    /**
     * The cone properties of the listener in the audio scene.
     *
     * The cone defines how directional attenuation is applied.
     * The default cone of a sound is (2 * PI, 2 * PI, 1).
     *
     * @see cone
     */
    public static mut prop cone: ListenerCone {
        get() {
            unsafe { sfListener_getCone() }
        }
        set(value) {
            unsafe { sfListener_setCone(value) }
        }
    }

    /**
     * The upward vector of the listener in the scene.
     *
     * The up vector is the vector that points upward from the
     * listener's perspective. Together with the direction, it
     * defines the 3D orientation of the listener in the scene.
     * The up vector doesn't have to be normalized.
     * The default listener's up vector is (0, 1, 0). It is usually
     * not necessary to change it, especially in 2D scenarios.
     *
     * @see upVector
     * @see direction
     * @see position
     */
    public static mut prop upVector: Vector3f {
        get() {
            unsafe { sfListener_getUpVector() }
        }
        set(value) {
            unsafe { sfListener_setUpVector(value) }
        }
    }
}
