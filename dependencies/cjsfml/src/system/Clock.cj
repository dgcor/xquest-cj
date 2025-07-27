package cjsfml.system

import std.time.*

public struct Clock {
    private var m_startTime: MonoTime = MonoTime.now()

    public prop elapsedTime: Time {
        get() {
            let elapsed = MonoTime.now() - m_startTime
            return Time(microseconds: elapsed.toMicroseconds())
        }
    }

    public mut func restart(): Time {
        let now = MonoTime.now()
        let elapsed = now - m_startTime
        m_startTime = now
        return Time(microseconds: elapsed.toMicroseconds())
    }
}
