package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import std.collection.*

extend Game <: ActionQueryable & Queryable {
    public func getAction(name: String): ?Action {
        match (name) {
            case "close" => m_closeAction
            case "focusGain" => m_focusGainAction
            case "focusLoss" => m_focusLossAction
            case "resize" => m_resizeAction
            case _ => None
        }
    }

    public func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "close" => m_closeAction = action
            case "focusGain" => m_focusGainAction = action
            case "focusLoss" => m_focusLossAction = action
            case "resize" => m_resizeAction = action
            case _ => return false
        }
        return true
    }

    public func getQueryAction(propName: String): ?Action {
        if (let Some(idx) <- propName.lastIndexOf('.')) {
            if (idx > 0) {
                let query = propName[0..idx]
                let actionName = propName[idx + 1..propName.size]
                if (let Some(obj) <- getQueryable(query)) {
                    if (let Some(uiObj) <- (obj.getQueryable() as ActionQueryable)) {
                        return uiObj.getAction(actionName)
                    }
                }
            }
        }
        return None
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 2) {
            return None
        }
        if (propName.startsWith('#')) {
            return m_variableManager.getVariableNoToken(propName[1..])
        }
        let props = splitStringIn2(propName, '.')
        return getProperty(props[0], props[1])
    }

    public func getProperty(prop1: String, prop2: String): ?Variable {
        match (prop1) {
            case "$" | "eval" => VaInteger(Int64(Formula.evalString(prop2, this)))
            case "evalMin" => VaInteger(Int64(Formula.evalMinString(prop2, this)))
            case "evalMax" => VaInteger(Int64(Formula.evalMaxString(prop2, this)))
            case "$f" | "evalf" => VaDouble(Formula.evalString(prop2, this))
            case "evalMinf" => VaDouble(Formula.evalMinString(prop2, this))
            case "evalMaxf" => VaDouble(Formula.evalMaxString(prop2, this))
            case "game" where prop2.size > 1 => getGameProperty(prop2)
            case "game" => None
            case "currentLevel" => m_resourceManager.getCurrentLevel()?.getProperty(prop2) ?? None
            case "focus" => m_resourceManager.getFocused()?.getProperty(prop2) ?? None
            case _ => m_resourceManager.getDrawable(prop1)?.getProperty(prop2) ?? None
        }
    }

    public func getGameProperty(propName: String): ?Variable {
        let props = splitStringIn2(propName, '.')
        return getGameProperty(props[0], props[1])
    }

    public func getGameProperty(prop1: String, prop2: String): ?Variable {
        match (prop1) {
            case "cursor" => Variable.getTuple2iProp(m_mousePositioni, prop2)
            case "frameRate" => VaInteger(Int64(m_frameRate))
            case "fullScreen" => VaBoolean(m_fullScreen)
            case "gamma" => VaInteger(Int64(m_gamma))
            case "hasAudio" => VaBoolean(m_resourceManager.hasAudioSource(prop2))
            case "hasDrawable" => VaBoolean(m_resourceManager.hasDrawable(prop2))
            case "hasEvent" => VaBoolean(m_eventManager.exists(prop2))
            case "hasFont" => VaBoolean(m_resourceManager.hasFont(prop2))
            case "hasGameShader" => VaBoolean(m_shaders.game.isSome())
            case "hasImageContainer" => VaBoolean(m_resourceManager.hasImageContainer(prop2))
            case "hasPalette" => VaBoolean(m_resourceManager.hasPalette(prop2))
            case "hasResource" => VaBoolean(m_resourceManager.resourceExists(prop2))
            case "hasShader" => VaBoolean(m_resourceManager.shaders.has(prop2))
            case "hasSong" => VaBoolean(m_resourceManager.hasSong(prop2))
            case "hasSpriteShader" => VaBoolean(m_shaders.sprite.isSome())
            case "hasTexture" => VaBoolean(m_resourceManager.hasTexture(prop2))
            case "hasTexturePack" => VaBoolean(m_resourceManager.hasTexturePack(prop2))
            case "keepAR" => VaBoolean(m_keepAR)
            case "maxHeight" => VaInteger(Int64(m_maxHeight))
            case "minSize" => Variable.getTuple2iProp(m_minSize, prop2)
            case "musicVolume" => VaInteger(Int64(m_musicVolume))
            case "openGL" => match ((prop2, m_window)) {
                case ("antialiasingLevel", Some(window)) => VaInteger(Int64(window.settings.antialiasing))
                case ("depthBits", Some(window)) => VaInteger(Int64(window.settings.depth))
                case ("hasGeometryShaders", _) => VaBoolean(Shader.isGeometryAvailable)
                case ("hasShaders", _) => VaBoolean(Shader.isAvailable)
                case ("majorVersion", Some(window)) => VaInteger(Int64(window.settings.major))
                case ("maxTextureSize", _) => VaInteger(Int64(Texture.maximumSize))
                case ("minorVersion", Some(window)) => VaInteger(Int64(window.settings.minor))
                case ("sRgbCapable", Some(window)) => VaBoolean(window.settings.sRgb)
                case ("stencilBits", Some(window)) => VaInteger(Int64(window.settings.stencil))
                case _ => None
            }
            case "path" => VaString(m_path)
            case "position" => Variable.getTuple2iProp(m_position ?? Vector2i(), prop2)
            case "refSize" => Variable.getTuple2iProp(m_refSize, prop2)
            case "saveDir" => VaString(FileUtils.saveDir)
            case "scancodeKey" => VaString(GameUtils.getScanCodeDescription(prop2))
            case "size" => Variable.getTuple2iProp(m_size, prop2)
            case "smoothScreen" => VaBoolean(m_smoothScreen)
            case "soundVolume" => VaInteger(Int64(m_soundVolume))
            case "stretchToFit" => VaBoolean(m_stretchToFit)
            case "title" => VaString(m_title)
            case "version" => VaString(m_version)
            case "windowedSize" => Variable.getTuple2iProp(m_windowedSize, prop2)
            case _ => None
        }
    }

    public func setGameProperty(propName: String, val: Variable): Unit {
        match ((propName, val)) {
            case ("frameRate", VaInteger(value)) => frameRate = UInt32(value)
            case ("fullScreen", VaBoolean(value)) => fullScreen = value
            case ("gamma", VaInteger(value)) => gamma = UInt32(value)
            case ("keepAR", VaBoolean(value)) => keepAR = value
            case ("maxHeight", VaInteger(value)) => maxHeight = UInt32(value)
            case ("minSize", VaTuple2i(value)) => minSize = Vector2u.create(value)
            case ("musicVolume", VaInteger(value)) => musicVolume = UInt32(value)
            case ("position", VaTuple2i(value)) => position = Vector2i.create(value)
            case ("refSize", VaTuple2i(value)) => refSize = Vector2u.create(value)
            case ("size", VaTuple2i(value)) => size = Vector2u.create(value)
            case ("smoothScreen", VaBoolean(value)) => smoothScreen = value
            case ("soundVolume", VaInteger(value)) => soundVolume = UInt32(value)
            case ("stretchToFit", VaBoolean(value)) => stretchToFit = value
            case ("title", VaString(value)) => title = value
            case ("version", VaString(value)) => version = value
            case _ => ()
        }
    }

    public func getQueryable(propName: String): ?QueryObject {
        if (propName.isEmpty()) {
            return ObjQueryable(this)
        }
        let props = splitStringIn2(propName, '.')
        return getQueryable(props[0], props[1])
    }

    public func getQueryable(prop1: String, prop2: String): ?QueryObject {
        match (prop1) {
            case "" | "game" => ObjQueryable(this)
            case _ =>
                let queryable: ?UIObject = match (prop1) {
                    case "currentLevel" => m_resourceManager.getCurrentLevel()
                    case "focus" => m_resourceManager.getFocused()
                    case _ => m_resourceManager.getDrawable(prop1)
                }
                if (let Some(queryable) <- queryable) {
                    if (prop2.isEmpty() == false) {
                        return queryable.getQueryable(prop2)
                    }
                    return ObjQueryable(queryable)
                }
                return None
        }
    }

    public func getQueryableList(propName: String): ArrayList<VarOrQueryObject> {
        let queryableList = ArrayList<VarOrQueryObject>()
        if (propName.isEmpty() == false) {
            let props = splitStringIn2(propName, '.')
            getQueryableList(props[0], props[1], queryableList)
        }
        return queryableList
    }

    public func getQueryableList(prop1: String, prop2: String, queryableList: ArrayList<VarOrQueryObject>): Bool {
        if (prop1 == "game") {
            let props = splitStringIn2(prop2, '.')
            match (props[0]) {
                case "saveDirs" =>
                    for (dir in FileUtils.getDirList(props[1], onlyWritableDirs: true)) {
                        queryableList.add(VarOrQueryVariable(VaString(dir)))
                    }
                    return true
                case "dirs" =>
                    for (dir in FileUtils.getDirList(props[1], onlyWritableDirs: false)) {
                        queryableList.add(VarOrQueryVariable(VaString(dir)))
                    }
                    return true
                case "files" =>
                    for (file in FileUtils.getFileList(props[1], "", getFullPath: false)) {
                        queryableList.add(VarOrQueryVariable(VaString(file)))
                    }
                    return true
                case _ => ()
            }
        }
        return false
    }
}
