package dgengine

import std.collection.*
import std.io.*
import stdjson2.*

public class JsonUtils {
    // replaces string value occurrences of "%str%" with obj.getProperty("str")
    public static func replaceStringValueWithQueryable(elem: JsonValue, obj: Queryable, changeValueType!: Bool = false): JsonValue {
        let str = elem.getString() ?? String.empty
        if (str.size <= 2) {
            return elem
        }
        var str2 = String.empty
        var firstTokenStart = 0
        var hadMatch = false
        while (true) {
            match (str.indexOf('%', firstTokenStart)) {
                case Some(index) => firstTokenStart = index
                case None => break
            }
            let firstTokenStop = firstTokenStart + 1
            let secondTokenStart = match (str.indexOf('%', firstTokenStop)) {
                case Some(index) => index
                case None => break
            }
            let secondTokenStop = secondTokenStart + 1
            if (hadMatch == false) {
                hadMatch = true
                str2 = str
            }
            let strProp = str[firstTokenStart..secondTokenStop]
            if (let Some(value) <- obj.getProperty(strProp[1..strProp.size - 1])) {
                if (changeValueType == true && strProp == str2) {
                    return replaceValueWithVariable(value)
                }
                str2 = str2.replace(strProp, value.toString())
            }
            firstTokenStart = secondTokenStop
        }
        if (hadMatch == true && str != str2) {
            return JsString(str2)
        }
        return elem
    }

    // replaces string value with variable
    public static func replaceStringValueWithVariable(elem: JsonValue, str: String, variable: Variable,
        changeValueType!: Bool = false): JsonValue {
        let str1 = elem.getString() ?? String.empty
        if (str1.isEmpty()) {
            return elem
        }
        if (changeValueType == true && str1 == str) {
            return replaceValueWithVariable(variable)
        }
        let str2 = str1.replace(str, variable.toString())
        if (str1 != str2) {
            return JsString(str2)
        }
        return elem
    }

    // replaces value with variable
    public static func replaceValueWithVariable(variable: Variable): JsonValue {
        match (variable) {
            case VaString(value) => JsString(value)
            case VaInteger(value) => JsInt(value)
            case VaDouble(value) => JsDouble(value)
            case VaBoolean(value) => JsBool(value)
            case VaTuple2i(value) => JsArray(ArrayList([JsInt(value[0]), JsInt(value[1])]))
            case VaTuple3i(value) => JsArray(ArrayList([JsInt(value[0]), JsInt(value[1]), JsInt(value[2])]))
            case VaTuple4i(value) => JsArray(
                ArrayList([JsInt(value[0]), JsInt(value[1]), JsInt(value[2]), JsInt(value[3])]))
            case VaTuple2f(value) => JsArray(ArrayList([JsDouble(value[0]), JsDouble(value[1])]))
            case VaTuple3f(value) => JsArray(ArrayList([JsDouble(value[0]), JsDouble(value[1]), JsDouble(value[2])]))
            case VaTuple4f(value) => JsArray(
                ArrayList([JsDouble(value[0]), JsDouble(value[1]), JsDouble(value[2]), JsDouble(value[3])]))
        }
    }

    // replaces all string values with function
    public static func replaceValuesWithFunction(elem: JsonValue, stringValueReplaceFunc: (JsonValue) -> JsonValue): JsonValue {
        match (elem) {
            case JsString(_) => return stringValueReplaceFunc(elem)
            case JsObject(items) =>
                for ((key, value) in items) {
                    let newValue = replaceValuesWithFunction(value, stringValueReplaceFunc)
                    items.replace(key, newValue)
                }
                return elem
            case JsArray(items) =>
                for (index in 0..items.size) {
                    let newValue = replaceValuesWithFunction(items[index], stringValueReplaceFunc)
                    items[index] = newValue
                }
                return elem
            case _ => return elem
        }
    }

    // replaces all string values with string
    public static func replaceValuesWithString(elem: JsonValue, oldStr: String, newStr: String): JsonValue {
        replaceValuesWithFunction(
            elem,
            {
                value =>
                    let str1 = value.getString() ?? return value
                    let str2 = str1.replace(oldStr, newStr)
                    if (str1 != str2) {
                        return JsString(str2)
                    }
                    return value
            }
        )
    }

