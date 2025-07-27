package dgengine

import std.regex.{MatchData, Regex as StdRegex}

public class Regex {
    private var m_regex: ?StdRegex = None

    public init() {}

    public init(pattern: String) {
        try {
            if (pattern.isEmpty() == false) {
                m_regex = StdRegex(pattern)
            }
        } catch (_: Exception) {}
    }

    public prop isValid: Bool {
        get() {
            m_regex.isSome()
        }
    }

    public func matcher(str: String): Bool {
        try {
            if (let Some(regex) <- m_regex) {
                if (let Some(matchData) <- regex.find(str)) {
                    return matchData.matchString().size == str.size
                }
            }
        } catch (_: Exception) {}
        return false
    }

    public static func matchPattern(pattern: String, str: String): Bool {
        try {
            return Regex(pattern).matcher(str)
        } catch (_: Exception) {}
        return false
    }
}
