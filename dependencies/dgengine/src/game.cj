package dgengine

import cjsfml.audio.*
import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import cjsfml.window.Event as SFMLEvent
import customiterators.*
import std.math.*
import std.runtime.*

public class Game <: Resource {
    public static var DefaultSizeX: UInt32 = 640
    public static var DefaultSizeY: UInt32 = 480

    public static var MinSizeX: UInt32 = 640
    public static var MinSizeY: UInt32 = 480

    public static var RefSizeX: UInt32 = 640
    public static var RefSizeY: UInt32 = 480

    protected var m_window: ?RenderWindow = None
    protected var m_gameTexture: ?RenderTexture = None
    protected var m_gameSprite: ?Sprite = None

    // window position when not in fullscreen
    protected var m_position: ?Vector2i = None

    // reference size
    // used to position drawables in bigger draw regions
    protected var m_refSize: Vector2u = Vector2u()

    // minimum window size
    // all other sizes are equal or bigger
    protected var m_minSize: Vector2u = Vector2u()

    // actual size of the window the player sees
    protected var m_size: Vector2u = Vector2u()

    // size of the window when not in fullscreen
    // if not in fullscreen, this will be equal to size
    protected var m_windowedSize: Vector2u = Vector2u()

    // draw region size
    // if stretched, this will be equal to minSize
    // otherwise, this will be equal to size
    protected var m_drawRegionSize: Vector2u = Vector2u()

    // previous draw region size
    protected var m_oldDrawRegionSize: Vector2u = Vector2u()

    protected var m_maxHeight: UInt32 = 0

    protected var m_frameRate: UInt32 = 0
    protected var m_fullScreen: Bool = false
    protected var m_smoothScreen: Bool = false
    protected var m_stretchToFit: Bool = false
    protected var m_keepAR: Bool = false
    protected var m_enableInput: Bool = false
    protected var m_paused: Bool = false
    protected var m_mouseCursorVisible: Bool = false

    protected var m_mousePositioni: Vector2i = Vector2i()
    protected var m_mousePositionf: Vector2f = Vector2f()

    protected var m_mousePressEvt: ?MouseButtonEvent = None
    protected var m_mouseReleaseEvt: ?MouseButtonEvent = None
    protected var m_mouseMoveEvt: ?MouseMoveEvent = None
    protected var m_mouseScrollEvt: ?MouseWheelScrollEvent = None
    protected var m_keyPressEvt: ?KeyEvent = None
    protected var m_textEnteredEvt: ?TextEvent = None
    protected var m_touchBeganEvt: ?TouchEvent = None
    protected var m_touchMovedEvt: ?TouchEvent = None
    protected var m_touchEndedEvt: ?TouchEvent = None

    protected var m_musicVolume: UInt32 = 0
    protected var m_soundVolume: UInt32 = 0
    protected var m_gamma: UInt32 = 0

    protected var m_elapsedTime: Time = Time()
    protected var m_totalElapsedTime: Time = Time()

    protected var m_path: String = String.empty
    protected var m_title: String = String.empty
    protected var m_version: String = String.empty

    protected var m_resourceManager: ResourceManager = ResourceManager()
    protected var m_eventManager: EventManager = EventManager()
    protected var m_variableManager: VariableManager = VariableManager()
    protected var m_gameInputEventManager: GameInputEventManager = GameInputEventManager()

    protected var m_loadingScreen: ?LoadingScreen = None
    protected var m_fadeObj: FadeInOut = FadeInOut()

    protected var m_shaders: GameShaders = GameShaders()

    protected var m_closeAction: ?Action = None
    protected var m_resizeAction: ?Action = None
    protected var m_focusLossAction: ?Action = None
    protected var m_focusGainAction: ?Action = None

    public init(reset!: Bool = false) {
        if (reset == true) {
            m_refSize = Vector2u(RefSizeX, RefSizeY)
            m_minSize = Vector2u(MinSizeX, MinSizeY)
            m_size = Vector2u(DefaultSizeX, DefaultSizeY)
            m_windowedSize = m_size
            m_drawRegionSize = m_size
            m_frameRate = 60
            m_keepAR = true
            m_enableInput = true
            m_mouseCursorVisible = true

            m_musicVolume = 100
            m_soundVolume = 100
        }
    }

