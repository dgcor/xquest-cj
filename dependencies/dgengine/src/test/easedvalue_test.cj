package dgengine.test

import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestEasedValue {
    @TestCase
    func test_init_default() {
        let val = EasedValue()

        @Expect(val.get(), 0.0)
        @Expect(val.getFinal(), 0.0)
    }

    @TestCase
    func test_init_float() {
        let val = EasedValue(value: 2.0)

        @Expect(val.get(), 2.0)
        @Expect(val.getFinal(), 2.0)
    }

    @TestCase
    func test_init_different_easing_function() {
        let val = EasedValue(easingFunc: easeLinear, value: 2.0)

        @Expect(val.get(), 2.0)
        @Expect(val.getFinal(), 2.0)
    }

    @TestCase
    func test_stop_time_not_set() {
        let val = EasedValue(value: 2.0)

        val.update(0.5)

        @Expect(val.get(), 2.0)
        @Expect(val.getFinal(), 2.0)
    }

    @TestCase
    func test_stop_time_set() {
        let val = EasedValue()

        val.set(2.0, 10.0)

        @Expect(val.get(), 0.0)
        @Expect(val.getFinal(), 2.0)
    }

    @TestCase
    func test_stop_time_set_and_updated() {
        let val = EasedValue()

        val.set(2.0, 10.0)
        val.update(2.5)

        @Expect(val.get() < 1.5)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get() < 2.0)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get() < 2.0)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get(), 2.0)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get(), 2.0)
        @Expect(val.getFinal(), 2.0)
    }

    @TestCase
    func test_stop_time_set_and_updated_with_linear_function() {
        let val = EasedValue(easingFunc: easeLinear)

        val.set(2.0, 10.0)
        val.update(2.5)

        @Expect(val.get(), 0.5)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get(), 1.0)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get(), 1.5)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get(), 2.0)
        @Expect(val.getFinal(), 2.0)

        val.update(2.5)

        @Expect(val.get(), 2.0)
        @Expect(val.getFinal(), 2.0)
    }
}

// cjlint-ignore -end function names should be lower camel case
