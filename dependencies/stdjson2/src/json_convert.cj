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

package stdjson2

let digits100: Array<Byte> = [
    b'0',b'0',b'0',b'1',b'0',b'2',b'0',b'3',b'0',b'4',b'0',b'5',b'0',b'6',b'0',b'7',b'0',b'8',b'0',b'9', //00 ~ 09
    b'1',b'0',b'1',b'1',b'1',b'2',b'1',b'3',b'1',b'4',b'1',b'5',b'1',b'6',b'1',b'7',b'1',b'8',b'1',b'9', //10 ~ 19
    b'2',b'0',b'2',b'1',b'2',b'2',b'2',b'3',b'2',b'4',b'2',b'5',b'2',b'6',b'2',b'7',b'2',b'8',b'2',b'9', //20 ~ 29
    b'3',b'0',b'3',b'1',b'3',b'2',b'3',b'3',b'3',b'4',b'3',b'5',b'3',b'6',b'3',b'7',b'3',b'8',b'3',b'9', //30 ~ 39
    b'4',b'0',b'4',b'1',b'4',b'2',b'4',b'3',b'4',b'4',b'4',b'5',b'4',b'6',b'4',b'7',b'4',b'8',b'4',b'9', //40 ~ 49
    b'5',b'0',b'5',b'1',b'5',b'2',b'5',b'3',b'5',b'4',b'5',b'5',b'5',b'6',b'5',b'7',b'5',b'8',b'5',b'9', //50 ~ 59
    b'6',b'0',b'6',b'1',b'6',b'2',b'6',b'3',b'6',b'4',b'6',b'5',b'6',b'6',b'6',b'7',b'6',b'8',b'6',b'9', //60 ~ 69
    b'7',b'0',b'7',b'1',b'7',b'2',b'7',b'3',b'7',b'4',b'7',b'5',b'7',b'6',b'7',b'7',b'7',b'8',b'7',b'9', //70 ~ 79
    b'8',b'0',b'8',b'1',b'8',b'2',b'8',b'3',b'8',b'4',b'8',b'5',b'8',b'6',b'8',b'7',b'8',b'8',b'8',b'9', //80 ~ 89
    b'9',b'0',b'9',b'1',b'9',b'2',b'9',b'3',b'9',b'4',b'9',b'5',b'9',b'6',b'9',b'7',b'9',b'8',b'9',b'9'] //90 ~ 99

@OverflowWrapping
func uitoalen(num: UInt64): Int64 {
    var p: UInt64 = 10
    for (i in 1..19) {
        if (num < p) {
            return i
        }
        p = p * UInt64(10)
    }
    if (num >= 10000000000000000000) {
        return 20
    }
    return 19
}

@OverflowWrapping
func uitoa(num: UInt64, arr: Array<Byte>): Int64 {
    // inside make sure arr.size > len
    let len = uitoalen(num)
    var next = len - 1
    var value = num
    var i = 0
    while (value >= 100) {
        i = Int64((value % 100) * 2)
        value = value / 100
        arr[next] = digits100[i + 1]
        arr[next - 1] = digits100[i]
        next = next - 2
    }
    if (value < 10) {
        arr[next] = b'0' + UInt8(value)
    } else {
        i = Int64(value * 2)
        arr[next] = digits100[i + 1]
        arr[next - 1] = digits100[i]
    }
    return len
}
