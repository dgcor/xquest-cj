package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import std.convert.*
import std.math.*

public class GameUtils {
    public static const doubleClickDelay: Int32 = 500

    public static func FPSToTime(fps: Int32): Time {
        var fps2: Float32 = match (Float32(fps)) {
            case value where value < 1.0 => 1.0
            case value where value > 1000.0 => 1000.0
            case value => value
        }
        return Time(seconds: 1.0 / fps2)
    }

    public static func getAlignmentPosition(position: Vector2f, size: Vector2f, horizAlign: HorizontalAlign,
        vertAlign: VerticalAlign): Vector2f {
        var drawPos = position
        match (horizAlign) {
            case AlignLeft => ()
            case AlignCenter => drawPos.x -= round(size.x / 2.0)
            case AlignRight => drawPos.x -= size.x
        }
        match (vertAlign) {
            case AlignBottom => ()
            case AlignCenter => drawPos.y -= round(size.y / 2.0)
            case AlignTop => drawPos.y -= size.y
        }
        return drawPos
    }

    public static func getPrimitiveType(str: String, default!: PrimitiveType = PrimitiveType.TriangleFan): PrimitiveType {
        match (str.toAsciiLower()) {
            case "points" => PrimitiveType.Points
            case "lines" => PrimitiveType.Lines
            case "linestrip" => PrimitiveType.LineStrip
            case "triangles" => PrimitiveType.Triangles
            case "trianglestrip" => PrimitiveType.TriangleStrip
            case "trianglefan" => PrimitiveType.TriangleFan
            case _ => default
        }
    }

    public static func getKeyCode(num: Int32, default!: KeyCode = KeyCode.Unknown): KeyCode {
        if (num >= 0 && num <= 9) {
            return KeyCode(KeyCode.Num0.value + num)
        }
        return default
    }

    public static func getKeyCode(str: String, default!: KeyCode = KeyCode.Unknown): KeyCode {
        match (str.size) {
            case 0 => default
            case 1 => match (str.runes().next()) {
                case Some(ch) where ch >= r'A' && ch <= r'Z' => KeyCode(
                    KeyCode.A.value + Int32(UInt32(ch)) - Int32(UInt32(r'A')))
                case Some(ch) where ch >= r'a' && ch <= r'z' => KeyCode(
                    KeyCode.A.value + Int32(UInt32(ch)) - Int32(UInt32(r'a')))
                case Some(ch) where ch >= r'0' && ch <= r'9' => KeyCode(
                    KeyCode.Num0.value + Int32(UInt32(ch)) - Int32(UInt32(r'0')))
                case Some(r'[') => KeyCode.LBracket
                case Some(r']') => KeyCode.RBracket
                case Some(r';') => KeyCode.Semicolon
                case Some(r',') => KeyCode.Comma
                case Some(r'.') => KeyCode.Period
                case Some(r"'") => KeyCode.Apostrophe
                case Some(r'\\') => KeyCode.Backslash
                case Some(r'~') => KeyCode.Grave
                case Some(r'=') => KeyCode.Equal
                case Some(r' ') => KeyCode.Space
                case Some(r'+') => KeyCode.Add
                case Some(r'-') => KeyCode.Subtract
                case Some(r'*') => KeyCode.Multiply
                case Some(r'/') => KeyCode.Divide
                case _ => default
            }
            case _ => match (str.toAsciiLower()) {
                case "all" | "any" => KeyCode.Count
                case "esc" | "escape" => KeyCode.Escape
                case "lcontrol" => KeyCode.LControl
                case "lshift" => KeyCode.LShift
                case "lalt" => KeyCode.LAlt
                case "lsystem" => KeyCode.LSystem
                case "rcontrol" => KeyCode.RControl
                case "rshift" => KeyCode.RShift
                case "ralt" => KeyCode.RAlt
                case "rsystem" => KeyCode.RSystem
                case "menu" => KeyCode.Menu
                case "leftbracket" => KeyCode.LBracket
                case "rightbracket" => KeyCode.RBracket
                case "semicolon" => KeyCode.Semicolon
                case "comma" => KeyCode.Comma
                case "period" => KeyCode.Period
                case "apostrophe" | "quote" => KeyCode.Apostrophe
                case "slash" => KeyCode.Slash
                case "backslash" => KeyCode.Backslash
                case "grave" | "tilde" => KeyCode.Grave
                case "equal" => KeyCode.Equal
                case "dash" | "hyphen" => KeyCode.Hyphen
                case "space" => KeyCode.Space
                case "enter" | "return" => KeyCode.Enter
                case "backspace" => KeyCode.Backspace
                case "tab" => KeyCode.Tab
                case "pageup" => KeyCode.PageUp
                case "pagedown" => KeyCode.PageDown
                case "end" => KeyCode.End
                case "home" => KeyCode.Home
                case "insert" => KeyCode.Insert
                case "delete" => KeyCode.Delete
                case "add" => KeyCode.Add
                case "subtract" => KeyCode.Subtract
                case "multiply" => KeyCode.Multiply
                case "divide" => KeyCode.Divide
                case "left" => KeyCode.Left
                case "right" => KeyCode.Right
                case "up" => KeyCode.Up
                case "down" => KeyCode.Down
                case "numpad0" => KeyCode.Numpad0
                case "numpad1" => KeyCode.Numpad1
                case "numpad2" => KeyCode.Numpad2
                case "numpad3" => KeyCode.Numpad3
                case "numpad4" => KeyCode.Numpad4
                case "numpad5" => KeyCode.Numpad5
                case "numpad6" => KeyCode.Numpad6
                case "numpad7" => KeyCode.Numpad7
                case "numpad8" => KeyCode.Numpad8
                case "numpad9" => KeyCode.Numpad9
                case "f1" => KeyCode.F1
                case "f2" => KeyCode.F2
                case "f3" => KeyCode.F3
                case "f4" => KeyCode.F4
                case "f5" => KeyCode.F5
                case "f6" => KeyCode.F6
                case "f7" => KeyCode.F7
                case "f8" => KeyCode.F8
                case "f9" => KeyCode.F9
                case "f10" => KeyCode.F10
                case "f11" => KeyCode.F11
                case "f12" => KeyCode.F12
                case "f13" => KeyCode.F13
                case "f14" => KeyCode.F14
                case "f15" => KeyCode.F15
                case "pause" => KeyCode.Pause
                case _ => default
            }
        }
    }

