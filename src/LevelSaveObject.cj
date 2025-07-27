package XQuest

import std.collection.*

struct LevelSaveObject {
    public var state = LevelStateObject()
    public var boardWalls = ArrayList<(Int64, Int64)>()
    public var links = ArrayList<((Int64, Int64), (Int64, Int64))>()
    public var explosions = ArrayList<(Int64, Int64)>()
}
