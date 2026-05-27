macro package ctemplate

import std.ast.{diagReport, DiagReportLevel, Token, Tokens, TokenKind}
import std.collection.{ArrayList, enumerate, filter, first, last, zip}

/**
 * @brief Parses the macro attributes to extract template parameters.
 *
 * This function analyzes the attribute tokens to determine the generic
 * parameters and their corresponding replacement types.
 *
 * @param attrTokens The tokens provided in the macro attribute list.
 *
 * @return An ArrayList of parameter sets, where each set represents one
 *         overload to be generated.
 */
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

/**
 * @brief Generates code by replacing template parameters with concrete types.
 *
 * This macro mimics C++ templates. It takes a set of type parameters and
 * a block of code, then generates a copy of that code for each set of
 * replacement types provided.
 *
 * Example:
 * ```
 * @Template[T: Int32, Int64, Float32](
 * func getNum(n: T): T {
 *     // implementation
 * })
 * ```
 * This generates three functions: one for `Int32`, one for `Int64`, and one for `Float32`.
 *
 * @param attrTokens Tokens defining the template parameters and replacement types.
 * @param inputTokens The code block to be duplicated and parameterized.
 *
 * @return The generated tokens containing all the overloaded definitions.
 */
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
