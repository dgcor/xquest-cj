package dgengine

import stdx.encoding.json.*
import stdx.encoding.json.stream.*
import std.collection.*
import std.io.*

extend JsonValue {
    func clone(): JsonValue {
        JsonValue.fromStr(toString())
    }

    func isUInt(): Bool {
        match (kind()) {
            case JsInt where asInt().getValue() >= 0 => true
            case _ => false
        }
    }

    func isNull(): Bool {
        match (kind()) {
            case JsNull => true
            case _ => false
        }
    }

    func isNumber(): Bool {
        match (kind()) {
            case JsInt | JsFloat => true
            case _ => false
        }
    }

    func isObject(): Bool {
        match (kind()) {
            case JsObject => true
            case _ => false
        }
    }
}

public class JsonUtils {
    // replaces string value occurrences of "%str%" with obj.getProperty("str")
    public static func replaceStringValueWithQueryable(elem: JsonValue, obj: Queryable, changeValueType!: Bool = false): JsonValue {
        let str = (elem as JsonString)?.getValue() ?? String.empty
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
            return JsonString(str2)
        }
        return elem
    }

    // replaces string value with variable
    public static func replaceStringValueWithVariable(elem: JsonValue, str: String, variable: Variable,
        changeValueType!: Bool = false): JsonValue {
        let str1 = (elem as JsonString)?.getValue() ?? String.empty
        if (str1.isEmpty()) {
            return elem
        }
        if (changeValueType == true && str1 == str) {
            return replaceValueWithVariable(variable)
        }
        let str2 = str1.replace(str, variable.toString())
        if (str1 != str2) {
            return JsonString(str2)
        }
        return elem
    }

    // replaces value with variable
    public static func replaceValueWithVariable(variable: Variable): JsonValue {
        match (variable) {
            case VaString(value) => JsonString(value)
            case VaInteger(value) => JsonInt(value)
            case VaDouble(value) => JsonFloat(value)
            case VaBoolean(value) => JsonBool(value)
            case VaTuple2i(value) => JsonArray([JsonInt(value[0]), JsonInt(value[1])])
            case VaTuple3i(value) => JsonArray([JsonInt(value[0]), JsonInt(value[1]), JsonInt(value[2])])
            case VaTuple4i(value) => JsonArray(
                [JsonInt(value[0]), JsonInt(value[1]), JsonInt(value[2]), JsonInt(value[3])])
            case VaTuple2f(value) => JsonArray([JsonFloat(value[0]), JsonFloat(value[1])])
            case VaTuple3f(value) => JsonArray([JsonFloat(value[0]), JsonFloat(value[1]), JsonFloat(value[2])])
            case VaTuple4f(value) => JsonArray(
                [JsonFloat(value[0]), JsonFloat(value[1]), JsonFloat(value[2]), JsonFloat(value[3])])
        }
    }

    // replaces all string values with function
    public static func replaceValuesWithFunction(elem: JsonValue, stringValueReplaceFunc: (JsonValue) -> JsonValue): JsonValue {
        match (elem.kind()) {
            case JsString => return stringValueReplaceFunc(elem)
            case JsObject =>
                let items = elem.asObject().getFields()
                for ((key, value) in items) {
                    let newValue = replaceValuesWithFunction(value, stringValueReplaceFunc)
                    items.add(key, newValue)
                }
                return elem
            case JsArray =>
                let items = elem.asArray().getItems()
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
                    let str1 = value.asString().getValue()
                    let str2 = str1.replace(oldStr, newStr)
                    if (str1 != str2) {
                        return JsonString(str2)
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
                    let str = value.asString().getValue()
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
                        return JsonString(str2)
                    }
                    return value
            }
        )
    }

    public static func toString(elem: JsonValue): String {
        match (elem.kind()) {
            case JsFloat => toString(elem.asFloat().getValue())
            case JsString => elem.asString().getValue()
            case _ => elem.toString()
        }
    }

    public static func jsonToString(elem: JsonValue): String {
        match (elem.kind()) {
            case JsFloat => toString(elem.asFloat().getValue())
            case _ => elem.toString()
        }
    }

    private static func writePrettyString(writer: JsonWriter, elem: JsonValue): Unit {
        match (elem.kind()) {
            case JsString => writer.writeValue(elem.asString().getValue())
            case JsInt => writer.writeValue(elem.asInt().getValue())
            case JsFloat => writer.writeValue(elem.asFloat().getValue())
            case JsBool => writer.writeValue(elem.asBool().getValue())
            case JsArray =>
                writer.writeConfig.newline = ""
                writer.startArray()
                for (elem in elem.asArray().getItems()) {
                    writePrettyString(writer, elem)
                }
                writer.endArray()
                writer.writeConfig.newline = "\n"
            case JsObject =>
                writer.startObject()
                for ((name, elem) in elem.asObject().getFields()) {
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
            logger.warn("loadJson error: ${ex}")
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
