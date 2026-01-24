package cjsfml.system

// cjlint-ignore -start !G.OPR.01 uncommon operator overloading

@C
public struct Time {
    public let microseconds: Int64

    public const init() {
        microseconds = 0
    }

    public init(seconds!: Float32) {
        microseconds = Int64(Float64(seconds) * 1000000.0)
    }

    public init(seconds!: Float64) {
        microseconds = Int64(seconds * 1000000.0)
    }

    public init(milliseconds!: Int32) {
        microseconds = Int64(milliseconds) * 1000
    }

    public const init(microseconds!: Int64) {
        this.microseconds = microseconds
    }

    public prop seconds: Float32 {
        get() {
            Float32(Float64(microseconds) / 1000000.0)
        }
    }

    public prop seconds64: Float64 {
        get() {
            Float64(microseconds) / 1000000.0
        }
    }

    public prop milliseconds: Int32 {
        get() {
            Int32(microseconds / 1000)
        }
    }

    public operator const func ==(right: Time): Bool {
        microseconds == right.microseconds
    }

    public operator const func !=(right: Time): Bool {
        microseconds != right.microseconds
    }

    public operator const func >(right: Time): Bool {
        microseconds > right.microseconds
    }

    public operator const func >=(right: Time): Bool {
        microseconds >= right.microseconds
    }

    public operator const func <(right: Time): Bool {
        microseconds < right.microseconds
    }

    public operator const func <=(right: Time): Bool {
        microseconds <= right.microseconds
    }

    public operator const func -(): Time {
        Time(microseconds: -microseconds)
    }

    public operator const func +(right: Time): Time {
        Time(microseconds: microseconds + right.microseconds)
    }

    public operator const func -(right: Time): Time {
        Time(microseconds: microseconds - right.microseconds)
    }

    public operator func *(right: Float64): Time {
        Time(seconds: (Float64(microseconds) / 1000000.0) * right)
    }

    public operator func *(right: Int64): Time {
        Time(microseconds: microseconds * right)
    }

    public operator func /(right: Float64): Time {
        Time(seconds: (Float64(microseconds) / 1000000.0) / right) // cjlint-ignore !G.EXP.05
    }

    public operator func /(right: Int64): Time {
        Time(microseconds: microseconds / right)
    }

    public operator func /(right: Time): Time {
        Time(seconds: (Float64(microseconds) / 1000000.0) / (Float64(right.microseconds) / 1000000.0)) // cjlint-ignore !G.EXP.05
    }

    public operator func %(right: Time): Time {
        Time(microseconds: microseconds % right.microseconds)
    }

    public static const ZERO: Time = Time()
}

// cjlint-ignore -end uncommon operator overloading
