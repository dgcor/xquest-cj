package dgengine.test

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestImageUtils {
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
    func applyMask() {
        try (img = SFMLImage(Vector2u(2, 2), Color.RED)) {
            // no update
            ImageUtils.applyMask(img)

            @Expect(img.getPixel(Vector2u(0, 0)) == Color.RED)
            @Expect(img.getPixel(Vector2u(1, 0)) == Color.RED)
            @Expect(img.getPixel(Vector2u(0, 1)) == Color.RED)
            @Expect(img.getPixel(Vector2u(1, 1)) == Color.RED)

            // update
            img.setPixel(Vector2u(0, 0), Color.GREEN)
            img.setPixel(Vector2u(1, 1), Color.GREEN)

            ImageUtils.applyMask(img, mask: Color.GREEN)

            @Expect(img.getPixel(Vector2u(0, 0)) == Color.TRANSPARENT)
            @Expect(img.getPixel(Vector2u(1, 0)) == Color.RED)
            @Expect(img.getPixel(Vector2u(0, 1)) == Color.RED)
            @Expect(img.getPixel(Vector2u(1, 1)) == Color.TRANSPARENT)
        }
    }

    @TestCase
    func packImages() {
        let json = ##"
        {
          "imageContainer": [
            {
              "id": "key01",
              "file": "res/texture/imageContainer.png",
              "frames": [2, 2],
              "blendMode": "add"
            }
          ]
        }"##

        try (game = Game()) {
            parseJson(game, json)

            if (let Some(imgContainer) <- game.resources.getImageContainer("key01")) {
                let (img, rects) = ImageUtils.packImages(imgContainer, None)
                match (img) {
                    case Some(image) => try (image = image) {
                        @Expect(image.size == Vector2u(32, 4))
                        @Expect(rects.size == 4)
                        @Expect(rects[0] == IntRect(0, 0, 8, 4))
                        @Expect(rects[1] == IntRect(8, 0, 8, 4))
                        @Expect(rects[2] == IntRect(16, 0, 8, 4))
                        @Expect(rects[3] == IntRect(24, 0, 8, 4))
                    }
                    case None => @Fail("packImages: Expected successful pack")
                }
            }
        }
    }

    @TestCase
    func splitImageHorizontal() {
        try (img = SFMLImage(Vector2u(2, 2), Color.RED)) {
            img.setPixel(Vector2u(0, 0), Color.GREEN)
            img.setPixel(Vector2u(1, 1), Color.GREEN)

            // no update
            @Expect(ImageUtils.splitImageHorizontal(img, pieces: 1).isNone())

            // uneven split
            try (img2 = SFMLImage(Vector2u(3, 3), Color.RED)) {
                @Expect(ImageUtils.splitImageHorizontal(img2, pieces: 2).isNone())
            }

            // update
            match (ImageUtils.splitImageHorizontal(img, pieces: 2)) {
                case Some(image) => try (image = image) {
                    @Expect(image.size == Vector2u(1, 4))
                    @Expect(image.getPixel(Vector2u(0, 0)) == Color.GREEN)
                    @Expect(image.getPixel(Vector2u(0, 1)) == Color.RED)
                    @Expect(image.getPixel(Vector2u(0, 2)) == Color.RED)
                    @Expect(image.getPixel(Vector2u(0, 3)) == Color.GREEN)
                }
                case None => @Fail("splitImageHorizontal: Expected successful split")
            }
        }
    }

    @TestCase
    func splitImageVertical() {
        try (img = SFMLImage(Vector2u(2, 2), Color.RED)) {
            img.setPixel(Vector2u(0, 0), Color.GREEN)
            img.setPixel(Vector2u(1, 1), Color.GREEN)

            // no update
            @Expect(ImageUtils.splitImageVertical(img, pieces: 1).isNone())

            // uneven split
            try (img2 = SFMLImage(Vector2u(3, 3), Color.RED)) {
                @Expect(ImageUtils.splitImageVertical(img2, pieces: 2).isNone())
            }

            // update
            match (ImageUtils.splitImageVertical(img, pieces: 2)) {
                case Some(image) => try (image = image) {
                    @Expect(image.size == Vector2u(4, 1))
                    @Expect(image.getPixel(Vector2u(0, 0)) == Color.GREEN)
                    @Expect(image.getPixel(Vector2u(1, 0)) == Color.RED)
                    @Expect(image.getPixel(Vector2u(2, 0)) == Color.RED)
                    @Expect(image.getPixel(Vector2u(3, 0)) == Color.GREEN)
                }
                case None => @Fail("splitImageVertical: Expected successful split")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
