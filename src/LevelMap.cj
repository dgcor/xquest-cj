package XQuest

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

    private var m_ship: ?LevelObject = None

    private var m_levelObjects = ArrayList<LevelObject>()

    // LevelMap

    public func initialize(level: Level, size: (Int64, Int64), padding: (Int64, Int64)): Unit {
        // if (size_.x < 128 || size_.x > 0x7FFF ||
        //     size_.y < 128 || size_.y > 0x7FFF)
        // {
        //     size_ = { 392, 320 };
        // }
        // if (padding_.x < 0 || padding_.x > 255 ||
        //     padding_.y < 0 || padding_.y > 255)
        // {
        //     padding_ = { 0, 0 };
        // }

        // size = size_;
        // padding.x = (float)padding_.x;
        // padding.y = (float)padding_.y;

        if (level.m_bordersTexturePack.isNone()) {
            return
        }

        // borders[0].setAnimation(level.BordersTexturePack(), 0, -1);
        // auto rect = borders[0].getTextureRect();
        // auto topLeftSize = rect.getSize();
        // rect.width += size.x;
        // borders[0].Position({ padding.x - topLeftSize.x, padding.y - topLeftSize.y });
        // borders[0].setTextureRect(rect);

        // borders[1].setAnimation(level.BordersTexturePack(), 1, -1);
        // rect = borders[1].getTextureRect();
        // auto topRightSize = rect.getSize();
        // rect.height += size.y;
        // borders[1].Position({ padding.x + size.x, padding.y - topRightSize.y });
        // borders[1].setTextureRect(rect);

        // borders[2].setAnimation(level.BordersTexturePack(), 2, -1);
        // borders[2].Position({ padding.x + size.x, padding.y + size.y });

        // borders[3].setAnimation(level.BordersTexturePack(), 3, -1);
        // rect = borders[3].getTextureRect();
        // auto bottomLeftSize = rect.getSize();
        // rect.width += size.x;
        // borders[3].Position({ padding.x - bottomLeftSize.x, padding.y + size.y });
        // borders[3].setTextureRect(rect);

        // auto minPosX = (int32_t)padding.x;
        // auto maxPosX = (int32_t)padding.x + size.x;
        // auto minPosY = (int32_t)padding.y;
        // auto maxPosY = (int32_t)padding.y + size.y;

        // for (auto i : std::views::iota(0, 100))
        // {
        //     sf::Vector2f pos{ (float)Random::get(minPosX, maxPosX), (float)Random::get(minPosY, maxPosY) };
        //     sf::Uint8 c = 72 + Random::get(162);
        //     stars.addVertex(sf::Vertex(pos, sf::Color(c, c, c)));
        // }

        // for (auto i : std::views::iota(0, 400))
        // {
        //     sf::Vector2f pos{ (float)Random::get(minPosX, maxPosX), (float)Random::get(minPosY, maxPosY) };
        //     sf::Uint8 c = 32 + Random::get(122);
        //     stars.addVertex(sf::Vertex(pos, sf::Color(c, c, c)));
        // }
    }

    public prop borders: Array<Animation> {
        get() {
            m_borders
        }
    }

    public prop stars: Shape {
        get() {
            m_stars
        }
    }

    public prop size: (Int64, Int64) {
        get() {
            m_size
        }
    }

    public prop padding: Vector2f {
        get() {
            m_padding
        }
    }

    public prop ship: ?LevelObject {
        get() {
            m_ship
        }
    }

    public prop levelObjects: ArrayList<LevelObject> {
        get() {
            m_levelObjects
        }
    }
}
