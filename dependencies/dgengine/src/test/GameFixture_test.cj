package dgengine.test

import cjsfml.system.*
import dgengine.*

extend Game {
    public func updateSize(size: Vector2u) {
        m_oldDrawRegionSize = m_drawRegionSize
        m_drawRegionSize = size
    }
}
