package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestCircle {
    @TestCase
    func test_constructor() {
        // default
        try (obj = Circle()) {
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.pointCount, 30)
            @Expect(obj.radius, 0.0)
            @Expect(obj.size == Vector2f(0.0, 0.0))
            @Expect(obj.visible, true)
        }

        // radius
        try (obj = Circle(2.0)) {
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.pointCount, 30)
            @Expect(obj.radius, 2.0)
            @Expect(obj.size == Vector2f(4.0, 4.0))
            @Expect(obj.visible, true)
        }

        // radius + pointCount
        try (obj = Circle(2.0, pointCount: 40)) {
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.pointCount, 40)
            @Expect(obj.radius, 2.0)
            @Expect(obj.visible, true)
        }

        // fractional radius
        // radius gets rounded
        try (obj = Circle(1.5)) {
            @Expect(obj.anchor == (Anchor.Top | Anchor.Left))
            @Expect(obj.pointCount, 30)
            @Expect(obj.radius, 2.0)
            @Expect(obj.size == Vector2f(4.0, 4.0))
            @Expect(obj.visible, true)
        }
    }

    @TestCase
    func test_getProperty() {
        try (obj = Circle(2.0)) {
            obj.position = Vector2f(10.0, 20.0)

            // UIObject
            @Expect(obj.getProperty("position").getOrThrow(), VaTuple2i((10, 20)))
            @Expect(obj.getProperty("position.x").getOrThrow(), VaInteger(10))
            @Expect(obj.getProperty("position.y").getOrThrow(), VaInteger(20))
            @Expect(obj.getProperty("size").getOrThrow(), VaTuple2i((4, 4)))
            @Expect(obj.getProperty("size.x").getOrThrow(), VaInteger(4))
            @Expect(obj.getProperty("size.y").getOrThrow(), VaInteger(4))
            @Expect(obj.getProperty("visible").getOrThrow(), VaBoolean(true))

            // circle
            @Expect(obj.getProperty("points").getOrThrow(), VaInteger(30))
            @Expect(obj.getProperty("radius").getOrThrow(), VaInteger(2))

            // invalid
            @Expect(obj.getProperty("invalid").isNone())
        }
    }

    @TestCase
    func test_updateSize() {
        try (game = Game(reset: true), obj = Circle(2.0)) {
            game.resources.addDrawable("obj", obj, manageObjDrawing: true)

            // position
            obj.anchor = Anchor.Right
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(170.0, 80.0))
            @Expect(obj.size == Vector2f(4.0, 4.0))

            // position + size
            game.updateSize(Vector2u(640, 480))
            obj.updateSize(game)

            obj.anchor = Anchor.All
            obj.position = Vector2f(10.0, 20.0)

            game.updateSize(Vector2u(800, 600))
            obj.updateSize(game)

            @Expect(obj.position == Vector2f(10.0, 20.0))
            @Expect(obj.size == Vector2f(4.0, 4.0))
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
