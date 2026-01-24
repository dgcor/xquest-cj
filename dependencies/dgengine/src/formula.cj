package dgengine

import std.collection.*
import std.convert.*
import std.math.*

public enum FormulaElement {
    | FormulaNone
    | FormulaDouble(Float64)
    | FormulaString(String)
    | FormulaAdd
    | FormulaSubtract
    | FormulaMultiply
    | FormulaDivide
    | FormulaModulo
    | FormulaPower
    | FormulaMin
    | FormulaMax
    | FormulaNvl
    | FormulaNegative
    | FormulaNegativeOr0
    | FormulaPositive
    | FormulaPositiveOr0
    | FormulaRand
    | FormulaRandFloat
    | FormulaRandNormalDist
    | FormulaAbs
    | FormulaCeil
    | FormulaFloor
    | FormulaTrunc
    | FormulaRound
    | FormulaLog
    | FormulaLn
    | FormulaSqrt
    | FormulaCos
    | FormulaSin
    | FormulaTan
    | FormulaLeftBracket
    | FormulaRightBracket

    public static func get(token: String): FormulaElement {
        if (token.isEmpty() == true) {
            return FormulaNone
        }
        if (token.size == 1 || token.startsWith(":")) {
            match (token) {
                case "+" => return FormulaAdd
                case "-" => return FormulaSubtract
                case "*" => return FormulaMultiply
                case "/" => return FormulaDivide
                case "%" => return FormulaModulo
                case ":mod" => return FormulaModulo
                case "^" => return FormulaPower
                case ":pow" => return FormulaPower
                case ":min" => return FormulaMin
                case ":max" => return FormulaMax
                case ":nvl" => return FormulaNvl
                case ":zero" => return FormulaNvl
                case ":neg" => return FormulaNegative
                case ":negz" => return FormulaNegativeOr0
                case ":pos" => return FormulaPositive
                case ":posz" => return FormulaPositiveOr0
                case ":rnd" => return FormulaRand
                case ":rndf" => return FormulaRandFloat
                case ":rndn" => return FormulaRandNormalDist
                case ":abs" => return FormulaAbs
                case ":ceil" => return FormulaCeil
                case ":floor" => return FormulaFloor
                case ":trunc" => return FormulaTrunc
                case ":round" => return FormulaRound
                case ":log" => return FormulaLog
                case ":ln" => return FormulaLn
                case ":sqrt" => return FormulaSqrt
                case ":cos" => return FormulaCos
                case ":sin" => return FormulaSin
                case ":tan" => return FormulaTan
                case "(" => return FormulaLeftBracket
                case ")" => return FormulaRightBracket
                case _ where token.isAsciiBlank() => return FormulaNone
                case _ => ()
            }
        }
        if (let Some(num) <- Float64.tryParse(token)) {
            return FormulaDouble(num)
        }
        FormulaString(token)
    }
}

public class FormulaElementIterator <: Iterator<FormulaElement> {
    private let m_formula: String
    private var m_bufferStart: Int64 = 0
    private var m_bufferSize: Int64 = 0
    private var m_index: Int64 = 0
    private static const M_DELIMITERS = " +-*/^:()"

    public init(formula: String) {
        m_formula = formula
    }

    public func next(): Option<FormulaElement> {
        if (m_index < 0) {
            return None
        }
        // tokenize formula
        while (m_index < m_formula.size) {
            let c = m_formula[m_index]
            if (M_DELIMITERS.indexOf(c).isSome()) {
                if (m_bufferSize > 0) {
                    let element = FormulaElement.get(m_formula[m_bufferStart..m_bufferStart + m_bufferSize])
                    m_bufferSize = 0
                    return element
                }
                if (Rune(c) == r':') {
                    m_bufferStart = m_index
                    m_bufferSize = 1
                } else {
                    m_bufferStart = m_index + 1
                    m_bufferSize = 0
                    if (Rune(c) != r' ') {
                        let element = FormulaElement.get(m_formula[m_index..m_index + 1])
                        m_index++
                        return element
                    }
                }
            } else {
                m_bufferSize++
            }
            m_index++
        }
        if (m_bufferSize > 0) {
            let element = FormulaElement.get(m_formula[m_bufferStart..m_bufferStart + m_bufferSize])
            m_bufferSize = 0
            return element
        }
        m_index = -1
        return None
    }
}

