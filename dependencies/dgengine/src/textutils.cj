package dgengine

import cenum.*
import customiterators.*
import std.collection.*

@FlagEnum[public TextOp](
    Set
    Replace
    Query
    FormatString
    ReplaceAll
    Trim
    RemoveEmptyLines
)

public class TextUtils {
    // formats string using bindings
    // bindings: %game.size.x%, %game.size.y%
    // output: "size: [1], [2]" -> "Size: 640, 480"
    public static func getFormatString(game: Game, format: String, bindings: Iterator<String>, outStr: Box<String>): Bool {
        let it = PeekIterator(bindings)
        if (it.peek().isSome()) {
            if (format == "[1]") {
                if (let Some(binding) <- it.next()) {
                    return game.getVarOrPropStringS(binding, outStr)
                }
            } else {
                var hasBinding = true
                outStr.value = format
                if (format.size > 2) {
                    for ((index, binding) in it |> enumerate) {
                        let str = Box(String())
                        if (game.getVarOrPropStringS(binding, str) == false) {
                            hasBinding = false
                        }
                        outStr.value = outStr.value.replace("[${index + 1}]", str.value)
                    }
                }
                return hasBinding
            }
        }
        return false
    }

    // formats string using bindings
    // bindings: %game.size.x%, %game.size.y%
    // output: "size: [1], [2]" -> "Size: 640, 480"
    public static func getFormatString(game: Game, format: String, bindings: Iterator<String>): String {
        let str = Box(String())
        getFormatString(game, format, bindings, str)
        return str.value
    }

    // formats string using query
    // query: game
    // output: "size: %size.x%, %size.y%" -> "Size: 640, 480"
    public static func getTextQueryable(game: Game, format: String, query: String): String {
        if (let Some(queryable) <- game.getQueryable(query)) {
            return GameUtils.replaceStringWithQueryable(format, queryable.getQueryable())
        }
        return format
    }

    public static func getText(game: Game, textOp: TextOp, textOrformat: String, bindings: Iterator<String>): String {
        let str = Box(String())
        appendText(game, textOp, str, textOrformat, bindings)
        return str.value
    }

    public static func appendText(game: Game, textOp: TextOp, str: Box<String>, textOrformat: String,
        bindings: Iterator<String>): Unit {
        let textFlags = TextOp(textOp.value & 0x7)
        if (textFlags == TextOp.Replace) {
            str.value += game.getVarOrPropStringS(textOrformat)
        } else if (textFlags == TextOp.Query) {
            if (let Some(binding) <- bindings.next()) {
                str.value += getTextQueryable(game, textOrformat, binding)
            } else {
                str.value += textOrformat
            }
        } else if (textFlags == TextOp.FormatString) {
            str.value += getFormatString(game, textOrformat, bindings)
        } else {
            // set
            str.value += textOrformat
        }

        if (textOp.isSet(TextOp.ReplaceAll)) {
            str.value = GameUtils.replaceStringWithVarOrProp(str.value, game)
        }
        if (textOp.isSet(TextOp.Trim)) {
            str.value = str.value.trimAscii()
        }
        if (textOp.isSet(TextOp.RemoveEmptyLines)) {
            str.value = removeEmptyLines(str.value)
        }
    }
}
