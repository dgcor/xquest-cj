package XQuest

import cjsfml.system.*
import dgengine.*
import stdx.encoding.json.*

// func parseLevelObject(game: Game, elem: JsonValue): Unit {
//     if (let Some(level) <- game.resources.getLevel<Level>(getStringCharKey(elem, "level"))) {
//         if (let Some(id) <- getValidString(elem, "class")) {
//             if (let Some(cls) <- level.getUnitClass(id)) {
//                 let boardPosv2i = getVector2NumberKey(elem, "boardPosition", default: Vector2i())
//                 let boardPos = (Int64(boardPosv2i.x), Int64(boardPosv2i.y))
//                 if (level.board.isCoordValid(boardPos) == false || level.board.hasUnit(boardPos) == true) {
//                     return
//                 }
//                 var direction = getUIntKey(elem, "direction")
//                 if (direction >= cls.directions) {
//                     direction = 0
//                 }
//                 let unit = UnitObject(cls, boardPosition: boardPos, direction: direction)
//                 unit.points = getInt64Key(elem, "points", default: cls.points)
//                 level.addUnit(unit)
//             }
//         }
//     }
// }