    public func isClosed(): Bool {
        m_window?.isClosed() ?? true
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        m_window?.closeWindow()
        m_gameSprite?.close()
        m_gameSprite = None
        m_gameTexture?.close()
        m_gameTexture = None
        m_window?.close()
        m_window = None
        m_loadingScreen?.close()
        m_loadingScreen = None
        m_shaders.close()
        m_resourceManager.close()
    }

    protected func reset(): Unit {
        m_gameSprite?.close()
        m_gameSprite = None

        m_position = None
        m_refSize = Vector2u(RefSizeX, RefSizeY)
        m_minSize = Vector2u(MinSizeX, MinSizeY)
        m_size = Vector2u(DefaultSizeX, DefaultSizeY)
        m_windowedSize = m_size
        m_drawRegionSize = m_size
        m_oldDrawRegionSize = Vector2u()
        m_maxHeight = 0
        m_frameRate = 60
        m_fullScreen = false
        m_smoothScreen = false
        m_stretchToFit = false
        m_keepAR = true
        m_enableInput = true
        m_paused = false
        m_mouseCursorVisible = true

        m_mousePositioni = Vector2i()
        m_mousePositionf = Vector2f()

        m_mousePressEvt = None
        m_mouseReleaseEvt = None
        m_mouseMoveEvt = None
        m_mouseScrollEvt = None
        m_keyPressEvt = None
        m_textEnteredEvt = None
        m_touchBeganEvt = None
        m_touchMovedEvt = None
        m_touchEndedEvt = None

        m_musicVolume = 100
        m_soundVolume = 100
        m_gamma = 0

        m_elapsedTime = Time()
        m_totalElapsedTime = Time()

        m_path = String.empty
        m_title = String.empty
        m_version = String.empty

        m_resourceManager.close()
        m_resourceManager = ResourceManager()
        if (let Some(initializeShaderManager) <- Hooks.initializeShaderManager) {
            initializeShaderManager(m_resourceManager.shaders)
        } else {
            ShaderManager.initShaderManager(m_resourceManager.shaders)
        }
        m_shaders.close()
        m_shaders = GameShaders()
        m_resourceManager.shaders.initGameShaders(m_shaders)

        m_variableManager = VariableManager()
        m_gameInputEventManager = GameInputEventManager()

        m_loadingScreen?.close()
        m_loadingScreen = None
        m_fadeObj = FadeInOut()

        m_closeAction = None
        m_resizeAction = None
        m_focusLossAction = None
        m_focusGainAction = None

        gc()
    }

    public func load(gamefilePath: String, mainFile: String): Unit {
        if (m_window?.isOpen == true) {
            m_window?.closeWindow()
        }
        reset()
        FileUtils.unmountAll()
        parseGame(this, gamefilePath, mainFile)
    }

    public func initialize(): Unit {
        if (m_window?.isOpen ?? false == true) {
            return
        }

        recreateWindow()

        // forces update of drawing window
        updateWindowSize()

        if (m_gameSprite.isNone()) {
            recreateGameTexture()
            m_gameSprite = Sprite((m_gameTexture?.texture).getOrThrow())
        }
    }

    public func closeGame(): Unit {
        m_window?.closeWindow()
    }

    public func play(): Unit {
        updateMousePosition()
        var frameClock = Clock()
        while (let Some(window) <- m_window) {
            if (window.isOpen == true) {
                if (m_fullScreen == false) {
                    m_position = window.position
                }

                processEvents()

                m_elapsedTime = frameClock.restart()
                m_totalElapsedTime += m_elapsedTime

                updateEvents()

                m_resourceManager.clearFinishedSounds()

                if (drawLoadingScreen() == false) {
                    update()
                    draw()
                }
            } else {
                break
            }
        }
    }

