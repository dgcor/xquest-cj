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

/**
 * @file
 *
 * This is a library for JsonValue enum.
 */
package stdjson2

import std.collection.*

/**
 * JsonValue enum used for encapsulating and manipulating JSON data.
 */
public enum JsonValue <: Collection<JsonValue> & ToString {
    | JsNull
    | JsBool(Bool)
    | JsInt(Int64)
    | JsDouble(Float64)
    | JsString(String)
    | JsArray(ArrayList<JsonValue>)
    | JsObject(HashMap<String, JsonValue>)

    /**
     * Parses string data into JsonValue.
     *
     * @param s String in JSON data format.
     * @throws IllegalArgumentException if string contains null character.
     * @return parsed JsonValue.
     *
     * @throws JsonException if malloc failed or json structure is non-standard.
     */
    public static func fromStr(s: String): JsonValue {
        parseString(s)
    }

    // Collection

    /**
     * Returns an iterator over the elements of this JSON array.
     *
     * This function is used to iterate over values in a JSON array.
     * It provides sequential access to each element.
     *
     * @return An iterator to traverse the array elements.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func iterator(): Iterator<JsonValue> {
        match (this) {
            case JsArray(arr) => arr.iterator()
            case _ => throw JsonException("Not an Array.")
        }
    }

    /**
     * Gets the size of the array.
     *
     * It returns the number of elements if this value is an array, or 0 otherwise.
     *
     * @return The number of elements in the array.
     */
    public prop size: Int64 {
        get() {
            match (this) {
                case JsArray(arr) => arr.size
                case _ => 0
            }
        }
    }

    /**
     * Checks if the array is empty.
     *
     * @return `true` if this array contains no elements or it's not an array.
     */
    public func isEmpty(): Bool {
        size <= 0
    }

    /**
     * Convert JsonArray to Array.
     *
     * @return array of JsonValue elements.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func toArray(): Array<JsonValue> {
        match (this) {
            case JsArray(arr) => Array<JsonValue>(arr.size, {i => arr[i]})
            case _ => throw JsonException("Not an Array.")
        }
    }

    // ToString

    /**
     * Convert JsonValue to String.
     *
     * @return json-converted String is value string data.
     *
     * @throws JsonException if there exists JsonValue which cannot be converted to String.
     */
    public func toString(): String {
        toJsonStringBase(depth: 0, format: false)
    }

    // JsonValue

    /**
     * Convert JsonValue to json-String.
     *
     * @return json-converted prettified String is value string data.
     *
     * @throws JsonException if there exists JsonValue which cannot be converted to String.
     */
    public func toJsonString(): String {
        toJsonStringBase(depth: 0, format: true)
    }

    /**
     * Convert JsonValue to String Without Escaping.
     *
     * @return json-converted String is value string data.
     *
     * @throws JsonException if there exists JsonValue which cannot be converted to String.
     */
    public func toStringWithoutEscaping(): String {
        toJsonStringBase(depth: 0, format: false, htmlSafe: false)
    }

    /**
     * Convert JsonValue to json-String Without Escaping.
     *
     * @return json-converted prettified String is value string data.
     *
     * @throws JsonException if there exists JsonValue which cannot be converted to String.
     */
    public func toJsonStringWithoutEscaping(): String {
        toJsonStringBase(depth: 0, format: true, htmlSafe: false)
    }

    /**
     * Convert JsonValue to Json-String.
     *
     * @param depth of indentation in JSON format.
     * @return json-converted String is value string data.
     *
     * @throws JsonException if there exists JsonValue which cannot be converted to String.
     */
    public func toJsonString(depth: Int64, bracketInNewLine!: Bool = false, indent!: String = "  "): String {
        toJsonStringBase(depth: depth, bracketInNewLine: bracketInNewLine, indent: indent, htmlSafe: true, format: true)
    }

    /**
     * Convert JsonValue to String Without Escaping.
     *
     * @param depth of indentation in JSON format.
     * @return json-converted String is value string data.
     *
     * @throws JsonException if there exists JsonValue which cannot be converted to String.
     */
    public func toStringWithoutEscaping(depth: Int64, bracketInNewLine!: Bool = false, indent!: String = "  "): String {
        toJsonStringBase(depth: depth, bracketInNewLine: bracketInNewLine, indent: indent, htmlSafe: false, format: true)
    }

    /**
     * Convert JsonValue to Json-String Without Escaping.
     *
     * @param depth of indentation in JSON format.
     * @return json-converted String is value string data.
     *
     * @throws JsonException if there exists JsonValue which cannot be converted to String.
     */
    public func toJsonStringWithoutEscaping(depth: Int64, bracketInNewLine!: Bool = false, indent!: String = "  "): String {
        toJsonStringBase(depth: depth, bracketInNewLine: bracketInNewLine, indent: indent, htmlSafe: false, format: true)
    }

