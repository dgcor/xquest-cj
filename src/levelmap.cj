package xquest

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.collection.*

class LevelMap {
    // animations for: 4 corners + 2 pillars + 3 for gate (sides + door) + 2 enemy doors
    private var m_borders = Array<Animation>(11, {_ => Animation()})
    private var m_stars = Shape(PrimitiveType.Points)

    private var m_size: (Int64, Int64) = (0, 0)

    // draw padding for borders
    private var m_padding = Vector2f()

    protected var m_ship: ?LevelObject = None

    var levelObjects = ArrayList<LevelObject>()

    // LevelMap

    func initialize(level: Level, size_: (Int64, Int64), padding_: (Int64, Int64)): Unit {
        if (size_[0] < 128 || size_[0] > 0x7FFF || size_[1] < 128 || size_[1] > 0x7FFF) {
            m_size = (392, 320)
        } else {
            m_size = size_
        }

        if (padding_[0] < 0 || padding_[0] > 255 || padding_[1] < 0 || padding_[1] > 255) {
            m_padding = Vector2f(0.0, 0.0)
        } else {
            m_padding = Vector2f(Float32(padding_[0]), Float32(padding_[1]))
        }

        if (level.bordersTexturePack.isNone()) {
            return
        }

        m_borders[0].setAnimation(level.bordersTexturePack, 0, -1)
        var rect = m_borders[0].textureRect
        var topLeftSize = rect.size
        rect.size.x += Int32(m_size[0])
        m_borders[0].position = Vector2f(m_padding.x - Float32(topLeftSize.x), m_padding.y - Float32(topLeftSize.y))
        m_borders[0].textureRect = rect

        m_borders[1].setAnimation(level.bordersTexturePack, 1, -1)
        rect = m_borders[1].textureRect
        var topRightSize = rect.size
        rect.size.y += Int32(m_size[1])
        m_borders[1].position = Vector2f(m_padding.x + Float32(m_size[0]), m_padding.y - Float32(topRightSize.y))
        m_borders[1].textureRect = rect

        m_borders[2].setAnimation(level.bordersTexturePack, 2, -1)
        m_borders[2].position = Vector2f(m_padding.x + Float32(m_size[0]), m_padding.y + Float32(m_size[1]))

        m_borders[3].setAnimation(level.bordersTexturePack, 3, -1)
        rect = m_borders[3].textureRect
        var bottomLeftSize = rect.size
        rect.size.x += Int32(m_size[0])
        m_borders[3].position = Vector2f(m_padding.x - Float32(bottomLeftSize.x), m_padding.y + Float32(m_size[1]))
        m_borders[3].textureRect = rect

        let minPosX = Int64(m_padding.x)
        let maxPosX = Int64(m_padding.x + Float32(m_size[0]))
        let minPosY = Int64(m_padding.y)
        let maxPosY = Int64(m_padding.y + Float32(m_size[1]))

        for (_ in 0..100) {
            let pos = Vector2f(Float32(Random.get(minPosX, maxPosX)), Float32(Random.get(minPosY, maxPosY)))
            let c = UInt8(72 + Random.get(Int64(0), Int64(162)))
            m_stars.addVertex(Vertex(position: pos, color: Color(c, c, c)))
        }

        for (_ in 0..400) {
            let pos = Vector2f(Float32(Random.get(minPosX, maxPosX)), Float32(Random.get(minPosY, maxPosY)))
            let c = UInt8(32 + Random.get(Int64(0), Int64(122)))
            m_stars.addVertex(Vertex(position: pos, color: Color(c, c, c)))
        }
    }

    prop borders: Array<Animation> {
        get() {
            m_borders
        }
    }

    prop stars: Shape {
        get() {
            m_stars
        }
    }

    prop size: (Int64, Int64) {
        get() {
            m_size
        }
    }

    // prop padding: Vector2f {
    //     get() {
    //         m_padding
    //     }
    // }
}
