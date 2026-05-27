package cjsfml.system

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestClock {
    @TestCase
    func initialize() {
        let clock = Clock()

        // Verify clock starts automatically
        @Expect(clock.elapsedTime >= Time(), true)
    }

    @TestCase
    func getElapsedTime() {
        let clock = Clock()
        @Expect(clock.elapsedTime >= Time(), true)

        let elapsed = clock.elapsedTime

        // Sleep for 1 millisecond
        sleep(Duration.millisecond)

        @Expect(clock.elapsedTime > elapsed, true)
    }

    @TestCase
    func restart() {
        var clock = Clock()

        // Restart should return time since construction
        @Expect(clock.restart() >= Time(), true)

        // Sleep for 1 millisecond
        sleep(Duration.millisecond)

        // Restart should return the ~1ms duration
        let elapsed = clock.restart()
        @Expect(elapsed >= Time(milliseconds: 1), true)

        // Clock should have reset, so next restart should be smaller
        let nextElapsed = clock.restart()
        @Expect(nextElapsed < elapsed, true)
    }
}

// cjlint-ignore -end function names should be lower camel case
