package cjsfml.graphics

import cjsfml.system.{Vector2f, Vector2i}

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestIntRect {
    @TestCase
    func init_default() {
        let rectangle = IntRect()
        @Expect(rectangle.position == Vector2i())
        @Expect(rectangle.size == Vector2i())
    }

    @TestCase
    func init_vectors() {
        let position = Vector2i(1, 2)
        let dimension = Vector2i(3, 4)
        let rectangle = IntRect(position, dimension)

        @Expect(rectangle.position == position)
        @Expect(rectangle.size == dimension)
    }

    @TestCase
    func contains_point() {
        let rectangle = IntRect(0, 0, 10, 10)

        @Expect(rectangle.contains(Vector2i(0, 0)), true)
        @Expect(rectangle.contains(Vector2i(9, 0)), true)
        @Expect(rectangle.contains(Vector2i(0, 9)), true)
        @Expect(rectangle.contains(Vector2i(9, 9)), true)

        @Expect(rectangle.contains(Vector2i(9, 10)), false)
        @Expect(rectangle.contains(Vector2i(10, 9)), false)
        @Expect(rectangle.contains(Vector2i(10, 10)), false)
        @Expect(rectangle.contains(Vector2i(15, 15)), false)
    }

    @TestCase
    func findIntersection() {
        let rectangle = IntRect(0, 0, 10, 10)
        let intersectingRectangle = IntRect(5, 5, 10, 10)

        let intersectionResult = rectangle.findIntersection(intersectingRectangle)
        @Expect(intersectionResult.isSome())
        @Expect(intersectionResult.getOrThrow() == IntRect(5, 5, 5, 5))

        let nonIntersectingRectangle = IntRect(-5, -5, 5, 5)
        @Expect(rectangle.findIntersection(nonIntersectingRectangle).isNone())
    }

    @TestCase
    func equality() {
        @Expect(IntRect() == IntRect())
        @Expect(IntRect(1, 3, 2, 5) == IntRect(1, 3, 2, 5))

        @Expect(IntRect(1, 0, 0, 0) != IntRect(0, 0, 0, 0))
        @Expect(IntRect(0, 1, 0, 0) != IntRect(0, 0, 0, 0))
        @Expect(IntRect(0, 0, 1, 0) != IntRect(0, 0, 0, 0))
        @Expect(IntRect(0, 0, 0, 1) != IntRect(0, 0, 0, 0))
    }
}

@Test
class TestFloatRect {
    @TestCase
    func init_default() {
        let rectangle = FloatRect()
        @Expect(rectangle.position == Vector2f())
        @Expect(rectangle.size == Vector2f())
    }

    @TestCase
    func init_vectors() {
        let position = Vector2f(1.0, 2.0)
        let dimension = Vector2f(3.0, 4.0)
        let rectangle = FloatRect(position, dimension)

        @Expect(rectangle.position == position)
        @Expect(rectangle.size == dimension)
    }

    @TestCase
    func contains_point() {
        let rectangle = FloatRect(0.0, 0.0, 10.0, 10.0)

        @Expect(rectangle.contains(Vector2f(0.0, 0.0)), true)
        @Expect(rectangle.contains(Vector2f(9.0, 0.0)), true)
        @Expect(rectangle.contains(Vector2f(0.0, 9.0)), true)
        @Expect(rectangle.contains(Vector2f(9.0, 9.0)), true)

        @Expect(rectangle.contains(Vector2f(9.0, 10.0)), false)
        @Expect(rectangle.contains(Vector2f(10.0, 9.0)), false)
        @Expect(rectangle.contains(Vector2f(10.0, 10.0)), false)
        @Expect(rectangle.contains(Vector2f(15.0, 15.0)), false)
    }

    @TestCase
    func findIntersection() {
        let rectangle = FloatRect(0.0, 0.0, 10.0, 10.0)
        let intersectingRectangle = FloatRect(5.0, 5.0, 10.0, 10.0)

        let intersectionResult = rectangle.findIntersection(intersectingRectangle)
        @Expect(intersectionResult.isSome())
        @Expect(intersectionResult.getOrThrow() == FloatRect(5.0, 5.0, 5.0, 5.0))

        let nonIntersectingRectangle = FloatRect(-5.0, -5.0, 5.0, 5.0)
        @Expect(rectangle.findIntersection(nonIntersectingRectangle).isNone())
    }

    @TestCase
    func equality() {
        @Expect(FloatRect() == FloatRect())
        @Expect(FloatRect(1.0, 3.0, 2.0, 5.0) == FloatRect(1.0, 3.0, 2.0, 5.0))

        @Expect(FloatRect(1.0, 0.0, 0.0, 0.0) != FloatRect(0.0, 0.0, 0.0, 0.0))
        @Expect(FloatRect(0.0, 1.0, 0.0, 0.0) != FloatRect(0.0, 0.0, 0.0, 0.0))
        @Expect(FloatRect(0.0, 0.0, 1.0, 0.0) != FloatRect(0.0, 0.0, 0.0, 0.0))
        @Expect(FloatRect(0.0, 0.0, 0.0, 1.0) != FloatRect(0.0, 0.0, 0.0, 0.0))
    }
}

// cjlint-ignore -end function names should be lower camel case