    /**
     * Internal helper function to handle base string conversion logic.
     * Unifies formatting, escaping (htmlSafe), and pretty-printing parameters.
     */
    private func toJsonStringBase(depth!: Int64 = 0, bracketInNewLine!: Bool = false, indent!: String = "  ",
        htmlSafe!: Bool = true, format!: Bool = true): String {
        match (this) {
            case JsNull => "null"
            case JsBool(value) => value.toString()
            case JsInt(value) => value.toString()
            case JsDouble(value) => value.toString()
            case JsString(value) =>
                let buff = WriteBuffer(value.size + 2)
                jsonWriteWithoutFormat(this, buff, htmlSafe: htmlSafe)
                unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
            case JsArray(arr) =>
                if (!format) {
                    let buff = WriteBuffer(asumecapacity(this))
                    jsonWriteWithoutFormat(this, buff, htmlSafe: htmlSafe)
                    unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
                } else {
                    if (depth < 0) {
                        throw IllegalArgumentException("Depth cannot be negative.")
                    }
                    if (!indent.isContainOnlySpaceAndTab()) {
                        throw IllegalArgumentException(
                            "Indent must be an empty string or any combination of spaces and tabs.")
                    }
                    let buff = WriteBuffer(asumecapacity(this))
                    jsonWriteArray(arr, buff, depth, bracketInNewLine, indent, htmlSafe: htmlSafe)
                    unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
                }
            case JsObject(obj) =>
                if (!format) {
                    let buff = WriteBuffer(asumecapacity(this))
                    jsonWriteWithoutFormat(this, buff, htmlSafe: htmlSafe)
                    unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
                } else {
                    if (depth < 0) {
                        throw IllegalArgumentException("Depth cannot be negative.")
                    }
                    if (!indent.isContainOnlySpaceAndTab()) {
                        throw IllegalArgumentException(
                            "Indent must be an empty string or any combination of spaces and tabs.")
                    }
                    let buff = WriteBuffer(asumecapacity(this))
                    jsonWriteObject(obj, buff, depth, bracketInNewLine, indent, htmlSafe: htmlSafe)
                    unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
                }
        }
    }

    /**
     * Creates a deep clone of this JsonValue.
     *
     * For primitive types (Null, Bool, Int, Double) and Strings, the same
     * instance is returned.
     *
     * For Arrays and Objects, new collections are allocated with  all nested
     * elements recursively deep-cloned.
     *
     * @return A deep-cloned JsonValue.
     */
    public func clone(): JsonValue {
        match (this) {
            case JsNull => this
            case JsBool(_) => this
            case JsInt(_) => this
            case JsDouble(_) => this
            case JsString(_) => this
            case JsArray(arr) =>
                let newArr = ArrayList<JsonValue>(arr.size)
                for (item in arr) {
                    newArr.add(item.clone())
                }
                JsArray(newArr)
            case JsObject(obj) =>
                let newObj = HashMap<String, JsonValue>(obj.size)
                for ((key, value) in obj) {
                    newObj.add(key, value.clone())
                }
                JsObject(newObj)
        }
    }

