package xquest

import dgengine.*
import std.collection.*
import stdjson2.*

func parseLevelScores(scoreManager: LevelScoreManager, elem: JsonValue): Unit {
    var score = LevelScore()
    let scores = ArrayList<LevelScore>()
    for (val in elem) {
        score.name = getStringKey(val, "name")
        score.level = getInt64Key(val, "level")
        score.score = getInt64Key(val, "score")
        scores.add(score)
    }
    scoreManager.set(scores)
}
