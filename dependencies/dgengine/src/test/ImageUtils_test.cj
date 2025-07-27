package dgengine.test

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import dgengine.*
import std.unittest.*

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
        try (img = SFMLImage(2, 2, Color.red)) {
            // no update
            ImageUtils.applyMask(img)

            @Expect(img.getPixel(0, 0) == Color.red)
            @Expect(img.getPixel(1, 0) == Color.red)
            @Expect(img.getPixel(0, 1) == Color.red)
            @Expect(img.getPixel(1, 1) == Color.red)

            // update
            img.setPixel(0, 0, Color.green)
            img.setPixel(1, 1, Color.green)

            ImageUtils.applyMask(img, mask: Color.green)

            @Expect(img.getPixel(0, 0) == Color.transparent)
            @Expect(img.getPixel(1, 0) == Color.red)
            @Expect(img.getPixel(0, 1) == Color.red)
            @Expect(img.getPixel(1, 1) == Color.transparent)
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
        try (img = SFMLImage(2, 2, Color.red)) {
            img.setPixel(0, 0, Color.green)
            img.setPixel(1, 1, Color.green)

            // no update
            @Expect(ImageUtils.splitImageHorizontal(img, pieces: 1).isNone())

            // uneven split
            try (img2 = SFMLImage(3, 3, Color.red)) {
                @Expect(ImageUtils.splitImageHorizontal(img2, pieces: 2).isNone())
            }

            // update
            match (ImageUtils.splitImageHorizontal(img, pieces: 2)) {
                case Some(image) => try (image = image) {
                    @Expect(image.size == Vector2u(1, 4))
                    @Expect(image.getPixel(0, 0) == Color.green)
                    @Expect(image.getPixel(0, 1) == Color.red)
                    @Expect(image.getPixel(0, 2) == Color.red)
                    @Expect(image.getPixel(0, 3) == Color.green)
                }
                case None => @Fail("splitImageHorizontal: Expected successful split")
            }
        }
    }

    @TestCase
    func splitImageVertical() {
        try (img = SFMLImage(2, 2, Color.red)) {
            img.setPixel(0, 0, Color.green)
            img.setPixel(1, 1, Color.green)

            // no update
            @Expect(ImageUtils.splitImageVertical(img, pieces: 1).isNone())

            // uneven split
            try (img2 = SFMLImage(3, 3, Color.red)) {
                @Expect(ImageUtils.splitImageVertical(img2, pieces: 2).isNone())
            }

            // update
            match (ImageUtils.splitImageVertical(img, pieces: 2)) {
                case Some(image) => try (image = image) {
                    @Expect(image.size == Vector2u(4, 1))
                    @Expect(image.getPixel(0, 0) == Color.green)
                    @Expect(image.getPixel(1, 0) == Color.red)
                    @Expect(image.getPixel(2, 0) == Color.red)
                    @Expect(image.getPixel(3, 0) == Color.green)
                }
                case None => @Fail("splitImageVertical: Expected successful split")
            }
        }
    }
}
