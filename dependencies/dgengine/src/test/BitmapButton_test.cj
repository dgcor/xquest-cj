package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.unittest.*

@Test
class TestBitmapButton {
    @TestCase
    func test_constructor() {
        // default
        try (obj = BitmapButton()) {
            @Expect(obj.background, false)
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.color == Color.white)
            @ExpectThrows[SFMLNullHandleException](obj.texture)
            @Expect(obj.palette.isNone())
            @Expect(obj.outlineEnabled, true)
            @Expect(obj.resizable, false)
            @Expect(obj.size == Vector2f(0.0, 0.0))
            @Expect(obj.stretch, false)
            @Expect(obj.visible, true)
        }

        // texture
        try (tex = makeTexture(), obj = BitmapButton(tex)) {
            @Expect(obj.background, false)
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.color == Color.white)
            @Expect(obj.texture.size == Vector2u(16, 8))
            @Expect(obj.palette.isNone())
            @Expect(obj.outlineEnabled, true)
            @Expect(obj.resizable, false)
            @Expect(obj.size == Vector2f(16.0, 8.0))
            @Expect(obj.stretch, false)
            @Expect(obj.visible, true)
        }
    }

    @TestCase
    func test_getProperty() {
        try (game = Game(reset: true)) {
            let obj = makeBitmapButton(game, "obj", makeTexture(game, "tex"))
            obj.position = Vector2f(10.0, 20.0)

            // UIObject
            @Expect(obj.getProperty("position").getOrThrow(), VaTuple2i((10, 20)))
            @Expect(obj.getProperty("position.x").getOrThrow(), VaInteger(10))
            @Expect(obj.getProperty("position.y").getOrThrow(), VaInteger(20))
            @Expect(obj.getProperty("size").getOrThrow(), VaTuple2i((16, 8)))
            @Expect(obj.getProperty("size.x").getOrThrow(), VaInteger(16))
            @Expect(obj.getProperty("size.y").getOrThrow(), VaInteger(8))
            @Expect(obj.getProperty("visible").getOrThrow(), VaBoolean(true))

            // button
            @Expect(obj.getProperty("clickUp").getOrThrow(), VaBoolean(false))
            @Expect(obj.getProperty("enabled").getOrThrow(), VaBoolean(true))

            // invalid
            @Expect(obj.getProperty("invalid").isNone())
        }
    }

    @TestCase
    func test_updateSize() {
        try (game = Game(reset: true)) {
            let obj = makeBitmapButton(game, "obj", makeTexture(game, "tex"))

            // position
            obj.anchor = Anchor.Right
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(170.0, 80.0))
            @Expect(obj.size == Vector2f(16.0, 8.0))

            // position + size
            game.updateSize(Vector2u(640, 480))
            obj.updateSize(game)

            obj.anchor = Anchor.All
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(10.0, 20.0))
            @Expect(obj.size == Vector2f(16.0, 8.0))

            // position + size + resizable
            game.updateSize(Vector2u(640, 480))
            obj.updateSize(game)

            obj.anchor = Anchor.All
            obj.resizable = true
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(10.0, 20.0))
            @Expect(obj.size == Vector2f(176.0, 128.0))
        }
    }
}
