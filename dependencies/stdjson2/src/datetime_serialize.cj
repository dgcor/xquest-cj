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

import std.time.*

extend DateTime <: JsonSerializable {
    public func toJson(w: JsonWriter): Unit {
        w.writeValue(this.format(w.writeConfig._timeFormat))
    }
}

extend DateTime <: JsonDeserializable<DateTime> {
    public static func fromJson(r: JsonReader): DateTime {
        let dt = r.readString()
        return if (let Some(fmt) <- r.dateTimeFormat) {
            DateTime.parse(dt, fmt)
        } else {
            DateTime.parse(dt)
        }
    }
}
