package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseMultiTextureTexturePack {
    var game: ?Game = None
    var pal: ?Palette = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game2 = Game()
        this.game = game2
        parseFile(game2, "json/texturePacks/multiTextureTexturePacks.json")

        pal = game2.resources.getPalette("pal")
    }

    @AfterAll
    func cleanup() {
        game?.close()
        FileUtils.deinitPhysFS()
    }

    static func CHECK_TexturePack(texturePack: TexturePack, size: UInt32, groups: UInt32, palette: ?Palette): Unit {
        @Expect(texturePack.size, size)
        @Expect(texturePack.groupCount, groups)
        match ((texturePack.palette, palette)) {
            case (Some(pal), Some(pal2)) => @Expect(isObjEq(pal, pal2))
            case (None, None) => ()
            case _ => @Fail("CHECK_TexturePack: Expected Palette match")
        }
        match (groups) {
            case 1 => @Expect(texturePack.texture.isSome())
            case _ => @Expect(texturePack.texture.isNone())
        }
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
                @Expect(ti.absoluteOffset, false)
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

    static func CHECK_AnimationAndDirection(texturePack: TexturePack, groupIndex: Int32, directionIndex: Int32,
        animType: AnimationType, indexRange: (UInt32, UInt32), refresh: Time): Unit {
        CHECK_Animation(texturePack, groupIndex, directionIndex, animType, indexRange, refresh)
        @Expect(Int64(texturePack.getDirection(indexRange[0])), Int64(directionIndex))
        @Expect(Int64(texturePack.getDirection(indexRange[1])), Int64(directionIndex))
    }

    @TestCase
    func test_MultiTextureTexturePack_key01() {
        if (let Some(game) <- game) {
            // invalid texture array (missing id)
            @Expect(game.resources.getImageContainer("key01").isNone())
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key02() {
        if (let Some(game) <- game) {
            // texture array
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 1, 1, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 8), None, None)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 0), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 0), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 0), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 0), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key03() {
        if (let Some(game) <- game) {
            @Expect(pal.isSome())

            // palette + directions array
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, pal)
                    @Expect(texturePack.getDirectionCount(0), 3)
                    @Expect(texturePack.getDirectionCount(1), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 1, (0, 2), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 3, (0, 6), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 5, (8, 2), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 7, (8, 6), (8, 2), pal, (1, 1))

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.BackAndForth, (0, 2),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.BackAndForth, (3, 6),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.BackAndForth, (7, 7),
                        Time(milliseconds: 50))

                    @Expect(texturePack.getDirection(8), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.BackAndForth, (0, 7), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 0, 3, AnimationType.BackAndForth, (0, 7), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key04() {
        if (let Some(game) <- game) {
            // directions array + directions number
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 16, 2, None)
                    @Expect(texturePack.getDirectionCount(0), 3)
                    @Expect(texturePack.getDirectionCount(1), 4)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 1, (0, 2), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 3, (0, 6), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 5, (8, 2), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 7, (8, 6), (8, 2), None, (1, 1))

                    CHECK_TextureGet(texturePack, 8, (0, 0), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 9, (0, 2), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 10, (0, 4), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 11, (0, 6), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 12, (8, 0), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 13, (8, 2), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 14, (8, 4), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 15, (8, 6), (8, 2), None, (2, 1))

                    CHECK_InvalidGet(texturePack, 16)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.BackAndForth, (0, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.BackAndForth, (3, 6), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.BackAndForth, (7, 7), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.PlayOnce, (8, 9),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.PlayOnce, (10, 11),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.PlayOnce, (12, 13),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 3, AnimationType.PlayOnce, (14, 15),
                        Time(milliseconds: 50))

                    @Expect(texturePack.getDirection(16), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 15), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.BackAndForth, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 4, AnimationType.PlayOnce, (8, 15), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 15), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key05() {
        if (let Some(game) <- game) {

            // directions array + directions number (reverse order)
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 16, 2, pal)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 3)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 1, (0, 2), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 3, (0, 6), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 5, (8, 2), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 7, (8, 6), (8, 2), pal, (2, 1))

                    CHECK_TextureGet(texturePack, 8, (0, 0), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 9, (0, 2), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 10, (0, 4), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 11, (0, 6), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 12, (8, 0), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 13, (8, 2), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 14, (8, 4), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 15, (8, 6), (8, 2), pal, (1, 1))

                    CHECK_InvalidGet(texturePack, 16)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (0, 1),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.PlayOnce, (2, 3),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.PlayOnce, (4, 5),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.PlayOnce, (6, 7),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.BackAndForth, (8, 10), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.BackAndForth, (11, 14), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.BackAndForth, (15, 15), Time.ZERO)

                    @Expect(texturePack.getDirection(16), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 15), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.PlayOnce, (0, 7), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, 3, AnimationType.BackAndForth, (8, 15), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 15), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key06() {
        if (let Some(game) <- game) {
            // start index + directions array + directions number
            match (game.resources.getTexturePack("key06")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 16, 2, None)
                    @Expect(texturePack.getDirectionCount(0), 3)
                    @Expect(texturePack.getDirectionCount(1), 4)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 11, (0, 2), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 12, (0, 4), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 13, (0, 6), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 14, (8, 0), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 15, (8, 2), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 16, (8, 4), (8, 2), None, (1, 1))
                    CHECK_TextureGet(texturePack, 17, (8, 6), (8, 2), None, (1, 1))

                    CHECK_InvalidGet(texturePack, 18)
                    CHECK_InvalidGet(texturePack, 19)

                    CHECK_TextureGet(texturePack, 20, (0, 0), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 21, (0, 2), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 22, (0, 4), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 23, (0, 6), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 24, (8, 0), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 25, (8, 2), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 26, (8, 4), (8, 2), None, (2, 1))
                    CHECK_TextureGet(texturePack, 27, (8, 6), (8, 2), None, (2, 1))

                    CHECK_InvalidGet(texturePack, 28)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.BackAndForth, (10, 12), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.BackAndForth, (13, 16), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.BackAndForth, (17, 17), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.PlayOnce, (20, 21),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.PlayOnce, (22, 23),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.PlayOnce, (24, 25),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 3, AnimationType.PlayOnce, (26, 27),
                        Time(milliseconds: 50))

                    @Expect(texturePack.getDirection(0), 0)
                    @Expect(texturePack.getDirection(9), 0)
                    @Expect(texturePack.getDirection(18), 0)
                    @Expect(texturePack.getDirection(19), 0)
                    @Expect(texturePack.getDirection(28), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 27), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.BackAndForth, (10, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 4, AnimationType.PlayOnce, (20, 27), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (10, 27), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key06")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key07() {
        if (let Some(game) <- game) {

            // start index + directions array + directions number (reverse order)
            match (game.resources.getTexturePack("key07")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 16, 2, pal)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 3)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 11, (0, 2), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 12, (0, 4), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 13, (0, 6), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 14, (8, 0), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 15, (8, 2), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 16, (8, 4), (8, 2), pal, (2, 1))
                    CHECK_TextureGet(texturePack, 17, (8, 6), (8, 2), pal, (2, 1))

                    CHECK_InvalidGet(texturePack, 18)
                    CHECK_InvalidGet(texturePack, 19)

                    CHECK_TextureGet(texturePack, 20, (0, 0), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 21, (0, 2), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 22, (0, 4), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 23, (0, 6), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 24, (8, 0), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 25, (8, 2), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 26, (8, 4), (8, 2), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 27, (8, 6), (8, 2), pal, (1, 1))

                    CHECK_InvalidGet(texturePack, 28)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (10, 11),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.PlayOnce, (12, 13),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.PlayOnce, (14, 15),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.PlayOnce, (16, 17),
                        Time(milliseconds: 50))
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.BackAndForth, (20, 22), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.BackAndForth, (23, 26), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.BackAndForth, (27, 27), Time.ZERO)

                    @Expect(texturePack.getDirection(0), 0)
                    @Expect(texturePack.getDirection(9), 0)
                    @Expect(texturePack.getDirection(18), 0)
                    @Expect(texturePack.getDirection(19), 0)
                    @Expect(texturePack.getDirection(28), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 27), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.PlayOnce, (10, 17), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, 3, AnimationType.BackAndForth, (20, 27), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (10, 27), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key07")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key08() {
        if (let Some(game) <- game) {
            // overlapping directions + gaps
            match (game.resources.getTexturePack("key08")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 6, 3, None)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 2)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 8), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 8), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 8), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 0), (8, 8), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (8, 8), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 0), (8, 8), None, None)

                    CHECK_InvalidGet(texturePack, 6, 3)
                    CHECK_InvalidGet(texturePack, 7, 3)
                    CHECK_InvalidGet(texturePack, 8, 0)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 1), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (2, 3), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (4, 5), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (6, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (2, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (5, 5), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 1, AnimationType.Looped, (6, 6), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 5), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 1, AnimationType.Looped, (2, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.Looped, (4, 5), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (0, 5), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key08")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key09() {
        if (let Some(game) <- game) {
            // odd directions number
            match (game.resources.getTexturePack("key09")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 16, 2, None)
                    @Expect(texturePack.getDirectionCount(0), 3)
                    @Expect(texturePack.getDirectionCount(1), 9)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 14, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 15, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 16, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 17, (12, 4), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 18)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (3, 5), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (6, 7), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (10, 10), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (11, 11), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.Looped, (12, 12), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 3, AnimationType.Looped, (13, 13), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 4, AnimationType.Looped, (14, 14), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 5, AnimationType.Looped, (15, 15), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 6, AnimationType.Looped, (16, 16), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 7, AnimationType.Looped, (17, 17), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 8, AnimationType.Looped, (10, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 17), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key09")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key10() {
        if (let Some(game) <- game) {

            // overlapping directions + startIndex in first texturePack
            match (game.resources.getTexturePack("key10")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 12, 3, pal)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 2)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 11, (8, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 12, (0, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 13, (8, 4), (8, 4), pal, None)

                    CHECK_TextureGet(texturePack, 14, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 15, (8, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 16, (0, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 17, (8, 4), (8, 4), pal, None)

                    CHECK_TextureGet(texturePack, 18, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 19, (8, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 20, (0, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 21, (8, 4), (8, 4), pal, None)

                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (10, 11), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.PlayOnce, (12, 13), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.PlayOnce, (14, 15), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.PlayOnce, (16, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (19, 19), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.Looped, (20, 20), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.PlayOnce, (10, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.PlayOnce, (10, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.BackAndForth, (14, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 1, AnimationType.BackAndForth, (14, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 2, -1, AnimationType.Looped, (18, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.Looped, (18, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 3, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 21), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key10")
            }
        }
    }

    @TestCase
    func test_MultiTextureTexturePack_key11() {
        if (let Some(game) <- game) {

            // default groups
            match (game.resources.getTexturePack("key11")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 12, 3, pal)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 11, (8, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 12, (0, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 13, (8, 4), (8, 4), pal, None)

                    CHECK_TextureGet(texturePack, 14, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 15, (8, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 16, (0, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 17, (8, 4), (8, 4), pal, None)

                    CHECK_TextureGet(texturePack, 18, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 19, (8, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 20, (0, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 21, (8, 4), (8, 4), pal, None)

                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (10, 13), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (14, 17), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (18, 21), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.Looped, (10, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (14, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 1, AnimationType.Looped, (14, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 2, -1, AnimationType.Looped, (18, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 1, AnimationType.Looped, (18, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 3, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 21), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key11")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
