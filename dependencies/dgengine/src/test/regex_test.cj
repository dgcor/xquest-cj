package dgengine.test

import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestRegex {
    @TestCase
    func test_constructor_default() {
        let regex = Regex()

        @Expect(regex.isValid, false)
        @Expect(regex.matcher(""), false)
        @Expect(regex.matcher("123"), false)
        @Expect(regex.matcher("test"), false)
    }

    @TestCase
    func test_constructor_valid_regex() {
        let regex = Regex(#"\d+"#)

        @Expect(regex.isValid, true)
        @Expect(regex.matcher(""), false)
        @Expect(regex.matcher("123"), true)
        @Expect(regex.matcher("test"), false)
    }

    @TestCase
    func test_constructor_invalid_regex() {
        let regex = Regex(#"[\d+"#)

        @Expect(regex.isValid, false)
        @Expect(regex.matcher(""), false)
        @Expect(regex.matcher("123"), false)
        @Expect(regex.matcher("test"), false)
    }

    @TestCase
    func test_matchPattern() {
        @Expect(Regex.matchPattern("\\d+", ""), false)
        @Expect(Regex.matchPattern("\\d+", "123"), true)
        @Expect(Regex.matchPattern("\\d+", "test"), false)
    }

    @TestCase
    func test_matchPattern_invalid() {
        @Expect(Regex.matchPattern("", ""), false)
        @Expect(Regex.matchPattern("", "test"), false)
        @Expect(Regex.matchPattern("[\\d+", ""), false)
        @Expect(Regex.matchPattern("[\\d+", "123"), false)
    }

    @TestCase
    func test_regexes() {
        @Expect(Regex.matchPattern("\\d+", ""), false)
        @Expect(Regex.matchPattern("\\d+", "123"), true)
        @Expect(Regex.matchPattern("\\d+", " 123 "), false)
        @Expect(Regex.matchPattern("\\d+", "-123"), false)
        @Expect(Regex.matchPattern("-?\\d+", "123"), true)
        @Expect(Regex.matchPattern("-?\\d+", "-123"), true)
        @Expect(Regex.matchPattern("\\D+", "test"), true)
        @Expect(Regex.matchPattern("\\D+", "test1"), false)
        @Expect(Regex.matchPattern("\\s+\\d+\\s+", " 123\t"), true)
        @Expect(Regex.matchPattern("\\w+", "test"), true)
        @Expect(Regex.matchPattern("\\w+", ""), false)
        @Expect(Regex.matchPattern("\\w+", "abzdefghijklmnopqrstuvwxyz"), true)
        @Expect(Regex.matchPattern("[a-zA-Z]*", "Testing"), true)
        @Expect(Regex.matchPattern("[a-zA-Z]*", ""), true)
        @Expect(Regex.matchPattern("[^abc]+", "a test"), false)
        @Expect(Regex.matchPattern("[^abc]+", "1 test"), true)
        @Expect(Regex.matchPattern(".*esting", "\tTesting"), true)
        @Expect(Regex.matchPattern(".*esting", "esting"), true)
        @Expect(Regex.matchPattern(".+", "àêíöÙ"), true)
    }
}

// cjlint-ignore -end function names should be lower camel case
