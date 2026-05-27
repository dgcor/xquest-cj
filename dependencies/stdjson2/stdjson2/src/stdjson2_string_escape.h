/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

#ifndef STDJSON2_STRING_ESCAPE_H
#define STDJSON2_STRING_ESCAPE_H

#include <stdint.h>
#include <stdbool.h>

int64_t StdJson2_ReplaceEscapeChar(const uint8_t* input, int64_t inputlen, uint8_t* buffer, bool htmlSafe);

int64_t StdJson2_WriteBufferAppendInt(uint8_t* buffer, const int64_t num);

int64_t StdJson2_StringEscapeCharNumGet(const uint8_t* input, int64_t strlen, bool htmlSafe);

int64_t StdJson2_WriteBufferAppendUint(uint8_t* buffer, const uint64_t num);

#endif