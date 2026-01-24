package dgengine

import cjsfml.system.*
import cjsfml.window.*

extend Game {
    public prop hasFocus: Bool {
        get() {
            m_window?.hasFocus ?? false
        }
    }

    public mut prop position: Vector2i {
        get() {
            m_position ?? Vector2i()
        }
        set(value) {
            m_position = value
            if (m_fullScreen == false) {
                m_window?.position = value
            }
        }
    }

    public mut prop refSize: Vector2u {
        get() {
            m_refSize
        }
        set(value) {
            if (value.x >= RefSizeX && value.y >= RefSizeY) {
                m_refSize = value
            }
        }
    }

    public mut prop minSize: Vector2u {
        get() {
            m_minSize
        }
        set(value) {
            var needsUpdate = false
            if (value.x >= MinSizeX && value.y >= MinSizeY) {
                m_minSize = value
                if (m_window?.isOpen == true) {
                    needsUpdate = true
                }
            }
            if (m_size.x < m_minSize.x && m_size.y < m_minSize.y) {
                if (m_window?.isOpen == true) {
                    m_window?.size = m_minSize
                    return
                } else {
                    m_size = m_minSize
                    m_windowedSize = m_minSize
                }
            }
            if (needsUpdate == true) {
                updateWindowSize()
            }
        }
    }

    public mut prop size: Vector2u {
        get() {
            m_size
        }
        set(value) {
            var value2 = value
            value2.x = max(m_minSize.x, value.x)
            value2.y = max(m_minSize.y, value.y)
            if (m_window?.isOpen == true) {
                if (fullScreen == true) {
                    m_windowedSize = value2
                } else {
                    m_window?.size = value2
                }
            } else {
                m_size = value2
                m_windowedSize = value2
            }
        }
    }

    public prop windowedSize: Vector2u {
        get() {
            m_windowedSize
        }
    }

    public prop drawRegionSize: Vector2u {
        get() {
            m_drawRegionSize
        }
    }

    public prop drawRegionSizef: Vector2f {
        get() {
            Vector2f(Float32(m_drawRegionSize.x), Float32(m_drawRegionSize.y))
        }
    }

    public prop oldDrawRegionSize: Vector2u {
        get() {
            m_oldDrawRegionSize
        }
    }

    public mut prop maxHeight: UInt32 {
        get() {
            m_maxHeight
        }
        set(value) {
            if (m_maxHeight == value) {
                return
            }
            m_maxHeight = value
            if (m_window?.isOpen == true) {
                updateWindowSize()
                updateMousePosition()
            }
        }
    }

    public mut prop frameRate: UInt32 {
        get() {
            m_frameRate
        }
        set(value) {
            m_frameRate = match (value) {
                case 0 => 0
                case _ where value < 30 => 30
                case _ where value > 240 => 240
                case _ => value
            }
            if (m_window?.isOpen == true) {
                m_window?.setFramerateLimit(m_frameRate)
            }
        }
    }

    public mut prop fullScreen: Bool {
        get() {
            m_fullScreen
        }
        set(value) {
            if (m_fullScreen == value) {
                return
            }
            if (value == false) {
                size = windowedSize
            }
            m_fullScreen = value

            if (m_window?.isOpen == true) {
                recreateWindow()
                updateWindowSize()
            }
        }
    }

    public mut prop smoothScreen: Bool {
        get() {
            m_smoothScreen
        }
        set(value) {
            m_smoothScreen = value
            m_gameTexture?.smooth = value
        }
    }

    public mut prop stretchToFit: Bool {
        get() {
            m_stretchToFit
        }
        set(value) {
            if (m_stretchToFit == value) {
                return
            }
            m_stretchToFit = value
            if (m_window?.isOpen == true) {
                updateWindowSize()
                updateMousePosition()
            }
        }
    }

    public mut prop keepAR: Bool {
        get() {
            m_keepAR
        }
        set(value) {
            if (m_keepAR == value) {
                return
            }
            m_keepAR = value
            if (m_window?.isOpen == false || m_stretchToFit == false) {
                return
            }
            updateWindowSize()
            updateMousePosition()
        }
    }

    public mut prop enableInput: Bool {
        get() {
            m_enableInput
        }
        set(value) {
            m_enableInput = value
        }
    }

    public mut prop paused: Bool {
        get() {
            m_paused
        }
        set(value) {
            m_paused = value
        }
    }

    public mut prop mouseCursorVisible: Bool {
        get() {
            m_mouseCursorVisible
        }
        set(value) {
            m_mouseCursorVisible = value
            m_window?.setMouseCursorVisible(value)
        }
    }

    public prop mousePositioni: Vector2i {
        get() {
            m_mousePositioni
        }
    }

    public prop mousePositionf: Vector2f {
        get() {
            m_mousePositionf
        }
    }

    public func setMousePosition(mousePos: Vector2i): Unit {
        if (let Some(window) <- m_window) {
            let mousePos2 = window.mapCoordsToPixel(Vector2f(Float32(mousePos.x), Float32(mousePos.y)))
            Mouse.setPosition(mousePos2, window)
            updateMousePosition()
        }
    }

    public mut prop mousePress: ?MouseButtonEvent {
        get() {
            return m_mousePressEvt
        }
        set(value) {
            m_mousePressEvt = value
        }
    }

    public mut prop mouseRelease: ?MouseButtonEvent {
        get() {
            return m_mouseReleaseEvt
        }
        set(value) {
            m_mouseReleaseEvt = value
        }
    }

    public mut prop mouseMove: ?MouseMoveEvent {
        get() {
            return m_mouseMoveEvt
        }
        set(value) {
            m_mouseMoveEvt = value
        }
    }

    public mut prop mouseScroll: ?MouseWheelScrollEvent {
        get() {
            return m_mouseScrollEvt
        }
        set(value) {
            m_mouseScrollEvt = value
        }
    }

    public mut prop keyPress: ?KeyEvent {
        get() {
            return m_keyPressEvt
        }
        set(value) {
            m_keyPressEvt = value
        }
    }

    public mut prop textEntered: ?TextEvent {
        get() {
            return m_textEnteredEvt
        }
        set(value) {
            m_textEnteredEvt = value
        }
    }

    public mut prop touchBegan: ?TouchEvent {
        get() {
            return m_touchBeganEvt
        }
        set(value) {
            m_touchBeganEvt = value
        }
    }

    public mut prop touchMoved: ?TouchEvent {
        get() {
            return m_touchMovedEvt
        }
        set(value) {
            m_touchMovedEvt = value
        }
    }

    public mut prop touchEnded: ?TouchEvent {
        get() {
            return m_touchEndedEvt
        }
        set(value) {
            m_touchEndedEvt = value
        }
    }

    public mut prop musicVolume: UInt32 {
        get() {
            m_musicVolume
        }
        set(value) {
            m_musicVolume = match (value) {
                case _ where value <= 100 => value
                case _ => 100
            }
        }
    }

    public mut prop soundVolume: UInt32 {
        get() {
            m_soundVolume
        }
        set(value) {
            m_soundVolume = match (value) {
                case _ where value <= 100 => value
                case _ => 100
            }
        }
    }

    public mut prop gamma: UInt32 {
        get() {
            m_gamma
        }
        set(value) {
            m_gamma = match (value) {
                case _ where value <= 100 => value
                case _ => 100
            }
        }
    }

    public prop elapsedTime: Time {
        get() {
            m_elapsedTime
        }
    }

    public prop totalElapsedTime: Time {
        get() {
            m_totalElapsedTime
        }
    }

    public mut prop path: String {
        get() {
            m_path
        }
        set(value) {
            m_path = value
        }
    }

    public mut prop title: String {
        get() {
            m_title
        }
        set(value) {
            m_title = value
            if (m_window?.isOpen == true) {
                m_window?.setTitle(title)
            }
        }
    }

    public mut prop version: String {
        get() {
            m_version
        }
        set(value) {
            m_version = value
        }
    }

    public prop resources: ResourceManager {
        get() {
            m_resourceManager
        }
    }

    public prop events: EventManager {
        get() {
            m_eventManager
        }
    }

    public prop variables: VariableManager {
        get() {
            m_variableManager
        }
    }

    public prop gameInputEvents: GameInputEventManager {
        get() {
            m_gameInputEventManager
        }
    }

    public mut prop loadingScreen: ?LoadingScreen {
        get() {
            m_loadingScreen
        }
        set(value) {
            if (let Some(loadingScreen) <- m_loadingScreen) {
                loadingScreen.close()
            }
            m_loadingScreen = value
        }
    }

    public prop fadeObj: FadeInOut {
        get() {
            m_fadeObj
        }
    }

    public prop shaders: GameShaders {
        get() {
            m_shaders
        }
    }

    public func setIcon(size: Vector2u, pixels: Array<UInt8>): Unit {
        m_window?.setIcon(size, pixels)
    }

    public func setIcon(size: Vector2u, pixels: CPointer<UInt8>): Unit {
        m_window?.setIcon(size, pixels)
    }

    public func getVarOrPropNoToken(key: String): ?Variable {
        m_variableManager.getVarOrPropNoToken(this, key)
    }

    public func getVarOrProp(value: Variable, default!: Int64): Int64 {
        m_variableManager.getVarOrProp(this, value, default: default)
    }

    public func getVarOrProp(value: Variable, default!: Float64): Float64 {
        m_variableManager.getVarOrProp(this, value, default: default)
    }

    public func getVarOrProp(value: ?Variable, default!: Int64): Int64 {
        match (value) {
            case Some(value) => m_variableManager.getVarOrProp(this, value, default: default)
            case None => default
        }
    }

    public func getVarOrProp(value: ?Variable, default!: Float64): Float64 {
        match (value) {
            case Some(value) => m_variableManager.getVarOrProp(this, value, default: default)
            case None => default
        }
    }

    public func getVarOrProp(key: String): ?Variable {
        m_variableManager.getVarOrProp(this, key)
    }

    public func getVarOrProp(value: Variable): Variable {
        m_variableManager.getVarOrProp(this, value)
    }

    public func getVarOrPropBoolS(key: String): Bool {
        m_variableManager.getVarOrPropBoolS(this, key)
    }

    public func getVarOrPropBoolV(value: Variable): Bool {
        m_variableManager.getVarOrPropBoolV(this, value)
    }

    public func getVarOrPropDoubleS(key: String): Float64 {
        m_variableManager.getVarOrPropDoubleS(this, key)
    }

    public func getVarOrPropDoubleV(value: Variable): Float64 {
        m_variableManager.getVarOrPropDoubleV(this, value)
    }

    public func getVarOrPropInt64S(key: String): Int64 {
        m_variableManager.getVarOrPropInt64S(this, key)
    }

    public func getVarOrPropInt64V(value: Variable): Int64 {
        m_variableManager.getVarOrPropInt64V(this, value)
    }

    public func getVarOrPropStringS(key: String, outStr: Box<String>): Bool {
        m_variableManager.getVarOrPropStringS(this, key, outStr)
    }

    public func getVarOrPropStringS(key: String): String {
        m_variableManager.getVarOrPropStringS(this, key)
    }

    public func getVarOrPropStringV(value: Variable): String {
        m_variableManager.getVarOrPropStringV(this, value)
    }
}
