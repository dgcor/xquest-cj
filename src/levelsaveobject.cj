package xquest

import std.collection.*

struct LevelSaveObject {
    public var state: LevelStateObject = LevelStateObject()
    public var boardWalls: ArrayList<(Int64, Int64)> = ArrayList<(Int64, Int64)>()
    public var links: ArrayList<((Int64, Int64), (Int64, Int64))> = ArrayList<((Int64, Int64), (Int64, Int64))>()
    public var explosions: ArrayList<(Int64, Int64)> = ArrayList<(Int64, Int64)>()
}