    protected func processEvents(): Unit {
        m_mousePressEvt = None
        m_mouseReleaseEvt = None
        m_mouseMoveEvt = None
        m_mouseScrollEvt = None
        m_keyPressEvt = None
        m_textEnteredEvt = None

        if (let Some(window) <- m_window) {
            while (let Some(event) <- window.pollEvent()) {
                match (event) {
                    case EvtClosed => onClosed()
                    case EvtResized(evt) => onResized(evt)
                    case EvtFocusLost => onFocusLost()
                    case EvtFocusGained => onFocusGained()
                    case EvtTextEntered(evt) => onTextEntered(evt)
                    case EvtKeyPressed(evt) => onKeyPressed(event, evt)
                    case EvtKeyReleased(evt) => onKeyReleased(event, evt)
                    case EvtMouseWheelScrolled(evt) => onMouseWheelScrolled(evt)
                    case EvtMouseButtonPressed(evt) => onMouseButtonPressed(evt)
                    case EvtMouseButtonReleased(evt) => onMouseButtonReleased(evt)
                    case EvtMouseMoved(evt) => onMouseMoved(evt)
                    case EvtTouchBegan(evt) => onTouchBegan(evt)
                    case EvtTouchMoved(evt) => onTouchMoved(evt)
                    case EvtTouchEnded(evt) => onTouchEnded(evt)
                    case _ => ()
                }
            }
        }
        m_resourceManager.updateActiveInputEvents()
    }

    protected func onClosed(): Unit {
        if (let Some(closeAction) <- m_closeAction) {
            m_eventManager.addBack(closeAction)
        } else {
            m_window?.closeWindow()
        }
    }

    protected func onResized(evt: SizeEvent): Unit {
        var needsResize = false
        var newSize = evt.size
        if (newSize.x < m_minSize.x) {
            newSize.x = m_minSize.x
            needsResize = true
        }
        if (newSize.y < m_minSize.y) {
            newSize.y = m_minSize.y
            needsResize = true
        }
        if (needsResize == true) {
            m_window?.size = newSize
            return
        }
        m_size = newSize
        if (m_fullScreen == false) {
            m_windowedSize = newSize
        }
        updateWindowSize()
        m_eventManager.addBack(m_resizeAction)
    }

    protected func updateWindowSize(): Unit {
        // update draw region sizes
        m_oldDrawRegionSize = m_drawRegionSize
        m_drawRegionSize = match (m_stretchToFit) {
            case true => m_minSize
            case false => m_size
        }

        var usingMaxHeight = false
        if (m_stretchToFit == false && m_maxHeight >= m_minSize.y && m_drawRegionSize.y > m_maxHeight) {
            usingMaxHeight = true

            let factor = Float32(m_maxHeight) / Float32(m_drawRegionSize.y)
            m_drawRegionSize.x = UInt32(Float32(m_drawRegionSize.x) * factor)
            m_drawRegionSize.y = m_maxHeight

            if (m_drawRegionSize.x < m_minSize.x) {
                m_drawRegionSize.x = m_minSize.x
            }
        }

        // force even size
        var evenRegionSize = m_drawRegionSize
        evenRegionSize.x = UInt32(Int32(Float32(evenRegionSize.x) * 0.5)) * 2
        evenRegionSize.y = UInt32(Int32(Float32(evenRegionSize.y) * 0.5)) * 2

        // update main view
        if (let Some(window) <- m_window) {
            let view = window.view
            view.reset(FloatRect(0.0, 0.0, Float32(evenRegionSize.x), Float32(evenRegionSize.y)))
            if (m_stretchToFit == true && m_keepAR == true) {
                SFMLUtils.viewStretchKeepAR(view, m_size)
            } else if (m_stretchToFit == false && usingMaxHeight == true) {
                SFMLUtils.viewStretchKeepAR(view, m_size)
            } else {
                let normalizedWidth = Float32(evenRegionSize.x) / Float32(m_drawRegionSize.x)
                let normalizedHeight = Float32(evenRegionSize.y) / Float32(m_drawRegionSize.y)
                view.viewport = FloatRect(0.0, 0.0, normalizedWidth, normalizedHeight)
            }
            window.view = view
        }

        m_drawRegionSize = evenRegionSize

        if (m_oldDrawRegionSize == m_drawRegionSize) {
            return
        }

        // clears artefacts
        m_window?.clear()
        m_window?.display()

        // update game texture
        recreateGameTexture()
        m_gameSprite?.setTexture((m_gameTexture?.texture).getOrThrow(), resetRect: true)

        // update drawables
        m_loadingScreen?.updateSize(this)
        for (res in m_resourceManager) {
            for (obj in res.drawables) {
                obj.updateSize(this)
            }
        }
    }