    /**
     * Checks if this value is null.
     *
     * @return `true` if this value is null; `false` otherwise.
     */
    public func isNull(): Bool {
        match (this) {
            case JsNull => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is null.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is null; `false` otherwise.
     */
    public func isNull(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isNull()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is null.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is null; `false` otherwise.
     */
    public func isNull(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isNull()
            case None => false
        }
    }

    /**
     * Checks if this value is a Bool.
     *
     * @return `true` if this value is a Bool; `false` otherwise.
     */
    public func isBool(): Bool {
        match (this) {
            case JsBool(_) => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Bool.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Bool; `false` otherwise.
     */
    public func isBool(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isBool()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Bool.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Bool; `false` otherwise.
     */
    public func isBool(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isBool()
            case None => false
        }
    }

    /**
     * Checks if this value is a Number.
     *
     * @return `true` if this value is a Number; `false` otherwise.
     */
    public func isNumber(): Bool {
        match (this) {
            case JsInt(_) | JsDouble(_) => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Number.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Number; `false` otherwise.
     */
    public func isNumber(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isNumber()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Number.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Number; `false` otherwise.
     */
    public func isNumber(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isNumber()
            case None => false
        }
    }

    /**
     * Checks if this value is an Int32.
     *
     * @return `true` if this value is an Int32; `false` otherwise.
     */
    public func isInt32(): Bool {
        match (this) {
            case JsInt(value) => value >= Int64(Int32.Min) && value <= Int64(Int32.Max)
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Int32.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Int32; `false` otherwise.
     */
    public func isInt32(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isInt32()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Int32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int32; `false` otherwise.
     */
    public func isInt32(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isInt32()
            case None => false
        }
    }

    /**
     * Checks if this value is a UInt32.
     *
     * @return `true` if this value is a UInt32; `false` otherwise.
     */
    public func isUInt32(): Bool {
        match (this) {
            case JsInt(value) => value >= 0 && value <= Int64(UInt32.Max)
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a UInt32.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a UInt32; `false` otherwise.
     */
    public func isUInt32(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isUInt32()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a UInt32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt32; `false` otherwise.
     */
    public func isUInt32(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isUInt32()
            case None => false
        }
    }

    /**
     * Checks if this value is an Int64.
     *
     * @return `true` if this value is an Int64; `false` otherwise.
     */
    public func isInt64(): Bool {
        match (this) {
            case JsInt(_) => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Int64.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Int64; `false` otherwise.
     */
    public func isInt64(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isInt64()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Int64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int64; `false` otherwise.
     */
    public func isInt64(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isInt64()
            case None => false
        }
    }

    /**
     * Checks if this value is a UInt64.
     *
     * @return `true` if this value is a UInt64; `false` otherwise.
     */
    @OverflowWrapping
    public func isUInt64(): Bool {
        match (this) {
            case JsInt(value) => value >= 0
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a UInt64.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a UInt64; `false` otherwise.
     */
    public func isUInt64(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isUInt64()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a UInt64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt64; `false` otherwise.
     */
    public func isUInt64(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isUInt64()
            case None => false
        }
    }

    /**
     * Checks if this value is a Float32.
     *
     * @return `true` if this value is a Float32; `false` otherwise.
     */
    @OverflowWrapping
    public func isFloat32(): Bool {
        match (this) {
            case JsDouble(value) => Float64(Float32(value)) == value
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Float32.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Float32; `false` otherwise.
     */
    public func isFloat32(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isFloat32()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Float32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float32; `false` otherwise.
     */
    public func isFloat32(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isFloat32()
            case None => false
        }
    }

    /**
     * Checks if this value is a Float64.
     *
     * @return `true` if this value is a Float64; `false` otherwise.
     */
    public func isFloat64(): Bool {
        match (this) {
            case JsDouble(_) => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Float64.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Float64; `false` otherwise.
     */
    public func isFloat64(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isFloat64()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Float64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float64; `false` otherwise.
     */
    public func isFloat64(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isFloat64()
            case None => false
        }
    }

    /**
     * Checks if this value is a String.
     *
     * @return `true` if this value is a String; `false` otherwise.
     */
    public func isString(): Bool {
        match (this) {
            case JsString(_) => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a String.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a String; `false` otherwise.
     */
    public func isString(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isString()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a String.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a String; `false` otherwise.
     */
    public func isString(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isString()
            case None => false
        }
    }

    /**
     * Checks if this value is an Array.
     *
     * @return `true` if this value is an Array; `false` otherwise.
     */
    public func isArray(): Bool {
        match (this) {
            case JsArray(_) => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Array.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Array; `false` otherwise.
     */
    public func isArray(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isArray()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Array.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Array; `false` otherwise.
     */
    public func isArray(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isArray()
            case None => false
        }
    }

    /**
     * Checks if this value is an Object.
     *
     * @return `true` if this value is an Object; `false` otherwise.
     */
    public func isObject(): Bool {
        match (this) {
            case JsObject(_) => true
            case _ => false
        }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Object.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Object; `false` otherwise.
     */
    public func isObject(index: Int64): Bool {
        match (get(index)) {
            case Some(value) => value.isObject()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Object.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Object; `false` otherwise.
     */
    public func isObject(key: String): Bool {
        match (get(key)) {
            case Some(value) => value.isObject()
            case None => false
        }
    }

    /**
     * Retrieves the Bool value directly from this value.
     *
     * @return `Some(Bool)` if this value is a Bool;
     *         `None` if this value is not a Bool.
     */
    public func getBool(): ?Bool {
        match (this) {
            case JsBool(b) => b
            case _ => None
        }
    }

    /**
     * Retrieves the Bool value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Bool)` if the index is valid and the value is a Bool;
     *         `None` if the index is out of range or the value is not a Bool.
     */
    public func getBool(index: Int64): ?Bool {
        match (get(index)) {
            case Some(value) => value.getBool()
            case None => None
        }
    }

    /**
     * Retrieves the Bool value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Bool)` if the key exists and the value is a Bool;
     *         `None` if the key is missing or the value is not a Bool.
     */
    public func getBool(key: String): ?Bool {
        match (get(key)) {
            case Some(value) => value.getBool()
            case None => None
        }
    }

    /**
     * Retrieves the Int32 value directly from this value.
     *
     * @return `Some(Int32)` if this value is an Int32;
     *         `None` if this value is not an Int32.
     */
    public func getInt32(): ?Int32 {
        match (this) {
            case JsInt(value) =>
                if (value >= Int64(Int32.Min) && value <= Int64(Int32.Max)) {
                    Int32(value)
                } else {
                    None
                }
            case _ => None
        }
    }

    /**
     * Retrieves the Int32 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Int32)` if the index is valid and the value is an Int32;
     *         `None` if the index is out of range or the value is not an Int32.
     */
    public func getInt32(index: Int64): ?Int32 {
        match (get(index)) {
            case Some(value) => value.getInt32()
            case None => None
        }
    }

    /**
     * Retrieves the Int32 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Int32)` if the key exists and the value is an Int32;
     *         `None` if the key is missing or the value is not an Int32.
     */
    public func getInt32(key: String): ?Int32 {
        match (get(key)) {
            case Some(value) => value.getInt32()
            case None => None
        }
    }

    /**
     * Retrieves the UInt32 value directly from this value.
     *
     * @return `Some(UInt32)` if this value is a UInt32;
     *         `None` if this value is not a UInt32.
     */
    public func getUInt32(): ?UInt32 {
        match (this) {
            case JsInt(value) =>
                if (value >= 0 && value <= Int64(UInt32.Max)) {
                    UInt32(value)
                } else {
                    None
                }
            case _ => None
        }
    }

    /**
     * Retrieves the UInt32 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(UInt32)` if the index is valid and the value is a UInt32;
     *         `None` if the index is out of range or the value is not a UInt32.
     */
    public func getUInt32(index: Int64): ?UInt32 {
        match (get(index)) {
            case Some(value) => value.getUInt32()
            case None => None
        }
    }

    /**
     * Retrieves the UInt32 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(UInt32)` if the key exists and the value is a UInt32;
     *         `None` if the key is missing or the value is not a UInt32.
     */
    public func getUInt32(key: String): ?UInt32 {
        match (get(key)) {
            case Some(value) => value.getUInt32()
            case None => None
        }
    }

    /**
     * Retrieves the Int64 value directly from this value.
     *
     * @return `Some(Int64)` if this value is an Int64;
     *         `None` if this value is not an Int64.
     */
    public func getInt64(): ?Int64 {
        match (this) {
            case JsInt(value) => value
            case _ => None
        }
    }

    /**
     * Retrieves the Int64 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Int64)` if the index is valid and the value is an Int64;
     *         `None` if the index is out of range or the value is not an Int64.
     */
    public func getInt64(index: Int64): ?Int64 {
        match (get(index)) {
            case Some(value) => value.getInt64()
            case None => None
        }
    }

    /**
     * Retrieves the Int64 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Int64)` if the key exists and the value is an Int64;
     *         `None` if the key is missing or the value is not an Int64.
     */
    public func getInt64(key: String): ?Int64 {
        match (get(key)) {
            case Some(value) => value.getInt64()
            case None => None
        }
    }

    /**
     * Retrieves the UInt64 value directly from this value.
     *
     * @return `Some(UInt64)` if this value is a UInt64;
     *         `None` if this value is not a UInt64.
     */
    @OverflowWrapping
    public func getUInt64(): ?UInt64 {
        match (this) {
            case JsInt(value) =>
                if (value >= 0) {
                    UInt64(value)
                } else {
                    None
                }
            case _ => None
        }
    }

    /**
     * Retrieves the UInt64 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(UInt64)` if the index is valid and the value is a UInt64;
     *         `None` if the index is out of range or the value is not a UInt64.
     */
    public func getUInt64(index: Int64): ?UInt64 {
        match (get(index)) {
            case Some(value) => value.getUInt64()
            case None => None
        }
    }

    /**
     * Retrieves the UInt64 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(UInt64)` if the key exists and the value is a UInt64;
     *         `None` if the key is missing or the value is not a UInt64.
     */
    public func getUInt64(key: String): ?UInt64 {
        match (get(key)) {
            case Some(value) => value.getUInt64()
            case None => None
        }
    }

    /**
     * Retrieves the Float32 value directly from this value.
     *
     * @return `Some(Float32)` if this value is a Float32;
     *         `None` if this value is not a Float32.
     */
    @OverflowWrapping
    public func getFloat32(): ?Float32 {
        match (this) {
            case JsDouble(f) => Float32(f)
            case _ => None
        }
    }

    /**
     * Retrieves the Float32 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Float32)` if the index is valid and the value is a Float32;
     *         `None` if the index is out of range or the value is not a Float32.
     */
    public func getFloat32(index: Int64): ?Float32 {
        match (get(index)) {
            case Some(value) => value.getFloat32()
            case None => None
        }
    }

    /**
     * Retrieves the Float32 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Float32)` if the key exists and the value is a Float32;
     *         `None` if the key is missing or the value is not a Float32.
     */
    public func getFloat32(key: String): ?Float32 {
        match (get(key)) {
            case Some(value) => value.getFloat32()
            case None => None
        }
    }

    /**
     * Retrieves the Float64 value directly from this value.
     *
     * @return `Some(Float64)` if this value is a Float64;
     *         `None` if this value is not a Float64.
     */
    public func getFloat64(): ?Float64 {
        match (this) {
            case JsDouble(value) => value
            case _ => None
        }
    }

    /**
     * Retrieves the Float64 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Float64)` if the index is valid and the value is a Float64;
     *         `None` if the index is out of range or the value is not a Float64.
     */
    public func getFloat64(index: Int64): ?Float64 {
        match (get(index)) {
            case Some(value) => value.getFloat64()
            case None => None
        }
    }

    /**
     * Retrieves the Float64 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Float64)` if the key exists and the value is a Float64;
     *         `None` if the key is missing or the value is not a Float64.
     */
    public func getFloat64(key: String): ?Float64 {
        match (get(key)) {
            case Some(value) => value.getFloat64()
            case None => None
        }
    }

    /**
     * Retrieves the string value directly from this value.
     *
     * @return `Some(String)` if this value is a valid String;
     *         `None` if this value is not a String.
     */
    public func getString(): ?String {
        match (this) {
            case JsString(value) => value
            case _ => None
        }
    }

    /**
     * Retrieves the string value associated with the specified index.
     *
     * This function performs a copy of the underlying UTF-8 data into a new String.
     *
     * @param index The array index.
     *
     * @return `Some(String)` if the index is valid and the value is a valid String;
     *         `None` if the index is out of range or the value is not a String.
     */
    public func getString(index: Int64): ?String {
        match (get(index)) {
            case Some(value) => value.getString()
            case None => None
        }
    }

    /**
     * Retrieves the string value associated with the specified key.
     *
     * This function performs a copy of the underlying UTF-8 data into a new String.
     *
     * @param key The key to look up.
     *
     * @return `Some(String)` if the key exists and the value is a valid String;
     *         `None` if the key is missing or the value is not a String.
     */
    public func getString(key: String): ?String {
        match (get(key)) {
            case Some(value) => value.getString()
            case None => None
        }
    }

    /**
     * Retrieves a sub-array (JsonValue) directly from this value.
     *
     * This function is used to access nested JSON arrays.
     *
     * @return `Some(JsonValue)` if this value is an array;
     *         `None` if this value is not an array.
     */
    public func getArray(): ?JsonValue {
        match (this) {
            case JsArray(_) => this
            case _ => None
        }
    }

    /**
     * Retrieves a sub-array (JsonValue) associated with the specified index.
     *
     * This function is used to access nested JSON arrays. If the index is valid and the
     * corresponding value is a JSON array, it returns a handle to that array.
     *
     * @param index The array index.
     *
     * @return `Some(JsonValue)` if the index is valid and the value is an array;
     *         `None` if the index is out of range or the value is not an array.
     */
    public func getArray(index: Int64): ?JsonValue {
        match (get(index)) {
            case Some(value) => value.getArray()
            case None => None
        }
    }

    /**
     * Retrieves a sub-array (JsonValue) associated with the specified key.
     *
     * This function is used to access nested JSON arrays. If the key exists and the
     * corresponding value is a JSON array, it returns a handle to that array.
     *
     * @param key The key to look up.
     *
     * @return `Some(JsonValue)` if the key exists and the value is an array;
     *         `None` if the key is missing or the value is not an array.
     */
    public func getArray(key: String): ?JsonValue {
        match (get(key)) {
            case Some(value) => value.getArray()
            case None => None
        }
    }

    /**
     * Retrieves a sub-object (JsonValue) directly from this value.
     *
     * This function is used to access nested JSON objects.
     *
     * @return `Some(JsonValue)` if this value is an object;
     *         `None` if this value is not an object.
     */
    public func getObject(): ?JsonValue {
        match (this) {
            case JsObject(_) => this
            case _ => None
        }
    }

    /**
     * Retrieves a sub-object (JsonValue) associated with the specified index.
     *
     * This function is used to access nested JSON objects. If the index is valid and the
     * corresponding value is a JSON object, it returns a handle to that object.
     *
     * @param index The array index.
     *
     * @return `Some(JsonValue)` if the index is valid and the value is an object;
     *         `None` if the index is out of range or the value is not an object.
     */
    public func getObject(index: Int64): ?JsonValue {
        match (get(index)) {
            case Some(value) => value.getObject()
            case None => None
        }
    }

    /**
     * Retrieves a sub-object (JsonValue) associated with the specified key.
     *
     * This function is used to access nested JSON objects. If the key exists and the
     * corresponding value is a JSON object, it returns a handle to that object.
     *
     * @param key The key to look up.
     *
     * @return `Some(JsonValue)` if the key exists and the value is an object;
     *         `None` if the key is missing or the value is not an object.
     */
    public func getObject(key: String): ?JsonValue {
        match (get(key)) {
            case Some(value) => value.getObject()
            case None => None
        }
    }

    /**
     * Gets the value of an array by its index.
     *
     * @param index The array index.
     *
     * @return `Some(JsonValue)` if the index is valid; `None` if the index is out of range.
     */
    public func get(index: Int64): ?JsonValue {
        match (this) {
            case JsArray(arr) => arr.get(index)
            case _ => None
        }
    }

    /**
     * Gets the value of an array by its index.
     *
     * @param index The array index.
     *
     * @return `JsonValue` if the index is valid.
     *
     * @throws IndexOutOfBoundsException If index out of range.
     */
    public operator func [](index: Int64): JsonValue {
        match (get(index)) {
            case Some(value) => value
            case None => throw IndexOutOfBoundsException("Index out of range.")
        }
    }

    /**
     * Pushes back a null value to the array.
     *
     * @return A JsonValue wrapping the newly added null for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addNull(): JsonValue {
        match (this) {
            case JsArray(arr) =>
                let item = JsNull
                arr.add(item)
                item
            case _ => throw JsonException("Cannot add to non-array JsonValue.")
        }
    }

    /**
     * Pushes back a boolean value to the array.
     *
     * @param val The boolean value to push back.
     *
     * @return A JsonValue wrapping the newly added boolean for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addBool(val: Bool): JsonValue {
        match (this) {
            case JsArray(arr) =>
                let item = JsBool(val)
                arr.add(item)
                item
            case _ => throw JsonException("Cannot add to non-array JsonValue.")
        }
    }

    /**
     * Pushes back an Int32 value to the array.
     *
     * @param val The Int32 value to push back.
     *
     * @return A JsonValue wrapping the newly added Int32 for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addInt32(val: Int32): JsonValue {
        addInt64(Int64(val))
    }

    /**
     * Pushes back a UInt32 value to the array.
     *
     * @param val The UInt32 value to push back.
     *
     * @return A JsonValue wrapping the newly added UInt32 for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addUInt32(val: UInt32): JsonValue {
        addInt64(Int64(val))
    }

    /**
     * Pushes back an Int64 value to the array.
     *
     * @param val The Int64 value to push back.
     *
     * @return A JsonValue wrapping the newly added Int64 for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addInt64(val: Int64): JsonValue {
        match (this) {
            case JsArray(arr) =>
                let item = JsInt(val)
                arr.add(item)
                item
            case _ => throw JsonException("Cannot add to non-array JsonValue.")
        }
    }

    /**
     * Pushes back a UInt64 value to the array.
     *
     * @param val The UInt64 value to push back.
     *
     * @return A JsonValue wrapping the newly added UInt64 for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    @OverflowWrapping
    public func addUInt64(val: UInt64): JsonValue {
        addInt64(Int64(val))
    }

    /**
     * Pushes back a Float32 value to the array.
     *
     * @param val The Float32 value to push back.
     *
     * @return A JsonValue wrapping the newly added Float32 for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addFloat32(val: Float32): JsonValue {
        addFloat64(Float64(val))
    }

    /**
     * Pushes back a Float64 value to the array.
     *
     * @param val The Float64 value to push back.
     *
     * @return A JsonValue wrapping the newly added Float64 for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addFloat64(val: Float64): JsonValue {
        match (this) {
            case JsArray(arr) =>
                let item = JsDouble(val)
                arr.add(item)
                item
            case _ => throw JsonException("Cannot add to non-array JsonValue.")
        }
    }

    /**
     * Pushes back a String value to the array.
     *
     * @param val The String value to push back.
     *
     * @return A JsonValue wrapping the newly added String for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addString(val: String): JsonValue {
        match (this) {
            case JsArray(arr) =>
                let item = JsString(val)
                arr.add(item)
                item
            case _ => throw JsonException("Cannot add to non-array JsonValue.")
        }
    }

    /**
     * Pushes back an empty Array value to the array.
     *
     * @return A JsonValue wrapping the newly added array for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addArray(): JsonValue {
        match (this) {
            case JsArray(arr) =>
                arr.clone()
                let item = JsArray(ArrayList<JsonValue>())
                arr.add(item)
                item
            case _ => throw JsonException("Cannot add to non-array JsonValue.")
        }
    }

    /**
     * Pushes back an empty Object value to the array.
     *
     * @return A JsonValue wrapping the newly added object for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Array.
     */
    public func addObject(): JsonValue {
        match (this) {
            case JsArray(arr) =>
                let item = JsObject(HashMap<String, JsonValue>())
                arr.add(item)
                item
            case _ => throw JsonException("Cannot add to non-array JsonValue.")
        }
    }

    /**
     * Removes the last element in the array.
     *
     * @return `true` if success; `false` if this value is not an array or is empty.
     */
    public func pop(): Bool {
        match (this) {
            case JsArray(arr) =>
                if (arr.size > 0) {
                    arr.remove(at: arr.size - 1)
                    return true
                }
                false
            case _ => false
        }
    }

    /**
     * Removes all elements in the array. Capacity remains unchanged.
     *
     * @return `true` if success; `false` if this value is not an array.
     */
    public func clearArray(): Bool {
        match (this) {
            case JsArray(arr) =>
                arr.clear()
                true
            case _ => false
        }
    }

    /**
     * Erases an element of array by index.
     * Note: Elements are shifted to fill the gap.
     *
     * @param index The index of the element to erase.
     *
     * @return `true` if success; `false` if this value is not an array or index is out of bounds.
     */
    public func eraseArrayItem(index: Int64): Bool {
        match (this) {
            case JsArray(arr) =>
                if (index >= 0 && index < arr.size) {
                    arr.remove(at: index)
                    return true
                }
                false
            case _ => false
        }
    }

    /**
     * Requests the array to have enough capacity to store elements.
     * Prevents reallocation when using PushBack functions.
     *
     * @param newCapacity The desired capacity (number of elements).
     *
     * @return `true` if success; `false` if this value is not an array or out of memory.
     */
    public func reserveArray(newCapacity: Int64): Bool {
        match (this) {
            case JsArray(arr) =>
                arr.reserve(newCapacity)
                true
            case _ => false
        }
    }

    /**
     * Gets the current capacity of the array.
     *
     * @return The capacity, or 0 if this value is not an array.
     */
    public func getArrayCapacity(): Int64 {
        match (this) {
            case JsArray(arr) => arr.capacity
            case _ => 0
        }
    }

    /**
     * Checks if a key exists in this JSON object.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists; `false` otherwise.
     */
    public func hasMember(key: String): Bool {
        match (this) {
            case JsObject(obj) => obj.contains(key)
            case _ => false
        }
    }

    /**
     * Retrieves a sub-value (JsonValue) associated with the specified key.
     *
     * This function is used to access nested JSON values. If the key exists,
     * it returns a handle to that value.
     *
     * @param key The key to look up.
     *
     * @return `Some(JsonValue)` if the key exists; `None` if the key is missing.
     */
    public func get(key: String): ?JsonValue {
        match (this) {
            case JsObject(obj) => obj.get(key)
            case _ => None
        }
    }

    /**
     * Retrieves a sub-value (JsonValue) associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `JsonValue` corresponding to the key.
     *
     * @throws NoneValueException If value does not exist.
     */
    public operator func [](key: String): JsonValue {
        match (get(key)) {
            case Some(value) => value
            case None => throw NoneValueException("Value does not exist.")
        }
    }

    /**
     * Gets the number of members in the object.
     *
     * It returns the count of key-value pairs if this value is an object, or 0 otherwise.
     *
     * @return The number of members in the object.
     */
    public prop memberSize: Int64 {
        get() {
            match (this) {
                case JsObject(obj) => obj.size
                case _ => 0
            }
        }
    }

    /**
     * Returns an iterator over the members of this JSON object.
     *
     * This function is used to iterate over key-value pairs in a JSON object.
     * It provides access to both the member name and its associated value.
     *
     * @return A `HashMapIterator<String, JsonValue>` to traverse the object members.
     */
    public func memberIterator(): HashMapIterator<String, JsonValue> {
        match (this) {
            case JsObject(obj) => obj.iterator()
            case _ => throw JsonException("Not an Object.")
        }
    }

    /**
     * Adds a null member to the object.
     *
     * @param key The key to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberNull(key: String): JsonValue {
        match (this) {
            case JsObject(obj) =>
                let item = JsNull
                obj.add(key, item)
                item
            case _ => throw JsonException("Cannot add member to non-object JsonValue.")
        }
    }

    /**
     * Adds a boolean member to the object.
     *
     * @param key The key to add.
     * @param val The boolean value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberBool(key: String, val: Bool): JsonValue {
        match (this) {
            case JsObject(obj) =>
                let item = JsBool(val)
                obj.add(key, item)
                item
            case _ => throw JsonException("Cannot add member to non-object JsonValue.")
        }
    }

    /**
     * Adds an Int32 member to the object.
     *
     * @param key The key to add.
     * @param val The Int32 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberInt32(key: String, val: Int32): JsonValue {
        addMemberInt64(key, Int64(val))
    }

    /**
     * Adds a UInt32 member to the object.
     *
     * @param key The key to add.
     * @param val The UInt32 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberUInt32(key: String, val: UInt32): JsonValue {
        addMemberInt64(key, Int64(val))
    }

    /**
     * Adds an Int64 member to the object.
     *
     * @param key The key to add.
     * @param val The Int64 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberInt64(key: String, val: Int64): JsonValue {
        match (this) {
            case JsObject(obj) =>
                let item = JsInt(val)
                obj.add(key, item)
                item
            case _ => throw JsonException("Cannot add member to non-object JsonValue.")
        }
    }

    /**
     * Adds a UInt64 member to the object.
     *
     * @param key The key to add.
     * @param val The UInt64 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    @OverflowWrapping
    public func addMemberUInt64(key: String, val: UInt64): JsonValue {
        addMemberInt64(key, Int64(val))
    }

    /**
     * Adds a Float32 member to the object.
     *
     * @param key The key to add.
     * @param val The Float32 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberFloat32(key: String, val: Float32): JsonValue {
        addMemberFloat64(key, Float64(val))
    }

    /**
     * Adds a Float64 member to the object.
     *
     * @param key The key to add.
     * @param val The Float64 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberFloat64(key: String, val: Float64): JsonValue {
        match (this) {
            case JsObject(obj) =>
                let item = JsDouble(val)
                obj.add(key, item)
                item
            case _ => throw JsonException("Cannot add member to non-object JsonValue.")
        }
    }

    /**
     * Adds a String member to the object.
     *
     * @param key The key to add.
     * @param val The String value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberString(key: String, val: String): JsonValue {
        match (this) {
            case JsObject(obj) =>
                let item = JsString(val)
                obj.add(key, item)
                item
            case _ => throw JsonException("Cannot add member to non-object JsonValue.")
        }
    }

    /**
     * Adds an empty Array member to the object.
     *
     * @param key The key to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberArray(key: String): JsonValue {
        match (this) {
            case JsObject(obj) =>
                let item = JsArray(ArrayList<JsonValue>())
                obj.add(key, item)
                item
            case _ => throw JsonException("Cannot add member to non-object JsonValue.")
        }
    }

    /**
     * Adds an empty Object member to the object.
     *
     * @param key The key to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws JsonException if the JsonValue is not an Object.
     */
    public func addMemberObject(key: String): JsonValue {
        match (this) {
            case JsObject(obj) =>
                let item = JsObject(HashMap<String, JsonValue>())
                obj.add(key, item)
                item
            case _ => throw JsonException("Cannot add member to non-object JsonValue.")
        }
    }

    /**
     * Removes all members in the object. Capacity remains unchanged.
     *
     * @return `true` if success; `false` if this value is not an object.
     */
    public func clearObject(): Bool {
        match (this) {
            case JsObject(obj) =>
                obj.clear()
                true
            case _ => false
        }
    }

    /**
     * Removes a member in object by its name.
     * Note: This function may reorder the object members.
     *
     * @param key The key to remove.
     *
     * @return `true` if the member existed and was removed; `false` otherwise.
     */
    public func removeMember(key: String): Bool {
        match (this) {
            case JsObject(obj) => obj.remove(key).isSome()
            case _ => false
        }
    }

    /**
     * Erases a member in object by its name.
     * Note: This function preserves the relative order of the remaining members (slower than removeMember).
     *
     * @param key The key to erase.
     *
     * @return `true` if the member existed and was erased; `false` otherwise.
     */
    public func eraseMember(key: String): Bool {
        match (this) {
            case JsObject(obj) => obj.remove(key).isSome()
            case _ => false
        }
    }

    /**
     * Requests the object to have enough capacity to store members.
     * Prevents reallocation when using AddMember functions.
     *
     * @param newCapacity The desired capacity (number of members).
     *
     * @return `true` if success; `false` if this value is not an object or out of memory.
     */
    public func reserveObject(newCapacity: Int64): Bool {
        match (this) {
            case JsObject(obj) =>
                obj.reserve(newCapacity)
                true
            case _ => false
        }
    }

    /**
     * Gets the current capacity of the object.
     *
     * @return The capacity, or 0 if this value is not an object.
     */
    public func getMemberCapacity(): Int64 {
        match (this) {
            case JsObject(obj) => obj.capacity
            case _ => 0
        }
    }
}

extend String {
    func isContainOnlySpaceAndTab() {
        for (i in this) {
            if (i != b' ' && i != b'\t') {
                return false
            }
        }
        return true
    }
}
