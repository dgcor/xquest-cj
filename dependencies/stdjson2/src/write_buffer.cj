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

import std.collection.*

@FastNative
foreign func memcpy_s(dest: CPointer<UInt8>, destMax: UIntNative, src: CPointer<UInt8>, count: UIntNative): Int32

@FastNative
foreign func strlen(str: CPointer<UInt8>): UIntNative

let BOOL_TRUE_STRING = "true".toArray()
let BOOL_FALSE_STRING = "false".toArray()
let NULL_STRING = "null".toArray()
const MIN_CAPACITY = 16
const BLANK: Byte = ' '
const MAX_JSON_WRITE_DEPTH = 100

/*
 * This is a stringbuilder customized for json serialization.
 * Compared with stringbuilder, it has the following optimization points:
 *  1. Constructor with capacity, and func asumecapacity(jv: JsonVaule) is used to
 *     estimate the capacity in advance. Although this is not accurate,
 *     it can reduce a large amount of memory application and copy during
 *     long jsonvalue serialization.
 *  2. The cache(_buffer) is initialized with blank character. when adding blanks,
 *     only need to move the pointer.
 *  3. append(str: String), faster then StringBuilder.
 *  4. func removetail(), faster then StringBuilder.
 */
class WriteBuffer {
    private var _buffer: Array<Byte>
    private var _size: Int64 = 0

    /*
     * buff must be filled with blank
     */
    init(capacity: Int64) {
        let cap = if (capacity > MIN_CAPACITY) {
            capacity
        } else {
            MIN_CAPACITY
        }
        _buffer = Array<Byte>(cap, repeat: BLANK)
    }

    prop size: Int64 {
        get() {
            return _size
        }
    }

    /*
     * buff must be filled with blank
     */
    func checkAndExpend(addition: Int64): Unit {
        let minCapacity = _size + addition
        let oldCapacity: Int64 = _buffer.size
        if (minCapacity < oldCapacity) {
            return
        }

        var newCapacity: Int64 = oldCapacity + (oldCapacity >> 1)
        if (newCapacity < minCapacity) {
            newCapacity = minCapacity
        }
        let newArr: Array<Byte> = Array<Byte>(newCapacity, repeat: BLANK)
        _buffer.copyTo(newArr, 0, 0, _size)
        _buffer = newArr
    }

    func append(arr: Array<Byte>): WriteBuffer {
        checkAndExpend(arr.size)

        if (arr.size < 32) {
            for (index in 0..arr.size) {
                _buffer[_size] = arr[index]
                _size++
            }
        } else {
            arr.copyTo(_buffer, 0, _size, arr.size)
            _size += arr.size
        }
        return this
    }

    func append(str: String): WriteBuffer {
        append(unsafe { str.rawData() })
        return this
    }

    func append(byte: Byte): WriteBuffer {
        checkAndExpend(1)
        _buffer[_size] = byte
        _size++
        return this
    }

    func append(n: Int64): WriteBuffer {
        checkAndExpend(22)
        unsafe {
            let buff = acquireArrayRawData<Byte>(_buffer)
            let len = StdJson2_WriteBufferAppendInt(buff.pointer + _size, n)
            releaseArrayRawData(buff)
            _size += len
        }
        return this
    }

    func append(fl: Float64): WriteBuffer {
        unsafe {
            let p: CPointer<UInt8> = CJ_CORE_Float64ToCPointer(fl)
            if (p.isNull()) {
                return this
            }
            let cpSize = Int64(strlen(p))
            checkAndExpend(cpSize)
            let dest = acquireArrayRawData(_buffer)
            memcpy_s(dest.pointer + _size, UIntNative(_buffer.size - _size), p, UIntNative(cpSize))
            releaseArrayRawData(dest)
            LibC.free(p)
            _size += cpSize
        }

        // the result of CJ_CORE_Float64ToCPointer have at least 6 decimal points
        // there is no out-of-bounds risk
        while (_buffer[_size - 1] == b'0') {
            _size--
        }
        if (_buffer[_size - 1] == b'.') {
            _size--
        }
        return this
    }

    func append(b: Bool): WriteBuffer {
        if (b) {
            append(BOOL_TRUE_STRING)
        } else {
            append(BOOL_FALSE_STRING)
        }
    }

    func appendBlank(n: Int64): WriteBuffer {
        checkAndExpend(n)
        _size += n
        return this
    }

    func removetail(): WriteBuffer {
        if (_size > 0) {
            _size--
        }
        return this
    }

    func appendEscape(str: String, htmlSafe!: Bool = true) {
        var escapenum = 0
        unsafe {
            let input = acquireArrayRawData(str.rawData())
            escapenum = StdJson2_StringEscapeCharNumGet(input.pointer, str.size, htmlSafe)
            releaseArrayRawData(input)
        }

        if (escapenum == 0) {
            append(str)
            return this
        } else {
            checkAndExpend(str.size + escapenum)
            unsafe {
                let input = acquireArrayRawData(str.rawData())
                let buff = acquireArrayRawData<Byte>(_buffer)
                let len = StdJson2_ReplaceEscapeChar(input.pointer, str.size, buff.pointer + _size, htmlSafe)
                releaseArrayRawData(input)
                releaseArrayRawData(buff)
                _size += len
                return this
            }
        }
    }

    func getAndClear(): Array<Byte> {
        let ret = _buffer[0.._size]
        _buffer = Array<Byte>(0, repeat: BLANK)
        _size = 0
        return ret
    }
}

