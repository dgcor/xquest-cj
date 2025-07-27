package dgengine

public enum Number32 {
    | NumberInt(Int32)
    | NumberUInt(UInt32)
    | NumberFloat(Float32)

    public func getInt32(): Int32 {
        match (this) {
            case NumberInt(value) => value
            case NumberUInt(value) => Int32(value)
            case NumberFloat(value) => Int32(value)
        }
    }

    public func getUInt32(): UInt32 {
        match (this) {
            case NumberInt(value) => UInt32(value)
            case NumberUInt(value) => value
            case NumberFloat(value) => UInt32(value)
        }
    }

    public func getInt64(): Int64 {
        match (this) {
            case NumberInt(value) => Int64(value)
            case NumberUInt(value) => Int64(value)
            case NumberFloat(value) => Int64(value)
        }
    }

    public func getFloat(): Float32 {
        match (this) {
            case NumberInt(value) => Float32(value)
            case NumberUInt(value) => Float32(value)
            case NumberFloat(value) => value
        }
    }

    public func getDouble(): Float64 {
        match (this) {
            case NumberInt(value) => Float64(value)
            case NumberUInt(value) => Float64(value)
            case NumberFloat(value) => Float64(value)
        }
    }
}
