package cjsfml.window

import cenum.*
import cjsfml.system.*

foreign {
    func sfClipboard_getUnicodeString(): CString

    func sfClipboard_setUnicodeString(string: CPointer<UInt32>): Unit
}

public class Clipboard {
    public static func getString(): String {
        unsafe { sfClipboard_getUnicodeString().toString() }
    }

    public static func setString(string: String): Unit {
        unsafe {
            try (str = (string |> toCStringUtf32).asResource()) {
                sfClipboard_setUnicodeString(str.value)
            }
        }
    }
}