// use brackets to force order
// ex: 2 + 2 * 4 = 16
// ex: 2 + (2 * 4) = 10
// ex: 2 - :abs(-10) = -8
// ops:
// +        add
// -        Subtract
// *        Multiply
// /        Divide
// %        Modulo
// :mod     Modulo
// ^        Power
// :pow     Power
// :min     Min (ex: (2 + 2) :min 10 = 4)
// :max     Max (ex: (2 + 2) :max 10 = 10)
// :zero    null value
// :nvl     null value (ex: (2 - 2) :nvl 10 = 10 | (2 - 1) :nvl 10 = 1)
// :neg     negative value (ex: (2 - 3) :neg 10 = 10 | (2 - 1) :neg 10 = 1)
// :negz    negative or zero value (ex: (2 - 2) :negz 10 = 10 | (2 - 1) :negz 10 = 1)
// :pos     positive value (ex: (2 - 1) :pos 10 = 10 | (2 - 3) :pos 10 = -1)
// :posz    positive or zero value (ex: (2 - 2) :posz 10 = 10 | (2 - 3) :posz 10 = -1)
// :rnd     random number (ex: :rnd(10) = 0 to 10)
// :rndf    random number (ex: :rnd(10) = 0.0 to 9.9)
// :rndn    normal distribution random number (ex: :rnd(10) = 0 to 10)
// :abs     absolute value
// :ceil    round value up
// :floor   round value down
// :trunc   round value towards 0
// :round   round value
// :log     common logarithm
// :ln      natural logarithm
// :sqrt    square root
// :cos     cosine
// :sin     sine
// :tan     tangent
public class Formula <: ToString {
    private var m_elements: ArrayList<FormulaElement> = ArrayList<FormulaElement>()

    public init() {}

    public init(formula: String) {
        // create internal formula
        var brackets = 0
        for (element in FormulaElementIterator(formula)) {
            match (element) {
                case FormulaNone => continue
                case FormulaLeftBracket => brackets++
                case FormulaRightBracket where brackets > 0 => brackets--
                case FormulaRightBracket => continue
                case _ => ()
            }
            m_elements.add(element)
        }
        // remove trailing closing brackets (faster eval, same result)
        while (m_elements.isEmpty() == false) {
            let lastIndex = m_elements.size - 1
            match (m_elements[lastIndex]) {
                case FormulaRightBracket => m_elements.remove(at: lastIndex)
                case _ => break
            }
        }
    }

