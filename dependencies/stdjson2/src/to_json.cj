/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * Copyright (c) causerp 2026. All rights reserved.
 *
 * This source file is derived from the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * Modified by causerp in 2026.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/**
 * @file
 *
 * This is a library for ToJson interface.
 */
package stdjson2

/**
 * This interface used for conversions JsonValue.
 */
public interface ToJson {
    /**
     * Convert DataModel to JsonValue.
     *
     * @return json-converted JsonValue.
     *
     * @throws JsonException if DataModel cannot be converted to JsonValue.
     */
    func toJson(): JsonValue
}
