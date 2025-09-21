package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

@Test
class TestElapsedTime {
    @TestCase
    func test_init_default() {
        var val = ElapsedTime()

        @Expect(val.currentTime.microseconds, 0)
        @Expect(val.timeout.microseconds, 0)
    }

    @TestCase
    func test_init_default_float() {
        var val = ElapsedTimef()

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 0.0)
    }

    @TestCase
    func test_init_timeout() {
        var val = ElapsedTime(timeout: Time(seconds: 1.0))

        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)
    }

    @TestCase
    func test_init_timeout_float() {
        var val = ElapsedTimef(timeout: 1.0)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)
    }

    @TestCase
    func test_reset() {
        var val = ElapsedTime(timeout: Time(seconds: 1.0))

        val.update(Time(seconds: 0.5))

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        val.reset()

        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)
    }

    @TestCase
    func test_reset_float() {
        var val = ElapsedTimef(timeout: 1.0)

        val.update(0.5)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        val.reset()

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)
    }

    @TestCase
    func test_update_default() {
        var val = ElapsedTime()

        @Expect(val.update(Time(seconds: 0.0)), true)

        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time.zero.microseconds)

        @Expect(val.update(Time(seconds: 0.5)), true)

        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time.zero.microseconds)
    }

    @TestCase
    func test_update_default_float() {
        var val = ElapsedTimef()

        @Expect(val.update(0.0), true)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 0.0)

        @Expect(val.update(0.5), true)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 0.0)
    }

    @TestCase
    func test_update() {
        var val = ElapsedTime(timeout: Time(seconds: 1.0))

        @Expect(val.update(Time(seconds: 0.5)), false)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.update(Time(seconds: 0.5)), true)

        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.update(Time(seconds: 0.5)), false)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.update(Time(seconds: 1.0)), true)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)
    }

    @TestCase
    func test_update_float() {
        var val = ElapsedTimef(timeout: 1.0)

        @Expect(val.update(0.5), false)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.update(0.5), true)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)

        @Expect(val.update(0.5), false)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.update(1.0), true)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)
    }

    @TestCase
    func test_updateAndReset() {
        var val = ElapsedTime(timeout: Time(seconds: 1.0))

        @Expect(val.updateAndReset(Time(seconds: 0.5)), false)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndReset(Time(seconds: 0.5)), true)

        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndReset(Time(seconds: 0.5)), false)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndReset(Time(seconds: 1.0)), true)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.0).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)
    }

    @TestCase
    func test_updateAndReset_float() {
        var val = ElapsedTimef(timeout: 1.0)

        @Expect(val.updateAndReset(0.5), false)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndReset(0.5), true)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndReset(0.5), false)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndReset(1.0), true)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)
    }

    @TestCase
    func test_updateAndSubtract() {
        var val = ElapsedTime(timeout: Time(seconds: 1.0))

        @Expect(val.updateAndSubtract(Time(seconds: 0.5)), false)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndSubtract(Time(seconds: 0.5)), true)

        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndSubtract(Time(seconds: 0.5)), false)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndSubtract(Time(seconds: 1.0)), true)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndSubtract(Time(seconds: 2.0)), true)

        @Expect(val.currentTime.microseconds, Time(seconds: 1.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndSubtract(Time.zero), true)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        @Expect(val.updateAndSubtract(Time.zero), false)

        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)
    }

    @TestCase
    func test_updateAndSubtract_float() {
        var val = ElapsedTimef(timeout: 1.0)

        @Expect(val.updateAndSubtract(0.5), false)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndSubtract(0.5), true)

        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndSubtract(0.5), false)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndSubtract(1.0), true)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndSubtract(2.0), true)

        @Expect(val.currentTime, 1.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndSubtract(0.0), true)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        @Expect(val.updateAndSubtract(0.0), false)

        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)
    }

    @TestCase
    func test_updateFunc() {
        var val = ElapsedTime(timeout: Time(seconds: 1.0))

        let count = Box(0i32)

        val.update(
            Time(seconds: 3.5),
            {
                => count.value++
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        val.update(
            Time(seconds: 0.25),
            {
                => count.value++
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime.microseconds, Time(seconds: 0.75).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        val.update(
            Time(seconds: 0.25),
            {
                => count.value++
            }
        )

        @Expect(count.value, 4)
        @Expect(val.currentTime.microseconds, Time.zero.microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)
    }

    @TestCase
    func test_updateFunc_float() {
        var val = ElapsedTimef(timeout: 1.0)

        let count = Box(0i32)

        val.update(
            3.5,
            {
                => count.value++
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        val.update(
            0.25,
            {
                => count.value++
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime, 0.75)
        @Expect(val.timeout, 1.0)

        val.update(
            0.25,
            {
                => count.value++
            }
        )

        @Expect(count.value, 4)
        @Expect(val.currentTime, 0.0)
        @Expect(val.timeout, 1.0)
    }

    @TestCase
    func test_updateFunc_returns_bool() {
        var val = ElapsedTime(timeout: Time(seconds: 1.0))

        let count = Box(0i32)

        val.update(
            Time(seconds: 3.5),
            {
                =>
                    count.value++
                    return true
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime.microseconds, Time(seconds: 0.5).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        val.update(
            Time(seconds: 0.25),
            {
                =>
                    count.value++
                    return true
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime.microseconds, Time(seconds: 0.75).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        val.update(
            Time(seconds: 3.5),
            {
                =>
                    count.value++
                    return false
            }
        )

        @Expect(count.value, 4)
        @Expect(val.currentTime.microseconds, Time(seconds: 3.25).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)

        val.update(
            Time.zero,
            {
                =>
                    count.value++
                    return true
            }
        )

        @Expect(count.value, 7)
        @Expect(val.currentTime.microseconds, Time(seconds: 0.25).microseconds)
        @Expect(val.timeout.microseconds, Time(seconds: 1.0).microseconds)
    }

    @TestCase
    func test_updateFunc_returns_bool_float() {
        var val = ElapsedTimef(timeout: 1.0)

        let count = Box(0i32)

        val.update(
            3.5,
            {
                =>
                    count.value++
                    return true
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime, 0.5)
        @Expect(val.timeout, 1.0)

        val.update(
            0.25,
            {
                =>
                    count.value++
                    return true
            }
        )

        @Expect(count.value, 3)
        @Expect(val.currentTime, 0.75)
        @Expect(val.timeout, 1.0)

        val.update(
            3.5,
            {
                =>
                    count.value++
                    return false
            }
        )

        @Expect(count.value, 4)
        @Expect(val.currentTime, 3.25)
        @Expect(val.timeout, 1.0)

        val.update(
            0.0,
            {
                =>
                    count.value++
                    return true
            }
        )

        @Expect(count.value, 7)
        @Expect(val.currentTime, 0.25)
        @Expect(val.timeout, 1.0)
    }
}
