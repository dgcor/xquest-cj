package dgengine

import std.math.{abs}
import std.random.Random as RandomImpl

private let RANDOM: RandomImpl = RandomImpl()

// uniform random number generator
public class Random {
    // Returns number between [0, max]
    public static func get(max: Int32): Int32 {
        RANDOM.nextInt32(max + 1)
    }

    // Returns number between [0, max]
    public static func get(max: Int64): Int64 {
        RANDOM.nextInt64(max + 1)
    }

    // Returns number between [0, max]
    public static func get(max: UInt32): UInt32 {
        RANDOM.nextUInt32(max + 1)
    }

    // Returns number between [0, max]
    public static func get(max: UInt64): UInt64 {
        RANDOM.nextUInt64(max + 1)
    }

    /**
     * Returns number between [min, max].
     *
     * @throws IllegalArgumentException when max < min
     */
    public static func get(min: Int64, max: Int64): Int64 {
        if (max < min) {
            throw IllegalArgumentException("max must be bigger than min")
        }
        let diff = UInt64(abs(max - min + 1))
        return min + Int64(RANDOM.nextUInt64(diff))
    }

    // Returns number between [0.0, 1.0)
    public static func getf32(): Float32 {
        RANDOM.nextFloat32()
    }

    // Returns number between [0.0, 1.0)
    public static func getf64(): Float64 {
        RANDOM.nextFloat64()
    }

    // Returns number between [0.0, max)
    public static func getf(max: Float32): Float32 {
        RANDOM.nextFloat32() * max
    }

    // Returns number between [0.0, max)
    public static func getf(max: Float64): Float64 {
        RANDOM.nextFloat64() * max
    }

    /**
     * Returns number between [min, max).
     *
     * @throws IllegalArgumentException when max < min
     */
    public static func getf(min: Float32, max: Float32): Float32 {
        if (max < min) {
            throw IllegalArgumentException("max must be bigger than min")
        }
        let diff = abs(max - min)
        return min + (RANDOM.nextFloat32() * diff)
    }

    /**
     * Returns number between [min, max).
     *
     * @throws IllegalArgumentException when max < min
     */
    public static func getf(min: Float64, max: Float64): Float64 {
        if (max < min) {
            throw IllegalArgumentException("max must be bigger than min")
        }
        let diff = abs(max - min)
        return min + (RANDOM.nextFloat64() * diff)
    }
}

// normal distribution random number generator
public class RandomNormal {
    // returns a normal distributed number with stdDev = 1
    public static func get(mean: Float32): Float32 {
        RANDOM.nextGaussianFloat32(mean: mean)
    }

    // returns a normal distributed number with stdDev = 1
    public static func get(mean: Float64): Float64 {
        RANDOM.nextGaussianFloat64(mean: mean)
    }

    // returns a normal distributed number
    public static func get(mean: Float32, stdDev: Float32): Float32 {
        RANDOM.nextGaussianFloat32(mean: mean, sigma: stdDev)
    }

    // returns a normal distributed number
    public static func get(mean: Float64, stdDev: Float64): Float64 {
        RANDOM.nextGaussianFloat64(mean: mean, sigma: stdDev)
    }

    // returns a normal distributed number between min and max tending towards the mean
    public static func get(min: Float64, mean: Float64, max: Float64): Float64 {
        let averageBoundWidth = ((mean - min) + (max - mean)) / 2.0
        let standardDeviation = averageBoundWidth / 3.0
        var value = mean
        do {
            value = RANDOM.nextGaussianFloat64(mean: mean, sigma: standardDeviation)
        } while (value < min || max < value)
        return value
    }

    // returns a normal distributed number between 0 and num
    // num must be > 0
    // example: 5000 x round(getRange(4.0))
    // 0 - 50
    // 1 - 1094
    // 2 - 2757
    // 3 - 1047
    // 4 - 52
    public static func getRange(num: Float64): Float64 {
        let mean = num * 0.5
        let standardDeviation = mean / 3.0
        var value = num
        do {
            value = RANDOM.nextGaussianFloat64(mean: mean, sigma: standardDeviation)
        } while (value < 0.0 || num < value)
        return value
    }
}
