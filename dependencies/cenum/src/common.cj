macro package cenum

import std.ast.{diagReport, DiagReportLevel, Token, TokenKind, Tokens, ToTokens}
import std.convert.Parsable
import std.math.abs

// cjlint-ignore -start !G.FUN.01 function should be less than 50 lines of code

private func enumBlockBegin(visibility: Token, name: Token, valueType: Token, addFlagOps!: Bool, ffi_c!: Bool): Tokens {
    let block = quote()
    if (ffi_c) {
        block.append(quote(@C
        $(visibility) struct $(name) {))
    } else {
        block.append(quote($(visibility) struct $(name) <: Hashable & Comparable<$(name)> {))
    }
    block.append(
        quote(
    public let value: $(valueType)

    public const init(enumVal: $(name)) {
        value = enumVal.value
    }

    public const init(value: $(valueType)) {
        this.value = value
    }

    public func hashCode(): Int64 {
        Int64(value)
    }

    public const func compare(right: $(name)): Ordering {
        if (value < right.value) {
            return LT
        }
        else if (value > right.value) {
            return GT
        }
        return EQ
    }

    public operator const func ==(right: $(name)): Bool {
        value == right.value
    }

    public operator const func !=(right: $(name)): Bool {
        value != right.value
    }

    public operator const func <(right: $(name)): Bool {
        value < right.value
    }

    public operator const func <=(right: $(name)): Bool {
        value <= right.value
    }

    public operator const func >(right: $(name)): Bool {
        value > right.value
    }

    public operator const func >=(right: $(name)): Bool {
        value >= right.value
    }
))
    if (addFlagOps) {
        block.append(
            quote(
    public const func set(right: $(name)): $(name) {
        $(name)(value | right.value)
    }

    public const func clear(right: $(name)): $(name) {
        $(name)(value & (!right.value))
    }

    public operator const func |(right: $(name)): $(name) {
        $(name)(value | right.value)
    }

    public operator const func &(right: $(name)): $(name) {
        $(name)(value & (!right.value))
    }

    public operator const func ^(right: $(name)): $(name) {
        $(name)(value ^ right.value)
    }

    public const func isSet(right: $(name)): Bool {
        (value & right.value) != 0
    }
))
    }
    return block
}

private func parseEnumValue(currentEnumIndex: Int32, tokenIt: Iterator<Token>): (Tokens, Int32) {
    let valueTokens = quote()
    var hasAssign = false
    while (let Some(token) <- tokenIt.next()) {
        if (hasAssign == false) {
            if (token.kind == ASSIGN) {
                hasAssign = true
                continue
            }
            if (token.kind == IDENTIFIER || token.kind == NL) {
                break
            }
            diagReport(DiagReportLevel.ERROR, token.toTokens(), "Invalid CEnum syntax",
                "Expected assignment, new line or another identifier.")
        } else {
            if (token.kind == NL) {
                break
            }
            valueTokens.append(token)
        }
    }
    if (valueTokens.size == 1 && valueTokens[0].kind == INTEGER_LITERAL) {
        return (valueTokens, Int32.parse(valueTokens[0].value))
    } else if (valueTokens.size == 2 && valueTokens[0].kind == SUB && valueTokens[1].kind == INTEGER_LITERAL) {
        return (valueTokens, -Int32.parse(valueTokens[1].value))
    } else if (valueTokens.size > 1) {
        return (valueTokens, currentEnumIndex)
    }
    return (quote(), currentEnumIndex)
}

private const ERROR_MSG = "Invalid CEnum syntax"
private const ERROR_HINT = "Syntax: CEnum[<Private|public|..> <Identifier> <type>]()\n" +
    "Example: CEnum[Seek](...),  CEnum[public Seek](...), CEnum[public Seek UInt32](...)"

func makeEnum(attrTokens: Tokens, inputTokens: Tokens, flagEnum!: Bool = false, startValue!: Int32 = 0,
    ffi_c!: Bool = false): Tokens {
    var visibility = Token(INTERNAL)
    var name = Token(IDENTIFIER)
    var valueType = Token(INT32)

    match (attrTokens.size) {
        case 1 => name = attrTokens[0]
        case 2 =>
            if (attrTokens[0].kind == IDENTIFIER) {
                name = attrTokens[0]
                valueType = attrTokens[1]
            } else {
                visibility = attrTokens[0]
                name = attrTokens[1]
            }
        case 3 =>
            visibility = attrTokens[0]
            name = attrTokens[1]
            valueType = attrTokens[2]
        case _ => diagReport(DiagReportLevel.ERROR, attrTokens, ERROR_MSG, ERROR_HINT)
    }

    if (visibility.kind != PRIVATE && visibility.kind != PROTECTED && visibility.kind != INTERNAL && visibility.kind !=
        PUBLIC) {
        diagReport(DiagReportLevel.ERROR, attrTokens, ERROR_MSG, ERROR_HINT)
    }
    if (name.kind != IDENTIFIER) {
        diagReport(DiagReportLevel.ERROR, attrTokens, ERROR_MSG, ERROR_HINT)
    }
    if (valueType.kind != INT8 && valueType.kind != INT16 && valueType.kind != INT32 && valueType.kind != INT64 &&
        valueType.kind != UINT8 && valueType.kind != UINT16 && valueType.kind != UINT32 && valueType.kind != UINT64 &&
        valueType.kind != INTNATIVE && valueType.kind != UINTNATIVE) {
        diagReport(DiagReportLevel.ERROR, attrTokens, ERROR_MSG, ERROR_HINT)
    }

    var enumQuote = enumBlockBegin(visibility, name, valueType, addFlagOps: flagEnum, ffi_c: ffi_c)
    var index = startValue
    var tokenIt = inputTokens.iterator()
    while (let Some(value) <- tokenIt.next()) {
        if (value.kind != IDENTIFIER) {
            continue
        }

        let (intTokens, newIndex) = parseEnumValue(index, tokenIt.iterator())
        index = newIndex
        if (intTokens.size == 0) {
            if (index >= 0) {
                intTokens.append(index.toTokens())
            } else {
                intTokens.append(Token(SUB))
                intTokens.append(abs(index).toTokens())
            }
        }

        enumQuote.append(quote(
            public static const $(value) = $(name)\($(intTokens)\)))

        if (index == 0 || flagEnum == false) {
            index++
        } else {
            index *= 2
        }
    }
    enumQuote.append(quote(
        }
    ))
    return enumQuote
}

// cjlint-ignore -end function should be less than 50 lines of code
