package dgengine.test

import dgengine.*
import std.unittest.*

@Test
class TestTextUtils {
    @TestCase
    func test_getFormatString() {
        var str = Box(String.empty)
        var bindings = Array<String>()
        try (game = Game(reset: true)) {
            // returns bool
            @Expect(TextUtils.getFormatString(game, "", bindings.iterator(), str), false)
            @Expect(TextUtils.getFormatString(game, "text", bindings.iterator(), str), false)
            @Expect(str.value, "")

            bindings = ["%%"]

            @Expect(TextUtils.getFormatString(game, "", bindings.iterator(), str), true)
            @Expect(TextUtils.getFormatString(game, "text", bindings.iterator(), str), false)
            @Expect(str.value, "text")

            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator(), str), false)
            @Expect(str.value, "Values: %%")

            bindings = ["game.keepAR"]

            @Expect(TextUtils.getFormatString(game, "Values: (1)", bindings.iterator(), str), false)
            @Expect(str.value, "Values: (1)")

            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator(), str), false)
            @Expect(str.value, "Values: game.keepAR")

            bindings = ["%game.keepAR%"]

            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator(), str), true)
            @Expect(str.value, "Values: true")

            @Expect(TextUtils.getFormatString(game, "Values: [1], [1]", bindings.iterator(), str), true)
            @Expect(str.value, "Values: true, true")

            @Expect(TextUtils.getFormatString(game, "Values: [1], [2]", bindings.iterator(), str), true)
            @Expect(str.value, "Values: true, [2]")

            bindings = ["%game.keepAR%", "%game.musicVolume%"]

            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator(), str), true)
            @Expect(str.value, "Values: true")

            @Expect(TextUtils.getFormatString(game, "Values: [1], [2]", bindings.iterator(), str), true)
            @Expect(str.value, "Values: true, 100")

            @Expect(TextUtils.getFormatString(game, "Values: [2], [1], [2]", bindings.iterator(), str), true)
            @Expect(str.value, "Values: 100, true, 100")

            bindings = ["%game.invalid%", "%game.musicVolume%"]

            @Expect(TextUtils.getFormatString(game, "Values: [1], [2]", bindings.iterator(), str), false)
            @Expect(str.value, "Values: %game.invalid%, 100")

            @Expect(TextUtils.getFormatString(game, "Values: [2]", bindings.iterator(), str), false)
            @Expect(str.value, "Values: 100")

            // returns string
            bindings = []

            @Expect(TextUtils.getFormatString(game, "", bindings.iterator()), "")
            @Expect(TextUtils.getFormatString(game, "text", bindings.iterator()), "")

            bindings = ["%%"]

            @Expect(TextUtils.getFormatString(game, "", bindings.iterator()), "")
            @Expect(TextUtils.getFormatString(game, "text", bindings.iterator()), "text")
            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator()), "Values: %%")

            bindings = ["game.keepAR"]

            @Expect(TextUtils.getFormatString(game, "Values: (1)", bindings.iterator()), "Values: (1)")
            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator()), "Values: game.keepAR")

            bindings = ["%game.keepAR%"]

            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator()), "Values: true")
            @Expect(TextUtils.getFormatString(game, "Values: [1], [1]", bindings.iterator()), "Values: true, true")
            @Expect(TextUtils.getFormatString(game, "Values: [1], [2]", bindings.iterator()), "Values: true, [2]")

            bindings = ["%game.keepAR%", "%game.musicVolume%"]

            @Expect(TextUtils.getFormatString(game, "Values: [1]", bindings.iterator()), "Values: true")
            @Expect(TextUtils.getFormatString(game, "Values: [1], [2]", bindings.iterator()), "Values: true, 100")
            @Expect(TextUtils.getFormatString(game, "Values: [2], [1], [2]", bindings.iterator()), "Values: 100, true, 100")

            bindings = ["%game.invalid%", "%game.musicVolume%"]

            @Expect(TextUtils.getFormatString(game, "Values: [1], [2]", bindings.iterator()), "Values: %game.invalid%, 100")
            @Expect(TextUtils.getFormatString(game, "Values: [2]", bindings.iterator()), "Values: 100")
        }
    }

    @TestCase
    func test_getTextQueryable() {
        try (game = Game(reset: true)) {
            try (obj = Circle(2.0, pointCount: 30)) {
                game.resources.addDrawable("obj", obj, manageObjDrawing: true)
                @Expect(TextUtils.getTextQueryable(game, "", ""), "")
                @Expect(TextUtils.getTextQueryable(game, "", "obj"), "")
                @Expect(TextUtils.getTextQueryable(game, "text", ""), "text")
                @Expect(TextUtils.getTextQueryable(game, "text", "obj"), "text")
                @Expect(TextUtils.getTextQueryable(game, "%text%", "obj"), "%text%")
                @Expect(TextUtils.getTextQueryable(game, "%radius%", "obj"), "2")
                @Expect(TextUtils.getTextQueryable(game, "%size.x%", "obj"), "4")
                @Expect(TextUtils.getTextQueryable(game, "%size.y%", "obj"), "4")
                @Expect(TextUtils.getTextQueryable(game, "The size is: [%size.x%, %size.y%]", "obj"), "The size is: [4, 4]")
                @Expect(TextUtils.getTextQueryable(game, "The size is: [%%size.x%, %size.y%]", "obj"), "The size is: [%4, 4]")
                @Expect(TextUtils.getTextQueryable(game, "The size is: [%%size.x%, %size.y%%]", "obj"), "The size is: [%4, 4%]")
                @Expect(TextUtils.getTextQueryable(game, "The size is: [%%size.x%%, %size.y%%]", "obj"), "The size is: [%4%, 4%]")
                @Expect(TextUtils.getTextQueryable(game, "The size is: [%%size.x%,% %size.y%%]", "obj"), "The size is: [%4,% 4%]")
            }
        }
    }

    @TestCase
    func test_getText() {
        var bindings = Array<String>()
        try (game = Game(reset: true)) {
            try (obj = Circle(2.0, pointCount: 30)) {
                game.resources.addDrawable("obj", obj, manageObjDrawing: true)

                // set
                var textOp = TextOp.Set

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "text")

                // bindings ignored
                bindings = ["game"]

                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: [1]")
                @Expect(TextUtils.getText(game, textOp, "Values: %keepAR%", bindings.iterator()), "Values: %keepAR%")

                // replace
                textOp = TextOp.Replace
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "text")
                @Expect(TextUtils.getText(game, textOp, "Values: %game.keepAR%", bindings.iterator()), "Values: %game.keepAR%")
                @Expect(TextUtils.getText(game, textOp, "game.keepAR", bindings.iterator()), "game.keepAR")
                @Expect(TextUtils.getText(game, textOp, "%game.keepAR%", bindings.iterator()), "true")

                // bindings ignored
                bindings = ["game"]

                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: [1]")
                @Expect(TextUtils.getText(game, textOp, "Values: %keepAR%", bindings.iterator()), "Values: %keepAR%")
                @Expect(TextUtils.getText(game, textOp, "Values: %game.keepAR%", bindings.iterator()), "Values: %game.keepAR%")
                @Expect(TextUtils.getText(game, textOp, "game.keepAR", bindings.iterator()), "game.keepAR")
                @Expect(TextUtils.getText(game, textOp, "%game.keepAR%", bindings.iterator()), "true")

                // query
                textOp = TextOp.Query
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")

                bindings = ["obj"]

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "text")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "text")
                @Expect(TextUtils.getText(game, textOp, "%text%", bindings.iterator()), "%text%")
                @Expect(TextUtils.getText(game, textOp, "%radius%", bindings.iterator()), "2")
                @Expect(TextUtils.getText(game, textOp, "%size.x%", bindings.iterator()), "4")
                @Expect(TextUtils.getText(game, textOp, "%size.y%", bindings.iterator()), "4")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%size.x%, %size.y%]", bindings.iterator()), "The size is: [4, 4]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%size.x%, %size.y%]", bindings.iterator()), "The size is: [%4, 4]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%size.x%, %size.y%%]", bindings.iterator()), "The size is: [%4, 4%]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%size.x%%, %size.y%%]", bindings.iterator()), "The size is: [%4%, 4%]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%size.x%,% %size.y%%]", bindings.iterator()), "The size is: [%4,% 4%]")

                // formatString
                textOp = TextOp.FormatString
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "")

                bindings = ["%%"]

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "text")
                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: %%")

                bindings = ["game.keepAR"]

                @Expect(TextUtils.getText(game, textOp, "Values: (1)", bindings.iterator()), "Values: (1)")
                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: game.keepAR")

                bindings = ["%game.keepAR%"]

                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: true")
                @Expect(TextUtils.getText(game, textOp, "Values: [1], [1]", bindings.iterator()), "Values: true, true")
                @Expect(TextUtils.getText(game, textOp, "Values: [1], [2]", bindings.iterator()), "Values: true, [2]")

                bindings = ["%game.keepAR%", "%game.musicVolume%"]

                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: true")
                @Expect(TextUtils.getText(game, textOp, "Values: [1], [2]", bindings.iterator()), "Values: true, 100")
                @Expect(TextUtils.getText(game, textOp, "Values: [2], [1], [2]", bindings.iterator()), "Values: 100, true, 100")

                bindings = ["%game.invalid%", "%game.musicVolume%"]

                @Expect(TextUtils.getText(game, textOp, "Values: [1], [2]", bindings.iterator()), "Values: %game.invalid%, 100")
                @Expect(TextUtils.getText(game, textOp, "Values: [2]", bindings.iterator()), "Values: 100")

                // replaceAll
                textOp = TextOp.ReplaceAll

                // bindings ignored
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "text")
                @Expect(TextUtils.getText(game, textOp, "%text%", bindings.iterator()), "%text%")
                @Expect(TextUtils.getText(game, textOp, "%game.gamma%", bindings.iterator()), "0")
                @Expect(TextUtils.getText(game, textOp, "%game.keepAR%", bindings.iterator()), "true")
                @Expect(TextUtils.getText(game, textOp, "%game.size.x%", bindings.iterator()), "640")
                @Expect(TextUtils.getText(game, textOp, "%game.size.y%", bindings.iterator()), "480")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%game.size.x%, %game.size.y%]", bindings.iterator()), "The size is: [640, 480]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%game.size.x%, %game.size.y%]", bindings.iterator()), "The size is: [%640, 480]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%game.size.x%, %game.size.y%%]", bindings.iterator()), "The size is: [%640, 480%]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%game.size.x%%, %game.size.y%%]", bindings.iterator()), "The size is: [%640%, 480%]")
                @Expect(TextUtils.getText(game, textOp, "The size is: [%%game.size.x%,% %game.size.y%%]", bindings.iterator()), "The size is: [%640,% 480%]")
                @Expect(TextUtils.getText(game, textOp, "keepAR: %game.keepAR%, radius: %obj.radius.y%", bindings.iterator()), "keepAR: true, radius: 2")

                // trim
                textOp = TextOp.Set | TextOp.Trim
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, " ", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "   ", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "\t", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "\t\n", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, " \t\r\n", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, " \ttext\n   ", bindings.iterator()), "text")
                @Expect(TextUtils.getText(game, textOp, "text", bindings.iterator()), "text")

                textOp = TextOp.Replace | TextOp.Trim

                @Expect(TextUtils.getText(game, textOp, "%game.keepAR%", bindings.iterator()), "true")
                @Expect(TextUtils.getText(game, textOp, " %game.keepAR% ", bindings.iterator()), "%game.keepAR%")

                textOp = TextOp.Query | TextOp.Trim
                bindings = ["obj"]

                @Expect(TextUtils.getText(game, textOp, "%radius%", bindings.iterator()), "2")
                @Expect(TextUtils.getText(game, textOp, " %radius% ", bindings.iterator()), "2")
                @Expect(TextUtils.getText(game, textOp, " \r\n\t%radius% \t\n\r\n\n", bindings.iterator()), "2")

                textOp = TextOp.FormatString | TextOp.Trim
                bindings = ["%game.keepAR%"]

                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: true")
                @Expect(TextUtils.getText(game, textOp, " Values: [1] ", bindings.iterator()), "Values: true")
                @Expect(TextUtils.getText(game, textOp, " \r\n\tValues: [1] \t\n\r\n\n", bindings.iterator()), "Values: true")

                textOp = TextOp.ReplaceAll | TextOp.Trim
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "%game.gamma%", bindings.iterator()), "0")
                @Expect(TextUtils.getText(game, textOp, " %game.gamma% ", bindings.iterator()), "0")
                @Expect(TextUtils.getText(game, textOp, " \r\n\t%game.gamma% \t\n\r\n\n", bindings.iterator()), "0")

                // removeEmptyLines
                textOp = TextOp.Set | TextOp.RemoveEmptyLines
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "\n", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "\t", bindings.iterator()), "\t")
                @Expect(TextUtils.getText(game, textOp, "\n\n", bindings.iterator()), "")
                @Expect(TextUtils.getText(game, textOp, "\nt\n", bindings.iterator()), "t")
                @Expect(TextUtils.getText(game, textOp, "\nt\nest", bindings.iterator()), "t\nest")
                @Expect(TextUtils.getText(game, textOp, " \ntext\n   ", bindings.iterator()), " \ntext\n   ")
                @Expect(TextUtils.getText(game, textOp, "\nthis\nis\n\na\nstring\n", bindings.iterator()), "this\nis\na\nstring")

                textOp = TextOp.Replace | TextOp.RemoveEmptyLines

                @Expect(TextUtils.getText(game, textOp, "%game.keepAR%", bindings.iterator()), "true")
                @Expect(TextUtils.getText(game, textOp, "\n%game.keepAR%\n", bindings.iterator()), "%game.keepAR%")

                textOp = TextOp.Query | TextOp.RemoveEmptyLines
                bindings = ["obj"]

                @Expect(TextUtils.getText(game, textOp, "%radius%", bindings.iterator()), "2")
                @Expect(TextUtils.getText(game, textOp, "\n%radius%\n", bindings.iterator()), "2")

                textOp = TextOp.FormatString | TextOp.RemoveEmptyLines
                bindings = ["%game.keepAR%"]

                @Expect(TextUtils.getText(game, textOp, "Values: [1]", bindings.iterator()), "Values: true")
                @Expect(TextUtils.getText(game, textOp, "\nValues: [1]\n", bindings.iterator()), "Values: true")

                textOp = TextOp.ReplaceAll | TextOp.RemoveEmptyLines
                bindings = []

                @Expect(TextUtils.getText(game, textOp, "%game.gamma%", bindings.iterator()), "0")
                @Expect(TextUtils.getText(game, textOp, "\n%game.gamma%\n", bindings.iterator()), "0")

                // trim + removeEmptyLines
                textOp = TextOp.Set | TextOp.Trim | TextOp.RemoveEmptyLines
                bindings = []

                @Expect(TextUtils.getText(game, textOp, " \r\n\tthis\nis\n\na\nstring \r\n\t", bindings.iterator()), "this\nis\na\nstring")

                textOp = TextOp.Replace | TextOp.Trim | TextOp.RemoveEmptyLines

                @Expect(TextUtils.getText(game, textOp, " \r\n\t%game.keepAR% \r\n\t", bindings.iterator()), "%game.keepAR%")

                textOp = TextOp.Query | TextOp.Trim | TextOp.RemoveEmptyLines
                bindings = ["obj"]

                @Expect(TextUtils.getText(game, textOp, " \r\n\t%radius% \r\n\t", bindings.iterator()), "2")

                textOp = TextOp.FormatString | TextOp.Trim | TextOp.RemoveEmptyLines
                bindings = ["%game.keepAR%"]

                @Expect(TextUtils.getText(game, textOp, " \r\n\tValues: \n\n[1] \r\n\t", bindings.iterator()), "Values: \ntrue")

                textOp = TextOp.ReplaceAll | TextOp.Trim | TextOp.RemoveEmptyLines
                bindings = []

                @Expect(TextUtils.getText(game, textOp, " \r\n\t%game.gamma% \r\n\t", bindings.iterator()), "0")

                // all
                // uses FormatString
                textOp = TextOp.Set | TextOp.Replace | TextOp.Query | TextOp.FormatString | TextOp.ReplaceAll | TextOp
                    .Trim | TextOp.RemoveEmptyLines

                bindings = []

                @Expect(TextUtils.getText(game, textOp, " \r\n\tthis\nis\n\na\nstring \r\n\t", bindings.iterator()), "this\nis\na\nstring")
                @Expect(TextUtils.getText(game, textOp, " \r\n\t%game.keepAR% \r\n\t", bindings.iterator()), "true")

                bindings = ["obj"]

                @Expect(TextUtils.getText(game, textOp, " \r\n\t%radius% \r\n\t", bindings.iterator()), "%radius%")

                bindings = ["%game.keepAR%"]

                @Expect(TextUtils.getText(game, textOp, " \r\n\tValues: \n\n[1] \r\n\t", bindings.iterator()), "Values: \n[1]")

                bindings = []

                @Expect(TextUtils.getText(game, textOp, " \r\n\t%game.gamma% \r\n\t", bindings.iterator()), "0")
            }
        }
    }

    // same as getText
    @TestCase
    func test_appendText() {
        var bindings = Array<String>()
        try (game = Game()) {
            var str = Box(String.empty)
            var textOp = TextOp.Set

            TextUtils.appendText(game, textOp, str, "", bindings.iterator())
            @Expect(str.value, "")
            TextUtils.appendText(game, textOp, str, " \r\n\tgamma:", bindings.iterator())
            @Expect(str.value, " \r\n\tgamma:")

            textOp = TextOp.ReplaceAll | TextOp.Trim

            TextUtils.appendText(game, textOp, str, " \t%game.gamma%\t", bindings.iterator())
            @Expect(str.value, "gamma: \t0")

            textOp = TextOp.Replace
            bindings = ["game"]

            TextUtils.appendText(game, textOp, str, "%game.keepAR%", bindings.iterator())
            @Expect(str.value, "gamma: \t0false")
        }
    }
}
