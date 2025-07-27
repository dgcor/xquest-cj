package XQuest

import dgengine.*
import stdx.encoding.json.*
import std.collection.*

func parseLevelScores(scoreManager: LevelScoreManager, elem: JsonArray): Unit {
    var score = LevelScore()
    let scores = ArrayList<LevelScore>()
    for (val in elem.getItems()) {
        score.name = getStringKey(val, "name")
        score.level = getInt64Key(val, "level")
        score.score = getInt64Key(val, "score")
        scores.add(score)
    }
    scoreManager.set(scores)
}
