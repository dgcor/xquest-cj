package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.convert.*
import std.unittest.*

@Test
class TestUtils {
    @TestCase
    func normalizeNumber_no_range() {
        let inputRange = Vector2i(0, 0)
        var outputRange = Vector2i(100, 100)

        @Expect(normalizeNumber(-1, inputRange, outputRange), 100)
        @Expect(normalizeNumber(0, inputRange, outputRange), 100)
        @Expect(normalizeNumber(100, inputRange, outputRange), 100)
        @Expect(normalizeNumber(200, inputRange, outputRange), 100)

        outputRange.y = 200

        @Expect(normalizeNumber(-1, inputRange, outputRange), 100)
        @Expect(normalizeNumber(0, inputRange, outputRange), 100)
        @Expect(normalizeNumber(100, inputRange, outputRange), 100)
        @Expect(normalizeNumber(200, inputRange, outputRange), 100)
    }

    @TestCase
    func normalizeNumber_positive_range() {
        let inputRange = Vector2i(0, 100)
        let outputRange = Vector2i(1000, 2000)

        @Expect(normalizeNumber(-1, inputRange, outputRange), 1000)
        @Expect(normalizeNumber(0, inputRange, outputRange), 1000)
        @Expect(normalizeNumber(25, inputRange, outputRange), 1250)
        @Expect(normalizeNumber(50, inputRange, outputRange), 1500)
        @Expect(normalizeNumber(75, inputRange, outputRange), 1750)
        @Expect(normalizeNumber(100, inputRange, outputRange), 2000)
        @Expect(normalizeNumber(200, inputRange, outputRange), 2000)
    }

    @TestCase
    func normalizeNumber_negative_input_range() {
        let inputRange = Vector2i(-100, -50)
        let outputRange = Vector2i(1000, 2000)

        @Expect(normalizeNumber(-200, inputRange, outputRange), 1000)
        @Expect(normalizeNumber(-100, inputRange, outputRange), 1000)
        @Expect(normalizeNumber(-75, inputRange, outputRange), 1500)
        @Expect(normalizeNumber(-50, inputRange, outputRange), 2000)
        @Expect(normalizeNumber(-10, inputRange, outputRange), 2000)
    }

    @TestCase
    func normalizeNumber_negative_output_range() {
        let inputRange = Vector2i(0, 100)
        let outputRange = Vector2i(-2000, -1000)

        @Expect(normalizeNumber(-1, inputRange, outputRange), -2000)
        @Expect(normalizeNumber(0, inputRange, outputRange), -2000)
        @Expect(normalizeNumber(50, inputRange, outputRange), -1500)
        @Expect(normalizeNumber(100, inputRange, outputRange), -1000)
        @Expect(normalizeNumber(200, inputRange, outputRange), -1000)
    }

    @TestCase
    func normalizeNumber_negative_input_and_output_range() {
        let inputRange = Vector2i(-100, -50)
        let outputRange = Vector2i(-2000, -1000)

        @Expect(normalizeNumber(-200, inputRange, outputRange), -2000)
        @Expect(normalizeNumber(-100, inputRange, outputRange), -2000)
        @Expect(normalizeNumber(-75, inputRange, outputRange), -1500)
        @Expect(normalizeNumber(-50, inputRange, outputRange), -1000)
        @Expect(normalizeNumber(-10, inputRange, outputRange), -1000)
    }

    @TestCase
    func normalizeNumber_float_range() {
        let inputRange = Vector2f(0.0, 100.0)
        let outputRange = Vector2f(10.5, 20.5)

        @Expect(normalizeNumber(-1, inputRange, outputRange), 10)
        @Expect(normalizeNumber(0, inputRange, outputRange), 10)
        @Expect(normalizeNumber(50, inputRange, outputRange), 15)
        @Expect(normalizeNumber(100, inputRange, outputRange), 20)
        @Expect(normalizeNumber(200, inputRange, outputRange), 20)
    }

