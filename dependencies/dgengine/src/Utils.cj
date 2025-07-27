package dgengine

import cjsfml.system.*
import ctemplate.*
import std.collection.*
import std.math.*

@Template[T: Int32, Int64, UInt32, UInt64](
public func clamp(v: T, min: T, max: T): T {
    if (v < min) {
        return min
    }
    else if (v > max) {
        return max
    }
    return v
})

@Template[T: Float32, Float64](
public func fmod(x: T, y: T): T {
    return x - trunc(x / y) * y
})

@Template[T: Float32, Float64](
public func modf(v: T): (int: T, fract: T) {
    let int = match (v >= 0.0) {
        case true => floor(v)
        case false => ceil(v)
    }
    let fract = v - int
    return (int, fract)
})

public func isObjEq<T>(obj1: T, obj2: T): Bool where T <: Any {
    match ((obj1 as Object, obj2 as Object)) {
        case (Some(obj1), Some(obj2)) => refEq(obj1, obj2)
        case _ => false
    }
}

extend<T> Array<T> where T <: NotEqual<T> {
    public func lastIndexNotOf(element: T): ?Int64 {
        for (index in size - 1..=0 : -1) {
            if (this[index] != element) {
                return index
            }
        }
        return None
    }
}

@Template[Container: Array, ArrayList](
extend<T> Container<T> {
    public mut prop back: T {
        get() {
            this[size - 1]
        }
        set(value) {
            this[size - 1] = value
        }
    }

    public mut prop front: T {
        get() {
            this[0]
        }
        set(value) {
            this[0] = value
        }
    }
})

@Template[T: Vector2f, Vector2i](
public func normalizeNumber(value: Int64, inputRange: T, outputRange: T): Int64 {
    if (inputRange.x > inputRange.y || outputRange.x > outputRange.y) {
        throw IllegalStateException("normalizeNumber: x > y ")
    }

    var val = match ((value, Int64(inputRange.x), Int64(inputRange.y))) {
        case (val, x, _) where val < x => x
        case (val, _, y) where val > y => y
        case (val, _, _) => val
    }

    let inputDiff = match (inputRange.x > inputRange.y) {
        case true => inputRange.x - inputRange.y
        case false => inputRange.y - inputRange.x
    }

    if (Int64(inputDiff) == 0) {
        return Int64(outputRange.x)
    }

    let outputDiff = match (outputRange.x > outputRange.y) {
        case true => outputRange.x - outputRange.y
        case false => outputRange.y - outputRange.x
    }

    val -= Int64(inputRange.x)
    val = Int64(round(Float64(val) * Float64(outputDiff) / Float64(inputDiff))) + Int64(outputRange.x)
    return val
})

public func removeEmptyLines(str: String): String {
    String.join(str.split("\n", removeEmpty: true), delimiter: "\n")
}

// positive - rotate left, negative - rotate right
public func rotate<T>(array: Array<T>, rotationCount: Int64): Unit where T <: Any {
    let size = array.size
    if (size <= 1) {
        return
    }

    var count = rotationCount % size
    if (count < 0) {
        count += size
    }
    if (count == 0) {
        return
    }

    array[0..count].reverse()
    array[count..size].reverse()
    array[0..size].reverse()
}

@Template[T, U: Float32, Int32 ; Float64, Int64](
public func round(num: T, digits: U): T {
    let fac = pow(10.0, digits)
    return round(num * fac) / fac
})

public func splitString(str: String, delimiters: String): Array<String> {
    let tokens = ArrayList<String>()
    var startIndex = 0

    while (startIndex < str.size) {
        // Find the next delimiter
        var delimiterIndex: ?Int64 = None

        for (delimiter in delimiters) {
            if (let Some(index) <- str.indexOf(delimiter, startIndex)) {
                if (delimiterIndex.isNone() || index < delimiterIndex.getOrThrow()) {
                    delimiterIndex = index
                }
            }
        }

        // If no delimiter is found, add the remaining substring
        if (let Some(delimiterIndex) <- delimiterIndex) {
            // Add the token found before the delimiter
            if (startIndex < delimiterIndex) {
                let token = str[startIndex..delimiterIndex]
                tokens.add(token)
            }
            // Move the start index past the delimiter
            startIndex = delimiterIndex + 1
        } else {
            // Add the last token if no more delimiters are found
            let token = str[startIndex..]
            tokens.add(token)
            break
        }
    }
    return tokens.toArray()
}

public func splitStringIn2(str: String, delimiter: String): (String, String) {
    if (let Some(pos) <- str.indexOf(delimiter)) {
        return (str[0..pos], str[pos + 1..])
    }
    return (str, "")
}

public func swap<T>(a: Box<T>, b: Box<T>): Unit where T <: Any {
    let temp = a.value
    a.value = b.value
    b.value = temp
}

public func toString(num: Float64): String {
    var str = num.toString().trimEnd("0")
    if (str.endsWith(".")) {
        str += "0"
    }
    return str
}

public func trim(str: String, chars!: String = " \t"): String {
    str.trimEnd(chars).trimStart(chars)
}

public func trimEnd(str: String, chars!: String = " \t"): String {
    str.trimEnd(chars)
}

public func trimStart(str: String, chars!: String = " \t"): String {
    str.trimStart(chars)
}

public func wordWrap(str: String, length: Int64): String {
    if (length < 0) {
        return str
    }
    let runes = str.toRuneArray()

    var index = 0
    var indexEnd = match (runes.lastIndexNotOf(r' ')) {
        case Some(index) => index + 1
        case None => runes.size
    }

    let strLength = indexEnd - index
    if (strLength <= length) {
        return str
    }

    var indexLastSpace = 0
    var distanceToWidth = 0

    while (index != indexEnd) {
        while (index != indexEnd && distanceToWidth <= length) {
            distanceToWidth++

            if (runes[index] == r' ') {
                indexLastSpace = index

                if (distanceToWidth == length) {
                    if (index + 1 != indexEnd) {
                        runes[indexLastSpace] = r'\n'
                        distanceToWidth = 0
                    }
                }
            }
            index++
        }

        if (indexLastSpace != 0) {
            if (distanceToWidth != length || index != indexEnd) {
                runes[indexLastSpace] = r'\n'
            }
        }

        distanceToWidth = clamp(index - indexLastSpace - 2, 0, length)
        indexLastSpace = 0
    }

    return String(runes)
}