    // replaces all string value occurrences of "%str%" with game.getVarOrProp("str")
    public static func replaceValuesWithGameVar(elem: JsonValue, game: Game, changeValueType!: Bool,
        token!: String = '%'): JsonValue {
        replaceValuesWithFunction(
            elem,
            {
                value =>
                    let str = value.getString() ?? return value
                    if (str.size <= 2) {
                        return value
                    }
                    if (changeValueType == true && str.startsWith(token) && str.endsWith(token)) {
                        if (let Some(variable) <- game.getVarOrPropNoToken(str[1..str.size - 1])) {
                            return replaceValueWithVariable(variable)
                        }
                    }
                    var str2 = GameUtils.replaceStringWithVarOrProp(str, game, token: token)
                    if (str != str2) {
                        return JsString(str2)
                    }
                    return value
            }
        )
    }

    public static func toString(elem: JsonValue): String {
        match (elem) {
            case JsDouble(value) => toString(value)
            case JsString(str) => str
            case _ => elem.toString()
        }
    }

    public static func jsonToString(elem: JsonValue): String {
        match (elem) {
            case JsDouble(value) => toString(value)
            case _ => elem.toString()
        }
    }

    private static func writePrettyString(writer: JsonWriter, elem: JsonValue): Unit {
        match (elem) {
            case JsString(value) => writer.writeValue(value)
            case JsInt(value) => writer.writeValue(value)
            case JsDouble(value) => writer.writeValue(value)
            case JsBool(value) => writer.writeValue(value)
            case JsArray(items) =>
                writer.writeConfig.newline = ""
                writer.startArray()
                for (elem in items) {
                    writePrettyString(writer, elem)
                }
                writer.endArray()
                writer.writeConfig.newline = "\n"
            case JsObject(items) =>
                writer.startObject()
                for ((name, elem) in items) {
                    writer.writeName(name)
                    writePrettyString(writer, elem)
                }
                writer.endObject()
            case JsNull => writer.writeNullValue()
        }
    }

    public static func jsonToPrettyString(elem: JsonValue): String {
        let stream = ByteBuffer()
        let writer = JsonWriter(stream)
        writer.writeConfig = WriteConfig.pretty
        writer.writeConfig.indent = "  "
        writePrettyString(writer, elem)
        writer.flush()
        return String.fromUtf8(stream.bytes())
    }

    // loads json from a file
    public static func loadFile(file: String): ?JsonValue {
        if (file.isEmpty() == true) {
            return None
        }
        return loadJson(FileUtils.readText(file))
    }

    // loads json from a json string
    public static func loadJson(json: String): ?JsonValue {
        if (json.isEmpty() == true) {
            return None
        }
        try {
            return JsonValue.fromStr(json)
        } catch (ex: Exception) {
            LOGGER.warn("loadJson error: ${ex}")
        }
        return None
    }

    // loads json from a json string and replaces all string value occurrences of "%str%" with game.getVarOrProp("str")
    public static func loadJsonAndReplaceValues(json: String, obj: Game, changeValueType!: Bool, token!: String = '%'): ?JsonValue {
        if (let Some(doc) <- loadJson(json)) {
            return replaceValuesWithGameVar(doc, obj, changeValueType: changeValueType, token: token)
        }
        return None
    }

    public static func saveToFile(file: String, elem: JsonValue): Unit {
        FileUtils.saveText(file, elem.toString())
    }

    public static func saveToFile(file: String, key: String, it: Iterator<(String, Variable)>): Unit {
        let stream = ByteBuffer()
        let writer = JsonWriter(stream)
        writer.writeConfig = WriteConfig.pretty

        writer.startObject()
        writer.writeName(key)
        writer.startObject()
        for ((key, value) in it) {
            writer.writeName(key)
            SaveUtils.writeValue(writer, value)
        }
        writer.endObject()
        writer.endObject()
        writer.flush()

        FileUtils.saveBytes(file, stream.bytes())
    }
}
