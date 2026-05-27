package xquest

import std.collection.*

struct LevelSaveObject {
    var state: LevelStateObject = LevelStateObject()
    var boardWalls: ArrayList<(Int64, Int64)> = ArrayList<(Int64, Int64)>()
    var links: ArrayList<((Int64, Int64), (Int64, Int64))> = ArrayList<((Int64, Int64), (Int64, Int64))>()
    var explosions: ArrayList<(Int64, Int64)> = ArrayList<(Int64, Int64)>()
}
