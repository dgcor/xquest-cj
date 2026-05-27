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

public enum JsonToken <: Equatable<JsonToken> & Hashable {
    // cjlint-ignore -start !G.ENU.01
    | JsonNull
    | JsonBool
    | JsonNumber
    | JsonString
    | BeginArray
    | EndArray
    | BeginObject
    | EndObject
    | Name
    // cjlint-ignore -end

    public operator func ==(that: JsonToken): Bool {
        return match ((this, that)) {
            case (JsonNull, JsonNull) => true
            case (JsonBool, JsonBool) => true
            case (JsonNumber, JsonNumber) => true
            case (JsonString, JsonString) => true
            case (BeginArray, BeginArray) => true
            case (EndArray, EndArray) => true
            case (BeginObject, BeginObject) => true
            case (EndObject, EndObject) => true
            case (Name, Name) => true
            case _ => false
        }
    }

    public operator func !=(that: JsonToken): Bool {
        return !(this == that)
    }

    public func hashCode(): Int64 {
        return match (this) {
            case JsonNull => 0
            case JsonBool => 1
            case JsonNumber => 2
            case JsonString => 3
            case BeginArray => 4
            case EndArray => 5
            case BeginObject => 6
            case EndObject => 7
            case Name => 8
        }
    }
}

const PEEK_STATE_NULL = 0
const PEEK_STATE_TRUE = 1
const PEEK_STATE_FALSE = 2
const PEEK_STATE_NUMBER = 3
const PEEK_STATE_STRING = 4
const PEEK_STATE_ARRAY_BEGIN = 5
const PEEK_STATE_ARRAY_END = 6
const PEEK_STATE_OBJECT_BEGIN = 7
const PEEK_STATE_OBJECT_END = 8
const PEEK_STATE_NAME = 9 // next token must be a name, which type is string
const PEEK_STATE_VALUE = 10 // next token must be a value, can not be a endArray\endobject\name
const PEEK_STATE_NONE = 11
let PEEKSTATE2TOKEN: Array<JsonToken> = [
    JsonToken.JsonNull,
    JsonToken.JsonBool,
    JsonToken.JsonBool,
    JsonToken.JsonNumber,
    JsonToken.JsonString,
    JsonToken.BeginArray,
    JsonToken.EndArray,
    JsonToken.BeginObject,
    JsonToken.EndObject,
    JsonToken.Name
]
const MAX_JSON_STREAM_DEPTH = 100

class JsonStateStack {
    static const JSON_UNDEFINE = 0
    static const JSON_OBJECT = 1
    static const JSON_ARRAY = 2

    var stack = Array<Int64>(8, repeat: 0)
    var stacksize = 1

    init() {}

    func put(v: Int64) {
        if (stacksize >= MAX_JSON_STREAM_DEPTH) {
            throw IllegalStateException("Json nested depth exceeds ${MAX_JSON_STREAM_DEPTH}.")
        }
        if (stacksize >= stack.size) {
            var newstack = Array<Int64>(stack.size * 2, repeat: 0)
            stack.copyTo(newstack, 0, 0, stack.size)
            stack = newstack
        }
        stack[stacksize] = v
        stacksize++
    }

    func pop() {
        stacksize--
    }

    prop top: Int64 {
        get() {
            stack[stacksize - 1]
        }
    }

    prop depth: Int64 {
        get() {
            stacksize
        }
    }
}
