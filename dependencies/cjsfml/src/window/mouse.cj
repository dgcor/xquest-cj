package cjsfml.window

import cenum.CEnum
import cjsfml.system.Vector2i

foreign {
    func sfMouse_isButtonPressed(button: MouseButton): Bool

    func sfMouse_getPosition(relativeTo: CPointer<Unit>): Vector2i

    func sfMouse_setPosition(position: Vector2i, relativeTo: CPointer<Unit>): Unit

    func sfMouse_getPositionWindowBase(relativeTo: CPointer<Unit>): Vector2i

    func sfMouse_setPositionWindowBase(position: Vector2i, relativeTo: CPointer<Unit>): Unit
}

/**
 * Mouse buttons.
 */
@CEnum[public MouseButton](
    Left // The left mouse button
    Right // The right mouse button
    Middle // The middle (wheel) mouse button
    ButtonExtra1 // The first extra mouse button
    ButtonExtra2 // The second extra mouse button
    Count // The total number of mouse buttons
)

/**
 * Mouse wheels.
 */
@CEnum[public MouseWheel](
    VerticalWheel // The vertical mouse wheel
    HorizontalWheel // The horizontal mouse wheel
)

/**
 * Give access to the real-time state of the mouse.
 *
 * `Mouse` provides an interface to the state of the
 * mouse. A single mouse is assumed.
 *
 * This class allows users to query the mouse state at any
 * time and directly, without having to deal with a window and
 * its events. Compared to the `MouseMoved`, `MouseButtonPressed`
 * and `MouseButtonReleased` events, `Mouse` can retrieve the
 * state of the cursor and the buttons at any time
 * (you don't need to store and update a boolean on your side
 * in order to know if a button is pressed or released), and you
 * always get the real state of the mouse, even if it is
 * moved, pressed or released when your window is out of focus
 * and no event is triggered.
 *
 * The `setPosition` and `getPosition` functions can be used to change
 * or retrieve the current position of the mouse pointer. There are
 * two versions: one that operates in global coordinates (relative
 * to the desktop) and one that operates in window coordinates
 * (relative to a specific window).
 *
 * Usage example:
 * ```
 * if (Mouse.isButtonPressed(MouseButton.Left)) {
 *     // left click...
 * }
 *
 * // get global mouse position
 * let position = Mouse.getPosition();
 *
 * // set mouse position relative to a window
 * Mouse.setPosition(Vector2i(100, 200), window);
 * ```
 *
 * @see `Joystick`, `Keyboard`, `Touch`
 */
public class Mouse {
    /**
     * Check if a mouse button is pressed.
     *
     * @warning Checking the state of buttons `MouseButton.ButtonExtra1` and
     *          `MouseButton.ButtonExtra2` is not supported on Linux with X11.
     *
     * @param button Button to check
     *
     * @return `true` if the button is pressed, `false` otherwise
     */
    public static func isButtonPressed(button: MouseButton): Bool {
        unsafe { sfMouse_isButtonPressed(button) }
    }

    /**
     * Get the current position of the mouse in desktop coordinates.
     *
     * This function returns the global position of the mouse
     * cursor on the desktop.
     *
     * @return Current position of the mouse
     */
    public static func getPosition(): Vector2i {
        getPosition(None)
    }

    /**
     * Get the current position of the mouse in window coordinates.
     *
     * This function returns the current position of the mouse
     * cursor, relative to the given window.
     *
     * @param relativeTo Reference window
     *
     * @return Current position of the mouse
     */
    public static func getPosition(relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfMouse_getPosition(relativeTo?.handle ?? CPointer()) }
    }

    /**
     * Set the current position of the mouse in desktop coordinates.
     *
     * This function sets the global position of the mouse
     * cursor on the desktop.
     *
     * @warning On macOS the OS API used for `setPosition` requires granting
     *          of Accessibility permission for your application.
     *          See also: https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/
     *
     * @param position New position of the mouse
     */
    public static func setPosition(position: Vector2i): Unit {
        setPosition(position, None)
    }

    /**
     * Set the current position of the mouse in window coordinates.
     *
     * This function sets the current position of the mouse
     * cursor, relative to the given window.
     *
     * @warning On macOS the OS API used for `setPosition` requires granting
     *          of Accessibility permission for your application.
     *          See also: https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/
     *
     * @param position New position of the mouse
     * @param relativeTo Reference window
     */
    public static func setPosition(position: Vector2i, relativeTo: ?SFMLWindow): Unit {
        unsafe { sfMouse_setPosition(position, relativeTo?.handle ?? CPointer()) }
    }

    /**
     * Get the current position of the mouse in desktop coordinates.
     *
     * This function returns the global position of the mouse
     * cursor on the desktop.
     *
     * @return Current position of the mouse
     */
    public static func getPositionWindowBase(): Vector2i {
        getPositionWindowBase(None)
    }

    /**
     * Get the current position of the mouse in window coordinates.
     *
     * This function returns the current position of the mouse
     * cursor, relative to the given window.
     *
     * @param relativeTo Reference window
     *
     * @return Current position of the mouse
     */
    public static func getPositionWindowBase(relativeTo: ?SFMLWindow): Vector2i {
        unsafe { sfMouse_getPositionWindowBase(relativeTo?.handle ?? CPointer()) }
    }

    /**
     * Set the current position of the mouse in desktop coordinates.
     *
     * This function sets the global position of the mouse
     * cursor on the desktop.
     *
     * @warning On macOS the OS API used for `setPosition` requires granting
     *          of Accessibility permission for your application.
     *          See also: https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/
     *
     * @param position New position of the mouse
     */
    public static func setPositionWindowBase(position: Vector2i): Unit {
        setPositionWindowBase(position, None)
    }

    /**
     * Set the current position of the mouse in window coordinates.
     *
     * This function sets the current position of the mouse
     * cursor, relative to the given window.
     *
     * @warning On macOS the OS API used for `setPosition` requires granting
     *          of Accessibility permission for your application.
     *          See also: https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/
     *
     * @param position New position of the mouse
     * @param relativeTo Reference window
     */
    public static func setPositionWindowBase(position: Vector2i, relativeTo: ?SFMLWindow): Unit {
        unsafe { sfMouse_setPositionWindowBase(position, relativeTo?.handle ?? CPointer()) }
    }
}
