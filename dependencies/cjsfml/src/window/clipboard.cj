package cjsfml.window

import cjsfml.system.toCStringUtf32

foreign {
    func sfClipboard_getUnicodeString(): CString

    func sfClipboard_setUnicodeString(string: CPointer<UInt32>): Unit
}

/**
 * Give access to the system clipboard.
 *
 * `Clipboard` provides an interface for getting and
 * setting the contents of the system clipboard.
 *
 * It is important to note that due to limitations on some
 * operating systems, setting the clipboard contents is
 * only guaranteed to work if there is currently an open
 * window for which events are being handled.
 *
 * Usage example:
 * ```
 * // get the clipboard content as a string
 * var string = Clipboard.getString()
 *
 * // or use it in the event loop
 * while (let event = window.pollEvent()) {
 *     if (event.is Closed) {
 *         window.close()
 *     }
 *
 *     if (let keyPressed = event.getIf KeyPressed) {
 *         // Using Ctrl + V to paste a string into SFML
 *         if (keyPressed.control && keyPressed.code == Key.V) {
 *             string = Clipboard.getString()
 *         }
 *
 *         // Using Ctrl + C to copy a string out of SFML
 *         if (keyPressed.control && keyPressed.code == Key.C) {
 *             Clipboard.setString("Hello World!")
 *         }
 *     }
 * }
 * ```
 *
 * @see `String`, `Event`
 */
public class Clipboard {
    /**
     * Get the content of the clipboard as string data.
     *
     * This function returns the content of the clipboard
     * as a string. If the clipboard does not contain string
     * it returns an empty string.
     *
     * @return Clipboard contents as string
     */
    public static func getString(): String {
        unsafe { sfClipboard_getUnicodeString().toString() }
    }

    /**
     * Set the content of the clipboard as string data.
     *
     * This function sets the content of the clipboard as a
     * string.
     *
     * @warning Due to limitations on some operating systems,
     *          setting the clipboard contents is only
     *          guaranteed to work if there is currently an
     *          open window for which events are being handled.
     *
     * @param text string containing the data to be sent
     * to the clipboard
     */
    public static func setString(string: String): Unit {
        unsafe {
            try (str = (string |> toCStringUtf32).asResource()) {
                sfClipboard_setUnicodeString(str.value)
            }
        }
    }
}
