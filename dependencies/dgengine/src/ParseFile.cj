package dgengine

import stdx.encoding.json.*
import std.collection.*

public type parseDocumentElemFunc = (game: Game, elem: JsonValue) -> Unit

public func parseFile(game: Game, fileName: String): Unit {
    let fileName2 = GameUtils.replaceStringWithVarOrProp(fileName, game)
    if (fileName2 == "null") {
        logger.warn("parseFile name null")
        return
    }

    if (parseJson(game, FileUtils.readText(fileName2)) == true) {
        logger.info("parseFile: ${fileName2}")
    } else {
        logger.warn("parseFile failed: ${fileName2}")
    }
}

public func parseFile(game: Game, params: Array<String>): Unit {
    if (params.isEmpty() == true) {
        logger.warn("parseFile invalid params")
        return
    }

    let fileName = GameUtils.replaceStringWithVarOrProp(params[0], game)
    if (fileName == "null") {
        logger.warn("parseFile name null")
        return
    }

    var json = FileUtils.readText(fileName)
    for ((index, param) in params |> enumerate |> skip(1)) {
        let param2 = GameUtils.replaceStringWithVarOrProp(param, game)
        json = json.replace("{${index}}", param2)
    }
    if (parseJson(game, json) == true) {
        logger.info("parseFile: ${fileName}")
    } else {
        logger.warn("parseFile failed: ${fileName}")
    }
}

public func parseFile(game: Game, params: JsonValue): Unit {
    if (isValidArray(params) == false) {
        logger.warn("parseFile invalid params")
        return
    }
    let paramsArr = params.asArray()

    let fileName = GameUtils.replaceStringWithVarOrProp(getStringVal(paramsArr[0]), game)
    if (fileName == "null") {
        logger.warn("parseFile name null")
        return
    }

    var json = FileUtils.readText(fileName)
    for ((index, param) in paramsArr.getItems() |> enumerate |> skip(1)) {
        let param2 = GameUtils.replaceStringWithVarOrProp(getStringVal(param), game)
        json = json.replace("{${index}}", param2)
    }
    if (parseJson(game, json) == true) {
        logger.info("parseFile: ${fileName}")
    } else {
        logger.warn("parseFile failed: ${fileName}")
    }
}

public func parseJson(game: Game, json: String, params: Array<String>): Bool {
    var json2 = json
    for ((index, param) in params |> enumerate) {
        let param2 = GameUtils.replaceStringWithVarOrProp(param, game)
        json2 = json2.replace("{${index + 1}}", param2)
    }
    return parseJson(game, json2)
}

public func parseJson(game: Game, json: String): Bool {
    if (json.isEmpty() == true) {
        return false
    }
    try {
        let doc = JsonValue.fromStr(json)
        parseDocument(game, doc)
        return true
    } catch (ex: Exception) {
        logger.warn("parseJson failed: ${ex}")
        return false
    }
}

public func parseDocument(game: Game, doc: JsonValue, replaceVars!: ReplaceVars = ReplaceNone): Unit {
    match (doc.kind()) {
        case JsObject => ()
        case _ => return
    }
    let replaceVarsBox = Box(replaceVars)
    for ((name, elem) in doc.asObject().getFields()) {
        let (name2, _) = splitStringIn2(name, ".")
        parseDocumentElemHelper(game, name2, elem, replaceVarsBox)
    }
}

public func parseLoad(game: Game, elem: JsonValue): Unit {
    if (let Some(str) <- getValidString(elem)) {
        parseFile(game, str)
    } else {
        parseFile(game, elem)
    }
}

public func parseDocumentElemHelper(game: Game, name: String, elem: JsonValue, replaceVars: Box<ReplaceVars>): Unit {
    var replaceVarsInElem = replaceVars.value
    var changeValueType = replaceVars.value == ReplaceValue
    match (elem.kind()) {
        case JsObject =>
            replaceVarsInElem = getReplaceVarsKey(elem, "replaceVars", default: replaceVarsInElem)
            changeValueType = replaceVarsInElem == ReplaceValue
        case _ => ()
    }
    if (replaceVarsInElem != ReplaceNone) {
        // if replaceVars is enabled, replace strings between | instead of %
        let elem = JsonUtils.replaceValuesWithGameVar(elem, game, changeValueType: changeValueType, token: '|')
        parseDocumentElem(game, name, elem, replaceVars)
    } else {
        parseDocumentElem(game, name, elem, replaceVars)
    }
}

