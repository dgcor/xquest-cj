package dgengine

import stdx.encoding.json.*

public func getPredicateObj(game: Game, elem: JsonValue): ?Predicate {
    if (let Some(name) <- getValidString(elem, "name")) {
        return match (name) {
            case "file.exists" => PredFileExists(getStringKey(elem, "file"))
            case "gamefile.exists" => PredGamefileExists(getStringKey(elem, "file"))
            case _ => match (Hooks.getPredicateObj) {
                case Some(getPredicateObj) => getPredicateObj(game, name, elem)
                case None => None
            }
        }
    }
    return None
}
