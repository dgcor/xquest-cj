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
import std.sync.{AtomicBool, Mutex}
import stdlog.*

enum LogStyle {
    | SIMPLE
    | TEXT
}

class CommonLoggerState {
    let mode: LogStyle
    let output: OutputStream
    let ioLock = Mutex()

    init(output: OutputStream, mode: LogStyle) {
        this.output = output
        this.mode = mode
    }
}

class CommonLogger <: Logger {
    let _attrs = ArrayList<Attr>()
    var _level = LogLevel.INFO
    let _state: CommonLoggerState
    let _closed = AtomicBool(false)

    init(output: OutputStream, mode: LogStyle) {
        _state = CommonLoggerState(output, mode)
    }

    private init(state: CommonLoggerState, level: LogLevel, attrs: Array<Attr>) {
        _state = state
        _level = level
        _attrs.add(all: attrs)
    }

    public mut prop level: LogLevel {
        get() {
            _level
        }
        set(v) {
            _level = v
        }
    }

    public func withAttrs(attrs: Array<Attr>): CommonLogger {
        if (attrs.size > 0) {
            let nl = this.clone()
            nl._attrs.add(all: attrs)
            return nl
        }
        return this
    }

    public func log(record: LogRecord): Unit {
        let localRecord = record.clone()
        let _as = this._attrs.clone()
        _as.add(all: localRecord.attrs)
        localRecord.attrs = _as.toArray()
        synchronized(_state.ioLock) {
            match (_state.mode) {
                case LogStyle.SIMPLE => logSimple(localRecord, _state.output)
                case LogStyle.TEXT => logText(localRecord, _state.output)
            }
        }
    }

    public func isClosed(): Bool {
        _closed.load()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        synchronized(_state.ioLock) {
            if (_closed.compareAndSwap(false, true)) {
                _state.output.flush()
            }
        }
    }

    func clone(): CommonLogger {
        CommonLogger(_state, _level, _attrs.toArray())
    }
}

func writeLogRecordKeyValue(lw: LogWriter, record: LogRecord) {
    // write time
    lw.writeKey("time")
    lw.writeValue(record.time)
    // write level
    lw.writeKey("level")
    lw.writeValue(record.level.toString())
    // write message
    lw.writeKey("msg")
    lw.writeValue(record.message)
    // write source

    // write attrs
    for (i in 0..record.attrs.size) {
        let (key, value) = record.attrs[i]
        lw.writeKey(key)
        lw.writeValue(value)
    }
}

func logSimple(record: LogRecord, output: OutputStream): Unit {
    let tw: TextLogWriter = TextLogWriter(output)
    tw.start()
    // write time
    tw.writeMessage(record.time.toString())
    tw.writeMessage(' ')
    // write level
    tw.writeMessage(record.level.toString())
    tw.writeMessage(' ')
    // write message
    tw.writeMessage(record.message)
    tw.writeMessage(' ')
    // write source

    // write attrs
    for (i in 0..record.attrs.size) {
        let (key, value) = record.attrs[i]
        tw.writeKey(key)
        tw.writeValue(value)
    }
    tw.end()
    tw.flush()
}

func logText(record: LogRecord, output: OutputStream): Unit {
    let tw: TextLogWriter = TextLogWriter(output)
    tw.start()
    writeLogRecordKeyValue(tw, record)
    tw.end()
    tw.flush()
}
