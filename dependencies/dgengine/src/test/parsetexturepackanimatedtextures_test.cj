package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseTexturePackAnimatedTextures {
    var game: ?Game = None
    var epoch = 0i32

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game2 = Game()
        this.game = game2
        parseFile(game2, "json/texturePacks/texturePackAnimatedTextures.json")
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
        CHECK_InvalidGet(texturePack, index, 0)
    }

    static func CHECK_InvalidGet(texturePack: TexturePack, index: UInt32, direction: UInt32): Unit {
        @Expect(texturePack.get(index).isNone())
        @Expect(texturePack.getDirection(index), direction)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, index: UInt32, position: (Int32, Int32),
        size: (Int32, Int32), palette: ?Palette, offset: ?(Int64, Int64)): Unit {
        CHECK_TextureGet(texturePack, index, position, size, palette, offset, false)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, index: UInt32, position: (Int32, Int32),
        size: (Int32, Int32), palette: ?Palette, offset: ?(Int64, Int64), absoluteOffsets: Bool): Unit {
        match (texturePack.get(index)) {
            case Some(ti) =>
                @Expect(ti.textureRect.position == Vector2i(position))
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
                @Expect(ti.absoluteOffset, absoluteOffsets)
                @Expect(ti.blendMode, BlendAlpha)
                @Expect(ti.nextIndex == -1)
            case _ => @Fail("CHECK_TextureGet: Expected TextureInfo")
        }
        @Expect(texturePack.getTextureSize(index) == Vector2i(size))
    }

    static func CHECK_Animation(texturePack: TexturePack, groupIndex: Int32, directionIndex: Int32,
        animType: AnimationType, indexRange: (UInt32, UInt32), refresh: Time): Unit {
        let animInfo = texturePack.getAnimation(groupIndex, directionIndex)
        @Expect(animInfo.animType, animType)
        @Expect(animInfo.indexRange[0], indexRange[0])
        @Expect(animInfo.indexRange[1], indexRange[1])
        @Expect(animInfo.refresh.microseconds, refresh.microseconds)
    }

    @TestCase
    func test_TexturePackAnimatedTextures_key01() {
        if (let Some(game) <- game) {
            // animatedTextures
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 60))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)

                    texturePack.update(epoch, Time(milliseconds: 60))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)

                    texturePack.update(epoch, Time(milliseconds: 60))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 30))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 60))

                    CHECK_TextureGet(texturePack, 2, (8, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 29))

                    CHECK_TextureGet(texturePack, 2, (8, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 0))

                    CHECK_TextureGet(texturePack, 2, (8, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 1))

                    CHECK_TextureGet(texturePack, 2, (0, 0), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 60))

                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_TexturePackAnimatedTextures_key02() {
        if (let Some(game) <- game) {
            // animatedTextures + different refresh rates
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 60))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (4, 0), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 15))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (4, 0), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 15))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 20))

                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (4, 4), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_TexturePackAnimatedTextures_key03() {
        if (let Some(game) <- game) {
            // animatedTextures + default refresh rate + custom index
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 1, (12, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 1, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 1, (12, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 1, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_TexturePackAnimatedTextures_key04() {
        if (let Some(game) <- game) {
            // animatedTextures + out of range custom index
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_TextureGet(texturePack, 50, (12, 0), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 50, (12, 4), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 50, (12, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_TexturePackAnimatedTextures_key05() {
        if (let Some(game) <- game) {
            // animatedTextures + textureIndexes
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 1, None)

                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (12, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 1)
                    CHECK_InvalidGet(texturePack, 2)
                    CHECK_InvalidGet(texturePack, 3)
                    CHECK_InvalidGet(texturePack, 10)
                    CHECK_InvalidGet(texturePack, 12)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (12, 0), (4, 4), None, None)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_InvalidGet(texturePack, 10)
                    CHECK_InvalidGet(texturePack, 12)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (10, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (10, 13), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_TexturePackAnimatedTextures_key06() {
        if (let Some(game) <- game) {
            // textureIndexes + animatedTextures
            match (game.resources.getTexturePack("key06")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 14, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_TextureGet(texturePack, 10, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (12, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (12, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)
                    CHECK_InvalidGet(texturePack, 9)
                    CHECK_InvalidGet(texturePack, 14)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (12, 0), (4, 4), None, None)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 13), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key06")
            }
        }
    }

    @TestCase
    func test_TexturePackAnimatedTextures_key07() {
        if (let Some(game) <- game) {
            // textureIndexes + animatedTextures
            match (game.resources.getTexturePack("key07")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 14, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (12, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)
                    CHECK_InvalidGet(texturePack, 9)
                    CHECK_InvalidGet(texturePack, 14)

                    epoch++
                    texturePack.update(epoch, Time(milliseconds: 50))

                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (12, 0), (4, 4), None, None)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.Looped, (0, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (0, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 13), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key07")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