    @TestCase
    func removeEmptyLines() {
        @Expect(removeEmptyLines(""), "")
        @Expect(removeEmptyLines("test"), "test")
        @Expect(removeEmptyLines("test\ntest"), "test\ntest")
        @Expect(removeEmptyLines("test\n\ntest"), "test\ntest")
        @Expect(removeEmptyLines("\ntest\ntest\n"), "test\ntest")
        @Expect(removeEmptyLines("\ntest\n\ntest\n"), "test\ntest")
        @Expect(removeEmptyLines("\n\ntest\n\ntest\n\n"), "test\ntest")
        @Expect(removeEmptyLines("\r\n"), "\r")
        @Expect(removeEmptyLines("\n\n\n"), "")
    }

    @TestCase
    func string_replace() {
        let str = "this is a test string"
        @Expect(str.replace("test ", ""), "this is a string")
        @Expect(str.replace("test", "new"), "this is a new string")
        @Expect(str.replace(" ", "_"), "this_is_a_test_string")
        @Expect(str.replace("is ", ""), "tha test string")
        @Expect(str.replace("", ""), str)
        // @Expect(str.replace("", "new"), str)
        @Expect(str.replace("  ", ""), str)
        @Expect(str.replace("IS", ""), str)
        @Expect(str.replace("notFound", "found"), str)
        @Expect("".replace("notFound", "found"), "")
    }

    @TestCase
    func test_rotate_left_1() {
        let array: Array<Int64> = [1, 2, 3, 4, 5]
        let array2: Array<Int64> = [2, 3, 4, 5, 1]
        rotate(array, 1)
        @Expect(array, array2)
    }

    @TestCase
    func test_rotate_right_1() {
        let array: Array<Int64> = [1, 2, 3, 4, 5]
        let array2: Array<Int64> = [5, 1, 2, 3, 4]
        rotate(array, -1)
        @Expect(array, array2)
    }

    @TestCase
    func test_rotate_left_4() {
        let array: Array<Int64> = [1, 2, 3, 4, 5]
        let array2: Array<Int64> = [5, 1, 2, 3, 4]
        rotate(array, 4)
        @Expect(array, array2)
    }

    @TestCase
    func test_rotate_right_4() {
        let array: Array<Int64> = [1, 2, 3, 4, 5]
        let array2: Array<Int64> = [2, 3, 4, 5, 1]
        rotate(array, -4)
        @Expect(array, array2)
    }

    @TestCase
    func test_rotate_range() {
        let array: Array<Int64> = [1, 2, 3, 4, 5]
        let array2: Array<Int64> = [1, 3, 4, 2, 5]
        rotate(array[1..4], 1)
        @Expect(array, array2)
    }

    @TestCase
    func round_float() {
        @Expect(round(0.0f32, 0i32), 0.0f32)
        @Expect(round(0.0f32, 2i32), 0.0f32)
        @Expect(round(-1.0f32, 0i32), -1.0f32)
        @Expect(round(-1.0f32, 2i32), -1.0f32)
        @Expect(round(123.0f32, 0i32), 123.0f32)
        @Expect(round(123.0f32, 2i32), 123.0f32)
        @Expect(round(-123.0f32, 0i32), -123.0f32)
        @Expect(round(-123.0f32, 2i32), -123.0f32)
        @Expect(round(123.4447f32, 2i32), 123.44f32)
        @Expect(round(-123.4447f32, 2i32), -123.44f32)
        @Expect(round(123.4467f32, 2i32), 123.45f32)
        @Expect(round(-123.4467f32, 2i32), -123.45f32)
    }

    @TestCase
    func round_double() {
        @Expect(round(-123.4464321f64, 4i64), -123.4464f64)
        @Expect(round(-9876543.4464321f64, 0i64), -9876543.0f64)
        @Expect(round(-9876543.4464321f64, 1i64), -9876543.4f64)
        @Expect(round(-9876543.4464321f64, 4i64), -9876543.4464f64)
    }

    @TestCase
    func splitString() {
        @Expect(splitString("",               "."), [])
        @Expect(splitString(".",              "."), [])
        @Expect(splitString("..",             "."), [])
        @Expect(splitString(" .. ",           "."), [" ", " "])
        @Expect(splitString("  ",             "."), ["  "])
        @Expect(splitString("test..",         "."), ["test"])
        @Expect(splitString("test.string",    "."), ["test", "string"])
        @Expect(splitString("test.string.",   "."), ["test", "string"])
        @Expect(splitString("test..string",   "."), ["test", "string"])
        @Expect(splitString("test.string.\n", "."), ["test", "string", "\n"])
        @Expect(splitString("\n.test.string", "."), ["\n", "test", "string"])
        @Expect(splitString("test. ",         "."), ["test", " "])
        @Expect(splitString(" .test",         "."), [" ", "test"])
        @Expect(splitString("test.string",    " "), ["test.string"])
        @Expect(splitString("\n \n \n",       " "), ["\n", "\n", "\n"])
    }

