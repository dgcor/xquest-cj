package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class Scrollable <: ActionQueryable & UIObject {
    private let m_uiObj: UIObject
    private let m_view: View = View()
    private var m_completeAction: ?Action = None
    private var m_direction: Direction = Direction.Down
    private var m_elapsedTime: ElapsedTime
    private var m_scrollSize: Float32 = 0.0
    private var m_offset: Float32 = 0.0
    private var m_loop: Bool = false
    private var m_pause: Bool = false
    private var m_visible: Bool = true

    public init(uiObj: UIObject, speed: Time) {
        m_uiObj = uiObj
        m_elapsedTime = ElapsedTime(timeout: speed)
    }

    // Resource

    public func isClosed(): Bool {
        m_view.isClosed()
    }

    public func close(): Unit {
        m_view.close()
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

    public mut prop anchor: Anchor {
        get() {
            m_view.anchor
        }
        set(value) {
            m_view.anchor = value
        }
    }

    public func updateSize(game: Game): Unit {
        m_view.updateSize(game)
    }

    public prop drawPosition: Vector2f {
        get() {
            m_view.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_view.position
        }
        set(value) {
            m_view.position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            m_view.size
        }
        set(value) {
            m_view.size = value
        }
    }

    public mut prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public func draw(game: Game, target: RenderTarget): Unit {
        if (m_visible == false) {
            return
        }
        if (m_uiObj.isClosed() == false) {
            try (origView = target.view.clone()) {
                target.view = m_view.view
                m_uiObj.draw(game, target)
                target.view = origView
            }
        }
    }

    public override func update(game: Game): Unit {
        if (m_pause == true || m_visible == false || m_uiObj.isClosed()) {
            return
        }

        m_uiObj.update(game)

        m_elapsedTime.update(
            game.elapsedTime,
            {
                =>
                var center = m_view.center
                var finished = false

                match (m_direction.value) {
                    case v where v == Direction.Up.value =>
                        let sizeY = m_uiObj.size.y
                        if (center.y + (m_scrollSize / 2.0) > 0.0) {
                            center.y -= 1.0
                        } else {
                            if (m_loop == true) {
                                center.y += sizeY + m_scrollSize
                            }
                            finished = true
                        }
                    case v where v == Direction.Down.value =>
                        let sizeY = m_uiObj.size.y
                        if (center.y - (m_scrollSize / 2.0) < sizeY) {
                            center.y += 1.0
                        } else {
                            if (m_loop == true) {
                                center.y -= sizeY + m_scrollSize
                            }
                            finished = true
                        }
                    case v where v == Direction.Left.value =>
                        let sizeX = m_uiObj.size.x
                        if (center.x + (m_scrollSize / 2.0) > 0.0) {
                            center.x -= 1.0
                        } else {
                            if (m_loop == true) {
                                center.x += sizeX + m_scrollSize
                            }
                            finished = true
                        }
                    case v where v == Direction.Right.value =>
                        let sizeX = m_uiObj.size.x
                        if (center.x - (m_scrollSize / 2.0) < sizeX) {
                            center.x += 1.0
                        } else {
                            if (m_loop == true) {
                                center.x -= sizeX + m_scrollSize
                            }
                            finished = true
                        }
                    case _ => ()
                }

                if (finished == true) {
                    if (m_loop == false) {
                        m_pause = true
                    }
                    game.events.addBack(m_completeAction)
                }
                m_view.center = center
            }
        )
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "loop" => VaBoolean(m_loop)
            case "paused" => VaBoolean(m_pause)
            case "scrollPosition" =>
                let center = m_view.center
                match (m_direction.value) {
                    case v where v == Direction.Up.value || v == Direction.Down.value => VaInteger(Int64(center.y))
                    case v where v == Direction.Left.value || v == Direction.Right.value => VaInteger(Int64(center.x))
                    case _ => None
                }
            case _ =>
                let value = getProperty(props[0], props[1])
                if (value.isSome()) {
                    return value
                }
                match (m_uiObj.isClosed()) {
                    case true => None
                    case false => m_uiObj.getProperty(propName)
                }
        }
    }

    // Scrollable

    public func reset(): Unit {
        let uiObjSize = match (m_uiObj.isClosed()) {
            case true => Vector2f()
            case false => m_uiObj.size
        }
        let vSize = m_view.visibleSize
        match (m_direction.value) {
            case v where v == Direction.Up.value =>
                m_view.reset(FloatRect(0.0, uiObjSize.y + m_offset, vSize.x, vSize.y))
                m_scrollSize = vSize.y
            case v where v == Direction.Down.value =>
                m_view.reset(FloatRect(0.0, -(vSize.y + m_offset), vSize.x, vSize.y))
                m_scrollSize = vSize.y
            case v where v == Direction.Left.value =>
                m_view.reset(FloatRect(uiObjSize.x + m_offset, 0.0, vSize.x, vSize.y))
                m_scrollSize = vSize.x
            case v where v == Direction.Right.value =>
                m_view.reset(FloatRect(-(vSize.x + m_offset), 0.0, vSize.x, vSize.y))
                m_scrollSize = vSize.x
            case _ => ()
        }
    }

    public func updateView(game: Game): Unit {
        m_view.update(game)
    }

    public mut prop direction: Direction {
        get() {
            m_direction
        }
        set(value) {
            m_direction = value
        }
    }

    public mut prop speed: Time {
        get() {
            m_elapsedTime.timeout
        }
        set(value) {
            m_elapsedTime.timeout = value
        }
    }

    public mut prop offset: Float32 {
        get() {
            m_offset
        }
        set(value) {
            m_offset = value
        }
    }

    public mut prop loop: Bool {
        get() {
            m_loop
        }
        set(value) {
            m_loop = value
        }
    }

    public mut prop pause: Bool {
        get() {
            m_pause
        }
        set(value) {
            m_pause = value
        }
    }
}
