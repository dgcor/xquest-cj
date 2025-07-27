package XQuest

import dgengine.*
import stdx.encoding.json.*
import std.collection.*
import std.math.*

func parseLevelOptions(optionsManager: LevelOptionsManager, elem: JsonArray): Unit {
    var options = LevelOptions()
    let allOptions = ArrayList<LevelOptions>()
    for (val in elem.getItems()) {
        options = options.clone()
        options.level = getInt64Key(val, "level", default: options.level + 1)
        options.numLives = clamp(getInt64Key(val, "lives"), 0, 99)
        options.numSmartBombs = clamp(getInt64Key(val, "smartBombs"), 1, 99)

        if (let Some(elem) <- getValidArray(val, "insert")) {
            options.insert.clear()
            for (val in elem.getItems()) {
                let id = getStringKey(val, "id")
                if (id.isEmpty() == true) {
                    continue
                }
                let count = getStringKey(val, "count")
                options.insert.add((id, Formula(count)))
            }
        }
        if (let Some(elem) <- getValidArray(val, "spawn")) {
            options.spawns.clear()
            for (val in elem.getItems()) {
                let id = getStringVal(val)
                if (id.isEmpty() == true) {
                    continue
                }
                options.spawns.add(id)
            }
        }
        if (let Some(elem) <- getValidArray(val, "formulas")) {
            for (val in elem.getItems()) {
                let key = getStringKey(val, "key")
                if (key.isEmpty() == true) {
                    continue
                }
                let formula = Formula(getStringVal(val, default: "value"))
                if (formula.empty == false) {
                    options.formulas.add(key, formula)
                } else {
                    options.formulas.remove(key)
                }
            }
        }
        if (let Some(elem) <- getValidArray(val, "maxObjectsById")) {
            options.maxObjectsById.clear()
            for (val in elem.getItems()) {
                let id = getStringKey(val, "id")
                if (id.isEmpty() == true) {
                    continue
                }
                let count = Int64(getUIntKey(val, "count"))
                options.maxObjectsById.add(id, count)
            }
        }
        if (let Some(elem) <- getValidArray(val, "maxObjectsByType")) {
            options.maxObjectsByType.clear()
            for (val in elem.getItems()) {
                let unitType = getStringKey(val, "type")
                if (unitType.isEmpty() == true) {
                    continue
                }
                let count = Int64(getUIntKey(val, "count"))
                options.maxObjectsByType.add(unitType, count)
            }
        }
        allOptions.add(options)
    }
    optionsManager.set(allOptions)
}
