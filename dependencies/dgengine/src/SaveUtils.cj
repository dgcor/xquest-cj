package dgengine

import cjsfml.system.*
import ctemplate.*
import stdx.encoding.json.*
import stdx.encoding.json.stream.*
import std.collection.*
import std.io.*

public class SaveUtils {
    public static func hasProperty(properties: Map<String, Variable>, key: String): Bool {
        properties.contains(key)
    }

    public static func getBoolProperty(properties: Map<String, Variable>, key: String): Bool {
        properties.get(key)?.toBool() ?? false
    }

    public static func getInt64Property(properties: Map<String, Variable>, key: String): Int64 {
        properties.get(key)?.toInt64() ?? 0
    }

    public static func getDoubleProperty(properties: Map<String, Variable>, key: String): Float64 {
        properties.get(key)?.toDouble() ?? 0.0
    }

    public static func getStringProperty(properties: Map<String, Variable>, key: String): String {
        properties.get(key)?.toString() ?? String.empty
    }

    private static func writeFloat64(writer: JsonWriter, value: Float64): Unit {
        match (modf(value)) {
            case (int, fract) where fract == 0.0 => writer.jsonValue(toString(int))
            case _ => writer.writeValue(value)
        }
    }

    public static func writeValue<T>(writer: JsonWriter, value: T): Unit where T <: JsonSerializable {
        match (value as Float64) {
            case Some(value) => writeFloat64(writer, value)
            case None => match (value as Float32) {
                case Some(value) => writeFloat64(writer, Float64(value))
                case None => writer.writeValue(value)
            }
        }
    }

    public static func writeValue<T>(writer: JsonWriter, key: String, value: T): Unit where T <: JsonSerializable {
        writer.writeName(key)
        writeValue(writer, value)
    }

    public static func writeValue(writer: JsonWriter, key: String, value: Number32): Unit {
        writer.writeName(key)
        match (value) {
            case NumberInt(value) => writer.writeValue(value)
            case NumberUInt(value) => writer.writeValue(value)
            case NumberFloat(value) => writeValue(writer, value)
        }
    }

    // same line formatted.
    @Template[T: Vector2f, Vector2i, Vector2u](
    public static func writeValue(writer: JsonWriter, value: T): Unit {
        let origCfg = writer.writeConfig
        var cfg = origCfg
        cfg.newline = ""
        writer.writeConfig = cfg

        writer.startArray()
        writeValue(writer, value.x)
        writeValue(writer, value.y)
        writer.endArray()

        writer.writeConfig = origCfg
    })

    // same line formatted.
    @Template[T: Vector2f, Vector2i, Vector2u](
    public static func writeValue(writer: JsonWriter, key: String, value: T): Unit {
        writer.writeName(key)
        writeValue(writer, value)
    })

    // same line formatted.
    public static func writeValue<T>(writer: JsonWriter, value: (T, T)): Unit where T <: JsonSerializable {
        let origCfg = writer.writeConfig
        var cfg = origCfg
        cfg.newline = ""
        writer.writeConfig = cfg

        writer.startArray()
        writeValue(writer, value[0])
        writeValue(writer, value[1])
        writer.endArray()

        writer.writeConfig = origCfg
    }

    // same line formatted.
    public static func writeValue<T>(writer: JsonWriter, key: String, value: (T, T)): Unit where T <: JsonSerializable {
        writer.writeName(key)
        writeValue(writer, value)
    }

    // same line formatted.
    public static func writeValue<T>(writer: JsonWriter, value: (T, T, T)): Unit where T <: JsonSerializable {
        let origCfg = writer.writeConfig
        var cfg = origCfg
        cfg.newline = ""
        writer.writeConfig = cfg

        writer.startArray()
        writeValue(writer, value[0])
        writeValue(writer, value[1])
        writeValue(writer, value[2])
        writer.endArray()

        writer.writeConfig = origCfg
    }

    // same line formatted.
    public static func writeValue<T>(writer: JsonWriter, key: String, value: (T, T, T)): Unit where T <: JsonSerializable {
        writer.writeName(key)
        writeValue(writer, value)
    }

    // same line formatted.
    public static func writeValue<T>(writer: JsonWriter, value: (T, T, T, T)): Unit where T <: JsonSerializable {
        let origCfg = writer.writeConfig
        var cfg = origCfg
        cfg.newline = ""
        writer.writeConfig = cfg

        writer.startArray()
        writeValue(writer, value[0])
        writeValue(writer, value[1])
        writeValue(writer, value[2])
        writeValue(writer, value[3])
        writer.endArray()

        writer.writeConfig = origCfg
    }

    // same line formatted.
    public static func writeValue<T>(writer: JsonWriter, key: String, value: (T, T, T, T)): Unit where T <: JsonSerializable {
        writer.writeName(key)
        writeValue(writer, value)
    }

    // writes floats. if the float has no decimal part, writes ints
    // same line formatted.
    public static func writeValuefi(writer: JsonWriter, value: Vector2f): Unit {
        let origCfg = writer.writeConfig
        var cfg = origCfg
        cfg.newline = ""
        writer.writeConfig = cfg

        writer.startArray()
        writer.writeValue(value.x)
        writer.writeValue(value.y)
        writer.endArray()

        writer.writeConfig = origCfg
    }

    // writes floats. if the float has no decimal part, writes ints
    // same line formatted.
    public static func writeValuefi(writer: JsonWriter, key: String, value: Vector2f): Unit {
        writer.writeName(key)
        writeValuefi(writer, value)
    }

    public static func writeValue(writer: JsonWriter, key: String, value: Variable): Unit {
        writer.writeName(key)
        writeValue(writer, value)
    }

    // write just the value (no key)
    public static func writeValue(writer: JsonWriter, value: Variable): Unit {
        match (value) {
            case VaString(value) => writer.writeValue(value)
            case VaInteger(value) => writer.writeValue(value)
            case VaDouble(value) => writeFloat64(writer, value)
            case VaBoolean(value) => writer.writeValue(value)
            case VaTuple2i(value) => writeValue(writer, value)
            case VaTuple3i(value) => writeValue(writer, value)
            case VaTuple4i(value) => writeValue(writer, value)
            case VaTuple2f(value) => writeValue(writer, value)
            case VaTuple3f(value) => writeValue(writer, value)
            case VaTuple4f(value) => writeValue(writer, value)
        }
    }
}