    @TestCase
    func splitStringIn2() {
        @Expect(splitStringIn2("",             ".") == ("", ""))
        @Expect(splitStringIn2(".",            ".") == ("", ""))
        @Expect(splitStringIn2("..",           ".") == ("", "."))
        @Expect(splitStringIn2("...",          ".") == ("", ".."))
        @Expect(splitStringIn2("  ",           ".") == ("  ", ""))
        @Expect(splitStringIn2("test.string",  ".") == ("test", "string"))
        @Expect(splitStringIn2("test.",        ".") == ("test", ""))
        @Expect(splitStringIn2("test..",       ".") == ("test", "."))
        @Expect(splitStringIn2("test..string", ".") == ("test", ".string"))
        @Expect(splitStringIn2("test. ",       ".") == ("test", " "))
        @Expect(splitStringIn2("test",         ".") == ("test", ""))
        @Expect(splitStringIn2("..test",       ".") == ("", ".test"))
        @Expect(splitStringIn2("test.string",  " ") == ("test.string", ""))
    }

    @TestCase
    func strToNumber() {
        @Expect(Int8.parse("0"), 0)
        @Expect(Int8.parse("127"), 127)
        @Expect(Int8.parse("-127"), -127)
        @ExpectThrows[IllegalArgumentException](Int8.parse("256"))
        @Expect(UInt8.parse("1"), 1)
        @Expect(UInt8.parse("255"), 255)
        @ExpectThrows[IllegalArgumentException](UInt8.parse("256"))
        @Expect(Int32.parse("98765432"), 98765432)
        @Expect(Int32.parse("-98765432"), -98765432)
        @ExpectThrows[IllegalArgumentException](Int32.parse("9876543210"))
        @Expect(UInt32.parse("98765432"), 98765432)
        @ExpectThrows[IllegalArgumentException](UInt32.parse("9876543210"))
        @Expect(Int64.parse("9876543210"), 9876543210)
        @Expect(Int64.parse("-9876543210"), -9876543210)
        @Expect(UInt64.parse("98765432109876"), 98765432109876)
        @ExpectThrows[IllegalArgumentException](UInt64.parse("98765432109876000000"))
        @Expect(Float32.parse("0.0"), 0.0)
        @Expect(Float32.parse(".1"), 0.1)
        @Expect(Float32.parse("1234.5678"), 1234.5678)
        @Expect(Float32.parse("-1234.5678"), -1234.5678)
        @Expect(Float64.parse("9876543210.123"), 9876543210.123)
        @Expect(Float64.parse("-9876543210.123"), -9876543210.123)
    }

    @TestCase
    func strToNumberOpt() {
        @Expect(Int8.tryParse("0").isSome(), true)
        @Expect(Int8.tryParse("256").isSome(), false)
        @Expect(UInt8.tryParse("1").isSome(), true)
        @Expect(UInt8.tryParse("256").isSome(), false)
        @Expect(Int32.tryParse("98765432").isSome(), true)
        @Expect(Int32.tryParse("9876543210").isSome(), false)
        @Expect(UInt32.tryParse("98765432").isSome(), true)
        @Expect(UInt32.tryParse("9876543210").isSome(), false)
        @Expect(Int64.tryParse("9876543210").isSome(), true)
        @Expect(Int64.tryParse("98765432109876000000").isSome(), false)
        @Expect(UInt64.tryParse("98765432109876").isSome(), true)
        @Expect(UInt64.tryParse("98765432109876000000").isSome(), false)
    }

    @TestCase
    func toLower() {
        @Expect("".toAsciiLower(), "")
        @Expect(" ".toAsciiLower(), " ")
        @Expect(".".toAsciiLower(), ".")
        @Expect("test".toAsciiLower(), "test")
        @Expect("TEST".toAsciiLower(), "test")
        @Expect(" TEST ".toAsciiLower(), " test ")
        @Expect("áèîöu".toAsciiLower(), "áèîöu")
        @Expect("ÁÈÎÖU".toAsciiLower(), "ÁÈÎÖu")
    }