public func parseDocumentElemArray(parseFunc: parseDocumentElemFunc, game: Game, name: String, elem: JsonValue,
    replaceVars: Box<ReplaceVars>): Unit {
    match (elem.kind()) {
        case JsArray => for (val in elem.asArray().getItems()) {
            parseDocumentElemHelper(game, name, val, replaceVars)
        }
        case _ => parseFunc(game, elem)
    }
}

private func parseDocumentElem(game: Game, name: String, elem: JsonValue, replaceVars: Box<ReplaceVars>): Unit {
    if (let Some(parseDoc) <- Hooks.parseDocumentElem) {
        if (parseDoc(game, name, elem, replaceVars) == true) {
            return
        }
    }
    match (name) {
        case "action" => parseDocumentElemArray(parseActionAndExecute, game, name, elem, replaceVars)
        case "animation" => parseDocumentElemArray(parseAnimation, game, name, elem, replaceVars)
        case "audio" => parseDocumentElemArray(parseAudio, game, name, elem, replaceVars)
        case "button" => parseDocumentElemArray(parseButton, game, name, elem, replaceVars)
        case "circle" => parseDocumentElemArray(parseCircle, game, name, elem, replaceVars)
        case "cursor" => parseDocumentElemArray(parseCursor, game, name, elem, replaceVars)
        case "event" => parseDocumentElemArray(parseEvent, game, name, elem, replaceVars)
        case "file" => parseDocumentElemArray(parseFileBytes, game, name, elem, replaceVars)
        case "font" => parseDocumentElemArray(parseFont, game, name, elem, replaceVars)
        case "game" => parseGame(game, elem)
        case "gameInputEvent" => parseDocumentElemArray(parseGameInputEvent, game, name, elem, replaceVars)
        case "image" => parseDocumentElemArray(parseImage, game, name, elem, replaceVars)
        case "imageContainer" => parseDocumentElemArray(parseImageContainer, game, name, elem, replaceVars)
        case "inputEvent" => parseDocumentElemArray(parseInputEvent, game, name, elem, replaceVars)
        case "inputText" => parseDocumentElemArray(parseInputText, game, name, elem, replaceVars)
        case "load" => parseLoad(game, elem)
        case "loadingScreen" => parseLoadingScreen(game, elem)
        case "menu" => parseDocumentElemArray(parseMenu, game, name, elem, replaceVars)
        case "mountFile" => parseDocumentElemArray(parseMountFile, game, name, elem, replaceVars)
        case "movie" => parseDocumentElemArray(parseMovie, game, name, elem, replaceVars)
        case "palette" => parseDocumentElemArray(parsePalette, game, name, elem, replaceVars)
        case "panel" => parseDocumentElemArray(parsePanel, game, name, elem, replaceVars)
        case "rectangle" => parseDocumentElemArray(parseRectangle, game, name, elem, replaceVars)
        case "replaceVars" => replaceVars.value = getReplaceVarsVal(elem)
        case "scrollable" => parseDocumentElemArray(parseScrollable, game, name, elem, replaceVars)
        case "shader" => parseDocumentElemArray(parseShader, game, name, elem, replaceVars)
        case "shape" => parseDocumentElemArray(parseShape, game, name, elem, replaceVars)
        case "sound" => parseDocumentElemArray(parseSound, game, name, elem, replaceVars)
        case "text" => parseDocumentElemArray(parseText, game, name, elem, replaceVars)
        case "texture" => parseDocumentElemArray(parseTexture, game, name, elem, replaceVars)
        case "texturePack" => parseDocumentElemArray(parseTexturePack, game, name, elem, replaceVars)
        case "variable" => parseDocumentElemArray(parseVariable, game, name, elem, replaceVars)
        case _ => logger.warn("Unknown Json element: ${name}")
    }
}
