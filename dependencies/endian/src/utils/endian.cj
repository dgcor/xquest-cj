macro package endian.utils

import std.ast.*

public macro ReadEndian(attrTokens: Tokens, inputTokens: Tokens) {
    match (Endian.Platform) {
        case Big => quote($(attrTokens).readBigEndian($(inputTokens)))
        case Little => quote($(attrTokens).readLittleEndian($(inputTokens)))
    }
}
