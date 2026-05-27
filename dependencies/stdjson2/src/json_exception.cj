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
 * This file introduces JsonException class.
 */
package stdjson2

/**
 * JsonException class.
 */
public class JsonException <: Exception {
    /**
     * Create a new JsonException instance.
     */
    public init() {
        super()
    }

    /**
     * Create a new JsonException instance.
     * Construction with parameters.
     *
     * @param message exception message.
     */
    public init(message: String) {
        super(message)
    }

    /**
     * Get class name.
     *
     * @return class name.
     */
    protected override func getClassName(): String {
        return "JsonException"
    }
}