    @TestCase
    func Float64_toString() {
        @Expect(toString(0.0), "0.0")
        @Expect(toString(-1.0), "-1.0")
        @Expect(toString(987654.0), "987654.0")
        @Expect(toString(-123456789.87654), "-123456789.87654")
    }

    @TestCase
    func Int32_toString() {
        @Expect((0i32).toString(), "0")
        @Expect((-1i32).toString(), "-1")
        @Expect((987654i32).toString(), "987654")
        @Expect((-123456789i32).toString(), "-123456789")
    }

    @TestCase
    func Int64_toString() {
        @Expect((0i64).toString(), "0")
        @Expect((-1i64).toString(), "-1")
        @Expect((987654i64).toString(), "987654")
        @Expect((-123456789i64).toString(), "-123456789")
    }

    @TestCase
    func UInt32_toString() {
        @Expect((0u32).toString(), "0")
        @Expect((1u32).toString(), "1")
        @Expect((987654u32).toString(), "987654")
        @Expect((123456789u32).toString(), "123456789")
    }

    @TestCase
    func UInt64_toString() {
        @Expect((0u64).toString(), "0")
        @Expect((1u64).toString(), "1")
        @Expect((987654u64).toString(), "987654")
        @Expect((123456789u64).toString(), "123456789")
    }

    @TestCase
    func toUpper() {
        @Expect("".toAsciiUpper(), "")
        @Expect(" ".toAsciiUpper(), " ")
        @Expect(".".toAsciiUpper(), ".")
        @Expect("test".toAsciiUpper(), "TEST")
        @Expect("TEST".toAsciiUpper(), "TEST")
        @Expect(" TEST ".toAsciiUpper(), " TEST ")
        @Expect("áèîöu".toAsciiUpper(), "áèîöU")
        @Expect("ÁÈÎÖU".toAsciiUpper(), "ÁÈÎÖU")
    }

    @TestCase
    func trim() {
        @Expect(trim(""), "")
        @Expect(trim("", chars: ""), "")
        @Expect(trim(" "), "")
        @Expect(trim(" ", chars: ""), " ")
        @Expect(trim("  "), "")
        @Expect(trim("\t"), "")
        @Expect(trim(" \t"), "")
        @Expect(trim("\t \t\t\t  "), "")
        @Expect(trim("\t \t\t\t  ", chars: "\t"), " \t\t\t  ")
        @Expect(trim("  \t \t\t\t", chars: "\t"), "  \t ")
        @Expect(trim("test string"), "test string")
        @Expect(trim(" test string"), "test string")
        @Expect(trim("test string "), "test string")
        @Expect(trim(" test string "), "test string")
        @Expect(trim("  test string  "), "test string")
        @Expect(trim("\ttest string"), "test string")
        @Expect(trim("test string\t"), "test string")
        @Expect(trim("\ttest string\t"), "test string")
        @Expect(trim("\t\ttest string\t\t"), "test string")
        @Expect(trim("__ test string __", chars: "_"), " test string ")
        @Expect(trim("__ test string __", chars: "__"), " test string ")
        @Expect(trim("__ test string __", chars: "___"), " test string ")
    }

    @TestCase
    func trimEnd() {
        @Expect(trimEnd(""), "")
        @Expect(trimEnd("", chars: ""), "")
        @Expect(trimEnd(" "), "")
        @Expect(trimEnd(" ", chars: ""), " ")
        @Expect(trimEnd("  "), "")
        @Expect(trimEnd("\t"), "")
        @Expect(trimEnd(" \t"), "")
        @Expect(trimEnd("\t \t\t\t  "), "")
        @Expect(trimEnd("\t \t\t\t  ", chars: "\t"), "\t \t\t\t  ")
        @Expect(trimEnd("  \t \t\t\t", chars: "\t"), "  \t ")
        @Expect(trimEnd("test string"), "test string")
        @Expect(trimEnd(" test string"), " test string")
        @Expect(trimEnd("test string "), "test string")
        @Expect(trimEnd(" test string "), " test string")
        @Expect(trimEnd("  test string  "), "  test string")
        @Expect(trimEnd("\ttest string"), "\ttest string")
        @Expect(trimEnd("test string\t"), "test string")
        @Expect(trimEnd("\ttest string\t"), "\ttest string")
        @Expect(trimEnd("\t\ttest string\t\t"), "\t\ttest string")
        @Expect(trimEnd("__ test string __", chars: "_"), "__ test string ")
        @Expect(trimEnd("__ test string __", chars: "__"), "__ test string ")
        @Expect(trimEnd("__ test string __", chars: "___"), "__ test string ")
    }

