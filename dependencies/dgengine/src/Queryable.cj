package dgengine

import std.math.*

public interface Queryable {
    func getNumber(propName: String): ?Number32 {
        if (let Some(value) <- getProperty(propName)) {
            return match (value) {
                case VaInteger(value) where value >= 0 && value <= Int64(Int32.Max) => NumberInt(Int32(value))
                case VaInteger(value) where value > 0 => NumberInt(Int32.Max)
                case VaInteger(value) where value < 0 && value >= Int64(Int32.Min) => NumberInt(Int32(value))
                case VaInteger(value) => NumberInt(Int32.Min)
                case VaDouble(value) => NumberFloat(Float32(value))
                case VaBoolean(true) => NumberInt(1)
                case VaBoolean(false) => NumberInt(0)
                case _ => None
            }
        }
        return None
    }

    func getProperty(propName: String): ?Variable

    // propName: String
    func getQueryable(_: String): ?QueryObject {
        None
    }
}