func checkJsonWriteDepth(depth: Int64): Unit {
    if (depth > MAX_JSON_WRITE_DEPTH) {
        throw JsonException("Json nested depth exceeds ${MAX_JSON_WRITE_DEPTH}.")
    }
}

func jsonWriteWithoutFormat(json: JsonValue, buff: WriteBuffer, htmlSafe!: Bool = true): Unit {
    jsonWriteWithoutFormat(json, buff, 0, htmlSafe: htmlSafe)
}

func jsonWriteWithoutFormat(json: JsonValue, buff: WriteBuffer, depth: Int64, htmlSafe!: Bool = true): Unit {
    checkJsonWriteDepth(depth)
    match (json) {
        case JsObject(jo) =>
            if (jo.size == 0) {
                buff.append("{}".toArray())
                return
            }
            buff.append(b'{')
            for ((strKey, jv) in jo) {
                buff.append(b'\"').appendEscape(strKey).append("\":".toArray())
                jsonWriteWithoutFormat(jv, buff, depth + 1, htmlSafe: htmlSafe)
                buff.append(b',')
            }
            buff.removetail()
            buff.append(b'}')
        case JsArray(ja) =>
            if (ja.size == 0) {
                buff.append("[]".toArray())
                return
            }
            buff.append(b'[')
            for (item in ja) {
                jsonWriteWithoutFormat(item, buff, depth + 1, htmlSafe: htmlSafe)
                buff.append(b',')
            }
            buff.removetail()
            buff.append(b']')
        case JsString(js) => buff.append(b'\"').appendEscape(js, htmlSafe: htmlSafe).append(b'\"')
        case JsBool(jb) => buff.append(jb)
        case JsInt(ji) => buff.append(ji)
        case JsDouble(jf) => buff.append(jf)
        case JsNull => buff.append(NULL_STRING)
    }
}

func jsonWriteObject(obj: HashMap<String, JsonValue>, buff: WriteBuffer, depth: Int64, bracketInNewLine: Bool,
    indent: String, htmlSafe!: Bool = true): Unit {
    checkJsonWriteDepth(depth)
    if (bracketInNewLine) {
        for (_ in 0..depth) {
            buff.append(indent)
        }
    }

    if (obj.size == 0) {
        buff.append("{}".toArray())
        return
    }

    buff.append(b'{')
    let new_depth = depth + 1
    for ((key, jv) in obj) {
        buff.append(b'\n')
        for (_ in 0..new_depth) {
            buff.append(indent)
        }
        buff
            .append(b'\"')
            .appendEscape(key)
            .append(b'\"')
            .append(b':')
            .appendBlank(1)
        match (jv) {
            case JsObject(jo) => jsonWriteObject(jo, buff, new_depth, false, indent, htmlSafe: htmlSafe)
            case JsArray(ja) => jsonWriteArray(ja, buff, new_depth, false, indent, htmlSafe: htmlSafe)
            case _ => jsonWriteWithoutFormat(jv, buff, new_depth, htmlSafe: htmlSafe)
        }
        buff.append(b',')
    }
    buff.removetail()
    buff.append(b'\n')
    for (_ in 0..depth) {
        buff.append(indent)
    }
    buff.append(b'}')
}

func jsonWriteArray(arr: ArrayList<JsonValue>, buff: WriteBuffer, depth: Int64, bracketInNewLine: Bool, indent: String,
    htmlSafe!: Bool = true): Unit {
    checkJsonWriteDepth(depth)
    if (bracketInNewLine) {
        for (_ in 0..depth) {
            buff.append(indent)
        }
    }

    if (arr.size == 0) {
        buff.append("[]".toArray())
        return
    }

    buff.append(b'[')
    let new_depth = depth + 1
    for (v in arr) {
        buff.append(b'\n')
        for (_ in 0..new_depth) {
            buff.append(indent)
        }
        match (v) {
            case JsObject(jo) => jsonWriteObject(jo, buff, new_depth, false, indent, htmlSafe: htmlSafe)
            case JsArray(ja) => jsonWriteArray(ja, buff, new_depth, false, indent, htmlSafe: htmlSafe)
            case _ => jsonWriteWithoutFormat(v, buff, new_depth, htmlSafe: htmlSafe)
        }
        buff.append(b',')
    }
    buff.removetail()
    buff.append(b'\n')
    for (_ in 0..depth) {
        buff.append(indent)
    }
    buff.append(b']')
}

func asumecapacity(json: JsonValue): Int64 {
    return asumecapacity(json, 0)
}

func asumecapacity(json: JsonValue, depth: Int64): Int64 {
    checkJsonWriteDepth(depth)
    match (json) {
        case JsObject(jo) =>
            var sum = 2
            for ((k, v) in jo) {
                sum = sum + k.size + 4 // + "key": value,
                sum += asumecapacity(v, depth + 1)
            }
            return sum
        case JsArray(ja) =>
            var sum = 2
            for (v in ja) {
                sum = sum + asumecapacity(v, depth + 1) + 1
            }
            return sum
        case JsString(js) => return js.size + 2 // "value"
        case JsBool(_) => return 5 // max of "false" and "true"
        case JsInt(_) => return 22 // max len is 22
        case JsDouble(_) => return 200 // not precision
        case JsNull => return 4 // len of "null" is 4
    }
}
