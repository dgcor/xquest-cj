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

public func setGlobalLogger(logger: Logger): Unit {
    synchronized(globalMtx) {
        for (h in loggerHolderList) {
            h.setLogger(logger)
        }
    }
}

public func getGlobalLogger(attrs: Array<Attr>): Logger {
    let h = defaultHolder.load()
    if (attrs.size > 0) {
        return h.withAttrs(attrs)
    }
    if (let Some(l) <- h.holder) {
        return l
    }
    return h
}

public abstract class Logger <: Resource {
    public open mut prop level: LogLevel
    public open func withAttrs(attrs: Array<Attr>): Logger

    public open func log(record: LogRecord): Unit
    public func enabled(level: LogLevel): Bool {
        this.level <= level
    }
    public open func log(level: LogLevel, message: String, attrs: Array<Attr>): Unit {
        if (this.enabled(level)) {
            let record: LogRecord = LogRecord(DateTime.now(), level, message, attrs)
            log(record)
        }
    }
    public open func log(level: LogLevel, message: () -> String, attrs: Array<Attr>): Unit {
        if (this.enabled(level)) {
            let record: LogRecord = LogRecord(DateTime.now(), level, message(), attrs)
            log(record)
        }
    }

    public func fatal(message: String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.FATAL, message, attrs)
    }
    public func fatal(message: () -> String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.FATAL, message, attrs)
    }
    public func error(message: String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.ERROR, message, attrs)
    }
    public func error(message: () -> String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.ERROR, message, attrs)
    }
    public func warn(message: String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.WARN, message, attrs)
    }
    public func warn(message: () -> String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.WARN, message, attrs)
    }
    public func info(message: String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.INFO, message, attrs)
    }
    public func info(message: () -> String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.INFO, message, attrs)
    }
    public func debug(message: String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.DEBUG, message, attrs)
    }
    public func debug(message: () -> String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.DEBUG, message, attrs)
    }
    public func trace(message: String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.TRACE, message, attrs)
    }
    public func trace(message: () -> String, attrs: Array<Attr>): Unit {
        this.log(LogLevel.TRACE, message, attrs)
    }
}
