package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.unittest.*

@Test
class TestParseTexture {
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
    func test_parseTexture() {
        try (game = Game(reset: true)) {
            parseFile(game, "json/textures.json")

            // invalid id from file
            @Expect(game.resources.getTexture("invalid-id").isNone())

            // id from file + split into 1 piece (no split)
            // existing id (doesn't override first resource parsed with the same id)
            match (game.resources.getTexture("texture")) {
                case Some(texture) =>
                    @Expect(texture.size == Vector2u(16, 8))
                    try (img = texture.copyToImage()) {
                        @Expect(img.getPixel(0, 0) == Color.red)
                        @Expect(img.getPixel(1, 0) == Color.red)
                        @Expect(img.getPixel(0, 1) == Color.red)
                        @Expect(img.getPixel(1, 1) == Color.red)
                    }
                case _ => @Fail("Expected Texture: texture")
            }

            // file + horizontal split into 2 pieces
            match (game.resources.getTexture("key01")) {
                case Some(texture) => @Expect(texture.size == Vector2u(8, 16))
                case _ => @Fail("Expected Texture: key01")
            }

            // file + vertical split into 2 pieces
            match (game.resources.getTexture("key02")) {
                case Some(texture) => @Expect(texture.size == Vector2u(32, 4))
                case _ => @Fail("Expected Texture: key02")
            }

            // file + VERTICAL split into 2 pieces
            match (game.resources.getTexture("key03")) {
                case Some(texture) => @Expect(texture.size == Vector2u(16, 8))
                case _ => @Fail("Expected Texture: key03")
            }

            // file + invalid split into 2 pieces
            match (game.resources.getTexture("key04")) {
                case Some(texture) => @Expect(texture.size == Vector2u(16, 8))
                case _ => @Fail("Expected Texture: key04")
            }

            // file + trim + mask
            match (game.resources.getTexture("key05")) {
                case Some(texture) =>
                    @Expect(texture.size == Vector2u(2, 2))
                    try (img = texture.copyToImage()) {
                        @Expect(img.getPixel(0, 0) == Color.transparent)
                        @Expect(img.getPixel(1, 0) == Color.transparent)
                        @Expect(img.getPixel(0, 1) == Color.transparent)
                        @Expect(img.getPixel(1, 1) == Color.transparent)
                    }
                case _ => @Fail("Expected Texture: key05")
            }

            // single color
            match (game.resources.getTexture("key06")) {
                case Some(texture) => @Expect(texture.size == Vector2u(2, 2))
                case _ => @Fail("Expected Texture: key06")
            }

            // color array
            match (game.resources.getTexture("key07")) {
                case Some(texture) =>
                    @Expect(texture.size == Vector2u(2, 2))
                    try (img = texture.copyToImage()) {
                        @Expect(img.getPixel(0, 0) == Color.red)
                        @Expect(img.getPixel(1, 0) == Color.green)
                        @Expect(img.getPixel(0, 1) == Color.blue)
                        @Expect(img.getPixel(1, 1) == Color.white)
                    }
                case _ => @Fail("Expected Texture: key07")
            }

            // single color + no size
            match (game.resources.getTexture("key08")) {
                case Some(texture) => @Expect(texture.size == Vector2u(640, 480))
                case _ => @Fail("Expected Texture: key08")
            }

            // color array + wrong size
            match (game.resources.getTexture("key09")) {
                case Some(texture) =>
                    @Expect(texture.size == Vector2u(1, 1))
                    try (img = texture.copyToImage()) {
                        @Expect(img.getPixel(0, 0) == Color.transparent)
                    }
                case _ => @Fail("Expected Texture: key09")
            }

            // color array + trim
            match (game.resources.getTexture("key10")) {
                case Some(texture) =>
                    @Expect(texture.size == Vector2u(2, 2))
                    try (img = texture.copyToImage()) {
                        @Expect(img.getPixel(0, 0) == Color.blue)
                        @Expect(img.getPixel(1, 0) == Color.blue)
                        @Expect(img.getPixel(0, 1) == Color.blue)
                        @Expect(img.getPixel(1, 1) == Color.blue)
                    }
                case _ => @Fail("Expected Texture: key10")
            }

            // color array (array colors)
            match (game.resources.getTexture("key11")) {
                case Some(texture) =>
                    @Expect(texture.size == Vector2u(2, 2))
                    try (img = texture.copyToImage()) {
                        @Expect(img.getPixel(0, 0) == Color.red)
                        @Expect(img.getPixel(1, 0) == Color.green)
                        @Expect(img.getPixel(0, 1) == Color.blue)
                        @Expect(img.getPixel(1, 1) == Color.black)
                    }
                case _ => @Fail("Expected Texture: key11")
            }

            // fromId
            match ((game.resources.getTexture("texture"), game.resources.getTexture("key12"))) {
                case (Some(texture), Some(texture2)) => @Expect(isObjEq(texture, texture2))
                case _ => @Fail("Expected Textures: texture, key12")
            }
        }
    }
}
