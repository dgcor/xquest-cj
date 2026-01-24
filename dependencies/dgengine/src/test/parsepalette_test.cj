package dgengine.test

import cjsfml.graphics.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParsePalette {
    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)
    }

    @AfterAll
    func cleanup() {
        FileUtils.deinitPhysFS()
    }

    @TestCase
    func test_parsePalette() {
        try (game = Game()) {
            parseFile(game, "json/palettes.json")

            // invalid id from file
            @Expect(game.resources.getPalette("invalid-id").isNone())

            // id from file
            match (game.resources.getPalette("pal")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.RED)
                    @Expect(palette[1] == Color.GREEN)
                    @Expect(palette[2] == Color.BLUE)
                case _ => @Fail("Expected Palette: pal")
            }

            // default binary
            match (game.resources.getPalette("key01")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.RED)
                    @Expect(palette[1] == Color.GREEN)
                    @Expect(palette[2] == Color.BLUE)
                case _ => @Fail("Expected Palette: key01")
            }

            // existing id
            match ((game.resources.getPalette("pal"), game.resources.getPalette("key05"))) {
                case (Some(palette), Some(palette2)) => @Expect(isObjEq(palette, palette2), false)
                case _ => @Fail("Expected Palettes: pal, key05")
            }

            // default text
            match (game.resources.getPalette("key02")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.RED)
                    @Expect(palette[1] == Color.GREEN)
                    @Expect(palette[2] == Color.BLUE)
                case _ => @Fail("Expected Palette: key02")
            }

            // RGB
            match (game.resources.getPalette("key03")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.RED)
                    @Expect(palette[1] == Color.GREEN)
                    @Expect(palette[2] == Color.BLUE)
                case _ => @Fail("Expected Palette: key03")
            }

            // BGR
            match (game.resources.getPalette("key04")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.BLUE)
                    @Expect(palette[1] == Color.GREEN)
                    @Expect(palette[2] == Color.RED)
                case _ => @Fail("Expected Palette: key04")
            }

            // RGBA
            match (game.resources.getPalette("key05")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color(0xFF, 0x00, 0x00, 0xAA))
                    @Expect(palette[1] == Color(0x00, 0xFF, 0x00, 0xAA))
                    @Expect(palette[2] == Color(0x00, 0x00, 0xFF, 0xAA))
                case _ => @Fail("Expected Palette: key05")
            }

            // BGRA
            match (game.resources.getPalette("key06")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color(0x00, 0x00, 0xFF, 0xAA))
                    @Expect(palette[1] == Color(0x00, 0xFF, 0x00, 0xAA))
                    @Expect(palette[2] == Color(0xFF, 0x00, 0x00, 0xAA))
                case _ => @Fail("Expected Palette: key06")
            }

            // ARGB
            match (game.resources.getPalette("key07")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color(0x00, 0x00, 0xAA, 0xFF))
                    @Expect(palette[1] == Color(0xFF, 0x00, 0xAA, 0x00))
                    @Expect(palette[2] == Color(0x00, 0xFF, 0xAA, 0x00))
                case _ => @Fail("Expected Palette: key07")
            }

            // ABGR
            match (game.resources.getPalette("key08")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color(0xAA, 0x00, 0x00, 0xFF))
                    @Expect(palette[1] == Color(0xAA, 0x00, 0xFF, 0x00))
                    @Expect(palette[2] == Color(0xAA, 0xFF, 0x00, 0x00))
                case _ => @Fail("Expected Palette: key08")
            }

            // invalid data
            // gray palette when file is too small for 256 RGB colors
            match (game.resources.getPalette("key09")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color(0x00, 0x00, 0x00, 0xFF))
                    @Expect(palette[1] == Color(0x01, 0x01, 0x01, 0xFF))
                    @Expect(palette[127] == Color(0x7F, 0x7F, 0x7F, 0xFF))
                    @Expect(palette[254] == Color(0xFE, 0xFE, 0xFE, 0xFF))
                    @Expect(palette[255] == Color(0xFF, 0xFF, 0xFF, 0xFF))
                case _ => @Fail("Expected Palette: key09")
            }

            // trnFile
            match (game.resources.getPalette("key10")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.BLUE)
                    @Expect(palette[1] == Color.GREEN)
                    @Expect(palette[2] == Color.RED)
                case _ => @Fail("Expected Palette: key10")
            }

            // id from trnFile
            match (game.resources.getPalette("trn")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.BLUE)
                    @Expect(palette[1] == Color.GREEN)
                    @Expect(palette[2] == Color.RED)
                case _ => @Fail("Expected Palette: trn")
            }

            // trnStart + trnLength
            // black color when trn index not applied
            match (game.resources.getPalette("key11")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.WHITE)
                    @Expect(palette[1] == Color.BLACK)
                    @Expect(palette[2] == Color.BLACK)
                case _ => @Fail("Expected Palette: key11")
            }

            // trnStart + trnLength out of range
            // black palette when trn index out of range
            match (game.resources.getPalette("key12")) {
                case Some(palette) =>
                    @Expect(palette[0] == Color.BLACK)
                    @Expect(palette[255] == Color.BLACK)
                case _ => @Fail("Expected Palette: key12")
            }

            // clone
            match ((game.resources.getPalette("pal"), game.resources.getPalette("key13"))) {
                case (Some(palette), Some(palette2)) =>
                    @Expect(isObjEq(palette, palette2), false)
                    @Expect(palette[0] == palette2[0])
                    @Expect(palette[1] == palette2[1])
                    @Expect(palette[2] == palette2[2])
                    @Expect(palette[255] == palette2[255])
                case _ => @Fail("Expected Palettes: pal, key13")
            }

            // fromId
            match ((game.resources.getPalette("pal"), game.resources.getPalette("key14"))) {
                case (Some(palette), Some(palette2)) => @Expect(isObjEq(palette, palette2))
                case _ => @Fail("Expected Palettes: pal, key14")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
