package cjsfml.system

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestTime {
    @TestCase
    func init_default() {
        var time = Time()

        @Expect(time.seconds, 0.0)
        @Expect(time.milliseconds, 0)
        @Expect(time.microseconds, 0)
    }

    @TestCase
    func init_seconds() {
        var time = Time(seconds: 1.2f32)

        @Expect(time.seconds, 1.2)
        @Expect(time.milliseconds, 1200)
        @Expect(time.microseconds, 1200000)
    }

    @TestCase
    func init_seconds_float64() {
        var time = Time(seconds: 1.2f64)

        @Expect(time.seconds, 1.2)
        @Expect(time.milliseconds, 1200)
        @Expect(time.microseconds, 1200000)
    }

    @TestCase
    func init_milliseconds() {
        var time = Time(milliseconds: 1200)

        @Expect(time.seconds, 1.2)
        @Expect(time.milliseconds, 1200)
        @Expect(time.microseconds, 1200000)
    }

    @TestCase
    func init_microseconds() {
        var time = Time(microseconds: 1200000)

        @Expect(time.seconds, 1.2)
        @Expect(time.milliseconds, 1200)
        @Expect(time.microseconds, 1200000)
    }

    @TestCase
    func zero_const() {
        var time = Time.ZERO

        @Expect(time.seconds, 0.0)
        @Expect(time.milliseconds, 0)
        @Expect(time.microseconds, 0)
    }

    @TestCase
    func comparison_operators() {
        @Expect(Time(seconds: 1.2) == Time(seconds: 1.2), true)
        @Expect(Time(seconds: 1.2) == Time(seconds: 1.0), false)

        @Expect(Time(seconds: 1.2) != Time(seconds: 1.0), true)
        @Expect(Time(seconds: 1.2) != Time(seconds: 1.2), false)

        @Expect(Time(seconds: 1.2) > Time(seconds: 1.1), true)
        @Expect(Time(seconds: 1.2) > Time(seconds: 1.2), false)
        @Expect(Time(seconds: 1.2) > Time(seconds: 1.3), false)

        @Expect(Time(seconds: 1.2) >= Time(seconds: 1.1), true)
        @Expect(Time(seconds: 1.2) >= Time(seconds: 1.2), true)
        @Expect(Time(seconds: 1.2) >= Time(seconds: 1.3), false)

        @Expect(Time(seconds: 1.2) < Time(seconds: 1.1), false)
        @Expect(Time(seconds: 1.2) < Time(seconds: 1.2), false)
        @Expect(Time(seconds: 1.2) < Time(seconds: 1.3), true)

        @Expect(Time(seconds: 1.2) <= Time(seconds: 1.1), false)
        @Expect(Time(seconds: 1.2) <= Time(seconds: 1.2), true)
        @Expect(Time(seconds: 1.2) <= Time(seconds: 1.3), true)
    }

    @TestCase
    func arithmetic_operators() {
        @Expect((Time(seconds: 1.2) + Time(seconds: 1.4)) == Time(seconds: 2.6))
        @Expect((Time(seconds: 1.2) + Time(seconds: -1.4)) == Time(seconds: -0.2))

        @Expect((Time(seconds: 1.2) - Time(seconds: 1.4)) == Time(seconds: -0.2))
        @Expect((Time(seconds: 1.2) - Time(seconds: -1.4)) == Time(seconds: 2.6))

        @Expect((-Time(seconds: 1.4)) == Time(seconds: -1.4))

        @Expect((Time(seconds: 1.2) * 2.0) == Time(seconds: 2.4))
        @Expect((Time(seconds: 1.2) * 2) == Time(seconds: 2.4))
        @Expect((Time(seconds: 1.2) * -2.0) == Time(seconds: -2.4))
        @Expect((Time(seconds: 1.2) * -2) == Time(seconds: -2.4))
        @Expect((Time(seconds: -1.2) * -2.0) == Time(seconds: 2.4))
        @Expect((Time(seconds: -1.2) * -2) == Time(seconds: 2.4))
        @Expect((Time(seconds: -1.2) * 2.0) == Time(seconds: -2.4))
        @Expect((Time(seconds: -1.2) * 2) == Time(seconds: -2.4))

        @Expect((Time(seconds: 2.4) / 2.0) == Time(seconds: 1.2))
        @Expect((Time(seconds: 2.4) / 2) == Time(seconds: 1.2))
        @Expect((Time(seconds: 2.4) / Time(seconds: 2.0)) == Time(seconds: 1.2))
        @Expect((Time(seconds: 2.4) / -2.0) == Time(seconds: -1.2))
        @Expect((Time(seconds: 2.4) / -2) == Time(seconds: -1.2))
        @Expect((Time(seconds: 2.4) / Time(seconds: -2.0)) == Time(seconds: -1.2))
        @Expect((Time(seconds: -2.4) / -2.0) == Time(seconds: 1.2))
        @Expect((Time(seconds: -2.4) / -2) == Time(seconds: 1.2))
        @Expect((Time(seconds: -2.4) / Time(seconds: -2.0)) == Time(seconds: 1.2))
        @Expect((Time(seconds: -2.4) / 2.0) == Time(seconds: -1.2))
        @Expect((Time(seconds: -2.4) / 2) == Time(seconds: -1.2))
        @Expect((Time(seconds: -2.4) / Time(seconds: 2.0)) == Time(seconds: -1.2))

        @Expect((Time(seconds: 2.0) % Time(seconds: 2.0)) == Time())
        @Expect((Time(seconds: 2.4) % Time(seconds: 2.0)) == Time(seconds: 0.4))
    }
}

// cjlint-ignore -end function names should be lower camel case
