package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseBitmapFontTexturePack {
    var game: ?Game = None
    var pal: ?Palette = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game2 = Game()
        this.game = game2
        parseFile(game2, "json/texturePacks/bitmapFontTexturePacks.json")

        pal = game2.resources.getPalette("pal")
    }

    @AfterAll
    func cleanup() {
        game?.close()
        FileUtils.deinitPhysFS()
    }

    static func CHECK_TexturePack(texturePack: TexturePack, size: UInt32, directions: UInt32, palette: ?Palette): Unit {
        @Expect(texturePack.size, size)
        @Expect(texturePack.groupCount, 1)
        @Expect(texturePack.getDirectionCount(0), directions)
        @Expect(texturePack.getDirectionCount(1), 1)
        match ((texturePack.palette, palette)) {
            case (Some(pal), Some(pal2)) => @Expect(isObjEq(pal, pal2))
            case (None, None) => ()
            case _ => @Fail("CHECK_TexturePack: Expected Palette match")
        }
        @Expect(texturePack.texture.isSome())
    }

    static func CHECK_InvalidGet(texturePack: TexturePack, index: UInt32): Unit {
        @Expect(texturePack.get(index).isNone())
        @Expect(texturePack.getDirection(index), 0)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, index: Rune, position: (Int32, Int32), size: (Int32, Int32),
        palette: ?Palette, offset: ?(Int64, Int64)): Unit {
        CHECK_TextureGet(texturePack, UInt32(index), position, size, palette, offset, false)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, index: UInt32, position: (Int32, Int32),
        size: (Int32, Int32), palette: ?Palette, offset: ?(Int64, Int64)): Unit {
        CHECK_TextureGet(texturePack, index, position, size, palette, offset, false)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, index: Rune, position: (Int32, Int32), size: (Int32, Int32),
        palette: ?Palette, offset: ?(Int64, Int64), skipPosition: Bool): Unit {
        CHECK_TextureGet(texturePack, UInt32(index), position, size, palette, offset, skipPosition)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, index: UInt32, position: (Int32, Int32),
        size: (Int32, Int32), palette: ?Palette, offset: ?(Int64, Int64), skipPosition: Bool): Unit {
        match (texturePack.get(index)) {
            case Some(ti) =>
                if (skipPosition == false) {
                    @Expect(ti.textureRect.position == Vector2i(position))
                }
                @Expect(ti.textureRect.size == Vector2i(size))
                match ((ti.palette, palette)) {
                    case (Some(pal), Some(pal2)) => @Expect(isObjEq(pal, pal2))
                    case (None, None) => ()
                    case _ => @Fail("CHECK_TextureGet: Expected Palette match")
                }
                match (offset) {
                    case Some(offset) => @Expect(ti.offset == Vector2f.create(offset))
                    case _ => @Expect(ti.offset == Vector2f())
                }
                @Expect(ti.absoluteOffset, false)
                @Expect(ti.blendMode, BlendAlpha)
                @Expect(ti.nextIndex == -1)
            case _ => @Fail("CHECK_TextureGet: Expected TextureInfo")
        }
        @Expect(texturePack.getTextureSize(index) == Vector2i(size))
    }

    static func CHECK_Animation(texturePack: TexturePack, groupIndex: Int32, directionIndex: Rune,
        indexRange: (UInt32, UInt32)): Unit {
        CHECK_Animation(texturePack, groupIndex, Int32(UInt32(directionIndex)), indexRange)
    }

    static func CHECK_Animation(texturePack: TexturePack, groupIndex: Int32, directionIndex: Int32,
        indexRange: (UInt32, UInt32)): Unit {
        let animInfo = texturePack.getAnimation(groupIndex, directionIndex)
        @Expect(animInfo.animType, AnimationType.Looped)
        @Expect(animInfo.indexRange[0], indexRange[0])
        @Expect(animInfo.indexRange[1], indexRange[1])
        @Expect(animInfo.refresh.microseconds, Time.ZERO.microseconds)
    }

    @TestCase
    func test_BitmapFontTexturePack_key01() {
        if (let Some(game) <- game) {
            @Expect(pal.isSome())

            // grid font texture + default rows, cols and direction
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (97, 32), (9, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (33, 96), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                    CHECK_InvalidGet(texturePack, 256)

                    CHECK_Animation(texturePack, -1, -1, (0, 255))
                    CHECK_Animation(texturePack, 0, 0, (0, 255))
                    CHECK_Animation(texturePack, 0, r'a', (0, 255))
                    CHECK_Animation(texturePack, 0, 255, (0, 255))
                    CHECK_Animation(texturePack, 0, 256, (0, 255))
                    CHECK_Animation(texturePack, 1, 0, (0, 255))

                    @Expect(texturePack.getDirection(0), 0)
                    @Expect(texturePack.getDirection(255), 0)
                    @Expect(texturePack.getDirection(256), 0)

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key02() {
        if (let Some(game) <- game) {
            // grid font texture + rows, cols = 16 + horizontal direction
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (32, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (16, 20), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (97, 32), (9, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (33, 96), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key03() {
        if (let Some(game) <- game) {
            // grid font texture + imageContainer + vertical direction
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (0, 144), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (0, 160), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r' ', (32, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (33, 96), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (97, 32), (9, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key04() {
        if (let Some(game) <- game) {
            // horizontal font texture + -1 sizes for newLine, space, tab
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, pal)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, r'\t', (36, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, r'\n', (40, 0), (4, 2), pal, None)
                    CHECK_TextureGet(texturePack, r' ', (128, 0), (2, 4), pal, None)
                    CHECK_TextureGet(texturePack, r'a', (388, 0), (1, 4), pal, None)
                    CHECK_TextureGet(texturePack, 255, (1020, 0), (1, 4), pal, None)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key05() {
        if (let Some(game) <- game) {
            // vertical font texture
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, r'a', (0, 388), (1, 4), None, None)
                    CHECK_TextureGet(texturePack, 255, (0, 1020), (1, 4), None, None)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key06() {
        if (let Some(game) <- game) {
            // invalid rows + cols
            @Expect(game.resources.getTexturePack("key06").isNone())
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key07() {
        if (let Some(game) <- game) {
            // invalid texture
            @Expect(game.resources.getTexturePack("key07").isNone())
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key08() {
        if (let Some(game) <- game) {
            // invalid imageContiner
            @Expect(game.resources.getTexturePack("key08").isNone())
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key09() {
        if (let Some(game) <- game) {
            // imageContainer
            // uses ImageUtils.packImages internally to pack textures into 1
            match (game.resources.getTexturePack("key09")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 16), None, None, true)
                    CHECK_TextureGet(texturePack, r'\t', (0, 0), (16, 16), None, None, true)
                    CHECK_TextureGet(texturePack, r'\n', (0, 0), (16, 16), None, None, true)
                    CHECK_TextureGet(texturePack, r' ', (0, 0), (16, 16), None, None, true)
                    CHECK_TextureGet(texturePack, r'&', (0, 0), (16, 16), None, None, true)
                    CHECK_TextureGet(texturePack, r'b', (0, 0), (16, 16), None, None, true)
                    CHECK_TextureGet(texturePack, 255, (0, 0), (16, 16), None, None, true)

                    CHECK_InvalidGet(texturePack, 256)

                    CHECK_Animation(texturePack, -1, -1, (0, 255))
                    CHECK_Animation(texturePack, 0, 0, (0, 255))
                    CHECK_Animation(texturePack, 0, r'a', (0, 255))
                    CHECK_Animation(texturePack, 0, 255, (0, 255))
                    CHECK_Animation(texturePack, 0, 256, (0, 255))
                    CHECK_Animation(texturePack, 1, 0, (0, 255))

                    @Expect(texturePack.getDirection(0), 0)
                    @Expect(texturePack.getDirection(255), 0)
                    @Expect(texturePack.getDirection(256), 0)

                case _ => @Fail("Expected TexturePack: key09")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key10() {
        if (let Some(game) <- game) {
            // imageContainer with small number of textures + palette
            match (game.resources.getTexturePack("key10")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 1, pal)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), pal, None, true)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), pal, None, true)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), pal, None, true)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), pal, None, true)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_Animation(texturePack, -1, -1, (0, 3))
                    CHECK_Animation(texturePack, 0, -1, (0, 3))
                    CHECK_Animation(texturePack, 0, 0, (0, 3))
                    CHECK_Animation(texturePack, 0, 3, (0, 3))
                    CHECK_Animation(texturePack, 0, 4, (0, 3))
                    CHECK_Animation(texturePack, 1, -1, (0, 3))
                    CHECK_Animation(texturePack, 1, 0, (0, 3))

                    @Expect(texturePack.getDirection(0), 0)
                    @Expect(texturePack.getDirection(3), 0)
                    @Expect(texturePack.getDirection(4), 0)

                case _ => @Fail("Expected TexturePack: key10")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key11() {
        if (let Some(game) <- game) {
            // grid font texture 256 + charSizeFile 256
            match (game.resources.getTexturePack("key11")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (4, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (96, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (32, 96), (7, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                case _ => @Fail("Expected TexturePack: key11")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key12() {
        if (let Some(game) <- game) {
            // grid font texture 256 + charSizeFile 256
            match (game.resources.getTexturePack("key12")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 128, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (4, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (96, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (32, 96), (7, 16), None, None)
                    CHECK_TextureGet(texturePack, 127, (240, 112), (3, 16), None, None)

                    CHECK_InvalidGet(texturePack, 128)

                    CHECK_Animation(texturePack, -1, -1, (0, 127))
                    CHECK_Animation(texturePack, 0, 0, (0, 127))
                    CHECK_Animation(texturePack, 0, r'a', (0, 127))
                    CHECK_Animation(texturePack, 0, 127, (0, 127))
                    CHECK_Animation(texturePack, 0, 128, (0, 127))
                    CHECK_Animation(texturePack, 1, 0, (0, 127))

                    @Expect(texturePack.getDirection(0), 0)
                    @Expect(texturePack.getDirection(127), 0)
                    @Expect(texturePack.getDirection(128), 0)

                case _ => @Fail("Expected TexturePack: key12")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key13() {
        if (let Some(game) <- game) {
            // grid font texture 256 + charSizeFile 258
            match (game.resources.getTexturePack("key13")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (8, 20), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (96, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (32, 96), (7, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                case _ => @Fail("Expected TexturePack: key13")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key14() {
        if (let Some(game) <- game) {
            // grid font texture 128 + charSizeFile 130
            match (game.resources.getTexturePack("key14")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 128, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (8, 20), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (96, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (32, 96), (7, 16), None, None)
                    CHECK_TextureGet(texturePack, 127, (240, 112), (3, 16), None, None)

                case _ => @Fail("Expected TexturePack: key14")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key15() {
        if (let Some(game) <- game) {
            // grid font texture 256 + charSizeFile 256 + charSizeFileStep
            match (game.resources.getTexturePack("key15")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (4, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (96, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (32, 96), (7, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                case _ => @Fail("Expected TexturePack: key15")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key16() {
        if (let Some(game) <- game) {
            // grid font texture 256 + charSizeFile 256 + charSizeFileStep + charSizeFileStart
            match (game.resources.getTexturePack("key16")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (8, 16), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (4, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (96, 32), (10, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (32, 96), (7, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                case _ => @Fail("Expected TexturePack: key16")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key17() {
        if (let Some(game) <- game) {
            // grid font texture 256 + charSizeFile 255 (invalid - defaults to calculating sizes)
            match (game.resources.getTexturePack("key17")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 256, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 32), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, r'&', (97, 32), (9, 16), None, None)
                    CHECK_TextureGet(texturePack, r'b', (33, 96), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                case _ => @Fail("Expected TexturePack: key17")
            }
        }
    }

    @TestCase
    func test_BitmapFontTexturePack_key18() {
        if (let Some(game) <- game) {
            // grid font texture 128 + charSizeFile 127 (invalid - defaults to calculating sizes)
            // the 128 char image has 2 pixels that can be remove from the top and bottom (smaller images than the 256 char image)
            match (game.resources.getTexturePack("key18")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 128, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 2), (16, 14), None, None)
                    CHECK_TextureGet(texturePack, r'\t', (144, 2), (16, 14), None, None)
                    CHECK_TextureGet(texturePack, r'\n', (160, 2), (16, 14), None, None)
                    CHECK_TextureGet(texturePack, r' ', (0, 34), (16, 14), None, None)
                    CHECK_TextureGet(texturePack, r'&', (97, 34), (9, 14), None, None)
                    CHECK_TextureGet(texturePack, r'b', (33, 98), (6, 14), None, None)
                    CHECK_TextureGet(texturePack, 127, (240, 114), (2, 14), None, None)

                case _ => @Fail("Expected TexturePack: key18")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
