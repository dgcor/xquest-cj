package XQuest

import dgengine.*
import std.collection.*

struct LevelOptions {
    public LevelOptions(
        public var level!: Int64 = 0,
        public var numLives!: Int64 = 2,
        public var numSmartBombs!: Int64 = 3,
        public var formulas!: HashMap<String, Formula> = HashMap<String, Formula>(),
        public var maxObjectsById!: HashMap<String, Int64> = HashMap<String, Int64>(),
        public var maxObjectsByType!: HashMap<String, Int64> = HashMap<String, Int64>(),
        public var insert!: ArrayList<(String, Formula)> = ArrayList<(String, Formula)>(),
        public var spawns!: ArrayList<String> = ArrayList<String>()
    ) {}

    public func clone(): LevelOptions {
        LevelOptions(
            level: level,
            numLives: numLives,
            numSmartBombs: numSmartBombs,
            formulas: formulas.clone(),
            maxObjectsById: maxObjectsById.clone(),
            maxObjectsByType: maxObjectsByType.clone(),
            insert: insert.clone(),
            spawns: spawns.clone()
        )
    }

    public func getMaxObjectsById(id: String): Int64 {
        maxObjectsById.get(id) ?? 0
    }

    public func getMaxObjectsByType(unitType: String): Int64 {
        maxObjectsByType.get(unitType) ?? 0
    }
}
