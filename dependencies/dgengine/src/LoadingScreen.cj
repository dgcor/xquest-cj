package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.math.*

public class LoadingScreen <: Animation & ActionQueryable {
    private var m_progressBar: RectangleShape = RectangleShape()
    private var m_barSize: Vector2f = Vector2f()
    private var m_barPosOffset: Vector2f = Vector2f()
    private var m_completeAction: ?Action = None
    private var m_percent: Int32 = 0

    public init() {}

    public init(texture: Texture) {
        super(texture)
    }

    public init(texturePack: TexturePack, animInfo: AnimationInfo, pause!: Bool = false) {
        super(texturePack, animInfo, pause: pause)
    }

    // ActionQueryable

    public func getAction(name: String): ?Action {
        match (name) {
            case "complete" => m_completeAction
            case _ => None
        }
    }

    public func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "complete" => m_completeAction = action
            case _ => return false
        }
        return true
    }

    // UIObject

    public override func updateSize(game: Game): Unit {
        super.updateSize(game)
        m_progressBar.position = super.position + m_barPosOffset
    }

    public mut override prop position: Vector2f {
        get() {
            super.position
        }
        set(value) {
            super.position = value
            m_progressBar.position = value + m_barPosOffset
        }
    }

    public mut override prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public override func draw(game: Game, target: RenderTarget): Unit {
        super.draw(game, target)
        target.draw(m_progressBar)
    }

    // LoadingScreen

    public mut prop progressBarColor: Color {
        get() {
            m_progressBar.fillColor
        }
        set(value) {
            m_progressBar.fillColor = value
        }
    }

    public mut prop progressBarPositionOffset: Vector2f {
        get() {
            m_barPosOffset
        }
        set(value) {
            m_barPosOffset = value
            m_progressBar.position = m_sprite.position + value
        }
    }

    public mut prop progressBarSize: Vector2f {
        get() {
            m_barSize
        }
        set(value) {
            m_barSize = value
        }
    }

    public mut prop progress: Int32 {
        get() {
            m_percent
        }
        set(value) {
            m_percent = match (value) {
                case _ where value < 0 => 0
                case _ where value > 100 => 100
                case _ => value
            }

            let percentage = (Float32(m_percent) / 100.0)
            var newSize = m_barSize
            newSize.x = round(newSize.x * percentage)
            m_progressBar.size = newSize

            if (m_animation.texturePack.isSome()) {
                let startIdx = Float32(m_animation.animInfo.indexRange[0])
                let range = Float32(m_animation.animInfo.indexRange[1] - m_animation.animInfo.indexRange[0])
                m_animation.currentTextureIdx = UInt32(round(startIdx + range * percentage))
                m_animation.updateTexture(m_sprite)
            }
        }
    }

    public prop isComplete: Bool {
        get() {
            m_percent >= 100
        }
    }
}
