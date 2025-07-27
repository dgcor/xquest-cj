package XQuest

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.collection.*
import std.math.*

class Level {
    protected let m_surface = Surface(forceEvenSize: false, isometricZoom: false)
    protected var m_gameShader: ?GameShader = None

    protected var m_bordersTexturePack: ?TexturePack = None

    protected var m_map = LevelMap()

    var id = String.empty
    var name = String.empty

    protected var m_pause = false
    protected var m_hasMouseInside = true

    protected var m_gameState = LevelStateObject()

    private var m_scoreFormula = Formula()
    protected var m_options = LevelOptions()

    protected var m_optionsManager = LevelOptionsManager()

    protected var m_leftClickAction: ?Action = None
    protected var m_rightClickAction: ?Action = None
    protected var m_newRoundAction: ?Action = None
    protected var m_gameOverAction: ?Action = None

    private var m_levelObjectsClasses = HashMap<String, LevelObjectClass>()

    protected var m_highScoresManager = LevelScoreManager()

    // Level

    public func initialize(bordersTexturePack: TexturePack, mapSize: (Int64, Int64), padding: (Int64, Int64)) {
        m_bordersTexturePack = bordersTexturePack
        m_map.initialize(this, mapSize, padding)
    }

    public func setShader(shader: ?GameShader): Unit {
        m_gameShader = shader
    }
}
