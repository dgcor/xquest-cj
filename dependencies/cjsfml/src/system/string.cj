package cjsfml.system

/**
 * @brief Convert a Cangjie String to a C-style UTF-32 string
 *
 * Allocates a new C-compatible string (UTF-32 encoded) from a Cangjie String.
 * The returned string is null-terminated.
 *
 * @param str String to convert
 * @return Pointer to the allocated C string (must be freed manually)
 */
protected func toCStringUtf32(str: String): CPointer<UInt32> {
    unsafe {
        let str32 = LibC.malloc<UInt32>(count: str.size + 1)
        var index = 0
        for (rune in str.runes()) {
            str32.write(index, UInt32(rune))
            index++
        }
        str32.write(index, 0)
        return str32
    }
}

/**
 * @brief Convert a C-style UTF-32 string to a Cangjie String
 *
 * Reads a null-terminated C string (UTF-32 encoded) and converts it
 * to a Cangjie String.
 *
 * @param str32 Pointer to the C string
 * @return Converted Cangjie String
 */
protected func toString(str32: CPointer<UInt32>): String {
    let sb = StringBuilder()
    for (i in 0..Int64(Int32.Max)) {
        let utf32Char = unsafe { str32.read(i) }
        if (utf32Char == 0) {
            break
        }
        sb.append(Rune(utf32Char))
    }
    return sb.toString()
}