    public static func getScanCode(num: Int32, default!: Scancode = Scancode.Unknown): Scancode {
        if (num == 0) {
            return Scancode.Num0
        }
        if (num >= 1 && num <= 9) {
            return Scancode(Scancode.Num1.value + num - 1)
        }
        return default
    }

    public static func getScanCode(str: String, default!: Scancode = Scancode.Unknown): Scancode {
        match (str.size) {
            case 0 => default
            case 1 => match (str.runes().next()) {
                case Some(ch) where ch >= r'A' && ch <= r'Z' => Scancode(
                    Scancode.A.value + Int32(UInt32(ch)) - Int32(UInt32(r'A')))
                case Some(ch) where ch >= r'a' && ch <= r'z' => Scancode(
                    Scancode.A.value + Int32(UInt32(ch)) - Int32(UInt32(r'a')))
                case Some(ch) where ch >= r'1' && ch <= r'9' => Scancode(
                    Scancode.Num1.value + Int32(UInt32(ch)) - Int32(UInt32(r'1')))
                case Some(r'0') => Scancode.Num0
                case Some(r'[') => Scancode.LBracket
                case Some(r']') => Scancode.RBracket
                case Some(r';') => Scancode.Semicolon
                case Some(r',') => Scancode.Comma
                case Some(r'.') => Scancode.Period
                case Some(r"'") => Scancode.Apostrophe
                case Some(r'\\') => Scancode.Backslash
                case Some(r'`') | Some(r'~') => Scancode.Grave
                case Some(r'=') => Scancode.Equal
                case Some(r' ') => Scancode.Space
                case Some(r'+') => Scancode.Equal
                case Some(r'-') => Scancode.Hyphen
                case Some(r'/') => Scancode.Slash
                case _ => default
            }
            case _ => match (str.toAsciiLower()) {
                case "all" | "any" => Scancode.Count
                case "esc" | "escape" => Scancode.Escape
                case "lcontrol" => Scancode.LControl
                case "lshift" => Scancode.LShift
                case "lalt" => Scancode.LAlt
                case "lsystem" => Scancode.LSystem
                case "rcontrol" => Scancode.RControl
                case "rshift" => Scancode.RShift
                case "ralt" => Scancode.RAlt
                case "rsystem" => Scancode.RSystem
                case "menu" => Scancode.Menu
                case "leftbracket" => Scancode.LBracket
                case "rightbracket" => Scancode.RBracket
                case "semicolon" => Scancode.Semicolon
                case "comma" => Scancode.Comma
                case "period" => Scancode.Period
                case "apostrophe" | "quote" => Scancode.Apostrophe
                case "slash" => Scancode.Slash
                case "backslash" => Scancode.Backslash
                case "tilde" => Scancode.Grave
                case "equal" => Scancode.Equal
                case "hyphen" => Scancode.Hyphen
                case "space" => Scancode.Space
                case "enter" | "return" => Scancode.Enter
                case "backspace" => Scancode.Backspace
                case "tab" => Scancode.Tab
                case "pageup" => Scancode.PageUp
                case "pagedown" => Scancode.PageDown
                case "end" => Scancode.End
                case "home" => Scancode.Home
                case "insert" => Scancode.Insert
                case "delete" => Scancode.Delete
                case "add" => Scancode.Equal
                case "subtract" => Scancode.Hyphen
                case "divide" => Scancode.Slash
                case "left" => Scancode.Left
                case "right" => Scancode.Right
                case "up" => Scancode.Up
                case "down" => Scancode.Down
                case "numpad0" => Scancode.Numpad0
                case "numpad1" => Scancode.Numpad1
                case "numpad2" => Scancode.Numpad2
                case "numpad3" => Scancode.Numpad3
                case "numpad4" => Scancode.Numpad4
                case "numpad5" => Scancode.Numpad5
                case "numpad6" => Scancode.Numpad6
                case "numpad7" => Scancode.Numpad7
                case "numpad8" => Scancode.Numpad8
                case "numpad9" => Scancode.Numpad9
                case "f1" => Scancode.F1
                case "f2" => Scancode.F2
                case "f3" => Scancode.F3
                case "f4" => Scancode.F4
                case "f5" => Scancode.F5
                case "f6" => Scancode.F6
                case "f7" => Scancode.F7
                case "f8" => Scancode.F8
                case "f9" => Scancode.F9
                case "f10" => Scancode.F10
                case "f11" => Scancode.F11
                case "f12" => Scancode.F12
                case "f13" => Scancode.F13
                case "f14" => Scancode.F14
                case "f15" => Scancode.F15
                case "pause" => Scancode.Pause
                case _ => default
            }
        }
    }

