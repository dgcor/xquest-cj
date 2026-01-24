package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseTexturePackRects {
    var game: ?Game = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game2 = Game()
        this.game = game2
        parseFile(game2, "json/texturePacks/texturePackRects.json")
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

    static func CHECK_TexturePackGroup(texturePack: TexturePack, size: UInt32, groups: UInt32, palette: ?Palette): Unit {
        @Expect(texturePack.size, size)
        @Expect(texturePack.groupCount, groups)
        match ((texturePack.palette, palette)) {
            case (Some(pal), Some(pal2)) => @Expect(isObjEq(pal, pal2))
            case (None, None) => ()
            case _ => @Fail("CHECK_TexturePackGroup: Expected Palette match")
        }
        @Expect(texturePack.texture.isSome())
    }

    static func CHECK_MultiTexturePack(texturePack: TexturePack, size: UInt32, groups: UInt32, palette: ?Palette): Unit {
        @Expect(texturePack.size, size)
        @Expect(texturePack.groupCount, groups)
        match ((texturePack.palette, palette)) {
            case (Some(pal), Some(pal2)) => @Expect(isObjEq(pal, pal2))
            case (None, None) => ()
            case _ => @Fail("CHECK_MultiTexturePack: Expected Palette match")
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
    func test_TexturePackRects_key01() {
        if (let Some(game) <- game) {
            // invalid rects
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key02() {
        if (let Some(game) <- game) {
            // horizontal direction + invalid texture index
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 5, 1, None)

                    CHECK_TextureGet(texturePack, 0, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (16, 8), None, None)

                    CHECK_InvalidGet(texturePack, 3)
                    CHECK_InvalidGet(texturePack, 5)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 4), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 4), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 4), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 4), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key03() {
        if (let Some(game) <- game) {
            // directions number + unused offset
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 4, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 0), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (1, 1), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (2, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (3, 3), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key04() {
        if (let Some(game) <- game) {
            // odd directions number + global offset + line offset
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 3, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, (1, 1))
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, (1, 1))
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, (1, 1))
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, (2, 2))

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 1), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (2, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (3, 3), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key05() {
        if (let Some(game) <- game) {
            // directions number > size + line offset + absoluteOffsets + invertOffsets
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 5, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None, true)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None, true)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None, true)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, (1, -2), true)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 0), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (1, 1), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (2, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (3, 3), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key06() {
        if (let Some(game) <- game) {
            // directions array
            match (game.resources.getTexturePack("key06")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 10, 4, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 8, (0, 0), (16, 8), None, None)
                    CHECK_TextureGet(texturePack, 9, (0, 0), (16, 8), None, None)

                    CHECK_InvalidGet(texturePack, 10)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 6), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (7, 7), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (8, 8), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.Looped, (9, 9), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 9), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.Looped, (0, 9), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 9), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key06")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key07() {
        if (let Some(game) <- game) {
            // multi textures + directions numbers + directions array
            match (game.resources.getTexturePack("key07")) {
                case Some(texturePack) =>
                    CHECK_MultiTexturePack(texturePack, 12, 3, None)
                    @Expect(texturePack.getDirectionCount(0), 3)
                    @Expect(texturePack.getDirectionCount(1), 3)
                    @Expect(texturePack.getDirectionCount(2), 9)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 8, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 9, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 10, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 12, 1)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 5), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.Looped, (6, 6), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.Looped, (7, 7), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (8, 10), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (11, 13), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.Looped, (14, 15), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.BackAndForth, (16, 16), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.BackAndForth, (17, 17), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 2, AnimationType.BackAndForth, (18, 18), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 3, AnimationType.BackAndForth, (19, 19), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 4, AnimationType.BackAndForth, (20, 20), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 5, AnimationType.BackAndForth, (21, 21), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 6, AnimationType.BackAndForth, (22, 22), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 7, AnimationType.BackAndForth, (23, 23), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 11), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (0, 7), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 3, AnimationType.Looped, (8, 15), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 8, AnimationType.BackAndForth, (16, 23), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (0, 11), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key07")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key08() {
        if (let Some(game) <- game) {
            // groups
            match (game.resources.getTexturePack("key08")) {
                case Some(texturePack) =>
                    CHECK_TexturePackGroup(texturePack, 4, 2, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (11, 12), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (11, 12), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (13, 13), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.Looped, (14, 14), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (11, 12), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 3, AnimationType.Looped, (11, 14), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key08")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key09() {
        if (let Some(game) <- game) {
            // groups + multi textures
            match (game.resources.getTexturePack("key09")) {
                case Some(texturePack) =>
                    CHECK_MultiTexturePack(texturePack, 12, 3, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 3)
                    @Expect(texturePack.getDirectionCount(2), 3)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 7, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 8, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 9, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 10, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 11, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 12)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (0, 5), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (6, 7), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (8, 8), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 2, AnimationType.Looped, (9, 9), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.BackAndForth, (10, 10), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.BackAndForth, (11, 11), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 11), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (0, 5), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 3, AnimationType.Looped, (6, 9), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.BackAndForth, (10, 11), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (0, 11), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key09")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key10() {
        if (let Some(game) <- game) {
            // imageContainer
            match (game.resources.getTexturePack("key10")) {
                case Some(texturePack) =>
                    CHECK_MultiTexturePack(texturePack, 4, 2, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (0, 1), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (2, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (3, 3), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (0, 1), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 2, AnimationType.Looped, (2, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key10")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key11() {
        if (let Some(game) <- game) {
            // multiImageContainer
            match (game.resources.getTexturePack("key11")) {
                case Some(texturePack) =>
                    CHECK_MultiTexturePack(texturePack, 4, 2, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, (2, -2))
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), None, (2, -2))

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (0, 1), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (2, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (3, 3), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (0, 1), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 2, AnimationType.Looped, (2, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key11")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key12() {
        if (let Some(game) <- game) {
            // bitmapFont
            match (game.resources.getTexturePack("key12")) {
                case Some(texturePack) =>
                    CHECK_TexturePackGroup(texturePack, 4, 2, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (0, 1), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (2, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (3, 3), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (0, 1), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 2, AnimationType.Looped, (2, 3), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 3), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key12")
            }
        }
    }

    @TestCase
    func test_TexturePackRects_key13() {
        if (let Some(game) <- game) {
            // only groups (no rects)
            match (game.resources.getTexturePack("key13")) {
                case Some(texturePack) =>
                    CHECK_TexturePackGroup(texturePack, 256, 3, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, 1, (17, 0), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, 254, (225, 240), (6, 16), None, None)
                    CHECK_TextureGet(texturePack, 255, (240, 240), (6, 16), None, None)

                    CHECK_InvalidGet(texturePack, 256)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (0, 0), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (1, 2), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 1, 1, AnimationType.Looped, (3, 4), Time.ZERO)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (5, 8), Time.ZERO)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 255), Time.ZERO)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.PlayOnce, (0, 0), Time.ZERO)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.PlayOnce, (0, 0), Time.ZERO)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (1, 4), Time.ZERO)
                    CHECK_Animation(texturePack, 1, 2, AnimationType.Looped, (1, 4), Time.ZERO)
                    CHECK_Animation(texturePack, 2, -1, AnimationType.Looped, (5, 8), Time.ZERO)
                    CHECK_Animation(texturePack, 2, 1, AnimationType.Looped, (5, 8), Time.ZERO)
                    CHECK_Animation(texturePack, 3, -1, AnimationType.Looped, (0, 255), Time.ZERO)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (0, 255), Time.ZERO)

                case _ => @Fail("Expected TexturePack: key13")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
