macro package cenum

import std.ast.Tokens

public macro Enum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens)
}

public macro CEnum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, ffi_c: true)
}

public macro FlagEnum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true)
}

public macro FlagEnum0(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true)
}

public macro FlagEnum1(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, startValue: 1)
}

public macro CFlagEnum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, ffi_c: true)
}

public macro CFlagEnum0(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, ffi_c: true)
}

public macro CFlagEnum1(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, startValue: 1, ffi_c: true)
}
