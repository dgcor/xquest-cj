macro package ctemplate

import std.ast.{diagReport, DiagReportLevel, Token, Tokens, TokenKind}
import std.collection.{ArrayList, enumerate, filter, first, last, zip}

private func getParams(attrTokens: Tokens): ArrayList<ArrayList<(Token, Token)>> {
    let allParams = ArrayList<ArrayList<(Token, Token)>>()
    let genericParams = ArrayList<Token>()
    var replaceParams = ArrayList<Token>()
    var hasColon = false
    for (token in attrTokens) { // cjlint-ignore !G.FUN.01 too many nested code blocks
        if (hasColon == false) {
            match (token.kind) {
                case IDENTIFIER => genericParams.add(token)
                case COLON =>
                    hasColon = true
                    if (genericParams.isEmpty()) {
                        diagReport(DiagReportLevel.ERROR, attrTokens, "No generic parameters",
                            "Example: <param>: <values>'T: Int32, Int64'")
                    }
                case _ => ()
            }
        } else {
            match (token.kind) {
                case COMMA => ()
                case SEMI => ()
                case _ => replaceParams.add(token)
            }
            if (replaceParams.size == genericParams.size) {
                let values = ArrayList<(Token, Token)>()
                for (keyValue in genericParams |> zip(replaceParams)) {
                    values.add(keyValue)
                }
                allParams.add(values)
                replaceParams = ArrayList<Token>()
            }
        }
    }
    if (replaceParams.isEmpty() == false) {
        diagReport(DiagReportLevel.ERROR, attrTokens, "too many or too few parameters",
            "Example: <param>: <values>'T: Int32, Int64'")
    }
    return allParams
}

public macro Template(attrTokens: Tokens, inputTokens: Tokens) {
    var ret = quote()
    let allParams = getParams(attrTokens)
    for ((index, params) in enumerate(allParams)) {
        for (token in inputTokens) {
            let keyValFound = params |> filter {tuple => tuple[0].value == token.value} |> first
            match (keyValFound) {
                case Some((_, value)) => ret.append(value)
                case None => ret.append(token)
            }
        }
        if (index < allParams.size - 1) {
            if (let Some(token) <- (ret |> last)) {
                match (token.kind) {
                    case NL => ()
                    case _ => ret.append(Token(NL))
                }
            }
            ret.append(Token(NL))
        }
    }
    return ret
}