    // recreates the game's renderTexture using the current draw region size
    // and sets the smooth property.
    protected func recreateGameTexture(): Unit {
        if (let Some(gameTexture) <- m_gameTexture) {
            gameTexture.close()
            m_gameTexture = None
        }
        let gameTexture = RenderTexture(m_drawRegionSize)
        gameTexture.smooth = m_smoothScreen
        m_gameTexture = gameTexture
    }

    protected func recreateWindow(): Unit {
        m_window?.close()
        m_window = None
        if (m_fullScreen == true) {
            let videoMode = VideoMode.desktopMode
            m_windowedSize = m_size
            m_size = videoMode.size
            m_window = RenderWindow(videoMode, m_title, state: WindowState.Fullscreen)
        } else {
            m_window = RenderWindow(VideoMode(m_size), m_title)
            if (let Some(position) <- m_position) {
                m_window?.position = position
            } else {
                m_position = m_window?.position
            }
        }
        m_window?.setMouseCursorVisible(m_mouseCursorVisible)
        if (m_frameRate > 0) {
            m_window?.setFramerateLimit(m_frameRate)
        }
    }

    protected func onFocusLost(): Unit {
        m_eventManager.addBack(m_focusLossAction)
    }

    protected func onFocusGained(): Unit {
        m_eventManager.addBack(m_focusGainAction)
    }

    protected func onTextEntered(evt: TextEvent): Unit {
        if (m_enableInput == false) {
            return
        }
        m_textEnteredEvt = evt
    }

    protected func onKeyPressed(event: SFMLEvent, evt: KeyEvent): Unit {
        if (m_enableInput == false) {
            return
        }
        m_keyPressEvt = evt
        if (m_loadingScreen.isSome()) {
            return
        }
        m_eventManager.addBack(m_resourceManager.getInputAction(event))
    }

    protected func onKeyReleased(event: SFMLEvent, _: KeyEvent): Unit {
        if (m_enableInput == false || m_loadingScreen.isSome()) {
            return
        }
        m_eventManager.addBack(m_resourceManager.getInputAction(event))
    }

    protected func onMouseWheelScrolled(evt: MouseWheelScrollEvent): Unit {
        if (m_enableInput == false) {
            return
        }
        updateMousePosition()
        var evt2 = evt
        evt2.position = m_mousePositioni
        m_mouseScrollEvt = evt2
    }

    protected func onMouseButtonPressed(evt: MouseButtonEvent): Unit {
        if (m_enableInput == false) {
            return
        }
        updateMousePosition()
        var evt2 = evt
        evt2.position = m_mousePositioni
        m_mousePressEvt = evt2
    }

    protected func onMouseButtonReleased(evt: MouseButtonEvent): Unit {
        if (m_enableInput == false) {
            return
        }
        updateMousePosition()
        var evt2 = evt
        evt2.position = m_mousePositioni
        m_mouseReleaseEvt = evt2
    }

    protected func onMouseMoved(evt: MouseMoveEvent): Unit {
        updateMousePosition(evt.position)
        if (m_enableInput == false) {
            return
        }
        var evt2 = evt
        evt2.position = m_mousePositioni
        m_mouseMoveEvt = evt2
    }

