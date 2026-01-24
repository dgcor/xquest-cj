package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestTextButton {
    @TestCase
    func test_constructor() {
        // BitmapFont
        try (game = Game(reset: true)) {
            let obj = makeTextButton(game, "obj", makeBitmapFont(game, "font", "font"))
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.visible, true)
        }
    }

    @TestCase
    func test_getProperty() {
        try (game = Game(reset: true)) {
            let obj = makeTextButton(game, "obj", makeBitmapFont(game, "font", "font"))
            obj.position = Vector2f(10.0, 20.0)

            // UIObject
            @Expect(obj.getProperty("position").getOrThrow(), VaTuple2i((10, 20)))
            @Expect(obj.getProperty("position.x").getOrThrow(), VaInteger(10))
            @Expect(obj.getProperty("position.y").getOrThrow(), VaInteger(20))
            @Expect(obj.getProperty("size").getOrThrow(), VaTuple2i((0, 4)))
            @Expect(obj.getProperty("size.x").getOrThrow(), VaInteger(0))
            @Expect(obj.getProperty("size.y").getOrThrow(), VaInteger(4))
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
            let obj = makeTextButton(game, "obj", makeBitmapFont(game, "font", "font"))

            // position
            obj.anchor = Anchor.Right
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(170.0, 80.0))
            @Expect(obj.size == Vector2f(0.0, 4.0))

            // position + size
            game.updateSize(Vector2u(640, 480))
            obj.updateSize(game)

            obj.anchor = Anchor.All
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(10.0, 20.0))
            @Expect(obj.size == Vector2f(160.0, 124.0))
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
