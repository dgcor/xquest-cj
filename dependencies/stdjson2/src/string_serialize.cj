/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * Copyright (c) causerp 2026. All rights reserved.
 *
 * This source file is derived from the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * Modified by causerp in 2026.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package stdjson2

let hex = "0123456789abcdef".toArray()
const HIGH_1_MASK: UInt32 = 0b10000000 // 0x80
const HIGH_2_MASK: UInt32 = 0b11000000 // 0xc0
const HIGH_3_MASK: UInt32 = 0b11100000 // 0xe0
const HIGH_4_MASK: UInt32 = 0b11110000 // 0xf0
const HIGH_5_MASK: UInt32 = 0b11111000 // 0xf8
const HIGH_6_MASK: UInt32 = 0b11111100 // 0xfc
const SHIFT_30: UInt32 = 30
const SHIFT_24: UInt32 = 24
const SHIFT_18: UInt32 = 18
const SHIFT_12: UInt32 = 12
const SHIFT_6: UInt32 = 6
const LOW_6_MASK: UInt32 = 0b00111111 // 0x3f
const LOW_5_MASK: UInt32 = 0b00011111 // 0x1f
const LOW_4_MASK: UInt32 = 0b00001111 // 0x0f
const LOW_3_MASK: UInt32 = 0b00000111 // 0x07
const LOW_2_MASK: UInt32 = 0b00000011 // 0x03
const LOW_1_MASK: UInt32 = 0b00000001 // 0x01

const UTF8_5_MAX: UInt32 = 0x3FFFFFF
const UTF8_4_MAX: UInt32 = 0x10FFFF
const UTF8_3_MAX: UInt32 = 0xFFFF
const UTF8_2_MAX: UInt32 = 0x07FF
const UTF8_1_MAX: UInt32 = 0x7F
const ESCAPE_SIZE_2: Int64 = 2
const ESCAPE_SIZE_6: Int64 = 6

func newEscapeTable(): Array<Byte> {
    let escapeTable: Array<Byte> = Array<Byte>(128, repeat: 0)
    escapeTable[Int64(b'\b')] = b'b'
    escapeTable[Int64(b'\t')] = b't'
    escapeTable[Int64(b'\n')] = b'n'
    escapeTable[Int64(b'\f')] = b'f'
    escapeTable[Int64(b'\r')] = b'r'
    escapeTable[Int64(b'\"')] = b'\"'
    escapeTable[Int64(b'\\')] = b'\\'
    return escapeTable
}

let escapeTable = newEscapeTable()

@OverflowWrapping
func writeEscapeAscii(w: JsonWriter, byte: Int64) {
    if (escapeTable[byte] != 0) {
        if (w.curPos + ESCAPE_SIZE_2 > JsonWriter.DEFAULT_CAPACITY) {
            w.flushOutBuf()
        }
        w.buffer[w.curPos + 1] = escapeTable[byte]
        w.buffer[w.curPos] = b'\\'
        w.curPos += 2
    } else {
        if (w.curPos + ESCAPE_SIZE_6 > JsonWriter.DEFAULT_CAPACITY) {
            w.flushOutBuf()
        }
        w.buffer[w.curPos + 5] = hex[byte & 0xF] // num of low 4 bits
        w.buffer[w.curPos + 4] = hex[byte >> 4] // num of high 4 bits
        w.buffer[w.curPos + 3] = b'0'
        w.buffer[w.curPos + 2] = b'0'
        w.buffer[w.curPos + 1] = b'u'
        w.buffer[w.curPos] = b'\\'
        w.curPos += 6
    }
}

extend String <: JsonSerializable {
    @OverflowWrapping
    public func toJson(w: JsonWriter): Unit {
        w.beforeValue()
        w.buffer[w.curPos] = b'\"'
        w.curPos++

        var beforePos = 0
        let backslash = Int64(b'\\')
        var escapeMask = 0u64
        escapeMask |= 1u64 << Int64(b'\"')
        escapeMask |= (1u64 << 32) - 1u64

        if (w.writeConfig.htmlSafe) {
            var htmlEscapeMask = 0u64
            htmlEscapeMask |= (1u64 << Int64(b'<'))
            htmlEscapeMask |= (1u64 << Int64(b'>'))
            htmlEscapeMask |= (1u64 << Int64(b'&'))
            htmlEscapeMask |= (1u64 << Int64(b'='))
            htmlEscapeMask |= (1u64 << Int64(b'\''))
            escapeMask |= htmlEscapeMask
        }
        for (index in 0..size) {
            let byte = Int64(this[index])
            if (byte > 127) {
                continue
            }
            if (byte == 127 || byte == backslash || (byte < 64 && ((1u64 << byte) & escapeMask) != 0)) {
                insideflush(w, index, beforePos)
                writeEscapeAscii(w, byte)
                beforePos = index + 1
            }
        }

        insideflush(w, this.size, beforePos)
        w.buffer[w.curPos] = b'\"'
        w.curPos++
    }

    @OverflowWrapping
    private func insideflush(w: JsonWriter, curPos: Int64, beforePos: Int64) {
        if (curPos <= beforePos) {
            return
        }
        if (curPos - beforePos >= JsonWriter.FLUSH_THRESHOLD) {
            // write directly to the stream if the string is too long
            w.flushOutBuf()
            unsafe { w.out.write(this.rawData()[beforePos..curPos]) }
        } else {
            if (w.curPos + curPos - beforePos > JsonWriter.DEFAULT_CAPACITY) {
                // flush if the buffer has not enough capacity
                w.flushOutBuf()
            }
            unsafe { this.rawData().copyTo(w.buffer, beforePos, w.curPos, curPos - beforePos) }
            w.curPos = w.curPos + curPos - beforePos
            // flush if the buffer is nearly full
            if (w.curPos >= JsonWriter.FLUSH_THRESHOLD) {
                w.flushOutBuf()
            }
        }
    }
}

extend String <: JsonDeserializable<String> {
    public static func fromJson(r: JsonReader): String {
        const TRUE = "true"
        const FALSE = "false"
        const NULL = "null"
        match (r.peek()) {
            case Some(JsonToken.JsonString) => return r.readString()
            case Some(JsonToken.JsonBool) => return if (r.readBool()) {
                TRUE
            } else {
                FALSE
            }
            case Some(JsonToken.JsonNull) =>
                r.readNull()
                return NULL
            case Some(JsonToken.JsonNumber) =>
                r.nextValue(r.stringBuffer)
                let value = unsafe { String.fromUtf8Unchecked(r.stringBuffer.data[0..r.stringBuffer.size]) }
                r.stringBuffer.clear()
                return value
            case _ => throw IllegalStateException("The next Token is not JSON String.")
        }
    }
}
