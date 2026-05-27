package xquest

import dgengine.*
import std.collection.*

struct LevelOptions {
    LevelOptions(
        var level!: Int64 = 0,
        var lives!: Int64 = 2,
        var smartBombs!: Int64 = 3,
        var formulas!: HashMap<String, Formula> = HashMap<String, Formula>(),
        var maxObjectsById!: HashMap<String, Int64> = HashMap<String, Int64>(),
        var maxObjectsByType!: HashMap<String, Int64> = HashMap<String, Int64>(),
        var insert!: ArrayList<(String, Formula)> = ArrayList<(String, Formula)>(),
        var spawns!: ArrayList<String> = ArrayList<String>()
    ) {}

    func clone(): LevelOptions {
        LevelOptions(
            level: level,
            lives: lives,
            smartBombs: smartBombs,
            formulas: formulas.clone(),
            maxObjectsById: maxObjectsById.clone(),
            maxObjectsByType: maxObjectsByType.clone(),
            insert: insert.clone(),
            spawns: spawns.clone()
        )
    }

    // func getMaxObjectsById(id: String): Int64 {
    //     maxObjectsById.get(id) ?? 0
    // }

    // func getMaxObjectsByType(unitType: String): Int64 {
    //     maxObjectsByType.get(unitType) ?? 0
    // }
}
