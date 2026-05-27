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

import std.collection.ArrayList
import std.sync.{AtomicUInt64, AtomicReference, Mutex}

let loggerHolderList = ArrayList<LoggerHolder>()
let globalMtx = Mutex()

class LoggerHolder <: Logger {
    static let id = AtomicUInt64(0)
    let objId: UInt64
    let _attrs = ArrayList<Attr>()
    var holder: ?Logger = None
    let mtx = Mutex()

    init() {
        id.fetchAdd(1)
        objId = id.load()
    }

    func setLogger(l: Logger): Unit {
        holder = l.withAttrs(_attrs.toArray())
    }

    public mut prop level: LogLevel {
        get() {
            match (holder) {
                case Some(l) => l.level
                case _ => LogLevel.OFF
            }
        }
        set(v) {
            match (holder) {
                case Some(l) => l.level = v
                case _ => ()
            }
        }
    }

    public func log(record: LogRecord): Unit {
        match (holder) {
            case Some(l) => l.log(record)
            case _ => ()
        }
    }

    public func withAttrs(attrs: Array<Attr>): Logger {
        synchronized(globalMtx) {
            match (holder) {
                case Some(l) => l.withAttrs(attrs)
                case _ =>
                    if (attrs.size > 0) {
                        let nh = this.clone()
                        loggerHolderList.add(nh)
                        nh.level = this.level
                        nh._attrs.add(all: attrs)
                        return nh
                    }
                    return this
            }
        }
    }

    public func isClosed(): Bool {
        match (holder) {
            case Some(l) => l.isClosed()
            case _ => return false
        }
    }

    public func close(): Unit {
        match (holder) {
            case Some(l) => l.close()
            case _ => ()
        }
    }
    func clone(): LoggerHolder {
        let cl = LoggerHolder()
        cl.level = this.level
        cl._attrs.add(all: this._attrs)
        return cl
    }
}

let h = LoggerHolder()
let defaultHolder = AtomicReference<LoggerHolder>(h)

let _ = {
    => loggerHolderList.add(h)
}()
