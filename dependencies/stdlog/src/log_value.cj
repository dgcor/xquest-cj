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

import std.collection.{HashMap, TreeMap}
import std.time.DateTime

public interface LogValue {
    func writeTo(w: LogWriter): Unit
}

extend Int64 <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.writeInt(this)
    }
}

extend Bool <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.writeBool(this)
    }
}

extend Float64 <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.writeFloat(this)
    }
}

extend DateTime <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.writeDateTime(this)
    }
}

extend Duration <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.writeDuration(this)
    }
}

extend String <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.writeString(this)
    }
}

extend Exception <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.writeException(this)
    }
}

extend<T> Array<T> <: LogValue where T <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.startArray()
        for (e in this) {
            w.writeValue(e)
        }
        w.endArray()
    }
}

extend<V> HashMap<String, V> <: LogValue where V <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.startObject()
        for ((k, v) in this) {
            w.writeKey(k)
            w.writeValue(v)
        }
        w.endObject()
    }
}

extend<V> TreeMap<String, V> <: LogValue where V <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        w.startObject()
        for ((k, v) in this) {
            w.writeKey(k)
            w.writeValue(v)
        }
        w.endObject()
    }
}

extend<T> Option<T> <: LogValue where T <: LogValue {
    public func writeTo(w: LogWriter): Unit {
        if (let Some(v) <- this) {
            w.writeValue(v)
        } else {
            w.writeNone()
        }
    }
}