    protected static func evalIterator(it: Iterator<FormulaElement>, queryA: ?Queryable, queryB: ?Queryable,
        randomNum!: Int32): Float64 {
        var val = 0.0
        var currUnaryOp = FormulaNone
        var currBinaryOp = FormulaAdd
        while (let Some(elem) <- it.next()) {
            var val2 = 0.0
            match (elem) {
                case FormulaDouble(value) => val2 = value
                case FormulaString(propName) =>
                    if (propName.isEmpty() == false) {
                        if (propName.startsWith('$') == false) {
                            if (let Some(queryVal) <- (queryA?.getNumber(propName) ?? None)) {
                                val2 = queryVal.getDouble()
                            }
                        } else {
                            if (let Some(queryVal) <- (queryB?.getNumber(propName[1..]) ?? None)) {
                                val2 = queryVal.getDouble()
                            }
                        }
                    }
                case FormulaLeftBracket => val2 = evalIterator(it, queryA, queryB, randomNum: randomNum)
                case FormulaRightBracket => return val
                case _ =>
                    while (true) {
                        match (elem) {
                            case FormulaAdd => ()
                            case FormulaSubtract => ()
                            case FormulaMultiply => ()
                            case FormulaDivide => ()
                            case FormulaModulo => ()
                            case FormulaPower => ()
                            case FormulaMin => ()
                            case FormulaMax => ()
                            case FormulaNvl => ()
                            case FormulaNegative => ()
                            case FormulaNegativeOr0 => ()
                            case FormulaPositive => ()
                            case FormulaPositiveOr0 => ()
                            case _ =>
                                currUnaryOp = elem
                                break
                        }
                        currBinaryOp = elem
                        currUnaryOp = FormulaNone
                        break
                    }
                    continue
            }
            match (currUnaryOp) {
                case FormulaRand | FormulaRandFloat => match (randomNum) {
                    case 0 =>
                        if (val2 > 0.0) {
                            match (currUnaryOp) {
                                case FormulaRand => val2 = Float64(Random.get(UInt32(val2)))
                                case FormulaRandFloat => val2 = Random.getf(val2)
                                case _ => ()
                            }
                        } else {
                            val2 = 0.0
                        }
                    case -1 => val2 = max(0.0, val2 - 1.0)
                    case _ where randomNum < -1 => val2 = 0.0
                    case _ => val2 = Float64(randomNum)
                }
                case FormulaRandNormalDist => match (randomNum) {
                    case 0 =>
                        if (val2 > 0.0) {
                            val2 = round(RandomNormal.getRange(val2))
                        } else {
                            val2 = 0.0
                        }
                    case -1 => val2 = max(0.0, val2)
                    case _ where randomNum < -1 => val2 = 0.0
                    case _ => val2 = Float64(randomNum)
                }
                case FormulaAbs => val2 = abs(val2)
                case FormulaCeil => val2 = ceil(val2)
                case FormulaFloor => val2 = floor(val2)
                case FormulaTrunc => val2 = trunc(val2)
                case FormulaRound => val2 = round(val2)
                case FormulaLog => val2 = log10(val2)
                case FormulaLn => val2 = log(val2)
                case FormulaSqrt => val2 = sqrt(val2)
                case FormulaCos => val2 = cos(val2)
                case FormulaSin => val2 = sin(val2)
                case FormulaTan => val2 = tan(val2)
                case _ => ()
            }
            match (currBinaryOp) {
                case FormulaAdd => val = val + val2
                case FormulaSubtract => val = val - val2
                case FormulaMultiply => val = val * val2
                case FormulaDivide where val2 != 0.0 => val = val / val2
                case FormulaModulo where val2 != 0.0 => val = fmod(val, val2)
                case FormulaPower => val = val ** val2
                case FormulaMin => val = min(val, val2)
                case FormulaMax => val = max(val, val2)
                case FormulaNvl where val == 0.0 => val = val2
                case FormulaNegative where val < 0.0 => val = val2
                case FormulaNegativeOr0 where val <= 0.0 => val = val2
                case FormulaPositive where val > 0.0 => val = val2
                case FormulaPositiveOr0 where val >= 0.0 => val = val2
                case _ => ()
            }
        }
        return val
    }

    protected func evalMinMax(queryA: ?Queryable, queryB: ?Queryable, minMaxNum: String): Float64 {
        let randomNum: Int32 = match (minMaxNum) {
            case "" | "0" => 0
            case "max" => -1
            case "min" => -2
            case _ => Int32.tryParse(minMaxNum) ?? 0
        }
        return evalIterator(m_elements.iterator(), queryA, queryB, randomNum: randomNum)
    }

    public prop empty: Bool {
        get() {
            m_elements.isEmpty()
        }
    }

    // randomNum - random number to use
    // randomNum > 0 -> use given number (ex: :rnd(10) = randomNum)
    // randomNum = 0 -> disabled (ex: :rnd(10) = 0-9)
    // randomNum = -1 -> max - 1  (ex: :rnd(10) = 9)
    // randomNum <= -2 -> 0        (ex: :rnd(10) = 0)
    public func eval(randomNum!: Int32 = 0): Float64 {
        evalIterator(m_elements.iterator(), None, None, randomNum: randomNum)
    }

    public func eval(query: Queryable, randomNum!: Int32 = 0): Float64 {
        evalIterator(m_elements.iterator(), query, query, randomNum: randomNum)
    }

    public func eval(queryA: Queryable, queryB: Queryable, randomNum!: Int32 = 0): Float64 {
        evalIterator(m_elements.iterator(), queryA, queryB, randomNum: randomNum)
    }

