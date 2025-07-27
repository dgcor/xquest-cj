package cjsfml.graphics

import std.unittest.*

@Test
class TestColor {
    @TestCase
    func init_default() {
        var color = Color()

        @Expect(color.r, 0)
        @Expect(color.g, 0)
        @Expect(color.b, 0)
        @Expect(color.a, 255)
    }

    @TestCase
    func init_rgb() {
        var color = Color(1, 2, 3)

        @Expect(color.r, 1)
        @Expect(color.g, 2)
        @Expect(color.b, 3)
        @Expect(color.a, 255)
    }

    @TestCase
    func init_rgb_tuple() {
        var color = Color((1, 2, 3))

        @Expect(color.r, 1)
        @Expect(color.g, 2)
        @Expect(color.b, 3)
        @Expect(color.a, 255)
    }

    @TestCase
    func init_rgba() {
        var color = Color(1, 2, 3, 4)

        @Expect(color.r, 1)
        @Expect(color.g, 2)
        @Expect(color.b, 3)
        @Expect(color.a, 4)
    }

    @TestCase
    func init_rgba_tuple() {
        var color = Color((1, 2, 3, 4))

        @Expect(color.r, 1)
        @Expect(color.g, 2)
        @Expect(color.b, 3)
        @Expect(color.a, 4)
    }

    @TestCase
    func init_UInt32() {
        var color = Color(0xAABBCCDD)

        @Expect(color.r, 0xAA)
        @Expect(color.g, 0xBB)
        @Expect(color.b, 0xCC)
        @Expect(color.a, 0xDD)

        color = Color(0x00000000)

        @Expect(color.r, 0x00)
        @Expect(color.g, 0x00)
        @Expect(color.b, 0x00)
        @Expect(color.a, 0x00)

        color = Color(0xFFFFFFFF)

        @Expect(color.r, 0xFF)
        @Expect(color.g, 0xFF)
        @Expect(color.b, 0xFF)
        @Expect(color.a, 0xFF)
    }

    @TestCase
    func equality_operators() {
        @Expect(Color(0xAA, 0xBB, 0xCC, 0xDD) == Color(0xAABBCCDD), true)
        @Expect(Color(0xAA, 0xBB, 0xCC, 0xDD) == Color(0xAABBCCDE), false)

        @Expect(Color(0xAA, 0xBB, 0xCC, 0xDD) != Color(0xAABBCCDD), false)
        @Expect(Color(0xAA, 0xBB, 0xCC, 0xDD) != Color(0xABBBCCDD), true)
        @Expect(Color(0xAA, 0xBB, 0xCC, 0xDD) != Color(0xAABCCCDD), true)
        @Expect(Color(0xAA, 0xBB, 0xCC, 0xDD) != Color(0xAABBCDDD), true)
        @Expect(Color(0xAA, 0xBB, 0xCC, 0xDD) != Color(0xAABBCCDE), true)
    }

    @TestCase
    func arithmetic_operators() {
        @Expect((Color(1, 2, 3, 4) + Color(1, 1, 1, 1)) == Color(2, 3, 4, 5))
        @Expect((Color(0xFF, 0xFF, 0xFF, 0xFF) + Color(1, 1, 1, 1)) == Color(0xFF, 0xFF, 0xFF, 0xFF))

        @Expect((Color(1, 2, 3, 4) - Color(1, 1, 1, 1)) == Color(0, 1, 2, 3))
        @Expect((Color(0, 0, 0, 0) - Color(1, 1, 1, 1)) == Color(0, 0, 0, 0))

        @Expect((Color(0xFF, 0xFF, 0xFF, 0xFF) * Color(2, 2, 2, 2)) == Color(2, 2, 2, 2))
    }

    @TestCase
    func toUInt32() {
        @Expect(Color(0, 0, 0, 0).toUInt32(), 0x00000000)
        @Expect(Color(1, 2, 3, 4).toUInt32(), 0x01020304)
        @Expect(Color(255, 255, 255, 255).toUInt32(), 0xFFFFFFFF)
    }
}
