package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseStackedTexturePack {
    var game: ?Game = None
    var pal: ?Palette = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game2 = Game()
        this.game = game2
        parseFile(game2, "json/texturePacks/stackedTexturePacks.json")

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
    }

    static func CHECK_TexturePackGroup(texturePack: TexturePack, size: UInt32, groups: UInt32, palette: ?Palette): Unit {
        @Expect(texturePack.size, size)
        @Expect(texturePack.groupCount, groups)
        match ((texturePack.palette, palette)) {
            case (Some(pal), Some(pal2)) => @Expect(isObjEq(pal, pal2))
            case (None, None) => ()
            case _ => @Fail("CHECK_TexturePackGroup: Expected Palette match")
        }
        @Expect(texturePack.texture.isNone())
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

    static func CHECK_AnimationAndDirection(texturePack: TexturePack, groupIndex: Int32, directionIndex: Int32,
        animType: AnimationType, indexRange: (UInt32, UInt32), refresh: Time): Unit {
        CHECK_Animation(texturePack, groupIndex, directionIndex, animType, indexRange, refresh)
        @Expect(Int64(texturePack.getDirection(indexRange[0])), Int64(directionIndex))
        @Expect(Int64(texturePack.getDirection(indexRange[1])), Int64(directionIndex))
    }

    @TestCase
    func test_StackedTexturePack_key01() {
        if (let Some(game) <- game) {
            @Expect(pal.isSome())

            // 2 texturePacks + overlapping indexes
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 10, 1, None)

                    CHECK_TextureGet(texturePack, 1, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 4), (8, 4), None, None)

                    CHECK_TextureGet(texturePack, 7, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 8, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 9, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 10, (4, 4), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 11)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (1, 6), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (1, 10), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (1, 10), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (1, 10), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_StackedTexturePack_key02() {
        if (let Some(game) <- game) {
            // 2 texturePacks + index gaps
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 17, 1, pal)

                    CHECK_TextureGet(texturePack, 1, (8, 4), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 3, (8, 0), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 4, (0, 0), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 5, (8, 0), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 6, (0, 4), (8, 4), pal, (1, 1))

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 7)
                    CHECK_InvalidGet(texturePack, 8)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (8, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 13)
                    CHECK_InvalidGet(texturePack, 14)

                    CHECK_TextureGet(texturePack, 15, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 16, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 17, (4, 4), (4, 4), None, None)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (1, 6), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (1, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (1, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (1, 17), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_StackedTexturePack_key03() {
        if (let Some(game) <- game) {
            // 1 texturePack
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 6, 1, pal)

                    CHECK_TextureGet(texturePack, 1, (8, 4), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 3, (8, 0), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 4, (0, 0), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 5, (8, 0), (8, 4), pal, (1, 1))
                    CHECK_TextureGet(texturePack, 6, (0, 4), (8, 4), pal, (1, 1))

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 7)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (1, 6), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (1, 6), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (1, 6), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (1, 6), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_StackedTexturePack_key04() {
        if (let Some(game) <- game) {
            // 2 texturePacks + multiple directions + no overrides
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePackGroup(texturePack, 12, 3, pal)
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
                    CHECK_Animation(texturePack, 0, 4, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 21), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_StackedTexturePack_key05() {
        if (let Some(game) <- game) {
            // 2 texturePacks + multiple directions + overrides
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePackGroup(texturePack, 12, 1, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (8, 0), (4, 4), None, None)

                    CHECK_TextureGet(texturePack, 13, (8, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 14, (0, 0), (8, 4), pal, None)

                    CHECK_TextureGet(texturePack, 15, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 16, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 17, (4, 4), (4, 4), None, None)

                    CHECK_TextureGet(texturePack, 18, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 19, (8, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 20, (0, 4), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 21, (8, 4), (8, 4), pal, None)

                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (10, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (12, 13), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.PlayOnce, (14, 15), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.PlayOnce, (16, 17), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (19, 19), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.Looped, (20, 20), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 2, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 3, -1, AnimationType.Looped, (10, 21), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 21), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
