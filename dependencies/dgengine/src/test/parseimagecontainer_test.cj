package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseImageContainer {
    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)
    }

    @AfterAll
    func cleanup() {
        FileUtils.deinitPhysFS()
    }

    @TestCase
    func test_parseImageContainer() {
        try (game = Game()) {
            parseFile(game, "json/imageContainers.json")

            // invalid id from file
            @Expect(game.resources.getImageContainer("invalid-id").isNone())

            // id from file + 1 frame
            // existing id (doesn't override first resource parsed with the same id)
            match (game.resources.getImageContainer("imageContainer")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 1)
                    @Expect(imageContainer.blendMode, BlendAlpha)
                    @Expect(imageContainer.directions, 1)
                    @Expect(imageContainer.getImageSize(0) == Vector2u(16, 8))
                case _ => @Fail("Expected ImageContainer: imageContainer")
            }

            // id from file + 0 frames
            @Expect(game.resources.getImageContainer("key01").isNone())

            // frame range (horizontal direction) + blendMode
            match (game.resources.getImageContainer("key02")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 4)
                    @Expect(imageContainer.blendMode, BlendAdd)
                    @Expect(imageContainer.directions, 1)
                    match (imageContainer.get(0, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAdd)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
                        case _ => @Fail("Expected Image: key02 -> 0")
                    }
                    match (imageContainer.get(1, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAdd)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key02 -> 1")
                    }
                    match (imageContainer.get(2, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAdd)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.BLUE)
                        case _ => @Fail("Expected Image: key02 -> 2")
                    }
                    match (imageContainer.get(3, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAdd)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.WHITE)
                        case _ => @Fail("Expected Image: key02 -> 3")
                    }
                case _ => @Fail("Expected ImageContainer: key02")
            }

            // frame range + vertical direction + 4 directions
            match (game.resources.getImageContainer("key03")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 4)
                    @Expect(imageContainer.blendMode, BlendAlpha)
                    @Expect(imageContainer.directions, 4)
                    match (imageContainer.get(0, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAlpha)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
                        case _ => @Fail("Expected Image: key03 -> 0")
                    }
                    match (imageContainer.get(1, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAlpha)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.BLUE)
                        case _ => @Fail("Expected Image: key03 -> 1")
                    }
                    match (imageContainer.get(2, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAlpha)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key03 -> 2")
                    }
                    match (imageContainer.get(3, None)) {
                        case Some((img, imgInfo)) =>
                            @Expect(imgInfo.blendMode, BlendAlpha)
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.WHITE)
                        case _ => @Fail("Expected Image: key03 -> 3")
                    }
                case _ => @Fail("Expected ImageContainer: key03")
            }

            // frame range + VERTICAL direction + odd directions
            match (game.resources.getImageContainer("key04")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 4)
                    @Expect(imageContainer.directions, 3)
                    match (imageContainer.get(1, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key04 -> 1")
                    }
                case _ => @Fail("Expected ImageContainer: key04")
            }

            // frame range + directions > frames
            match (game.resources.getImageContainer("key05")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 4)
                    @Expect(imageContainer.directions, 8)
                    match (imageContainer.get(1, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key05 -> 1")
                    }
                case _ => @Fail("Expected ImageContainer: key05")
            }

            // frame range + 2 directions
            match (game.resources.getImageContainer("key06")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 4)
                    @Expect(imageContainer.directions, 2)
                    match (imageContainer.get(1, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key06 -> 1")
                    }
                case _ => @Fail("Expected ImageContainer: key06")
            }

            // odd frame range + horizontal direction
            match (game.resources.getImageContainer("key07")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 8)
                    @Expect(imageContainer.directions, 1)
                    match (imageContainer.get(0, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
                        case _ => @Fail("Expected Image: key07 -> 0")
                    }
                    match (imageContainer.get(1, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
                        case _ => @Fail("Expected Image: key07 -> 1")
                    }
                    match (imageContainer.get(2, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key07 -> 2")
                    }
                    match (imageContainer.get(3, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key07 -> 3")
                    }
                    match (imageContainer.get(4, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.BLUE)
                        case _ => @Fail("Expected Image: key07 -> 4")
                    }
                    match (imageContainer.get(5, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.BLUE)
                        case _ => @Fail("Expected Image: key07 -> 5")
                    }
                    match (imageContainer.get(6, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.WHITE)
                        case _ => @Fail("Expected Image: key07 -> 6")
                    }
                    match (imageContainer.get(7, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(4, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.WHITE)
                        case _ => @Fail("Expected Image: key07 -> 7")
                    }
                case _ => @Fail("Expected ImageContainer: key07")
            }

            // odd frame range + vertical direction
            match (game.resources.getImageContainer("key08")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 8)
                    @Expect(imageContainer.directions, 1)
                    match (imageContainer.get(0, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
                        case _ => @Fail("Expected Image: key08 -> 0")
                    }
                    match (imageContainer.get(1, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
                        case _ => @Fail("Expected Image: key08 -> 1")
                    }
                    match (imageContainer.get(2, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.BLUE)
                        case _ => @Fail("Expected Image: key08 -> 2")
                    }
                    match (imageContainer.get(3, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.BLUE)
                        case _ => @Fail("Expected Image: key08 -> 3")
                    }
                    match (imageContainer.get(4, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key08 -> 4")
                    }
                    match (imageContainer.get(5, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key08 -> 5")
                    }
                    match (imageContainer.get(6, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.WHITE)
                        case _ => @Fail("Expected Image: key08 -> 6")
                    }
                    match (imageContainer.get(7, None)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 2))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.WHITE)
                        case _ => @Fail("Expected Image: key08 -> 7")
                    }
                case _ => @Fail("Expected ImageContainer: key08")
            }

            // invalid frame range (non integer split)
            @Expect(game.resources.getImageContainer("key09").isNone())

            // frame range + vertical direction + palette image
            let pal = game.resources.getPalette("pal").getOrThrow()
            match (game.resources.getImageContainer("key10")) {
                case Some(imageContainer) =>
                    @Expect(imageContainer.size, 4)
                    match (imageContainer.get(0, pal.palette)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
                        case _ => @Fail("Expected Image: key10 -> 0")
                    }
                    match (imageContainer.get(1, pal.palette)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.BLUE)
                        case _ => @Fail("Expected Image: key10 -> 1")
                    }
                    match (imageContainer.get(2, pal.palette)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.GREEN)
                        case _ => @Fail("Expected Image: key10 -> 2")
                    }
                    match (imageContainer.get(3, pal.palette)) {
                        case Some((img, __)) =>
                            @Expect(img.size == Vector2u(8, 4))
                            @Expect(img.getPixel(Vector2u(0, 0)) == Color.WHITE)
                        case _ => @Fail("Expected Image: key10 -> 3")
                    }
                case _ => @Fail("Expected ImageContainer: key10")
            }

            // fromId
            match ((game.resources.getImageContainer("imageContainer"), game.resources.getImageContainer("key11"))) {
                case (Some(imgContainer), Some(imgContainer2)) => @Expect(isObjEq(imgContainer, imgContainer2))
                case _ => @Fail("Expected Palettes: imageContainer, key11")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