    public static func getScanCodeDescription(str: String): String {
        let scancode = getScanCode(str, default: Scancode.Unknown)
        return Keyboard.getDescription(scancode)
    }

    // total time to seconds
    private static func getTimeS(time: Time, roundUp!: Bool): Float32 {
        if (roundUp == true) {
            return ceil(time.seconds)
        } else {
            return floor(time.seconds)
        }
    }

    // total time to seconds and milliseconds
    private static func getTimeSf(time: Time): (seconds: Float32, milliseconds: Float32) {
        let (seconds, milliseconds) = modf(time.seconds)
        return (seconds, abs(milliseconds))
    }

    // total time to minutes and seconds
    private static func getTimeMS(timeSeconds: Int32): (minutes: Float32, seconds: Float32) {
        var totalSeconds = abs(timeSeconds)
        var minutes = 0.0f32
        var seconds = 0.0f32
        let negative = timeSeconds != totalSeconds
        if (totalSeconds < 60) {
            seconds = Float32(totalSeconds)
        } else if (totalSeconds < 3600) {
            totalSeconds = totalSeconds % 3600
            minutes = Float32(totalSeconds / 60)
            seconds = Float32(totalSeconds % 60)
        } else {
            let h = totalSeconds / 3600
            totalSeconds = totalSeconds % 3600
            minutes = Float32((totalSeconds / 60) + (h * 60))
            seconds = Float32(totalSeconds % 60)
        }
        if (negative == true) {
            if (minutes == 0.0) {
                minutes = -0.0
            } else {
                minutes = -minutes
            }
        }
        return (minutes, seconds)
    }

