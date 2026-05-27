package xquest

import cjsfml.system.*
import dgengine.*
import stdjson2.*

func parseLevelObject(game: Game, elem: JsonValue): Unit {
    if (let Some(level) <- game.resources.getLevel<Level>(getStringCharKey(elem, "level"))) {
        if (let Some(id) <- getValidString(elem, "class")) {
            if (let Some(cls) <- level.levelObjectsClasses.get(id)) {
                let mapPosv2i = getVector2NumberKey(elem, "mapPosition", default: Vector2i())
                let mapPos = (Int64(mapPosv2i.x), Int64(mapPosv2i.y))
                let obj = LevelObject(cls, mapPosition: mapPos)
                obj.points = getInt64Key(elem, "points", default: cls.points)
                level.addLevelObject(obj)
            }
        }
    }
}
