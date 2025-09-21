package cjsfml.system

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