    // total time to minutes and seconds
    private static func getTimeMS(time: Time, roundUp!: Bool): (minutes: Float32, seconds: Float32) {
        let seconds = getTimeS(time, roundUp: roundUp)
        return getTimeMS(Int32(seconds))
    }

    // total time to minutes, seconds and milliseconds
    private static func getTimeMSf(time: Time): (minutes: Float32, seconds: Float32, milliseconds: Float32) {
        let (totalSeconds, milliseconds) = getTimeSf(time)
        let (minutes, seconds) = getTimeMS(Int32(totalSeconds))
        return (minutes, seconds, milliseconds)
    }

    // total time to hours, minutes and seconds
    private static func getTimeHMS(timeSeconds: Int32): (hours: Float32, minutes: Float32, seconds: Float32) {
        var totalSeconds = abs(timeSeconds)
        var hours = 0.0f32
        var minutes = 0.0f32
        var seconds = 0.0f32
        let negative = timeSeconds != totalSeconds
        if (totalSeconds < 60) {
            seconds = Float32(totalSeconds)
        } else if (totalSeconds < 3600) {
            totalSeconds = totalSeconds % 3600
            minutes = Float32(totalSeconds / 60)
            seconds = Float32(totalSeconds % 60)
        } else {
            hours = Float32(totalSeconds / 3600)
            totalSeconds = totalSeconds % 3600
            minutes = Float32(totalSeconds / 60)
            seconds = Float32(totalSeconds % 60)
        }
        if (negative == true) {
            if (hours == 0.0) {
                hours = -0.0
            } else {
                hours = -hours
            }
        }
        return (hours, minutes, seconds)
    }

    // total time to hours, minutes and seconds
    private static func getTimeHMS(time: Time, roundUp!: Bool): (hours: Float32, minutes: Float32, seconds: Float32) {
        let seconds = getTimeS(time, roundUp: roundUp)
        return getTimeHMS(Int32(seconds))
    }

    // total time to hours, minutes, seconds and milliseconds
    private static func getTimeHMSf(time: Time): (hours: Float32, minutes: Float32, seconds: Float32, 
        milliseconds: Float32) {
        let (totalSeconds, milliseconds) = getTimeSf(time)
        let (hours, minutes, seconds) = getTimeHMS(Int32(totalSeconds))
        return (hours, minutes, seconds, milliseconds)
    }

    private static func getTimeString(hours!: ?Float32 = None, minutes!: ?Float32 = None, seconds!: ?Float32 = None,
        milliseconds!: ?Float32 = None, leadingZeroes!: ?Int32 = None, milliDecimals!: ?Int32 = None): String {
        let h = hours ?? 0.0
        let m = minutes ?? 0.0
        let s = seconds ?? 0.0
        var ms = 0.0f32
        var zeroes = 1i32
        var decimals = 0i32

        if (let Some(milliseconds) <- milliseconds) {
            decimals = clamp(milliDecimals ?? 0, 0, 3)
            ms = milliseconds
            ms = round(ms * pow(10.0, decimals))
        }
        if (let Some(leadingZeroes) <- leadingZeroes) {
            zeroes = clamp(leadingZeroes, 1, 2)

            // add extra space for minus sign
            if (h < 0.0 || m < 0.0 || s < 0.0 || ms < 0.0) {
                zeroes++
            }
        }

        var str = String.empty
        if (hours.isSome()) {
            if (decimals != 0) {
                let h = h.format("0${zeroes}.0")
                let m = m.format("02.0")
                let s = s.format("02.0")
                let ms = ms.format("0${decimals}.0")
                str = "${h}:${m}:${s}.${ms}"
            } else {
                let h = h.format("0${zeroes}.0")
                let m = m.format("02.0")
                let s = s.format("02.0")
                str = "${h}:${m}:${s}"
            }
        } else if (minutes.isSome()) {
            if (decimals != 0) {
                let m = m.format("0${zeroes}.0")
                let s = s.format("02.0")
                let ms = ms.format("0${decimals}.0")
                str = "${m}:${s}.${ms}"
            } else {
                let m = m.format("0${zeroes}.0")
                let s = s.format("02.0")
                str = "${m}:${s}"
            }
        } else if (seconds.isSome()) {
            if (decimals != 0) {
                let s = s.format("0${zeroes}.0")
                let ms = ms.format("0${decimals}.0")
                str = "${s}.${ms}"
            } else {
                let s = s.format("0${zeroes}.0")
                str = "${s}"
            }
        }
        if (let Some(ch) <- str.runes().next()) {
            if (ch == r'-' && zeroes == 2) {
                str = "-0" + str[1..str.size]
            }
        }
        return str
    }

