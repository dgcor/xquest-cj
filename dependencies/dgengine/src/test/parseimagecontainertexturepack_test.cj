package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseImageContainerTexturePack {
    var game: ?Game = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game2 = Game()
        this.game = game2
        parseFile(game2, "json/texturePacks/imageContainerTexturePacks.json")
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
    func test_ImageContainerTexturePack_key01() {
        if (let Some(game) <- game) {
            // imageContainer
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 3))

                    CHECK_Animation(texturePack, -1, -1, (0, 3))
                    CHECK_Animation(texturePack, 0, -1, (0, 3))
                    CHECK_Animation(texturePack, 0, 1, (0, 3))
                    CHECK_Animation(texturePack, 1, -1, (0, 3))
                    CHECK_Animation(texturePack, 1, 0, (0, 3))

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_ImageContainerTexturePack_key02() {
        if (let Some(game) <- game) {
            // imageContainer single array + palette
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    let pal = game.resources.getPalette("pal")
                    @Expect(pal.isSome())

                    CHECK_TexturePack(texturePack, 4, 1, pal)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), pal, (2, -2))
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), pal, (2, -2))
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), pal, (2, -2))
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), pal, (2, -2))

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 3))

                    CHECK_Animation(texturePack, -1, -1, (0, 3))
                    CHECK_Animation(texturePack, 0, 1, (0, 3))
                    CHECK_Animation(texturePack, 1, 0, (0, 3))

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_ImageContainerTexturePack_key03() {
        if (let Some(game) <- game) {
            // imageContainer + invalid palette
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 1, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 2, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 3, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 4, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 5, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 6, (0, 0), (4, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 7, (0, 0), (4, 4), None, (2, -2))

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 7))

                    CHECK_Animation(texturePack, -1, -1, (0, 7))
                    CHECK_Animation(texturePack, 0, 1, (0, 7))
                    CHECK_Animation(texturePack, 1, 0, (0, 7))

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_ImageContainerTexturePack_key04() {
        if (let Some(game) <- game) {
            // imageContainer + invalid palette
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 4, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (0, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 1))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, (2, 3))
                    CHECK_AnimationAndDirection(texturePack, 0, 2, (4, 5))
                    CHECK_AnimationAndDirection(texturePack, 0, 3, (6, 7))

                    CHECK_Animation(texturePack, -1, -1, (0, 7))
                    CHECK_Animation(texturePack, 0, 4, (0, 7))
                    CHECK_Animation(texturePack, 1, 0, (0, 7))

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_ImageContainerTexturePack_key05() {
        if (let Some(game) <- game) {
            // imageContainer + invalid palette
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 3, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (0, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 2))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, (3, 5))
                    CHECK_AnimationAndDirection(texturePack, 0, 2, (6, 7))

                    CHECK_Animation(texturePack, -1, -1, (0, 7))
                    CHECK_Animation(texturePack, 0, 4, (0, 7))
                    CHECK_Animation(texturePack, 1, 0, (0, 7))

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_ImageContainerTexturePack_key06() {
        if (let Some(game) <- game) {
            // imageContainer + invalid palette
            match (game.resources.getTexturePack("key06")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 9, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 0), (4, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (0, 0), (4, 4), None, None)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, (0, 0))
                    CHECK_AnimationAndDirection(texturePack, 0, 1, (1, 1))
                    CHECK_AnimationAndDirection(texturePack, 0, 2, (2, 2))
                    CHECK_AnimationAndDirection(texturePack, 0, 3, (3, 3))
                    CHECK_AnimationAndDirection(texturePack, 0, 4, (4, 4))
                    CHECK_AnimationAndDirection(texturePack, 0, 5, (5, 5))
                    CHECK_AnimationAndDirection(texturePack, 0, 6, (6, 6))
                    CHECK_AnimationAndDirection(texturePack, 0, 7, (7, 7))

                    CHECK_Animation(texturePack, -1, -1, (0, 7))
                    CHECK_Animation(texturePack, 0, 8, (0, 7))
                    CHECK_Animation(texturePack, 1, 0, (0, 7))

                case _ => @Fail("Expected TexturePack: key06")
            }
        }
    }

    @TestCase
    func test_ImageContainerTexturePack_key07() {
        if (let Some(game) <- game) {
            // invalid imageContainer
            @Expect(game.resources.getTexturePack("key07").isNone())
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
