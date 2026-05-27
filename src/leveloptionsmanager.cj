package xquest

import customiterators.*
import std.collection.*
import std.sort.*

class LevelOptionsManager {
    private var m_options = ArrayList<LevelOptions>()

    func get(level: Int64): LevelOptions {
        for (opt in m_options |> reverse) {
            if (level >= opt.level) {
                return opt
            }
        }
        return LevelOptions()
    }

    func set(options: ArrayList<LevelOptions>): Unit {
        m_options = options
        sort(
            m_options,
            by: {
                a, b =>
                    if (a.level < b.level) {
                        return Ordering.LT
                    } else if (a.level > b.level) {
                        return Ordering.GT
                    }
                    return Ordering.EQ
            }
        )
    }
}