    // converts time to seconds or string
    // roundUp doesn't apply when milliseconds are used
    // (empty) - 0 (int) - seconds
    // ms - 0 (int) - milliseconds
    // s - 0 (int) - seconds
    // S - 0
    // Sf - 0.0
    // Sff - 0.00
    // Sfff - 0.000
    // SS - 00
    // SSf - 00.0
    // SSff - 00.00
    // SSfff - 00.000
    // MSS - 0:00
    // MSSf - 0:00.0
    // MSSff - 0:00.00
    // MSSfff - 0:00.000
    // MMSS - 00:00
    // MMSSf - 00:00.0
    // MMSSff - 00:00.00
    // MMSSfff - 00:00.000
    // HMMSS - 0:00:00
    // HMMSSf - 0:00:00.0
    // HMMSSff - 0:00:00.00
    // HMMSSfff - 0:00:00.000
    // HHMMSS - 00:00:00
    // HHMMSSf - 00:00:00.0
    // HHMMSSff - 00:00:00.00
    // HHMMSSfff - 00:00:00.000
    public static func getTime(time: Time, format: String, roundUp!: Bool = false): Variable {
        match (format) {
            case "ms" => VaInteger(time.microseconds / 1000)
            case "S" =>
                let s = getTimeS(time, roundUp: roundUp)
                VaString(getTimeString(seconds: s))
            case "Sf" =>
                let (s, ms) = getTimeSf(time)
                VaString(getTimeString(seconds: s, milliseconds: ms, milliDecimals: 1))
            case "Sff" =>
                let (s, ms) = getTimeSf(time)
                VaString(getTimeString(seconds: s, milliseconds: ms, milliDecimals: 2))
            case "Sfff" =>
                let (s, ms) = getTimeSf(time)
                VaString(getTimeString(seconds: s, milliseconds: ms, milliDecimals: 3))
            case "SS" =>
                let s = getTimeS(time, roundUp: roundUp)
                VaString(getTimeString(seconds: s, leadingZeroes: 2))
            case "SSf" =>
                let (s, ms) = getTimeSf(time)
                VaString(getTimeString(seconds: s, milliseconds: ms, leadingZeroes: 2, milliDecimals: 1))
            case "SSff" =>
                let (s, ms) = getTimeSf(time)
                VaString(getTimeString(seconds: s, milliseconds: ms, leadingZeroes: 2, milliDecimals: 2))
            case "SSfff" =>
                let (s, ms) = getTimeSf(time)
                VaString(getTimeString(seconds: s, milliseconds: ms, leadingZeroes: 2, milliDecimals: 3))
            case "MSS" =>
                let (m, s) = getTimeMS(time, roundUp: roundUp)
                VaString(getTimeString(minutes: m, seconds: s))
            case "MSSf" =>
                let (m, s, ms) = getTimeMSf(time)
                VaString(getTimeString(minutes: m, seconds: s, milliseconds: ms, milliDecimals: 1))
            case "MSSff" =>
                let (m, s, ms) = getTimeMSf(time)
                VaString(getTimeString(minutes: m, seconds: s, milliseconds: ms, milliDecimals: 2))
            case "MSSfff" =>
                let (m, s, ms) = getTimeMSf(time)
                VaString(getTimeString(minutes: m, seconds: s, milliseconds: ms, milliDecimals: 3))
            case "MMSS" =>
                let (m, s) = getTimeMS(time, roundUp: roundUp)
                VaString(getTimeString(minutes: m, seconds: s, leadingZeroes: 2))
            case "MMSSf" =>
                let (m, s, ms) = getTimeMSf(time)
                VaString(getTimeString(minutes: m, seconds: s, milliseconds: ms, leadingZeroes: 2, milliDecimals: 1))
            case "MMSSff" =>
                let (m, s, ms) = getTimeMSf(time)
                VaString(getTimeString(minutes: m, seconds: s, milliseconds: ms, leadingZeroes: 2, milliDecimals: 2))
            case "MMSSfff" =>
                let (m, s, ms) = getTimeMSf(time)
                VaString(getTimeString(minutes: m, seconds: s, milliseconds: ms, leadingZeroes: 2, milliDecimals: 3))
            case "HMMSS" =>
                let (h, m, s) = getTimeHMS(time, roundUp: roundUp)
                VaString(getTimeString(hours: h, minutes: m, seconds: s))
            case "HMMSSf" =>
                let (h, m, s, ms) = getTimeHMSf(time)
                VaString(getTimeString(hours: h, minutes: m, seconds: s, milliseconds: ms, milliDecimals: 1))
            case "HMMSSff" =>
                let (h, m, s, ms) = getTimeHMSf(time)
                VaString(getTimeString(hours: h, minutes: m, seconds: s, milliseconds: ms, milliDecimals: 2))
            case "HMMSSfff" =>
                let (h, m, s, ms) = getTimeHMSf(time)
                VaString(getTimeString(hours: h, minutes: m, seconds: s, milliseconds: ms, milliDecimals: 3))
            case "HHMMSS" =>
                let (h, m, s) = getTimeHMS(time, roundUp: roundUp)
                VaString(getTimeString(hours: h, minutes: m, seconds: s, leadingZeroes: 2))
            case "HHMMSSf" =>
                let (h, m, s, ms) = getTimeHMSf(time)
                VaString(
                    getTimeString(
                        hours: h,
                        minutes: m,
                        seconds: s,
                        milliseconds: ms,
                        leadingZeroes: 2,
                        milliDecimals: 1
                    )
                )
            case "HHMMSSff" =>
                let (h, m, s, ms) = getTimeHMSf(time)
                VaString(
                    getTimeString(
                        hours: h,
                        minutes: m,
                        seconds: s,
                        milliseconds: ms,
                        leadingZeroes: 2,
                        milliDecimals: 2
                    )
                )
            case "HHMMSSfff" =>
                let (h, m, s, ms) = getTimeHMSf(time)
                VaString(
                    getTimeString(
                        hours: h,
                        minutes: m,
                        seconds: s,
                        milliseconds: ms,
                        leadingZeroes: 2,
                        milliDecimals: 3
                    )
                )
            case _ => VaInteger(Int64(getTimeS(time, roundUp: roundUp)))
        }
    }

