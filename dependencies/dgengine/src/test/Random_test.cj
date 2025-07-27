package dgengine.test

import dgengine.*
import std.collection.*
import std.math.*
import std.unittest.*

@Test
class TestRandom {
    @TestCase
    func get_0_n() {
        let hist = HashMap<Int64, Int64>()
        for (_ in 0..100) {
            let val = Random.get(4)
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.contains(-1), false)
        @Expect(hist.contains(0), true)
        @Expect(hist.contains(4), true)
        @Expect(hist.contains(5), false)

        @Expect(hist[0] > 2)
        @Expect(hist[1] > 2)
        @Expect(hist[2] > 2)
        @Expect(hist[3] > 2)
        @Expect(hist[4] > 2)
    }

    @TestCase
    func get_n1_n2() {
        let hist = HashMap<Int64, Int64>()
        for (_ in 0..100) {
            let val = Random.get(-2, 2)
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.contains(-3), false)
        @Expect(hist.contains(-2), true)
        @Expect(hist.contains(2), true)
        @Expect(hist.contains(3), false)

        @Expect(hist[-2] > 2)
        @Expect(hist[-1] > 2)
        @Expect(hist[0] > 2)
        @Expect(hist[1] > 2)
        @Expect(hist[2] > 2)
    }

    @TestCase
    func getf32_0_1() {
        for (_ in 0..10) {
            let val = Random.getf32()
            @Expect(val >= 0.0)
            @Expect(val < 1.0)
        }
    }

    @TestCase
    func getf64_0_1() {
        for (_ in 0..10) {
            let val = Random.getf64()
            @Expect(val >= 0.0)
            @Expect(val < 1.0)
        }
    }

    @TestCase
    func getf_0_n() {
        for (_ in 0..10) {
            let val = Random.getf(4.0)
            @Expect(val >= 0.0)
            @Expect(val < 4.0)
        }
    }

    @TestCase
    func getf_n1_n2() {
        for (_ in 0..10) {
            let val = Random.getf(-2.0, 2.0)
            @Expect(val >= -2.0)
            @Expect(val < 2.0)
        }
    }

    @TestCase
    func getf_n1_n2_hist() {
        let hist = HashMap<Float64, Int64>()
        for (_ in 0..100) {
            let val = round(Random.getf(-2.0, 2.0))
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.contains(-3.0), false)
        @Expect(hist.contains(-2.0), true)
        @Expect(hist.contains(2.0), true)
        @Expect(hist.contains(3.0), false)

        @Expect(hist[-2.0] > 2)
        @Expect(hist[-1.0] > 2)
        @Expect(hist[0.0] > 2)
        @Expect(hist[1.0] > 2)
        @Expect(hist[2.0] > 2)
    }
}

@Test
class TestRandomNormal {
    @TestCase
    func get_mean_stdDev_1() {
        let hist = HashMap<Int64, Int64>()
        for (_ in 0..1000) {
            let val = Int64(round(RandomNormal.get(5.0)))
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.contains(-1), false)
        @Expect(hist.contains(2), true)
        @Expect(hist.contains(3), true)
        @Expect(hist.contains(4), true)
        @Expect(hist.contains(5), true)
        @Expect(hist.contains(6), true)
        @Expect(hist.contains(7), true)
        @Expect(hist.contains(8), true)
        @Expect(hist.contains(11), false)

        @Expect(hist[2] < hist[3])
        @Expect(hist[3] < hist[4])
        @Expect(hist[4] < hist[5])
        @Expect(hist[5] > hist[6])
        @Expect(hist[6] > hist[7])
        @Expect(hist[7] > hist[8])
    }

    @TestCase
    func get_mean_stdDev_n() {
        let hist = HashMap<Int64, Int64>()
        for (_ in 0..1000) {
            let val = Int64(round(RandomNormal.get(0.0, 2.0)))
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.contains(-3), true)
        @Expect(hist.contains(-2), true)
        @Expect(hist.contains(-1), true)
        @Expect(hist.contains(0), true)
        @Expect(hist.contains(1), true)
        @Expect(hist.contains(2), true)
        @Expect(hist.contains(3), true)

        @Expect(hist[-3] < hist[-2])
        @Expect(hist[-3] < hist[-1])
        @Expect(hist[-2] < hist[0])
        @Expect(hist[0] > hist[2])
        @Expect(hist[1] > hist[3])
        @Expect(hist[2] > hist[3])
    }

    @TestCase
    func get_min_mean_max() {
        let hist = HashMap<Int64, Int64>()
        for (_ in 0..1000) {
            let val = Int64(round(RandomNormal.get(-2.0, 0.0, 2.0)))
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.size, 5)

        @Expect(hist.contains(-3), false)
        @Expect(hist.contains(-2), true)
        @Expect(hist.contains(-1), true)
        @Expect(hist.contains(0), true)
        @Expect(hist.contains(1), true)
        @Expect(hist.contains(2), true)
        @Expect(hist.contains(3), false)

        @Expect(hist[-2] < hist[-1])
        @Expect(hist[-1] < hist[0])
        @Expect(hist[0] > hist[1])
        @Expect(hist[1] > hist[2])
    }

    @TestCase
    func get_min_mean_equals_max() {
        let hist = HashMap<Int64, Int64>()
        for (_ in 0..1000) {
            let val = Int64(round(RandomNormal.get(-2.0, 2.0, 2.0)))
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.size <= 5)

        @Expect(hist.contains(-3), false)
        @Expect(hist.contains(0), true)
        @Expect(hist.contains(1), true)
        @Expect(hist.contains(2), true)
        @Expect(hist.contains(3), false)

        @Expect(hist[0] < hist[1])
        @Expect(hist[1] < hist[2])
    }

    @TestCase
    func getRange_0_n() {
        let hist = HashMap<Int64, Int64>()
        for (_ in 0..1000) {
            let val = Int64(round(RandomNormal.getRange(4.0)))
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.size, 5)

        @Expect(hist.contains(-1), false)
        @Expect(hist.contains(0), true)
        @Expect(hist.contains(1), true)
        @Expect(hist.contains(2), true)
        @Expect(hist.contains(3), true)
        @Expect(hist.contains(4), true)
        @Expect(hist.contains(5), false)

        @Expect(hist[0] < hist[1])
        @Expect(hist[1] < hist[2])
        @Expect(hist[2] > hist[3])
        @Expect(hist[3] > hist[4])
    }
}
