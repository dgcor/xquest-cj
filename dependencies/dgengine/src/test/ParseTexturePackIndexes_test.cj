package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

@Test
class TestParseTexturePackIndexes {
    var game: ?Game = None
    var pal: ?Palette = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game = Game()
        this.game = game
        parseFile(game, "json/texturePacks/texturePackIndexes.json")

        pal = game.resources.getPalette("pal")
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

    static func CHECK_MultiTexturePack(texturePack: TexturePack, size: UInt32, groups: UInt32, palette: ?Palette): Unit {
        @Expect(texturePack.size, size)
        @Expect(texturePack.groupCount, groups)
        match ((texturePack.palette, palette)) {
            case (Some(pal), Some(pal2)) => @Expect(isObjEq(pal, pal2))
            case (None, None) => ()
            case _ => @Fail("CHECK_MultiTexturePack: Expected Palette match")
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

    static func CHECK_TextureGetAll(texturePack: TexturePack, index: UInt32, position: (Int32, Int32),
        size: (Int32, Int32), palette: ?Palette, offset: ?(Int64, Int64)): Unit {
        match (texturePack.getAll(index)) {
            case Some(ti) => match (ti) {
                case TextureInfoSingle(ti) =>
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
                case _ => @Fail("CHECK_TextureGetAll: Expected TextureInfo")
            }
            case _ => @Fail("CHECK_TextureGetAll: Expected TextureInfo")
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
    func test_TexturePackIndexes_key01() {
        if (let Some(game) <- game) {
            @Expect(pal.isSome())

            // textureIndexes (array) + default onlyUseIndexed (true)
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 6, 1, None)

                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1024, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1025, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1026, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1027, (0, 4), (8, 4), None, None)

                    // check get var (test that texturePackIndexWrapper uses correct index mapping)

                    CHECK_TextureGetAll(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGetAll(texturePack, 1027, (0, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 3)
                    CHECK_InvalidGet(texturePack, 1023)
                    CHECK_InvalidGet(texturePack, 1028)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (1, 1027), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (1, 1027), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (1, 1027), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (1, 1027), Time.zero)

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key02() {
        if (let Some(game) <- game) {
            // textureIndexes (array) + onlyUseIndexed (false) + reverseMapIndex (ignored)
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 1028, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1024, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1025, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1026, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1027, (0, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)
                    CHECK_InvalidGet(texturePack, 1023)
                    CHECK_InvalidGet(texturePack, 1028)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 1027), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 1027), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 1027), Time.zero)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key03() {
        if (let Some(game) <- game) {
            // textureIndexes (number) + default onlyUseIndexed (true)
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 5, 1, None)

                    CHECK_TextureGet(texturePack, 16, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 17, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 18, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 19, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 1)
                    CHECK_InvalidGet(texturePack, 2)
                    CHECK_InvalidGet(texturePack, 3)
                    CHECK_InvalidGet(texturePack, 15)
                    CHECK_InvalidGet(texturePack, 20)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (16, 20), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (16, 20), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (16, 20), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (16, 20), Time.zero)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key04() {
        if (let Some(game) <- game) {
            // textureIndexes (number) + onlyUseIndexed (false)
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 21, 1, None)

                    CHECK_TextureGet(texturePack, 0, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 16, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 17, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 18, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 19, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 4)
                    CHECK_InvalidGet(texturePack, 15)
                    CHECK_InvalidGet(texturePack, 20)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 20), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 20), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 20), Time.zero)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key05() {
        if (let Some(game) <- game) {
            // textureIndexes (number) + reverseMapIndex
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)

                    CHECK_TextureGet(texturePack, 0, (8, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 1, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 2, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 3, (0, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 4, (8, 0), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 5, (0, 4), (8, 4), None, None)
                    CHECK_TextureGet(texturePack, 6, (8, 4), (8, 4), None, None)

                    CHECK_InvalidGet(texturePack, 7)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key06() {
        if (let Some(game) <- game) {
            // textureIndexes (number) + multiTexturepack + startIndex
            match (game.resources.getTexturePack("key06")) {
                case Some(texturePack) =>
                    CHECK_MultiTexturePack(texturePack, 17, 1, pal)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 2, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 3, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 4, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_TextureGet(texturePack, 20, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 21, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 22, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 23, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_TextureGet(texturePack, 30, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 31, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 32, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 33, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 5)
                    CHECK_InvalidGet(texturePack, 8)
                    CHECK_InvalidGet(texturePack, 9)
                    CHECK_InvalidGet(texturePack, 13)
                    CHECK_InvalidGet(texturePack, 19)
                    CHECK_InvalidGet(texturePack, 24)
                    CHECK_InvalidGet(texturePack, 29)
                    CHECK_InvalidGet(texturePack, 34)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (1, 50), Time.zero)

                case _ => @Fail("Expected TexturePack: key06")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key07() {
        if (let Some(game) <- game) {
            // textureIndexes (number) + onlyUseIndexed (false) + multiTexturepack + startIndex
            match (game.resources.getTexturePack("key07")) {
                case Some(texturePack) =>
                    CHECK_MultiTexturePack(texturePack, 50, 3, pal)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 4)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_TextureGet(texturePack, 1, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 2, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 3, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 4, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_TextureGet(texturePack, 10, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 11, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 12, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 13, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_TextureGet(texturePack, 14, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 15, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 16, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 17, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_TextureGet(texturePack, 18, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 19, (8, 0), (8, 4), pal, (1, 0))

                    CHECK_TextureGet(texturePack, 20, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 21, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 22, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 23, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_TextureGet(texturePack, 30, (0, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 31, (8, 0), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 32, (0, 4), (8, 4), pal, (1, 0))
                    CHECK_TextureGet(texturePack, 33, (8, 4), (8, 4), pal, (1, 0))

                    CHECK_InvalidGet(texturePack, 5)
                    CHECK_InvalidGet(texturePack, 9)
                    CHECK_InvalidGet(texturePack, 24)
                    CHECK_InvalidGet(texturePack, 29)
                    CHECK_InvalidGet(texturePack, 34)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (10, 11), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.PlayOnce, (12, 13), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.PlayOnce, (14, 15), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.PlayOnce, (16, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (18, 18), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.Looped, (19, 19), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 2, AnimationType.Looped, (20, 20), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 3, AnimationType.Looped, (21, 21), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 1, 1, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 2, 4, AnimationType.Looped, (1, 50), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (1, 50), Time.zero)

                case _ => @Fail("Expected TexturePack: key07")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key08() {
        if (let Some(game) <- game) {
            // utf8Indexes
            match (game.resources.getTexturePack("key08")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 26, 1, None)

                    CHECK_TextureGet(texturePack, UInt32(r'a'), (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'z'), (400, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 64)
                    CHECK_InvalidGet(texturePack, 91)
                    CHECK_InvalidGet(texturePack, 96)
                    CHECK_InvalidGet(texturePack, 123)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (97, 122), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (97, 122), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (97, 122), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (97, 122), Time.zero)

                case _ => @Fail("Expected TexturePack: key08")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key09() {
        if (let Some(game) <- game) {
            // utf8IndexFile
            match (game.resources.getTexturePack("key09")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 26, 1, None)

                    CHECK_TextureGet(texturePack, UInt32(r'A'), (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'Z'), (400, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 64)
                    CHECK_InvalidGet(texturePack, 91)
                    CHECK_InvalidGet(texturePack, 96)
                    CHECK_InvalidGet(texturePack, 123)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (65, 90), Time.zero)

                case _ => @Fail("Expected TexturePack: key09")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key10() {
        if (let Some(game) <- game) {
            // textureIndexRange
            match (game.resources.getTexturePack("key10")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 26, 1, None)

                    CHECK_TextureGet(texturePack, UInt32(r'A'), (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'Z'), (400, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 64)
                    CHECK_InvalidGet(texturePack, 91)
                    CHECK_InvalidGet(texturePack, 96)
                    CHECK_InvalidGet(texturePack, 123)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (65, 90), Time.zero)

                case _ => @Fail("Expected TexturePack: key10")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key11() {
        if (let Some(game) <- game) {
            // inverted textureIndexRange
            match (game.resources.getTexturePack("key11")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 26, 1, None)

                    CHECK_TextureGet(texturePack, UInt32(r'A'), (400, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'Z'), (0, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 64)
                    CHECK_InvalidGet(texturePack, 91)
                    CHECK_InvalidGet(texturePack, 96)
                    CHECK_InvalidGet(texturePack, 123)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (65, 90), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (65, 90), Time.zero)

                case _ => @Fail("Expected TexturePack: key11")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key12() {
        if (let Some(game) <- game) {
            // textureIndexRange + reverseMapIndex
            match (game.resources.getTexturePack("key12")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 26, 1, None)

                    CHECK_TextureGet(texturePack, 0, (160, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, 15, (400, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 16)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 25), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (0, 25), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 25), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 25), Time.zero)

                case _ => @Fail("Expected TexturePack: key12")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key13() {
        if (let Some(game) <- game) {
            // empty range textureIndexRange
            match (game.resources.getTexturePack("key13")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 1, 1, None)

                    CHECK_TextureGet(texturePack, 10, (0, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)
                    CHECK_InvalidGet(texturePack, 11)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 10), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (10, 10), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 10), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (10, 10), Time.zero)

                case _ => @Fail("Expected TexturePack: key13")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key14() {
        if (let Some(game) <- game) {
            // utf8Indexes + textureIndexRange + textureIndexRangeStart
            match (game.resources.getTexturePack("key14")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 52, 1, None)

                    CHECK_TextureGet(texturePack, UInt32(r'A'), (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'Z'), (400, 0), (16, 16), None, None)

                    CHECK_TextureGet(texturePack, UInt32(r'a'), (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'z'), (400, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 64)
                    CHECK_InvalidGet(texturePack, 91)
                    CHECK_InvalidGet(texturePack, 96)
                    CHECK_InvalidGet(texturePack, 123)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (65, 122), Time.zero)

                case _ => @Fail("Expected TexturePack: key14")
            }
        }
    }

    @TestCase
    func test_TexturePackIndexes_key15() {
        if (let Some(game) <- game) {
            // utf8Indexes + inverted textureIndexRange + textureIndexRangeStart
            match (game.resources.getTexturePack("key15")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 52, 1, None)

                    CHECK_TextureGet(texturePack, UInt32(r'A'), (0, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'Z'), (400, 0), (16, 16), None, None)

                    CHECK_TextureGet(texturePack, UInt32(r'a'), (400, 0), (16, 16), None, None)
                    CHECK_TextureGet(texturePack, UInt32(r'z'), (0, 0), (16, 16), None, None)

                    // check get var (test that texturePackIndexWrapper uses correct index mapping)

                    CHECK_TextureGetAll(texturePack, UInt32(r'A'), (0, 0), (16, 16), None, None)
                    CHECK_TextureGetAll(texturePack, UInt32(r'Z'), (400, 0), (16, 16), None, None)

                    CHECK_TextureGetAll(texturePack, UInt32(r'a'), (400, 0), (16, 16), None, None)
                    CHECK_TextureGetAll(texturePack, UInt32(r'z'), (0, 0), (16, 16), None, None)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 64)
                    CHECK_InvalidGet(texturePack, 91)
                    CHECK_InvalidGet(texturePack, 96)
                    CHECK_InvalidGet(texturePack, 123)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 0, 0, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (65, 122), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (65, 122), Time.zero)

                case _ => @Fail("Expected TexturePack: key15")
            }
        }
    }
}
