package dgengine.test

import dgengine.*
import std.collection.*
import std.math.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestFormula {
    @TestCase
    func test_init() {
        let formula = Formula()

        @Expect(formula.empty, true)
        @Expect(formula.eval(), 0.0)
    }

    @TestCase
    func test_init_invalid() {
        let formula = Formula("text")

        @Expect(formula.empty, false)
        @Expect(formula.eval(), 0.0)
        @Expect(formula.toString(), "text")
    }

    @TestCase
    func test_init_valid() {
        let formula = Formula("2.00 + 2 ")

        @Expect(formula.empty, false)
        @Expect(formula.eval(), 4.0)
        @Expect(formula.toString(), "2.0 + 2.0")
    }

    @TestCase
    func test_evalMaxString() {
        @Expect(Formula.evalMaxString(":rnd 0"), 0.0)
        @Expect(Formula.evalMaxString(":rnd 10"), 9.0)
        @Expect(Formula.evalMaxString(":rndf 0"), 0.0)
        @Expect(Formula.evalMaxString(":rndf 10"), 9.0)
        @Expect(Formula.evalMaxString(":rndn 0"), 0.0)
        @Expect(Formula.evalMaxString(":rndn 10"), 10.0)
    }

    @TestCase
    func test_evalMinString() {
        @Expect(Formula.evalMinString(":rnd 0"), 0.0)
        @Expect(Formula.evalMinString(":rnd 10"), 0.0)
        @Expect(Formula.evalMinString(":rndf 0"), 0.0)
        @Expect(Formula.evalMinString(":rndf 10"), 0.0)
        @Expect(Formula.evalMinString(":rndn 0"), 0.0)
        @Expect(Formula.evalMinString(":rndn 10"), 0.0)
    }

    @TestCase
    func test_evalString_basic_math() {
        // +, -, *, /, %, ^
        @Expect(Formula.evalString("2 + 2"), 4.0)
        @Expect(Formula.evalString("2 + -3"), -1.0)
        @Expect(Formula.evalString("-2.5 * 10"), -25.0)
        @Expect(Formula.evalString("-2.5 / 10"), -0.25)
        @Expect(Formula.evalString("2 / 0"), 2.0)
        @Expect(Formula.evalString("-2.5 / 0"), -2.5)
        @Expect(Formula.evalString("3 % 2"), 1.0)
        @Expect(Formula.evalString("3 :mod 2"), 1.0)
        @Expect(Formula.evalString("-2.5 % 2"), -0.5)
        @Expect(Formula.evalString("10 ^ 3"), 1000.0)
        @Expect(Formula.evalString("10 :pow 3"), 1000.0)
        @Expect(Formula.evalString("10^6 + 5.5"), 1000005.5)
    }

    @TestCase
    func test_evalString_parentheses() {
        // parentheses force order of operations
        @Expect(Formula.evalString("2 + 2 * 4 / 5"), 3.2)
        @Expect(Formula.evalString("2 + ((2 * 4) / 5)"), 3.6)
        @Expect(Formula.evalString("2 + ((((((2 * 4) / 5)"), 3.6)
        @Expect(Formula.evalString("2 + ((2 * 4) / 5)))))"), 3.6)
    }

    @TestCase
    func test_evalString_operator_override() {
        // operators override the previous one
        @Expect(Formula.evalString("2 * -4"), -2.0)
        @Expect(Formula.evalString("2 * -4"), -2.0)
        @Expect(Formula.evalString("2 :max -4"), -2.0)
    }

    @TestCase
    func test_evalString_no_op() {
        // no op = +
        @Expect(Formula.evalString("2 3"), 5.0)
    }

    @TestCase
    func test_evalString_min_max_operations() {
        // :min, :max, :nvl, :neg, :negz, :pos, :posz
        @Expect(Formula.evalString("2 :min 5"), 2.0)
        @Expect(Formula.evalString("(-6) :min (-2)"), -6.0)

        @Expect(Formula.evalString("2 :max 5"), 5.0)
        @Expect(Formula.evalString("(-6) :max (-2)"), -2.0)

        @Expect(Formula.evalString("2 :nvl 5"), 2.0)
        @Expect(Formula.evalString("0 :nvl 5"), 5.0)
        @Expect(Formula.evalString("2 :zero 5"), 2.0)
        @Expect(Formula.evalString("0 :zero 5"), 5.0)

        @Expect(Formula.evalString("2 :neg 5"), 2.0)
        @Expect(Formula.evalString("0 :neg 5"), 0.0)
        @Expect(Formula.evalString("-2 :neg 5"), 5.0)

        @Expect(Formula.evalString("2 :negz 5"), 2.0)
        @Expect(Formula.evalString("0 :negz 5"), 5.0)
        @Expect(Formula.evalString("-2 :negz 5"), 5.0)

        @Expect(Formula.evalString("2 :pos 5"), 5.0)
        @Expect(Formula.evalString("0 :pos 5"), 0.0)
        @Expect(Formula.evalString("-2 :pos 5"), -2.0)

        @Expect(Formula.evalString("2 :posz 5"), 5.0)
        @Expect(Formula.evalString("0 :posz 5"), 5.0)
        @Expect(Formula.evalString("-2 :posz 5"), -2.0)
    }

    @TestCase
    func test_eval_random_int() {
        let formula = Formula(":rnd 4")

        let hist = HashMap<Int64, Int64>()
        for (_ in 0..100) {
            let val = Int64(formula.eval())
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.contains(-1), false)
        @Expect(hist.contains(0), true)
        @Expect(hist.contains(4), true)
        @Expect(hist.contains(5), false)

        @Expect(hist[0] > 2)
        @Expect(hist[1] > 2)
        @Expect(hist[2] > 2)
        @Expect(hist[3] > 2)
        @Expect(hist[4] > 2)

        @Expect(Formula.evalString(":rnd(5)") >= 0.0)
        @Expect(Formula.evalString(":rnd(0)"), 0.0)
        @Expect(Formula.evalString(":rnd(-5)"), 0.0)
    }

    @TestCase
    func test_eval_random_float() {
        let formula = Formula(":rndf 4")

        for (_ in 0..10) {
            let val = formula.eval()
            @Expect(val >= 0.0)
            @Expect(val < 4.0)
        }

        @Expect(Formula.evalString(":rndf(5)") >= 0.0)
        @Expect(Formula.evalString(":rndf(0)"), 0.0)
        @Expect(Formula.evalString(":rndf(-5)"), 0.0)
    }

    @TestCase
    func test_eval_random_normal_distribution() {
        let formula = Formula(":rndn 4")

        let hist = HashMap<Int64, Int64>()
        for (_ in 0..1000) {
            let val = Int64(round(formula.eval()))
            if (hist.addIfAbsent(val, 1).isSome()) {
                hist[val]++
            }
        }

        @Expect(hist.contains(-1), false)
        @Expect(hist.contains(0), true)
        @Expect(hist.contains(1), true)
        @Expect(hist.contains(2), true)
        @Expect(hist.contains(3), true)
        @Expect(hist.contains(4), true)
        @Expect(hist.contains(5), false)

        @Expect(hist[0] < hist[1])
        @Expect(hist[1] < hist[2])
        @Expect(hist[2] > hist[3])
        @Expect(hist[3] > hist[4])

        @Expect(Formula.evalString(":rndn(5)") >= 0.0)
        @Expect(Formula.evalString(":rndn(0)"), 0.0)
        @Expect(Formula.evalString(":rndn(-5)"), 0.0)
    }

    @TestCase
    func test_evalString_random_static() {
        @Expect(Formula.evalString(":rnd(5)", randomNum: -1), 4.0)
        @Expect(Formula.evalString(":rnd(5)", randomNum: -2), 0.0)
        @Expect(Formula.evalString(":rnd(5)", randomNum: 10), 10.0)
        @Expect(Formula.evalString(":rnd(0)", randomNum: 20), 20.0)
        @Expect(Formula.evalString(":rnd(-5)", randomNum: 30), 30.0)

        @Expect(Formula.evalString(":rndf(5)", randomNum: -1), 4.0)
        @Expect(Formula.evalString(":rndf(5)", randomNum: -2), 0.0)
        @Expect(Formula.evalString(":rndf(5)", randomNum: 10), 10.0)
        @Expect(Formula.evalString(":rndf(0)", randomNum: 20), 20.0)
        @Expect(Formula.evalString(":rndf(-5)", randomNum: 30), 30.0)

        @Expect(Formula.evalString(":rndn(5)", randomNum: -1), 5.0)
        @Expect(Formula.evalString(":rndn(5)", randomNum: -2), 0.0)
        @Expect(Formula.evalString(":rndn(5)", randomNum: 10), 10.0)
        @Expect(Formula.evalString(":rndn(0)", randomNum: 20), 20.0)
        @Expect(Formula.evalString(":rndn(-5)", randomNum: 30), 30.0)

        @Expect(Formula(":rnd(5)").eval("0") >= 0.0)
        @Expect(Formula(":rnd(5)").eval("20"), 20.0)
        @Expect(Formula(":rnd(5)").eval("-3"), 0.0)
        @Expect(Formula(":rnd(5)").eval("min"), 0.0)
        @Expect(Formula(":rnd(5)").eval("max"), 4.0)
    }

    @TestCase
    func test_evalString_round_operations() {
        // :abs, :ceil, :floor, :trunc, :round
        @Expect(Formula.evalString(":abs 5"), 5.0)
        @Expect(Formula.evalString(":abs (-2)"), 2.0)

        @Expect(Formula.evalString(":ceil 5.2"), 6.0)
        @Expect(Formula.evalString(":ceil 5.6"), 6.0)
        @Expect(Formula.evalString(":ceil (-2.2)"), -2.0)
        @Expect(Formula.evalString(":ceil (-2.6)"), -2.0)

        @Expect(Formula.evalString(":floor 5.2"), 5.0)
        @Expect(Formula.evalString(":floor 5.6"), 5.0)
        @Expect(Formula.evalString(":floor (-2.2)"), -3.0)
        @Expect(Formula.evalString(":floor (-2.6)"), -3.0)

        @Expect(Formula.evalString(":trunc 5.2"), 5.0)
        @Expect(Formula.evalString(":trunc 5.6"), 5.0)
        @Expect(Formula.evalString(":trunc (-2.2)"), -2.0)
        @Expect(Formula.evalString(":trunc (-2.6)"), -2.0)

        @Expect(Formula.evalString(":round 5.2"), 5.0)
        @Expect(Formula.evalString(":round 5.6"), 6.0)
        @Expect(Formula.evalString(":round (-2.2)"), -2.0)
        @Expect(Formula.evalString(":round (-2.6)"), -3.0)
    }

    @TestCase
    func test_evalString_math_operations() {
        // :log, :ln, :sqrt, :cos, :sin, :tan
        @Expect(Formula.evalString(":log 1"), 0.0)
        @Expect(round(Formula.evalString(":log 2"), 2), 0.30)
        @Expect(round(Formula.evalString(":log 3"), 2), 0.48)
        @Expect(Formula.evalString(":log 0"), -Float64.Inf)
        // @Expect(Formula.evalString(":log (-1)"), Float64.NaN)

        @Expect(Formula.evalString(":ln 1"), 0.0)
        @Expect(round(Formula.evalString(":ln 2"), 2), 0.69)
        @Expect(round(Formula.evalString(":ln 3"), 2), 1.1)
        @Expect(Formula.evalString(":ln 0"), -Float64.Inf)
        // @Expect(Formula.evalString(":ln (-1)"), Float64.NaN)

        @Expect(Formula.evalString(":cos 0"), 1.0)
        @Expect(round(Formula.evalString(":cos 1"), 2), 0.54)
        @Expect(round(Formula.evalString(":cos (-1)"), 2), 0.54)
        @Expect(round(Formula.evalString(":cos (-100)"), 2), 0.86)
        @Expect(round(Formula.evalString(":cos (3.1415 / 3)"), 2), 0.5)

        @Expect(Formula.evalString(":sin 0"), 0.0)
        @Expect(round(Formula.evalString(":sin 1"), 2), 0.84)
        @Expect(round(Formula.evalString(":sin (-1)"), 2), -0.84)
        @Expect(round(Formula.evalString(":sin (-100)"), 2), 0.51)
        @Expect(round(Formula.evalString(":sin (3.1415 / 6)"), 2), 0.5)

        @Expect(Formula.evalString(":tan 0"), 0.0)
        @Expect(round(Formula.evalString(":tan 1"), 2), 1.56)
        @Expect(round(Formula.evalString(":tan (-1)"), 2), -1.56)
        @Expect(round(Formula.evalString(":tan (-100)"), 2), 0.59)
        @Expect(round(Formula.evalString(":tan (3.1415 / 4)"), 2), 1.0)
    }

    @TestCase
    func test_toString() {
        @Expect(Formula("-2").toString(), "- 2.0")
        @Expect(Formula("2+2").toString(), "2.0 + 2.0")
        @Expect(Formula("2 * -4").toString(), "2.0 * - 4.0")
        @Expect(Formula("2 :max -4").toString(), "2.0 :max - 4.0")
        @Expect(Formula("2+((2*4)/5").toString(), "2.0 + ((2.0 * 4.0) / 5.0)")
        @Expect(Formula("2+((2*4)/5)").toString(), "2.0 + ((2.0 * 4.0) / 5.0)")
        @Expect(Formula("2+((2*4)/5))").toString(), "2.0 + ((2.0 * 4.0) / 5.0)")
        @Expect(Formula("2+((((((2*4)/5))").toString(), "2.0 + ((((((2.0 * 4.0) / 5.0)))))")
        @Expect(Formula("2+((2*4)/5))))))").toString(), "2.0 + ((2.0 * 4.0) / 5.0)")
        @Expect(Formula("1 + 2 - 3 * 4 / 5 % 6 :mod 7 ^ 1 :pow 2").toString(), "1.0 + 2.0 - 3.0 * 4.0 / 5.0 % 6.0 % 7.0 ^ 1.0 ^ 2.0")
        @Expect(Formula("1 :min 2 :max 3 :zero 4 :nvl 5 neg 6 :negz 7").toString(), "1.0 :min 2.0 :max 3.0 :nvl 4.0 :nvl 5.0 neg 6.0 :negz 7.0")
        @Expect(Formula("1 :pos 2 :posz 3 :rnd 4 :rndf 5 :rndn 6 :abs 7").toString(), "1.0 :pos 2.0 :posz 3.0 :rnd 4.0 :rndf 5.0 :rndn 6.0 :abs 7.0")
        @Expect(Formula("1 :ceil 2 :floor 3 :trunc 4 :round 5 :log 6 :ln 7").toString(), "1.0 :ceil 2.0 :floor 3.0 :trunc 4.0 :round 5.0 :log 6.0 :ln 7.0")
        @Expect(Formula("1 :sqrt 2 :cos 3 :sin 4 :tan 5").toString(), "1.0 :sqrt 2.0 :cos 3.0 :sin 4.0 :tan 5.0")
    }
}

// cjlint-ignore -end function names should be lower camel case
