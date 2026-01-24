package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseMultiImageContainerTexturePack {
    var game: ?Game = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game2 = Game()
        this.game = game2
        parseFile(game2, "json/texturePacks/multiImageContainerTexturePacks.json")
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
        @Expect(texturePack.texture.isNone())
    }

    static func CHECK_InvalidGet(texturePack: TexturePack, index: UInt32): Unit {
        @Expect(texturePack.get(index).isNone())
        @Expect(texturePack.getDirection(index), 0)
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
        indexRange: (UInt32, UInt32)): Unit {
        let animInfo = texturePack.getAnimation(groupIndex, directionIndex)
        @Expect(animInfo.animType, AnimationType.Looped)
        @Expect(animInfo.indexRange[0], indexRange[0])
        @Expect(animInfo.indexRange[1], indexRange[1])
        @Expect(animInfo.refresh.microseconds, Time.ZERO.microseconds)
    }

    static func CHECK_AnimationAndDirection(texturePack: TexturePack, groupIndex: Int32, directionIndex: Int32,
        indexRange: (UInt32, UInt32)): Unit {
        CHECK_Animation(texturePack, groupIndex, directionIndex, indexRange)
        @Expect(Int64(texturePack.getDirection(indexRange[0])), Int64(directionIndex))
        @Expect(Int64(texturePack.getDirection(indexRange[1])), Int64(directionIndex))
    }

    @TestCase
    func test_MultiImageContainerTexturePack_key01() {
        if (let Some(game) <- game) {
            // imageContainer array
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 12, 2, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), None, (2, -2))

                    CHECK_TextureGet(texturePack, 4, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 5, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 6, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 7, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 8, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 9, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 11, (0, 0), (4, 4), None, (2, -2))

                    CHECK_InvalidGet(texturePack, 12)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 3))
                    CHECK_AnimationAndDirection(texturePack, 1, 0, (4, 11))

                    CHECK_Animation(texturePack, -1, -1, (0, 11))
                    CHECK_Animation(texturePack, 0, -1, (0, 3))
                    CHECK_Animation(texturePack, 0, 1, (0, 3))
                    CHECK_Animation(texturePack, 1, -1, (4, 11))
                    CHECK_Animation(texturePack, 1, 1, (4, 11))
                    CHECK_Animation(texturePack, 2, -1, (0, 11))
                    CHECK_Animation(texturePack, 2, 0, (0, 11))

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_MultiImageContainerTexturePack_key02() {
        if (let Some(game) <- game) {
            // imageContainer array + multiple directions
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    let pal = game.resources.getPalette("pal")
                    @Expect(pal.isSome())

                    CHECK_TexturePack(texturePack, 12, 2, pal)
                    @Expect(texturePack.getDirectionCount(0), 2)
                    @Expect(texturePack.getDirectionCount(1), 4)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), pal, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), pal, None)

                    CHECK_TextureGet(texturePack, 4, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, 5, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, 6, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, 7, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, 8, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, 9, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), pal, None)
                    CHECK_TextureGet(texturePack, 11, (0, 0), (4, 4), pal, None)

                    CHECK_InvalidGet(texturePack, 12)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 1))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, (2, 3))
                    CHECK_AnimationAndDirection(texturePack, 1, 0, (4, 5))
                    CHECK_AnimationAndDirection(texturePack, 1, 1, (6, 7))
                    CHECK_AnimationAndDirection(texturePack, 1, 2, (8, 9))
                    CHECK_AnimationAndDirection(texturePack, 1, 3, (10, 11))

                    CHECK_Animation(texturePack, -1, -1, (0, 11))
                    CHECK_Animation(texturePack, 0, 2, (0, 3))
                    CHECK_Animation(texturePack, 1, 4, (4, 11))
                    CHECK_Animation(texturePack, 2, 0, (0, 11))

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_MultiImageContainerTexturePack_key03() {
        if (let Some(game) <- game) {
            // imageContainer array + multiple odd directions
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 24, 3, None)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 3)
                    @Expect(texturePack.getDirectionCount(2), 9)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (0, 0), (4, 4), None, None)

                    CHECK_TextureGet(texturePack, 8, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 9, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 10, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 12, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 13, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 14, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 15, (0, 0), (4, 4), None, None)

                    CHECK_TextureGet(texturePack, 16, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 17, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 18, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 19, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 20, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 21, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 22, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 23, (0, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 24)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 1))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, (2, 3))
                    CHECK_AnimationAndDirection(texturePack, 0, 2, (4, 5))
                    CHECK_AnimationAndDirection(texturePack, 0, 3, (6, 7))
                    CHECK_AnimationAndDirection(texturePack, 1, 0, (8, 10))
                    CHECK_AnimationAndDirection(texturePack, 1, 1, (11, 13))
                    CHECK_AnimationAndDirection(texturePack, 1, 2, (14, 15))
                    CHECK_AnimationAndDirection(texturePack, 2, 0, (16, 16))
                    CHECK_AnimationAndDirection(texturePack, 2, 1, (17, 17))
                    CHECK_AnimationAndDirection(texturePack, 2, 2, (18, 18))
                    CHECK_AnimationAndDirection(texturePack, 2, 3, (19, 19))
                    CHECK_AnimationAndDirection(texturePack, 2, 4, (20, 20))
                    CHECK_AnimationAndDirection(texturePack, 2, 5, (21, 21))
                    CHECK_AnimationAndDirection(texturePack, 2, 6, (22, 22))
                    CHECK_AnimationAndDirection(texturePack, 2, 7, (23, 23))

                    CHECK_Animation(texturePack, -1, -1, (0, 23))
                    CHECK_Animation(texturePack, 0, -1, (0, 7))
                    CHECK_Animation(texturePack, 0, 4, (0, 7))
                    CHECK_Animation(texturePack, 1, -1, (8, 15))
                    CHECK_Animation(texturePack, 1, 3, (8, 15))
                    CHECK_Animation(texturePack, 2, -1, (16, 23))
                    CHECK_Animation(texturePack, 2, 8, (16, 23))
                    CHECK_Animation(texturePack, 3, -1, (0, 23))
                    CHECK_Animation(texturePack, 3, 0, (0, 23))

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
