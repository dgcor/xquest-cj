macro package endian.utils

import std.ast.{Token, Tokens}

/**
 * @brief Macro to read data in the platform's native endianness.
 *
 * This macro expands to either a big-endian or little-endian read
 * operation depending on the target platform's architecture.
 *
 * @param attrTokens The object or buffer from which to read.
 * @param inputTokens The arguments for the read operation (e.g., offset or type).
 *
 * @return A token stream representing the appropriate read function call
 *         (`readBigEndian` or `readLittleEndian`).
 */
public macro ReadEndian(attrTokens: Tokens, inputTokens: Tokens) {
    match (Endian.Platform) {
        case Big => quote($(attrTokens).readBigEndian($(inputTokens)))
        case Little => quote($(attrTokens).readLittleEndian($(inputTokens)))
    }
}
