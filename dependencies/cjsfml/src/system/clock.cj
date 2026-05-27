package cjsfml.system

import std.time.MonoTime

/**
 * Utility class that measures the elapsed time.
 *
 * `Clock` is a lightweight class for measuring time.
 *
 * It provides the most precise time that the underlying
 * OS can achieve (generally microseconds or nanoseconds).
 * It also ensures monotonicity, which means that the returned
 * time can never go backward, even if the system time is
 * changed.
 *
 * Usage example:
 * ```
 * var clock = Clock();
 * ...
 * var time1 = clock.elapsedTime;
 * ...
 * var time2 = clock.restart();
 * ```
 *
 * The `Time` value returned by the clock can then be
 * converted to a number of seconds, milliseconds or even
 * microseconds.
 *
 * @see `Time`
 */
public struct Clock {
    private var m_startTime: MonoTime = MonoTime.now()

    /**
     * Get the elapsed time.
     *
     * This function returns the time elapsed since the last call
     * to `restart()` (or the construction of the instance if `restart()`
     * has not been called).
     *
     * @return Time elapsed
     */
    public prop elapsedTime: Time {
        get() {
            let elapsed = MonoTime.now() - m_startTime
            return Time(microseconds: elapsed.toMicroseconds())
        }
    }

    /**
     * Restart the clock.
     *
     * This function puts the time counter back to zero, returns
     * the elapsed time, and leaves the clock in a running state.
     *
     * @return Time elapsed
     */
    public mut func restart(): Time {
        let now = MonoTime.now()
        let elapsed = now - m_startTime
        m_startTime = now
        return Time(microseconds: elapsed.toMicroseconds())
    }
}
