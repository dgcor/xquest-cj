package XQuest

import customiterators.*
import dgengine.*
import std.collection.*
import std.sort.*

class LevelOptionsManager {
    private var m_options = ArrayList<LevelOptions>()

    // public prop size: Int64 {
    //     get() {
    //         m_options.size
    //     }
    // }

    public func get(level: Int64): LevelOptions {
        for (opt in m_options |> reverse) {
            if (level >= opt.level) {
                return opt
            }
        }
        return LevelOptions()
    }

    public func set(options: ArrayList<LevelOptions>): Unit {
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
