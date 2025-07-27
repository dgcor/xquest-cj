package dgengine

import cjsfml.system.*
import ctemplate.*
import std.convert.*

public enum Variable <: Comparable<Variable> & Equatable<String> & Equatable<Int64> & Equatable<Float64> & Equatable<Bool>
    & Equatable<(Int64, Int64)> & Equatable<(Int64, Int64, Int64)> & Equatable<(Int64, Int64, Int64, Int64)> & Equatable<(Float64, 
        Float64)> & Equatable<(Float64, Float64, Float64)> & Equatable<(Float64, Float64, Float64, Float64)> & ToString {
    | VaString(String)
    | VaInteger(Int64)
    | VaDouble(Float64)
    | VaBoolean(Bool)
    | VaTuple2i((Int64, Int64))
    | VaTuple3i((Int64, Int64, Int64))
    | VaTuple4i((Int64, Int64, Int64, Int64))
    | VaTuple2f((Float64, Float64))
    | VaTuple3f((Float64, Float64, Float64))
    | VaTuple4f((Float64, Float64, Float64, Float64))

    public operator func <(right: Variable): Bool {
        match ((this, right)) {
            case (VaString(a), VaString(b)) => a < b
            case (VaInteger(a), VaInteger(b)) => a < b
            case (VaDouble(a), VaDouble(b)) => a < b
            case (VaBoolean(false), VaBoolean(true)) => true
            case (VaTuple2i(a), VaTuple2i(b)) => a[0] < b[0] && a[1] < b[1]
            case (VaTuple3i(a), VaTuple3i(b)) => a[0] < b[0] && a[1] < b[1] && a[2] < b[2]
            case (VaTuple4i(a), VaTuple4i(b)) => a[0] < b[0] && a[1] < b[1] && a[2] < b[2] && a[3] < b[3]
            case (VaTuple2f(a), VaTuple2f(b)) => a[0] < b[0] && a[1] < b[1]
            case (VaTuple3f(a), VaTuple3f(b)) => a[0] < b[0] && a[1] < b[1] && a[2] < b[2]
            case (VaTuple4f(a), VaTuple4f(b)) => a[0] < b[0] && a[1] < b[1] && a[2] < b[2] && a[3] < b[3]
            case (_, _) => false
        }
    }

    public operator func <=(right: Variable): Bool {
        match ((this, right)) {
            case (VaString(a), VaString(b)) => a <= b
            case (VaInteger(a), VaInteger(b)) => a <= b
            case (VaDouble(a), VaDouble(b)) => a <= b
            case (VaBoolean(false), VaBoolean(false)) => true
            case (VaBoolean(false), VaBoolean(true)) => true
            case (VaBoolean(true), VaBoolean(true)) => true
            case (VaTuple2i(a), VaTuple2i(b)) => a[0] <= b[0] && a[1] <= b[1]
            case (VaTuple3i(a), VaTuple3i(b)) => a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2]
            case (VaTuple4i(a), VaTuple4i(b)) => a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2] && a[3] <= b[3]
            case (VaTuple2f(a), VaTuple2f(b)) => a[0] <= b[0] && a[1] <= b[1]
            case (VaTuple3f(a), VaTuple3f(b)) => a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2]
            case (VaTuple4f(a), VaTuple4f(b)) => a[0] <= b[0] && a[1] <= b[1] && a[2] <= b[2] && a[3] <= b[3]
            case (_, _) => false
        }
    }

    public operator func >(right: Variable): Bool {
        match ((this, right)) {
            case (VaString(a), VaString(b)) => a > b
            case (VaInteger(a), VaInteger(b)) => a > b
            case (VaDouble(a), VaDouble(b)) => a > b
            case (VaBoolean(true), VaBoolean(false)) => true
            case (VaTuple2i(a), VaTuple2i(b)) => a[0] > b[0] && a[1] > b[1]
            case (VaTuple3i(a), VaTuple3i(b)) => a[0] > b[0] && a[1] > b[1] && a[2] > b[2]
            case (VaTuple4i(a), VaTuple4i(b)) => a[0] > b[0] && a[1] > b[1] && a[2] > b[2] && a[3] > b[3]
            case (VaTuple2f(a), VaTuple2f(b)) => a[0] > b[0] && a[1] > b[1]
            case (VaTuple3f(a), VaTuple3f(b)) => a[0] > b[0] && a[1] > b[1] && a[2] > b[2]
            case (VaTuple4f(a), VaTuple4f(b)) => a[0] > b[0] && a[1] > b[1] && a[2] > b[2] && a[3] > b[3]
            case (_, _) => false
        }
    }

    public operator func >=(right: Variable): Bool {
        match ((this, right)) {
            case (VaString(a), VaString(b)) => a >= b
            case (VaInteger(a), VaInteger(b)) => a >= b
            case (VaDouble(a), VaDouble(b)) => a >= b
            case (VaBoolean(false), VaBoolean(false)) => true
            case (VaBoolean(true), VaBoolean(false)) => true
            case (VaBoolean(true), VaBoolean(true)) => true
            case (VaTuple2i(a), VaTuple2i(b)) => a[0] >= b[0] && a[1] >= b[1]
            case (VaTuple3i(a), VaTuple3i(b)) => a[0] >= b[0] && a[1] >= b[1] && a[2] >= b[2]
            case (VaTuple4i(a), VaTuple4i(b)) => a[0] >= b[0] && a[1] >= b[1] && a[2] >= b[2] && a[3] >= b[3]
            case (VaTuple2f(a), VaTuple2f(b)) => a[0] >= b[0] && a[1] >= b[1]
            case (VaTuple3f(a), VaTuple3f(b)) => a[0] >= b[0] && a[1] >= b[1] && a[2] >= b[2]
            case (VaTuple4f(a), VaTuple4f(b)) => a[0] >= b[0] && a[1] >= b[1] && a[2] >= b[2] && a[3] >= b[3]
            case (_, _) => false
        }
    }

    public func compare(right: Variable): Ordering {
        if (this < right) {
            return LT
        } else if (this > right) {
            return GT
        }
        return EQ
    }

    public operator func ==(right: Variable): Bool {
        match ((this, right)) {
            case (VaString(value1), VaString(value2)) => value1 == value2
            case (VaInteger(value1), VaInteger(value2)) => value1 == value2
            case (VaDouble(value1), VaDouble(value2)) => value1 == value2
            case (VaBoolean(value1), VaBoolean(value2)) => value1 == value2
            case (VaTuple2i(value1), VaTuple2i(value2)) => value1 == value2
            case (VaTuple3i(value1), VaTuple3i(value2)) => value1 == value2
            case (VaTuple4i(value1), VaTuple4i(value2)) => value1 == value2
            case (VaTuple2f(value1), VaTuple2f(value2)) => value1 == value2
            case (VaTuple3f(value1), VaTuple3f(value2)) => value1 == value2
            case (VaTuple4f(value1), VaTuple4f(value2)) => value1 == value2
            case (_, _) => false
        }
    }

    public operator func !=(right: Variable): Bool {
        !(this == right)
    }

    public operator func ==(right: String): Bool {
        match (this) {
            case VaString(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: String): Bool {
        match (this) {
            case VaString(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: Int64): Bool {
        match (this) {
            case VaInteger(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: Int64): Bool {
        match (this) {
            case VaInteger(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: Float64): Bool {
        match (this) {
            case VaDouble(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: Float64): Bool {
        match (this) {
            case VaDouble(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: Bool): Bool {
        match (this) {
            case VaBoolean(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: Bool): Bool {
        match (this) {
            case VaBoolean(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: (Int64, Int64)): Bool {
        match (this) {
            case VaTuple2i(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: (Int64, Int64)): Bool {
        match (this) {
            case VaTuple2i(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: (Int64, Int64, Int64)): Bool {
        match (this) {
            case VaTuple3i(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: (Int64, Int64, Int64)): Bool {
        match (this) {
            case VaTuple3i(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: (Int64, Int64, Int64, Int64)): Bool {
        match (this) {
            case VaTuple4i(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: (Int64, Int64, Int64, Int64)): Bool {
        match (this) {
            case VaTuple4i(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: (Float64, Float64)): Bool {
        match (this) {
            case VaTuple2f(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: (Float64, Float64)): Bool {
        match (this) {
            case VaTuple2f(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: (Float64, Float64, Float64)): Bool {
        match (this) {
            case VaTuple3f(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: (Float64, Float64, Float64)): Bool {
        match (this) {
            case VaTuple3f(value1) => value1 != right
            case _ => false
        }
    }

    public operator func ==(right: (Float64, Float64, Float64, Float64)): Bool {
        match (this) {
            case VaTuple4f(value1) => value1 == right
            case _ => false
        }
    }

    public operator func !=(right: (Float64, Float64, Float64, Float64)): Bool {
        match (this) {
            case VaTuple4f(value1) => value1 != right
            case _ => false
        }
    }

    @Template[T: Vector2f, Vector2i](
    public static func getTuple2fProp(val: T, propName: String): Variable {
        match (propName) {
            case "" => VaTuple2f((Float64(val.x), Float64(val.y)))
            case "x" => VaDouble(Float64(val.x))
            case _ => VaDouble(Float64(val.y))
        }
    })

    @Template[T: Float32, Float64](
    public static func getTuple2fProp(val: (T, T), propName: String): Variable {
        match (propName) {
            case "" => VaTuple2f((Float64(val[0]), Float64(val[1])))
            case "x" => VaDouble(Float64(val[0]))
            case _ => VaDouble(Float64(val[1]))
        }
    })

    @Template[T: Vector2f, Vector2i, Vector2u](
    public static func getTuple2iProp(val: T, propName: String): Variable {
        match (propName) {
            case "" => VaTuple2i((Int64(val.x), Int64(val.y)))
            case "x" => VaInteger(Int64(val.x))
            case _ => VaInteger(Int64(val.y))
        }
    })

    @Template[T: Int32, Int64](
    public static func getTuple2iProp(val: (T, T), propName: String): Variable {
        match (propName) {
            case "" => VaTuple2i((Int64(val[0]), Int64(val[1])))
            case "x" => VaInteger(Int64(val[0]))
            case _ => VaInteger(Int64(val[1]))
        }
    })

    public func isBool(): Bool {
        match (this) {
            case VaBoolean(_) => true
            case _ => false
        }
    }

    public func isDouble(): Bool {
        match (this) {
            case VaDouble(_) => true
            case _ => false
        }
    }

    public func isInteger(): Bool {
        match (this) {
            case VaInteger(_) => true
            case _ => false
        }
    }

    public func isString(): Bool {
        match (this) {
            case VaString(_) => true
            case _ => false
        }
    }

    public func isTuple2i(): Bool {
        match (this) {
            case VaTuple2i(_) => true
            case _ => false
        }
    }

    public func isTuple3i(): Bool {
        match (this) {
            case VaTuple3i(_) => true
            case _ => false
        }
    }

    public func isTuple4i(): Bool {
        match (this) {
            case VaTuple4i(_) => true
            case _ => false
        }
    }

    public func isTuple2f(): Bool {
        match (this) {
            case VaTuple2f(_) => true
            case _ => false
        }
    }

    public func isTuple3f(): Bool {
        match (this) {
            case VaTuple3f(_) => true
            case _ => false
        }
    }

    public func isTuple4f(): Bool {
        match (this) {
            case VaTuple4f(_) => true
            case _ => false
        }
    }

    public func toBool(): Bool {
        match (this) {
            case VaBoolean(value) => value
            case VaInteger(value) => value != 0
            case VaDouble(value) => value != 0.0
            case VaString(value) => value.isEmpty() == false
            case _ => false
        }
    }

    public func toDouble(): Float64 {
        match (this) {
            case VaDouble(value) => value
            case VaInteger(value) => Float64(value)
            case VaBoolean(value) => match (value) {
                case true => 1.0
                case false => 0.0
            }
            case VaString(value) => Float64.tryParse(value) ?? 0.0
            case _ => 0.0
        }
    }

    public func toInt64(): Int64 {
        match (this) {
            case VaInteger(value) => value
            case VaDouble(value) => Int64(value)
            case VaBoolean(value) => match (value) {
                case true => 1
                case false => 0
            }
            case VaString(value) => Int64.tryParse(value) ?? 0
            case _ => 0
        }
    }

    public func toString(): String {
        match (this) {
            case VaString(value) => value
            case VaInteger(value) => value.toString()
            case VaDouble(value) => toString(value)
            case VaBoolean(value) => value.toString()
            case VaTuple2i(value) => "[${value[0].toString()}, ${value[1].toString()}]"
            case VaTuple3i(value) => "[${value[0].toString()}, ${value[1].toString()}, ${value[2].toString()}]"
            case VaTuple4i(value) => "[${value[0].toString()}, ${value[1].toString()}, ${value[2].toString()}, ${value[3].toString()}]"
            case VaTuple2f(value) => "[${toString(value[0])}, ${toString(value[1])}]"
            case VaTuple3f(value) => "[${toString(value[0])}, ${toString(value[1])}, ${toString(value[2])}]"
            case VaTuple4f(value) => "[${toString(value[0])}, ${toString(value[1])}, ${toString(value[2])}, ${toString(value[3])}]"
        }
    }
}
