package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

@Test
class TestParseCompositeTexturePack {
    var game: ?Game = None
    var pal: ?Palette = None

    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)

        let game = Game()
        this.game = game
        parseFile(game, "json/texturePacks/compositeTexturePacks.json")

        pal = game.resources.getPalette("pal")
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
    }

    static func CHECK_InvalidGet(texturePack: TexturePack, index: UInt32): Unit {
        CHECK_InvalidGet(texturePack, index, 0)
    }

    static func CHECK_InvalidGet(texturePack: TexturePack, index: UInt32, direction: UInt32): Unit {
        @Expect(texturePack.get(index).isNone())
        @Expect(texturePack.getDirection(index), direction)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, tiIndex: Int64, index: UInt32, position: (Int32, Int32),
        size: (Int32, Int32), palette: ?Palette, offset: ?(Int64, Int64)): Unit {
        CHECK_TextureGet(texturePack, tiIndex, index, position, size, palette, offset, -1)
    }

    static func CHECK_TextureGet(texturePack: TexturePack, tiIndex: Int64, index: UInt32, position: (Int32, Int32),
        size: (Int32, Int32), palette: ?Palette, offset: ?(Int64, Int64), tiVecSize: Int32): Unit {
        match (texturePack.getAll(index)) {
            case Some(tiVar) =>
                if (tiIndex == 0) {
                    @Expect(texturePack.getTextureSize(index) == Vector2i(size))
                }
                if (let TextureInfoMulti(tiVec) <- tiVar) {
                    @Expect(tiIndex < tiVec.size)
                    if (tiVecSize >= 0) {
                        @Expect(tiVec.size == Int64(tiVecSize))
                    }
                    if (tiIndex < tiVec.size) {
                        let ti = tiVec[tiIndex]
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
                    }
                } else {
                    @Fail("CHECK_TextureGet: Expected TextureInfoMulti")
                }
            case _ => @Fail("CHECK_TextureGet: Expected TextureInfoVar")
        }
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
    func test_CompositeTexturePack_key01() {
        if (let Some(game) <- game) {
            // invalid rects
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 4, 1, None)

                    CHECK_TextureGet(texturePack, 0, 0, (0, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 1, (0, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 2, (0, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 3, (0, 0), (8, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 0, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 1, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 2, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 3, (0, 0), (4, 4), None, None, 2)

                    CHECK_InvalidGet(texturePack, 4)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 3), Time.zero)

                case _ => @Fail("Expected TexturePack: key01")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key02() {
        if (let Some(game) <- game) {
            // 2 texturePacks + multiple directions + overrides
            match (game.resources.getTexturePack("key02")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 0, 10, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 11, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 12, (8, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 13, (8, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 14, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 15, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 16, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 17, (4, 4), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 10, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 11, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 12, (0, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 1, 15, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 16, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 17, (8, 4), (8, 4), pal, None, 2)

                    CHECK_InvalidGet(texturePack, 18)
                    CHECK_InvalidGet(texturePack, 19)
                    CHECK_InvalidGet(texturePack, 20, 1)
                    CHECK_InvalidGet(texturePack, 21)
                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (10, 17), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 17), Time.zero)

                case _ => @Fail("Expected TexturePack: key02")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key03() {
        if (let Some(game) <- game) {
            @Expect(pal.isSome())

            // 2 texturePacks (reverse order) + multiple directions + overrides
            match (game.resources.getTexturePack("key03")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 12, 3, pal)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 4)
                    @Expect(texturePack.getDirectionCount(2), 4)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 0, 10, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 11, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 12, (0, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 0, 13, (8, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 14, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 15, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 16, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 17, (8, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 0, 18, (0, 0), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 19, (8, 0), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 20, (0, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 21, (8, 4), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 1, 10, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 11, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 12, (8, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 15, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 16, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 17, (4, 4), (4, 4), None, None, 2)

                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (10, 11), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.PlayOnce, (12, 13), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.PlayOnce, (14, 15), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.PlayOnce, (16, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (19, 19), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.Looped, (20, 20), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 21), Time.zero)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.PlayOnce, (10, 13), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.zero)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.Looped, (18, 21), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 21), Time.zero)

                case _ => @Fail("Expected TexturePack: key03")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key04() {
        if (let Some(game) <- game) {
            // 2 texturePacks + directionLayerOrders (same order)
            match (game.resources.getTexturePack("key04")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 0, 10, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 11, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 12, (8, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 13, (8, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 14, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 15, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 16, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 17, (4, 4), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 10, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 11, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 12, (0, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 1, 15, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 16, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 17, (8, 4), (8, 4), pal, None, 2)

                    CHECK_InvalidGet(texturePack, 18)
                    CHECK_InvalidGet(texturePack, 19)
                    CHECK_InvalidGet(texturePack, 20, 1)
                    CHECK_InvalidGet(texturePack, 21)
                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (10, 17), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 17), Time.zero)

                case _ => @Fail("Expected TexturePack: key04")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key05() {
        if (let Some(game) <- game) {

            // 2 texturePacks + directionLayerOrders (different order)
            match (game.resources.getTexturePack("key05")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 0, 10, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 11, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 12, (0, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 0, 13, (8, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 14, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 15, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 16, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 17, (8, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 1, 10, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 11, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 12, (8, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 15, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 16, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 17, (4, 4), (4, 4), None, None, 2)

                    CHECK_InvalidGet(texturePack, 18)
                    CHECK_InvalidGet(texturePack, 19)
                    CHECK_InvalidGet(texturePack, 20, 1)
                    CHECK_InvalidGet(texturePack, 21)
                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (10, 17), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 17), Time.zero)

                case _ => @Fail("Expected TexturePack: key05")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key06() {
        if (let Some(game) <- game) {
            // 2 texturePacks + directionLayerOrders (invalid + overflow orders)
            match (game.resources.getTexturePack("key06")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 0, 10, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 11, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 12, (0, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 0, 13, (8, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 14, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 15, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 16, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 17, (8, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 1, 10, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 11, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 12, (8, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 15, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 16, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 17, (4, 4), (4, 4), None, None, 2)

                    CHECK_InvalidGet(texturePack, 18)
                    CHECK_InvalidGet(texturePack, 19)
                    CHECK_InvalidGet(texturePack, 20, 1)
                    CHECK_InvalidGet(texturePack, 21)
                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (10, 17), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 2, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 0, 3, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (10, 17), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 17), Time.zero)

                case _ => @Fail("Expected TexturePack: key06")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key07() {
        if (let Some(game) <- game) {

            // 2 texturePacks (reverse order) + directionLayerOrders (invalid + missing layer orders)
            match (game.resources.getTexturePack("key07")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 12, 3, pal)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 4)
                    @Expect(texturePack.getDirectionCount(2), 4)
                    @Expect(texturePack.getDirectionCount(3), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 0, 10, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 11, (4, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 12, (8, 0), (4, 4), None, None, 1)
                    CHECK_InvalidGet(texturePack, 13, 1)

                    CHECK_TextureGet(texturePack, 0, 14, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 15, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 16, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 17, (8, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 0, 18, (0, 0), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 19, (8, 0), (8, 4), pal, None, 1)

                    CHECK_InvalidGet(texturePack, 20, 1)

                    CHECK_TextureGet(texturePack, 0, 21, (8, 4), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 1, 10, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 11, (8, 0), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 1, 15, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 16, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 17, (4, 4), (4, 4), None, None, 2)

                    CHECK_InvalidGet(texturePack, 22)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (10, 11), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.PlayOnce, (12, 13), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.PlayOnce, (14, 15), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.PlayOnce, (16, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (19, 19), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.Looped, (20, 20), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 21), Time.zero)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.PlayOnce, (10, 13), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.zero)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.Looped, (18, 21), Time.zero)
                    CHECK_Animation(texturePack, 3, 0, AnimationType.Looped, (10, 21), Time.zero)

                case _ => @Fail("Expected TexturePack: key07")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key08() {
        if (let Some(game) <- game) {
            // 2 texturePacks + directionLayerOrders (for all directions)
            match (game.resources.getTexturePack("key08")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 8, 1, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)

                    CHECK_TextureGet(texturePack, 0, 0, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 1, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 2, (8, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 3, (12, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 4, (0, 4), (4, 4), None, None, 1)
                    CHECK_TextureGet(texturePack, 0, 5, (4, 4), (4, 4), None, None, 1)
                    CHECK_TextureGet(texturePack, 0, 6, (8, 4), (4, 4), None, None, 1)
                    CHECK_TextureGet(texturePack, 0, 7, (12, 4), (4, 4), None, None, 1)

                    CHECK_TextureGet(texturePack, 1, 0, (0, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 1, (8, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 2, (0, 4), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 3, (8, 4), (8, 4), None, None, 2)

                    CHECK_InvalidGet(texturePack, 8)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 7), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 7), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.Looped, (0, 7), Time.zero)

                case _ => @Fail("Expected TexturePack: key08")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key09() {
        if (let Some(game) <- game) {
            // 2 groups
            match (game.resources.getTexturePack("key09")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 20, 4, pal)
                    @Expect(texturePack.getDirectionCount(0), 4)
                    @Expect(texturePack.getDirectionCount(1), 4)
                    @Expect(texturePack.getDirectionCount(2), 4)
                    @Expect(texturePack.getDirectionCount(3), 4)
                    @Expect(texturePack.getDirectionCount(4), 1)

                    CHECK_InvalidGet(texturePack, 0)
                    CHECK_InvalidGet(texturePack, 9)

                    CHECK_TextureGet(texturePack, 0, 10, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 11, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 12, (8, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 13, (8, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 14, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 15, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 16, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 17, (4, 4), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 18, (0, 0), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 19, (8, 0), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 20, (0, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 21, (8, 4), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 1, 10, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 11, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 12, (0, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 1, 15, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 16, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 1, 17, (8, 4), (8, 4), pal, None, 2)

                    CHECK_InvalidGet(texturePack, 22)
                    CHECK_InvalidGet(texturePack, 23)
                    CHECK_InvalidGet(texturePack, 24)
                    CHECK_InvalidGet(texturePack, 25)
                    CHECK_InvalidGet(texturePack, 26)
                    CHECK_InvalidGet(texturePack, 27)
                    CHECK_InvalidGet(texturePack, 28)
                    CHECK_InvalidGet(texturePack, 29)
                    CHECK_InvalidGet(texturePack, 30)
                    CHECK_InvalidGet(texturePack, 31)

                    CHECK_TextureGet(texturePack, 0, 32, (0, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 33, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 34, (0, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 0, 35, (8, 4), (8, 4), pal, None, 1)
                    CHECK_TextureGet(texturePack, 0, 36, (0, 0), (8, 4), pal, None, 1)

                    CHECK_TextureGet(texturePack, 0, 37, (8, 0), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 38, (0, 4), (8, 4), pal, None, 2)
                    CHECK_TextureGet(texturePack, 0, 39, (8, 4), (8, 4), pal, None, 2)

                    CHECK_TextureGet(texturePack, 1, 32, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 33, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 34, (8, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 37, (12, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 38, (0, 4), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 39, (4, 4), (4, 4), None, None, 2)

                    CHECK_InvalidGet(texturePack, 40)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.PlayOnce, (10, 11), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 1, AnimationType.PlayOnce, (12, 13), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 2, AnimationType.PlayOnce, (14, 15), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 0, 3, AnimationType.PlayOnce, (16, 17), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 0, AnimationType.Looped, (19, 19), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 2, 1, AnimationType.Looped, (20, 20), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 3, 0, AnimationType.Looped, (32, 39), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (10, 39), Time.zero)
                    CHECK_Animation(texturePack, 0, 4, AnimationType.PlayOnce, (10, 13), Time.zero)
                    CHECK_Animation(texturePack, 1, 0, AnimationType.BackAndForth, (14, 17), Time.zero)
                    CHECK_Animation(texturePack, 2, 2, AnimationType.Looped, (18, 21), Time.zero)
                    CHECK_Animation(texturePack, 3, 1, AnimationType.Looped, (32, 39), Time.zero)
                    CHECK_Animation(texturePack, 4, 0, AnimationType.Looped, (10, 39), Time.zero)

                case _ => @Fail("Expected TexturePack: key09")
            }
        }
    }

    @TestCase
    func test_CompositeTexturePack_key10() {
        if (let Some(game) <- game) {

            // 2 groups + directionLayerOrders (for all directions)
            match (game.resources.getTexturePack("key10")) {
                case Some(texturePack) =>
                    CHECK_TexturePack(texturePack, 12, 2, None)
                    @Expect(texturePack.getDirectionCount(0), 1)
                    @Expect(texturePack.getDirectionCount(1), 1)
                    @Expect(texturePack.getDirectionCount(2), 1)

                    CHECK_TextureGet(texturePack, 0, 0, (0, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 1, (8, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 2, (8, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 3, (12, 0), (4, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 1, 0, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 1, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 2, (0, 4), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 3, (8, 4), (8, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 4, (0, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 5, (8, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 6, (8, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 0, 7, (8, 4), (8, 4), None, None, 2)

                    CHECK_TextureGet(texturePack, 0, 8, (0, 4), (4, 4), None, None, 1)
                    CHECK_TextureGet(texturePack, 0, 9, (4, 4), (4, 4), None, None, 1)
                    CHECK_TextureGet(texturePack, 0, 10, (8, 4), (4, 4), None, None, 1)
                    CHECK_TextureGet(texturePack, 0, 11, (12, 4), (4, 4), None, None, 1)

                    CHECK_TextureGet(texturePack, 1, 4, (0, 0), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 5, (4, 0), (4, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 6, (0, 4), (8, 4), None, None, 2)
                    CHECK_TextureGet(texturePack, 1, 7, (12, 0), (4, 4), None, None, 2)

                    CHECK_AnimationAndDirection(texturePack, 0, 0, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_AnimationAndDirection(texturePack, 1, 0, AnimationType.Looped, (4, 11), Time.zero)

                    CHECK_Animation(texturePack, -1, -1, AnimationType.Looped, (0, 11), Time.zero)
                    CHECK_Animation(texturePack, 0, -1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 0, 1, AnimationType.Looped, (0, 3), Time.zero)
                    CHECK_Animation(texturePack, 1, -1, AnimationType.Looped, (4, 11), Time.zero)
                    CHECK_Animation(texturePack, 1, 1, AnimationType.Looped, (4, 11), Time.zero)
                    CHECK_Animation(texturePack, 2, -1, AnimationType.Looped, (0, 11), Time.zero)
                    CHECK_Animation(texturePack, 2, 0, AnimationType.Looped, (0, 11), Time.zero)

                case _ => @Fail("Expected TexturePack: key10")
            }
        }
    }
}
