package dgengine

import std.math.*

// https://easings.net/
// t is the current time.
// b is the beginning value of the property.
// c is the change between the beginning and destination value of the property.
// d is the final time.

public func easeLinear(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    return c * (t / d) + b
}

public func easeInQuad(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d
    return c * t2 * t2 + b
}

public func easeOutQuad(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d
    return -c * t2 * (t2 - 2.0) + b
}

public func easeInCubic(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d
    return c * t2 * t2 * t2 + b
}

public func easeOutCubic(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d - 1.0
    return c * (t2 * t2 * t2 + 1.0) + b
}

public func easeInQuart(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d
    return c * t2 * t2 * t2 * t2 + b
}

public func easeOutQuart(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d - 1.0
    return -c * (t2 * t2 * t2 * t2 - 1.0) + b
}

public func easeInQuint(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d
    return c * t2 * t2 * t2 * t2 * t2 + b
}

public func easeOutQuint(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d - 1.0
    return c * (t2 * t2 * t2 * t2 * t2 + 1.0) + b
}

public func easeInSine(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    return -c * cos(t / d * (Float64.getPI() / 2.0)) + c + b
}

public func easeOutSine(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    return c * sin(t / d * (Float64.getPI() / 2.0)) + b
}

public func easeInExpo(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    return match (t) {
        case 0.0 => b
        case _ => c * pow(2.0, 10.0 * (t / d - 1.0)) + b
    }
}

public func easeOutExpo(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    return match (t == d) {
        case true => b + c
        case false => c * (-pow(2.0, -10.0 * t / d) + 1.0) + b
    }
}

public func easeInCirc(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d
    return -c * (sqrt(1.0 - t2 * t2) - 1.0) + b
}

public func easeOutCirc(t: Float64, b: Float64, c: Float64, d: Float64): Float64 {
    let t2 = t / d - 1.0
    return c * sqrt(1.0 - t2 * t2) + b
}
