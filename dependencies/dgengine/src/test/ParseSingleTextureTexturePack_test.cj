package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

@Test
class TestParseSingleTextureTexturePack {
    var game: ?Game = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game = Game()
        this.game = game
        parseFile(game, "json/texturePacks/singleTextureTexturePacks.json")
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
    func test_SingleTextureTexturePack_key01() {
        if (let Some(game) <- game) {
            // texture
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 1, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 8), None, None)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 0), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 0), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 0), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 0), Time.zero)

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key02() {
        if (let Some(game) <- game) {
            // texture + startIndex + invalid palette
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 1, 1, None)

                    CHECK_InvalidGet(texturePack, 0)

                    CHECK_TextureGet(texturePack, 1, (0, 0), (16, 8), None, None)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (1, 1),
                        Time(milliseconds: 50))

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (1, 1), Time.zero)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.PlayOnce, (1, 1), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (1, 1), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (1, 1), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (1, 1), Time.zero)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key03() {
        if (let Some(game) <- game) {
            // range + horizontal direction
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, (2, -2))

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 3), Time.zero)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key04() {
        if (let Some(game) <- game) {
            // range + vertical direction + palette
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    let pal = game.resources.getPalette("pal")
                    @Expect(pal.isSome())

                    CHECK_TexturePack(texturePack, 4, 1, pal)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (8, 4), pal, (2, -2))
                    CHECK_TextureGet(texturePack, 11, (0, 4), (8, 4), pal, (2, -2))
                    CHECK_TextureGet(texturePack, 12, (8, 0), (8, 4), pal, (2, -2))
                    CHECK_TextureGet(texturePack, 13, (8, 4), (8, 4), pal, (2, -2))

                    CHECK_InvalidGet(texturePack, 14)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (10, 13), Time.zero)

                    @Expect(texturePack.getDirection(0), 0)
                    @Expect(texturePack.getDirection(9), 0)
                    @Expect(texturePack.getDirection(14), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 13), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 13), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (10, 13), Time.zero)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key05() {
        if (let Some(game) <- game) {
            // odd frame range + horizontal direction + odd directions < size
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 6, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 1), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (2, 2), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (3, 3), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (4, 5), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 4, AnimationType.Looped, (6, 6), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 5, AnimationType.Looped, (7, 7), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 6, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 7, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key06() {
        if (let Some(game) <- game) {
            // odd frame range + horizontal direction + odd directions < size
            match (game.resources.getTexturePack("key06")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 7, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 1), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (2, 2), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (3, 3), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (4, 4), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 4, AnimationType.Looped, (5, 5), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 5, AnimationType.Looped, (6, 6), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 6, AnimationType.Looped, (7, 7), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 7, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key06")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key07() {
        if (let Some(game) <- game) {
            // odd frame range + horizontal direction + odd directions > size
            match (game.resources.getTexturePack("key07")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 9, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 0), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (1, 1), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (2, 2), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (3, 3), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 4, AnimationType.Looped, (4, 4), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 5, AnimationType.Looped, (5, 5), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 6, AnimationType.Looped, (6, 6), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 7, AnimationType.Looped, (7, 7), Time.zero)

                    @Expect(texturePack.getDirection(8), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 8, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 9, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 10, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key07")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key08() {
        if (let Some(game) <- game) {
            // odd frame range + horizontal direction + odd directions > size
            match (game.resources.getTexturePack("key08")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 16, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (4, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (12, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (4, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (12, 4), (4, 4), None, None)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 0), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (1, 1), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (2, 2), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (3, 3), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 4, AnimationType.Looped, (4, 4), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 5, AnimationType.Looped, (5, 5), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 6, AnimationType.Looped, (6, 6), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 7, AnimationType.Looped, (7, 7), Time.zero)

                    @Expect(texturePack.getDirection(8), 0)
                    @Expect(texturePack.getDirection(15), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 8, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 15, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 16, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key08")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key09() {
        if (let Some(game) <- game) {
            // odd frame range + vertical direction + invalid palette + 2 directions
            match (game.resources.getTexturePack("key09")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 2, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 6), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 7, (8, 6), (8, 2), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (4, 7), Time.zero)

                    @Expect(texturePack.getDirection(8), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key09")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key10() {
        if (let Some(game) <- game) {
            // frame number - equal to [1, n]
            match (game.resources.getTexturePack("key10")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 2, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 4), (16, 4), None, None)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.BackAndForth, (0, 1),
                        Time(milliseconds: 50))

                    @Expect(texturePack.getDirection(2), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 1), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.BackAndForth, (0, 1), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 1), Time.zero)

                case _ => @Fail("Expected TexturePack: key10")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key11() {
        if (let Some(game) <- game) {
            // texture + invalid frame range (non integer split)
            @Expect(game.resources.getTexturePack("key11").isNone())
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key12() {
        if (let Some(game) <- game) {
            // directions array
            match (game.resources.getTexturePack("key12")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 3, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 6), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 7, (8, 6), (8, 2), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 2), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (3, 6), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (7, 7), Time.zero)

                    @Expect(texturePack.getDirection(8), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key12")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key13() {
        if (let Some(game) <- game) {
            // directions array + invalid array element + missing direction for index 1
            match (game.resources.getTexturePack("key13")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 3, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 6), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 7, (8, 6), (8, 2), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 0), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (2, 6), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (7, 7), Time.zero)

                    @Expect(texturePack.getDirection(1), 0)
                    @Expect(texturePack.getDirection(8), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key13")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key14() {
        if (let Some(game) <- game) {
            // directions array + overlapping direction ranges + bad range (first > last)
            match (game.resources.getTexturePack("key14")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 2, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 6), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 2), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 2), None, None)
                    CHECK_TextureGet(texturePack, 7, (8, 6), (8, 2), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (1, 6), Time(milliseconds: 50))

                    @Expect(texturePack.getDirection(1), 0)
                    @Expect(texturePack.getDirection(3), 0)
                    @Expect(texturePack.getDirection(4), 1)
                    @Expect(texturePack.getDirection(6), 1)
                    @Expect(texturePack.getDirection(7), 0)
                    @Expect(texturePack.getDirection(8), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.Looped, (0, 7), Time(milliseconds: 50))
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key14")
            }
        }
    }

    @TestCase
    func test_SingleTextureTexturePack_key15() {
        if (let Some(game) <- game) {
            // directions array + overflow range
            match (game.resources.getTexturePack("key15")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 2, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4, 1)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 1), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (2, 12), Time.zero)

                    @Expect(texturePack.getDirection(2), 1)
                    @Expect(texturePack.getDirection(4), 1)
                    @Expect(texturePack.getDirection(12), 1)
                    @Expect(texturePack.getDirection(13), 0)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 3), Time.zero)

                case _ => @Fail("Expected TexturePack: key15")
            }
        }
    }
}
