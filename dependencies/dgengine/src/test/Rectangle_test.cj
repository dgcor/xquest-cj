package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

@Test
class TestRectangle {
    @TestCase
    func test_constructor() {
        // default
        try (obj = Rectangle()) {
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.size == Vector2f(0.0, 0.0))
            @Expect(obj.visible, true)
        }

        // size
        try (obj = Rectangle(Vector2f(2.0, 4.0))) {
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.size == Vector2f(2.0, 4.0))
            @Expect(obj.visible, true)
        }
    }

    @TestCase
    func test_getProperty() {
        try (obj = Rectangle(Vector2f(2.0, 4.0))) {
            obj.position = Vector2f(10.0, 20.0)

            // UIObject
            @Expect(obj.getProperty("position").getOrThrow(), VaTuple2i((10, 20)))
            @Expect(obj.getProperty("position.x").getOrThrow(), VaInteger(10))
            @Expect(obj.getProperty("position.y").getOrThrow(), VaInteger(20))
            @Expect(obj.getProperty("size").getOrThrow(), VaTuple2i((2, 4)))
            @Expect(obj.getProperty("size.x").getOrThrow(), VaInteger(2))
            @Expect(obj.getProperty("size.y").getOrThrow(), VaInteger(4))
            @Expect(obj.getProperty("visible").getOrThrow(), VaBoolean(true))

            // invalid
            @Expect(obj.getProperty("invalid").isNone())
        }
    }

    @TestCase
    func test_updateSize() {
        try (game = Game(reset: true), obj = Rectangle(Vector2f(2.0, 4.0))) {
            game.resources.addDrawable("obj", obj, manageObjDrawing: true)

            // position
            obj.anchor = Anchor.Right
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(170.0, 80.0))
            @Expect(obj.size == Vector2f(2.0, 4.0))

            // position + size
            game.updateSize(Vector2u(640, 480))
            obj.updateSize(game)

            obj.anchor = Anchor.All
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(10.0, 20.0))
            @Expect(obj.size == Vector2f(162.0, 124.0))
        }
    }
}
