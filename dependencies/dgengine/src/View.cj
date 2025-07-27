package dgengine

import cjsfml.graphics.*
import cjsfml.graphics.View as SFMLView
import cjsfml.system.*
import std.math.*

public class View <: Resource {
    private let m_view: SFMLView = SFMLView()
    private var m_position: Vector2f = Vector2f()
    private var m_sizeNoZoom: Vector2f = Vector2f()
    private var m_roundedSizeNoZoom: Vector2f = Vector2f()
    private var m_zoomFactor: Float32 = 1.0
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_forceEvenSize: Bool = false

    public init(forceEvenSize!: Bool = false) {
        m_forceEvenSize = forceEvenSize
    }

    // Resource

    public func isClosed(): Bool {
        m_view.isClosed()
    }

    public func close(): Unit {
        m_view.close()
    }

    // View

    public mut prop anchor: Anchor {
        get() {
            m_anchor
        }
        set(value) {
            m_anchor = value
        }
    }

    public mut prop center: Vector2f {
        get() {
            m_view.center
        }
        set(value) {
            m_view.center = value
        }
    }

    public func getPosition(point: Vector2f): Vector2f {
        let topLeft = m_view.center - (m_view.size / 2.0)
        var pos = topLeft + (point * m_zoomFactor) - (m_position * m_zoomFactor)
        pos.x = round(pos.x)
        pos.y = round(pos.y)
        return pos
    }

    public func getDrawPosition(point: Vector2f): Vector2f {
        let topLeft = m_view.center - (m_view.size / 2.0)
        var pos = (point + m_position - topLeft) / m_zoomFactor
        pos.x = round(pos.x)
        pos.y = round(pos.y)
        return pos
    }

    public mut prop position: Vector2f {
        get() {
            m_position
        }
        set(value) {
            m_position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            m_sizeNoZoom
        }
        set(value) {
            m_sizeNoZoom = value
            if (m_forceEvenSize == true) {
                m_roundedSizeNoZoom.x = Float32((Int32(value.x * 0.5)) * 2)
                m_roundedSizeNoZoom.y = Float32((Int32(value.y * 0.5)) * 2)
            } else {
                m_roundedSizeNoZoom = m_sizeNoZoom
            }
            m_view.size = m_roundedSizeNoZoom
        }
    }

    public prop visibleSize: Vector2f {
        get() {
            m_view.size
        }
    }

    public prop roundedSize: Vector2f {
        get() {
            m_roundedSizeNoZoom
        }
    }

    public prop view: SFMLView {
        get() {
            m_view
        }
    }

    public mut prop viewport: FloatRect {
        get() {
            m_view.viewport
        }
        set(value) {
            m_view.viewport = value
        }
    }

    public mut prop zoom: Float32 {
        get() {
            m_zoomFactor
        }
        set(value) {
            m_zoomFactor = value
        }
    }

    private func setViewport(game: Game): Unit {
        let drawRegionSize = game.drawRegionSize
        let gameWindowSize = game.size
        var x = m_position.x
        if (drawRegionSize.x > gameWindowSize.x) {
            x += (Float32(drawRegionSize.x) / 2.0) - (Float32(gameWindowSize.x) / 2.0)
        }
        x /= Float32(drawRegionSize.x)
        var y = m_position.y
        if (drawRegionSize.y > gameWindowSize.y) {
            y += (Float32(drawRegionSize.y) / 2.0) - (Float32(gameWindowSize.y) / 2.0)
        }
        y /= Float32(drawRegionSize.y)

        let w = m_roundedSizeNoZoom.x / Float32(drawRegionSize.x)
        let h = m_roundedSizeNoZoom.y / Float32(drawRegionSize.y)

        m_view.viewport = FloatRect(x, y, w, h)
    }

    public func updateSize(game: Game, dontUpdateViewport!: Bool = false): Unit {
        let pos2 = Box(position)
        let size2 = Box(size)
        anchor.getPosSize(pos2, size2, game.oldDrawRegionSize, game.drawRegionSize)
        position = pos2.value
        size = size2.value
        if (dontUpdateViewport == false) {
            setViewport(game)
        }
        m_view.zoom(m_zoomFactor)
    }

    // updates size, zoom and the viewport
    public func update(game: Game, dontUpdateViewport!: Bool = false): Unit {
        size = m_sizeNoZoom
        if (dontUpdateViewport == false) {
            setViewport(game)
        }
        m_view.zoom(m_zoomFactor)
    }

    public func reset(rectangle: FloatRect): Unit {
        m_view.reset(rectangle)
    }

    public func reset(): Unit {
        let vSize = m_view.size
        view.reset(FloatRect(0.0, 0.0, vSize.x, vSize.y))
    }
}