    @TestCase
    func trimStart() {
        @Expect(trimStart(""), "")
        @Expect(trimStart("", chars: ""), "")
        @Expect(trimStart(" "), "")
        @Expect(trimStart(" ", chars: ""), " ")
        @Expect(trimStart("  "), "")
        @Expect(trimStart("\t"), "")
        @Expect(trimStart(" \t"), "")
        @Expect(trimStart("\t \t\t\t  "), "")
        @Expect(trimStart("\t \t\t\t  ", chars: "\t"), " \t\t\t  ")
        @Expect(trimStart("  \t \t\t\t", chars: "\t"), "  \t \t\t\t")
        @Expect(trimStart("test string"), "test string")
        @Expect(trimStart(" test string"), "test string")
        @Expect(trimStart("test string "), "test string ")
        @Expect(trimStart(" test string "), "test string ")
        @Expect(trimStart("  test string  "), "test string  ")
        @Expect(trimStart("\ttest string"), "test string")
        @Expect(trimStart("test string\t"), "test string\t")
        @Expect(trimStart("\ttest string\t"), "test string\t")
        @Expect(trimStart("\t\ttest string\t\t"), "test string\t\t")
        @Expect(trimStart("__ test string __", chars: "_"), " test string __")
        @Expect(trimStart("__ test string __", chars: "__"), " test string __")
        @Expect(trimStart("__ test string __", chars: "___"), " test string __")
    }

    @TestCase
    func wordWrap() {
        let str = "This is a very long string to test the word wrap algorithm."

        @Expect(wordWrap(str, -1), str)
        @Expect(wordWrap(str, 0), "This\nis\na\nvery\nlong\nstring\nto\ntest\nthe\nword\nwrap\nalgorithm.")
        @Expect(wordWrap(str, 1), "This\nis\na\nvery\nlong\nstring\nto\ntest\nthe\nword\nwrap\nalgorithm.")
        @Expect(wordWrap(str, 20), "This is a very long\nstring to test the\nword wrap\nalgorithm.")
        @Expect(wordWrap(str, str.size - 1), "This is a very long string to test the word wrap\nalgorithm.")
        @Expect(wordWrap(str, str.size), str)
        @Expect(wordWrap(str, str.size + 1), str)
        @Expect(wordWrap(str, str.size + 10), str)
        @Expect(wordWrap("test string", 4), "test\nstring")
        @Expect(wordWrap(" test string", 4), " test\nstring")
        @Expect(wordWrap("\ttest string", 4), "\ttest\nstring")
        @Expect(wordWrap("test", -1), "test")
        @Expect(wordWrap("t e s t", -1), "t e s t")
        @Expect(wordWrap("t e s t", 0), "t\ne\ns\nt")
        @Expect(wordWrap("t e s t", 1), "t\ne\ns\nt")
        @Expect(wordWrap("t e s t", 2), "t\ne\ns\nt")
        @Expect(wordWrap("t e s t ", 2), "t\ne\ns\nt ")
        @Expect(wordWrap("t e s t  ", 2), "t\ne\ns\nt  ")
        @Expect(wordWrap("t e s t   ", 2), "t\ne\ns\nt   ")
        @Expect(wordWrap("t e s t    ", 2), "t\ne\ns\nt    ")
        @Expect(wordWrap(" t e s t", 2), " t\ne\ns\nt")
        @Expect(wordWrap("  t e s t", 2), " \nt\ne\ns\nt")
        @Expect(wordWrap("   t e s t", 2), " \n t\ne\ns\nt")
        @Expect(wordWrap("    t e s t", 2), " \n \nt\ne\ns\nt")
        @Expect(wordWrap("t e s t", 3), "t e\ns t")
    }
}
