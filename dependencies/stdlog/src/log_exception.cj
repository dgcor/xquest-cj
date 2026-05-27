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

package stdlog

public open class LogException <: Exception {
    public init() {}
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "LogException"
    }
}
