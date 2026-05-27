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

public abstract class LogWriter {
    public func writeNone(): Unit
    public func writeInt(v: Int64): Unit
    public func writeBool(v: Bool): Unit
    public func writeFloat(v: Float64): Unit
    public func writeString(v: String): Unit
    public func writeDateTime(v: DateTime): Unit
    public func writeDuration(v: Duration): Unit
    public func writeException(v: Exception): Unit
    public func writeKey(v: String): Unit
    public func writeValue(v: LogValue): Unit
    public func startArray(): Unit
    public func endArray(): Unit
    public func startObject(): Unit
    public func endObject(): Unit
}
