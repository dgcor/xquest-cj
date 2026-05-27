macro package cenum

import std.ast.Tokens

/**
 * @brief Defines a standard enumeration.
 *
 * Generates an enum struct that implements `Hashable` and `Comparable`.
 * Values auto-increment starting from 0.
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro Enum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens)
}

/**
 * @brief Defines a C-compatible standard enumeration.
 *
 * Generates a C-compatible struct (`@C`) for use with FFI.
 * Values auto-increment starting from 0.
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro CEnum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, ffi_c: true)
}

/**
 * @brief Defines a flag (bitfield) enumeration.
 *
 * Generates an enum struct with bitwise operators (`|`, `&`, `^`, etc.).
 * Values auto-increment using bit shifting starting from 0 (0, 1, 2, 4, ...).
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro FlagEnum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true)
}

/**
 * @brief Defines a flag (bitfield) enumeration starting at 0.
 *
 * Similar to `FlagEnum`, explicitly starts the sequence at 0.
 * Values: 0, 1, 2, 4, ...
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro FlagEnum0(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true)
}

/**
 * @brief Defines a flag (bitfield) enumeration starting at 1.
 *
 * Generates a flag enum where the first value is 1.
 * Values: 1, 2, 4, 8, ...
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro FlagEnum1(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, startValue: 1)
}

/**
 * @brief Defines a C-compatible flag (bitfield) enumeration.
 *
 * Generates a C-compatible struct (`@C`) with bitwise operators.
 * Values auto-increment starting from 0.
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro CFlagEnum(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, ffi_c: true)
}

/**
 * @brief Defines a C-compatible flag (bitfield) enumeration starting at 0.
 *
 * Generates a C-compatible struct (`@C`) with bitwise operators.
 * Values: 0, 1, 2, 4, ...
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro CFlagEnum0(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, ffi_c: true)
}

/**
 * @brief Defines a C-compatible flag (bitfield) enumeration starting at 1.
 *
 * Generates a C-compatible struct (`@C`) with bitwise operators.
 * Values: 1, 2, 4, 8, ...
 *
 * @param attrTokens Tokens specifying visibility, name, and optional type.
 * @param inputTokens Tokens specifying the enum members.
 */
public macro CFlagEnum1(attrTokens: Tokens, inputTokens: Tokens) {
    makeEnum(attrTokens, inputTokens, flagEnum: true, startValue: 1, ffi_c: true)
}
