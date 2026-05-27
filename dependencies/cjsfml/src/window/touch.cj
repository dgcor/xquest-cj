package cjsfml.window

import cjsfml.system.Vector2i

foreign {
    func sfTouch_isDown(finger: UInt32): Bool

    func sfTouch_getPosition(finger: UInt32, relativeTo: CPointer<Unit>): Vector2i

    func sfTouch_getPositionWindowBase(finger: UInt32, relativeTo: CPointer<Unit>): Vector2i
}

/**
 * Give access to the real-time state of the touches.
 *
 * `Touch` provides an interface to the state of the
 * touches.
 *
 * This class allows users to query the touches state at any
 * time and directly, without having to deal with a window and
 * its events. Compared to the `TouchBegan`, `TouchMoved`
 * and `TouchEnded` events, `Touch` can retrieve the
 * state of the touches at any time (you don't need to store and
 * update a boolean on your side in order to know if a touch is down),
 * and you always get the real state of the touches, even if they
 * happen when your window is out of focus and no event is triggered.
 *
 * The getPosition function can be used to retrieve the current
 * position of a touch. There are two versions: one that operates
 * in global coordinates (relative to the desktop) and one that
 * operates in window coordinates (relative to a specific window).
 *
 * Touches are identified by an index (the "finger"), so that in
 * multi-touch events, individual touches can be tracked correctly.
 * As long as a finger touches the screen, it will keep the same index
 * even if other fingers start or stop touching the screen in the
 * meantime. As a consequence, active touch indices may not always be
 * sequential (i.e. touch number 0 may be released while touch number 1
 * is still down).
 *
 * Usage example:
 * ```
 * if (Touch.isDown(0)) {
 *     // touch 0 is down
 * }
 *
 * // get global touch position
 * let position = Touch.getPosition(0);
 *
 * // set touch position relative to a window
 * let relativePosition = Touch.getPosition(0, window);
 * ```
 *
 * @see `Joystick`, `Keyboard`, `Mouse`
 */
public class Touch {
    /**
     * Check if a touch event is currently down.
     *
     * @param finger Finger index
     *
     * @return `true` if `finger` is currently touching the screen, `false` otherwise
     */
    public static func isDown(finger: UInt32): Bool {
        unsafe { sfTouch_isDown(finger) }
    }

    /**
     * Get the current position of a touch in desktop coordinates.
     *
     * This function returns the current touch position
     * in global (desktop) coordinates.
     *
     * @param finger Finger index
     *
     * @return Current position of `finger`, or undefined if it's not down
     */
    public static func getPosition(finger: UInt32): Vector2i {
        getPosition(finger, None)
    }

    /**
     * Get the current position of a touch in window coordinates.
     *
     * This function returns the current touch position
     * relative to the given window.
     *
     * @param finger Finger index
     * @param relativeTo Reference window
     *
     * @return Current position of `finger`, or undefined if it's not down
     */
    public static func getPosition(finger: UInt32, relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfTouch_getPosition(finger, relativeTo?.handle ?? CPointer()) }
    }

    /**
     * Get the current position of a touch in window coordinates (WindowBase version).
     *
     * This function returns the current touch position
     * relative to the given window.
     *
     * @param finger Finger index
     * @param relativeTo Reference window
     *
     * @return Current position of `finger`, or undefined if it's not down
     */
    public static func getPositionWindowBase(finger: UInt32, relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfTouch_getPositionWindowBase(finger, relativeTo?.handle ?? CPointer()) }
    }
}
