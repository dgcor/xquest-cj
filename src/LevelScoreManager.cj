package XQuest

import dgengine.*
import std.collection.*
import std.convert.*
import std.sort.*

class LevelScoreManager {
    private static const MaxSize = 10
    private var m_levelScores = ArrayList<LevelScore>()

    public func add(levelScore: LevelScore): Unit {
        m_levelScores.add(levelScore)
        updateScores()
    }

    public func set(levelScores: ArrayList<LevelScore>): Unit {
        m_levelScores = levelScores
        updateScores()
    }

    private func updateScores(): Unit {
        sort(
            m_levelScores,
            by: {
                a, b =>
                if (b.score > a.score) {
                    return Ordering.GT
                } else if (b.score < a.score) {
                    return Ordering.LT
                }
                return Ordering.EQ
            }
        )
        if (m_levelScores.size > MaxSize) {
            m_levelScores.remove(MaxSize..m_levelScores.size)
        }
    }

    public prop size: Int64 {
        get() {
            m_levelScores.size
        }
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        var props = splitStringIn2(propName, ".")
        let index = match ((props[0], m_levelScores.size)) {
            case ("highest", 0) => -1
            case ("highest", _) => 0
            case ("lowest", 0) => -1
            case ("lowest", size) => size - 1
            case (str, _) => Int64.tryParse(str) ?? -1
        }
        if (index < 0 || index >= m_levelScores.size) {
            return None
        }
        props = splitStringIn2(props[1], ".")
        return match (props[0]) {
            case "name" => VaString(m_levelScores[index].name)
            case "level" => VaInteger(m_levelScores[index].level)
            case "score" => VaInteger(m_levelScores[index].score)
            case _ => None
        }
    }
}