    protected func onTouchBegan(evt: TouchEvent): Unit {
        if (m_enableInput == false) {
            return
        }
        updateMousePosition()
        var evt2 = evt
        evt2.position = m_mousePositioni
        m_touchBeganEvt = evt2
    }

    protected func onTouchMoved(evt: TouchEvent): Unit {
        updateMousePosition(evt.position)
        if (m_enableInput == false) {
            return
        }
        var evt2 = evt
        evt2.position = m_mousePositioni
        m_touchMovedEvt = evt2
    }

    protected func onTouchEnded(evt: TouchEvent): Unit {
        if (m_enableInput == false) {
            return
        }
        updateMousePosition()
        var evt2 = evt
        evt2.position = m_mousePositioni
        m_touchEndedEvt = evt2
    }

    public func updateMousePosition(): Unit {
        if (let Some(window) <- m_window) {
            updateMousePosition(Mouse.getPosition(window))
        }
    }

    protected func updateMousePosition(mousePos: Vector2i): Unit {
        if (let Some(window) <- m_window) {
            m_mousePositionf = window.mapPixelToCoords(mousePos)
            m_mousePositionf.x = round(m_mousePositionf.x)
            m_mousePositionf.y = round(m_mousePositionf.y)
            m_mousePositioni.x = Int32(m_mousePositionf.x)
            m_mousePositioni.y = Int32(m_mousePositionf.y)
            updateCursorPosition()
        }
    }

    public func updateCursorPosition(): Unit {
        if (let Some(cursor) <- m_resourceManager.getCursor()) {
            cursor.position = m_mousePositionf
        }
    }

    public func updateEvents(): Unit {
        if (m_paused == false) {
            m_eventManager.update(this)
        }
    }

    public func drawLoadingScreen(): Bool {
        if (let Some(gameTexture) <- m_gameTexture) {
            if (let Some(loadingScreen) <- m_loadingScreen) {
                m_window?.clear()
                gameTexture.clear()
                loadingScreen.draw(this, gameTexture)
                drawWindow()
                return true
            }
        }
        return false
    }

    public func update(): Unit {
        for (res in m_resourceManager.reverseIterator()) {
            if (res.ignore.isSet(IgnoreResource.Update) == false) {
                for (obj in res.drawables |> reverse) {
                    if (m_paused == false && res.ignore != IgnoreResource.Update) {
                        obj.update(this)
                    }
                }
            } else if (res.ignore.isSet(IgnoreResource.All) == true) {
                break
            }
        }
    }

    public func drawUI(): Unit {
        if (let Some(gameTexture) <- m_gameTexture) {
            for (res in m_resourceManager) {
                if (res.ignore.isSet(IgnoreResource.Draw) == false) {
                    for (obj in res.drawables) {
                        obj.draw(this, gameTexture)
                    }
                } else if (res.ignore.isSet(IgnoreResource.All) == true) {
                    break
                }
            }
        }
    }

    public func drawCursor(): Unit {
        if (let Some(gameTexture) <- m_gameTexture) {
            if (let Some(cursor) <- m_resourceManager.getCursor()) {
                cursor.update(this)
                cursor.draw(this, gameTexture)
            }
        }
    }

    public func drawWindow(): Unit {
        if (let Some(window) <- m_window) {
            if (let Some(gameTexture) <- m_gameTexture) {
                if (let Some(gameSprite) <- m_gameSprite) {
                    gameTexture.display()
                    var states = RenderStates.DEFAULT
                    if (let Some(gameShader) <- m_shaders.game) {
                        states.shader = gameShader.shader
                        for (uniforn in gameShader.uniforms) {
                            match (uniforn) {
                                case "elapsedTime" => gameShader.shader.setUniform("elapsedTime",
                                    m_totalElapsedTime.seconds)
                                case "gamma" => gameShader.shader.setUniform("gamma", Float32(m_gamma))
                                case "fade" => gameShader.shader.setUniform("fade", m_fadeObj.color)
                                case "loading" => gameShader.shader.setUniform("loading",
                                    Float32(m_loadingScreen?.progress ?? 100) / 100.0)
                                case "mousePosition" => gameShader.shader.setUniform(
                                    "mousePosition",
                                    GlslVec2(
                                        Float32(clamp(m_mousePositioni.x, 0, Int32(m_drawRegionSize.x))) / Float32(m_drawRegionSize
                                            .x),
                                        Float32(clamp(m_mousePositioni.y, 0, Int32(m_drawRegionSize.y))) / Float32(m_drawRegionSize
                                            .y)
                                    )
                                )
                                case "textureSize" => gameShader.shader.setUniform("textureSize",
                                    GlslVec2(Float32(m_drawRegionSize.x), Float32(m_drawRegionSize.y)))
                                case _ => ()
                            }
                        }
                    }
                    m_fadeObj.update(this)
                    window.draw(gameSprite, states)
                    window.display()
                }
            }
        }
    }