    // minMaxNum - string_view with random number to use
    // minMaxNum > 0 -> use given number (ex: :rnd(10) = randomNum)
    // minMaxNum = 0 -> disabled (ex: :rnd(10) = 0-9)
    // minMaxNum = max -> max - 1  (ex: :rnd(10) = 9)
    // minMaxNum = min -> 0        (ex: :rnd(10) = 0)
    public func eval(minMaxNum: String): Float64 {
        evalMinMax(None, None, minMaxNum)
    }

    public func eval(query: Queryable, minMaxNum: String): Float64 {
        evalMinMax(query, query, minMaxNum)
    }

    public func eval(queryA: Queryable, queryB: Queryable, minMaxNum: String): Float64 {
        evalMinMax(queryA, queryB, minMaxNum)
    }

    public static func evalString(formula: String, randomNum!: Int32 = 0): Float64 {
        evalIterator(FormulaElementIterator(formula), None, None, randomNum: randomNum)
    }

    public static func evalString(formula: String, query: Queryable, randomNum!: Int32 = 0): Float64 {
        evalIterator(FormulaElementIterator(formula), query, query, randomNum: randomNum)
    }

    public static func evalString(formula: String, queryA: Queryable, queryB: Queryable, randomNum!: Int32 = 0): Float64 {
        evalIterator(FormulaElementIterator(formula), queryA, queryB, randomNum: randomNum)
    }

    public static func evalMinString(formula: String): Float64 {
        evalString(formula, randomNum: -2)
    }

    public static func evalMinString(formula: String, query: Queryable): Float64 {
        evalString(formula, query, randomNum: -2)
    }

    public static func evalMinString(formula: String, queryA: Queryable, queryB: Queryable): Float64 {
        evalString(formula, queryA, queryB, randomNum: -2)
    }

    public static func evalMaxString(formula: String): Float64 {
        evalString(formula, randomNum: -1)
    }

    public static func evalMaxString(formula: String, query: Queryable): Float64 {
        evalString(formula, query, randomNum: -1)
    }

    public static func evalMaxString(formula: String, queryA: Queryable, queryB: Queryable): Float64 {
        evalString(formula, queryA, queryB, randomNum: -1)
    }

    public func toString(): String {
        let str = StringBuilder()
        var brackets = 0
        for (elem in m_elements) {
            match (elem) {
                case FormulaDouble(value) => str.append("${toString(value)} ")
                case FormulaString(value) => str.append("${value} ")
                case FormulaAdd => str.append("+ ")
                case FormulaSubtract => str.append("- ")
                case FormulaMultiply => str.append("* ")
                case FormulaDivide => str.append("/ ")
                case FormulaModulo => str.append("% ")
                case FormulaPower => str.append("^ ")
                case FormulaMin => str.append(":min ")
                case FormulaMax => str.append(":max ")
                case FormulaNvl => str.append(":nvl ")
                case FormulaNegative => str.append(":neg ")
                case FormulaNegativeOr0 => str.append(":negz ")
                case FormulaPositive => str.append(":pos ")
                case FormulaPositiveOr0 => str.append(":posz ")
                case FormulaRand => str.append(":rnd ")
                case FormulaRandFloat => str.append(":rndf ")
                case FormulaRandNormalDist => str.append(":rndn ")
                case FormulaAbs => str.append(":abs ")
                case FormulaCeil => str.append(":ceil ")
                case FormulaFloor => str.append(":floor ")
                case FormulaTrunc => str.append(":trunc ")
                case FormulaRound => str.append(":round ")
                case FormulaLog => str.append(":log ")
                case FormulaLn => str.append(":ln ")
                case FormulaSqrt => str.append(":sqrt ")
                case FormulaCos => str.append(":cos ")
                case FormulaSin => str.append(":sin ")
                case FormulaTan => str.append(":tan ")
                case FormulaLeftBracket =>
                    str.append("(")
                    brackets++
                case FormulaRightBracket where brackets > 0 =>
                    str.append(") ")
                    brackets--
                case _ => ()
            }
        }
        for (_ in 0..brackets) {
            str.append(")")
        }
        return str.toString().replace(" )", ")").replace("  ", " ").trimAsciiEnd()
    }
}
