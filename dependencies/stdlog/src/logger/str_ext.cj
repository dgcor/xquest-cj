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

package stdlog.logger

import std.collection.ArrayList
import std.io.OutputStream

let hex = "0123456789ABCDEF".toArray()

struct JsonUtils {
    static let needEscape: Array<Bool> = Array<Bool>(128, repeat: false)
    static let escapeTable: Array<Byte> = Array<Byte>(128, repeat: 0)

    static init() {
        for (i in 0..32) {
            needEscape[i] = true
        }
        needEscape[127] = true
        needEscape[Int64(b'\"')] = true
        needEscape[Int64(b'\\')] = true

        escapeTable[Int64(b'\b')] = b'b'
        escapeTable[Int64(b'\t')] = b't'
        escapeTable[Int64(b'\n')] = b'n'
        escapeTable[Int64(b'\f')] = b'f'
        escapeTable[Int64(b'\r')] = b'r'
        escapeTable[Int64(b'\"')] = b'\"'
        escapeTable[Int64(b'\\')] = b'\\'
    }
}

func quotedReplace(w: OutputStream, s: String): Unit {
    for (b in s) {
        let codePoint = Int64(b)
        if (codePoint < JsonUtils.needEscape.size && JsonUtils.needEscape[codePoint]) {
            if (JsonUtils.escapeTable[codePoint] != 0) {
                w.write([b'\\', JsonUtils.escapeTable[codePoint]])
            } else {
                w.write([b'\\', b'u', b'0', b'0', hex[codePoint >> 4], hex[codePoint & 0xF]])
            }
        } else {
            w.write([b])
        }
    }
}

func needsQuoting(s: String): Bool {
    if (s.size == 0) {
        return true
    }
    for (b in s) {
        if (b < 0x80) {
            if (b != b'\\' && (b == b' ' || b == b'=' || JsonUtils.needEscape[Int64(b)])) {
                return true
            }
            continue
        }
    }
    return false
}

@When[os == "Windows"]
const PATH_SEP = "\\"
@When[os != "Windows"]
const PATH_SEP = "/"

extend Exception {
    func stackToString(): Array<String> {
        let al = ArrayList<String>.of(this.toString())

        let seArr = getStackTrace()
        let sb = StringBuilder()
        for (ste in seArr) {
            sb.append(ste.declaringClass)
            sb.append(".")
            sb.append(ste.methodName)
            sb.append("(")
            match (ste.fileName.lastIndexOf(PATH_SEP)) {
                case Some(i) => sb.append(ste.fileName[i + 1..])
                case _ => sb.append(ste.fileName)
            }
            sb.append(":")
            sb.append(ste.lineNumber.toString())
            sb.append(")")
            al.add(sb.toString())
            sb.reset()
        }
        return al.toArray()
    }
}