    public func draw(): Unit {
        m_window?.clear()
        m_gameTexture?.clear()

        drawUI()
        drawCursor()
        drawWindow()
    }

    public func clearInputEvents(e: InputEventType): Unit {
        if (e == InputEventType.None) {
            return
        } else if (e == InputEventType.All) {
            m_mousePressEvt = None
            m_mouseReleaseEvt = None
            m_mouseMoveEvt = None
            m_mouseScrollEvt = None
            m_keyPressEvt = None
            m_textEnteredEvt = None
            m_touchBeganEvt = None
            m_touchMovedEvt = None
            m_touchEndedEvt = None
            return
        }
        if (let Some(mouseButtonEvt) <- m_mousePressEvt) {
            if (e.isSet(InputEventType.LeftClick) && mouseButtonEvt.button == MouseButton.Left) {
                m_mousePressEvt = None
            } else if (e.isSet(InputEventType.MiddleClick) && mouseButtonEvt.button == MouseButton.Middle) {
                m_mousePressEvt = None
            } else if (e.isSet(InputEventType.RightClick) && mouseButtonEvt.button == MouseButton.Right) {
                m_mousePressEvt = None
            }
        }
        if (let Some(mouseButtonEvt) <- m_mouseReleaseEvt) {
            if (e.isSet(InputEventType.LeftClick) && mouseButtonEvt.button == MouseButton.Left) {
                m_mouseReleaseEvt = None
            } else if (e.isSet(InputEventType.MiddleClick) && mouseButtonEvt.button == MouseButton.Middle) {
                m_mouseReleaseEvt = None
            } else if (e.isSet(InputEventType.RightClick) && mouseButtonEvt.button == MouseButton.Right) {
                m_mouseReleaseEvt = None
            }
        }
        if (m_mouseMoveEvt.isSome() && e.isSet(InputEventType.MouseMove)) {
            m_mouseMoveEvt = None
        }
        if (m_mouseScrollEvt.isSome() && e.isSet(InputEventType.MouseScroll)) {
            m_mouseScrollEvt = None
        }
        if (m_keyPressEvt.isSome() && e.isSet(InputEventType.KeyPress)) {
            m_keyPressEvt = None
        }
        if (m_textEnteredEvt.isSome() && e.isSet(InputEventType.TextEnter)) {
            m_textEnteredEvt = None
        }
        if (m_touchBeganEvt.isSome() && e.isSet(InputEventType.TouchBegin)) {
            m_touchBeganEvt = None
        }
        if (m_touchMovedEvt.isSome() && e.isSet(InputEventType.TouchMove)) {
            m_touchMovedEvt = None
        }
        if (m_touchEndedEvt.isSome() && e.isSet(InputEventType.TouchEnd)) {
            m_touchEndedEvt = None
        }
    }

    public func addPlayingSound(obj: SoundBuffer): Unit {
        let sound = Sound(obj)
        sound.volume = Float32(m_soundVolume)
        m_resourceManager.addPlayingSound(sound)
    }

    public func addPlayingSound(obj: ?SoundBuffer): Unit { // cjlint-ignore !G.DCL.01 function name already exists
        if (let Some(buffer) <- obj) {
            addPlayingSound(buffer)
        }
    }
}