    public static func replaceStringWithFunction(str: String, token: String,
        stringReplaceFunc: (String, String) -> String): String {
        var str2 = str
        var firstTokenStart = 0
        while (true) {
            match (str.indexOf(token, firstTokenStart)) {
                case Some(index) => firstTokenStart = index
                case None => break
            }
            let firstTokenStop = firstTokenStart + 1
            var secondTokenStart = 0
            match (str.indexOf(token, firstTokenStop)) {
                case Some(index) => secondTokenStart = index
                case None => break
            }
            let secondTokenStop = secondTokenStart + 1

            // %str%
            let strProp = str[firstTokenStart..secondTokenStop]
            str2 = stringReplaceFunc(strProp, str2)

            firstTokenStart = secondTokenStart
        }
        return str2
    }

    public static func replaceStringWithQueryable(str: String, obj: Queryable, token!: String = '%'): String {
        replaceStringWithFunction(
            str,
            token,
            {
                strProp, str2 =>
                    if (strProp.size > 2) {
                        if (let Some(value) <- obj.getProperty(strProp[1..strProp.size - 1])) {
                            return str2.replace(strProp, value.toString())
                        }
                    }
                    return str2
            }
        )
    }

    public static func replaceStringWithVarOrProp(str: String, obj: Game, token!: String = '%'): String {
        replaceStringWithFunction(
            str,
            token,
            {
                strProp, str2 =>
                    if (strProp.size > 2) {
                        if (let Some(value) <- obj.getVarOrPropNoToken(strProp[1..strProp.size - 1])) {
                            return str2.replace(strProp, value.toString())
                        }
                    }
                    return str2
            }
        )
    }
}
