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

package stdlog

import std.time.DateTime

public class LogRecord {
    let _time: DateTime
    let _level: LogLevel
    var _msg: String
    var _attrs: Array<Attr>

    public init(time: DateTime, level: LogLevel, msg: String, attrs: Array<Attr>) {
        _time = time
        _level = level
        _msg = msg
        _attrs = attrs
    }
    public prop time: DateTime {
        get() {
            return _time
        }
    }
    public prop level: LogLevel {
        get() {
            return _level
        }
    }

    public mut prop message: String {
        get() {
            return _msg
        }
        set(v) {
            _msg = v
        }
    }
    public mut prop attrs: Array<Attr> {
        get() {
            _attrs
        }
        set(v) {
            _attrs = v
        }
    }
    public func clone(): LogRecord {
        return LogRecord(time, level, message, attrs.clone())
    }
}
