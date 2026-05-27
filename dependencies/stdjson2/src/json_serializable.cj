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
import std.collection.concurrent.ConcurrentHashMap
import std.convert.Parsable

@FastNative
foreign func StdJson2_FloatPrint(num: Float64, dest: CPointer<UInt8>, destSize: Int64): Int64

public interface JsonSerializable {
    func toJson(w: JsonWriter): Unit
}

func isInvalidJsonFloat(buffer: Array<UInt8>, start: Int64, length: Int64): Bool {
    let value = Float64.parse(String.fromUtf8(buffer[start..start + length]))
    return value.isNaN() || value.isInf()
}

extend Int64 <: JsonSerializable {
    @OverflowWrapping
    public func toJson(w: JsonWriter): Unit {
        w.beforeValue()
        if (this < 0) {
            w.buffer[w.curPos] = b'-'
            w.curPos++
            w.curPos += uitoa(UInt64(-this), w.buffer[w.curPos..])
        } else {
            w.curPos += uitoa(UInt64(this), w.buffer[w.curPos..])
        }
    }
}

extend Int32 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        Int64(this).toJson(w)
    }
}

extend Int16 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        Int64(this).toJson(w)
    }
}

extend Int8 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        Int64(this).toJson(w)
    }
}

extend IntNative <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        Int64(this).toJson(w)
    }
}

extend UInt64 <: JsonSerializable {
    @OverflowWrapping
    public func toJson(w: JsonWriter): Unit {
        w.beforeValue()
        w.curPos += uitoa(this, w.buffer[w.curPos..])
    }
}

extend UInt32 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        UInt64(this).toJson(w)
    }
}

extend UInt16 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        UInt64(this).toJson(w)
    }
}

extend UInt8 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        UInt64(this).toJson(w)
    }
}

extend UIntNative <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        UInt64(this).toJson(w)
    }
}

extend Float64 <: JsonSerializable {
    @OverflowWrapping
    public func toJson(w: JsonWriter): Unit {
        w.beforeValue()
        unsafe {
            let dest = acquireArrayRawData(w.buffer)
            let printedLen = StdJson2_FloatPrint(this, dest.pointer + w.curPos, w.buffer.size - w.curPos)
            releaseArrayRawData(dest)
            if (printedLen <= 0 || isInvalidJsonFloat(w.buffer, w.curPos, printedLen)) {
                throw IllegalStateException("Failed to serialize JSON float.")
            }
            w.curPos += printedLen
        }
        // the result of StdJson2_FloatPrint have at least 6 decimal points
        // there is no out-of-bounds risk
        while (w.buffer[w.curPos - 1] == b'0') {
            w.curPos--
        }
        if (w.buffer[w.curPos - 1] == b'.') {
            w.curPos--
        }
    }
}

extend Float32 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        Float64(this).toJson(w)
    }
}

extend Float16 <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        Float64(this).toJson(w)
    }
}

extend Bool <: JsonSerializable {
    @OverflowWrapping
    public func toJson(w: JsonWriter): Unit {
        w.beforeValue()
        if (this) {
            w.buffer[w.curPos] = b't'
            w.buffer[w.curPos + 1] = b'r'
            w.buffer[w.curPos + 2] = b'u'
            w.buffer[w.curPos + 3] = b'e'
            w.curPos += 4
        } else {
            w.buffer[w.curPos] = b'f'
            w.buffer[w.curPos + 1] = b'a'
            w.buffer[w.curPos + 2] = b'l'
            w.buffer[w.curPos + 3] = b's'
            w.buffer[w.curPos + 4] = b'e'
            w.curPos += 5
        }
    }
}

extend<T> Array<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        for (item in this) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<T> ArrayList<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        for (item in this) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<V> HashMap<String, V> <: JsonSerializable where V <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startObject()
        for ((k, v) in this) {
            w.writeName(k).writeValue(v)
        }
        w.endObject()
    }
}

extend<T> Option<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        if (let Some(v) <- this) {
            w.writeValue<T>(v)
        } else {
            w.writeNullValue()
        }
    }
}

extend<T> HashSet<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        for (item in this) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<T> LinkedList<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        for (item in this) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<T> ArrayQueue<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        for (item in this) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<T> ArrayDeque<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        for (item in this) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<T> ArrayStack<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        let list = this.toArray()
        list.reverse()
        for (item in list) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<T> TreeSet<T> <: JsonSerializable where T <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startArray()
        for (item in this) {
            w.writeValue<T>(item)
        }
        w.endArray()
    }
}

extend<V> TreeMap<String, V> <: JsonSerializable where V <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startObject()
        for ((k, v) in this) {
            w.writeName(k).writeValue(v)
        }
        w.endObject()
    }
}

extend<V> ConcurrentHashMap<String, V> <: JsonSerializable where V <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.startObject()
        for ((k, v) in this) {
            w.writeName(k).writeValue(v)
        }
        w.endObject()
    }
}
