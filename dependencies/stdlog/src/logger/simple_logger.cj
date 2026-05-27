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

import std.io.OutputStream
import stdlog.*

public class SimpleLogger <: Logger {
    let cl: CommonLogger
    init(cl: CommonLogger) {
        this.cl = cl
    }
    public init(output: OutputStream) {
        cl = CommonLogger(output, LogStyle.SIMPLE)
    }
    public mut prop level: LogLevel {
        get() {
            cl.level
        }
        set(v) {
            cl.level = v
        }
    }
    public func withAttrs(attrs: Array<Attr>): Logger {
        return SimpleLogger(cl.withAttrs(attrs))
    }
    public func isClosed(): Bool {
        cl.isClosed()
    }
    public func close(): Unit {
        cl.close()
    }
    public func log(record: LogRecord): Unit {
        cl.log(record)
    }
}
