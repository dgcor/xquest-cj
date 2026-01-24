package dgengine.test

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestSFMLUtils {
    @TestCase
    func toBlendMode() {
        @Expect(BlendAlpha.toBlendMode() == BlendMode.ALPHA)
        @Expect(BlendAdd.toBlendMode() == BlendMode.ADD)
        @Expect(BlendMultiply.toBlendMode() == BlendMode.MULTIPLY)
        @Expect(BlendMin.toBlendMode() == BlendMode.MIN)
        @Expect(BlendMax.toBlendMode() == BlendMode.MAX)
        @Expect(BlendNone.toBlendMode() == BlendMode.NONE)
    }

    @TestCase
    func rgbToColor() {
        @Expect(SFMLUtils.rgbToColor(0xAABBCC) == Color(0xAA, 0xBB, 0xCC, 0xFF))
    }

    @TestCase
    func rgbaToColor() {
        @Expect(SFMLUtils.rgbaToColor(0xAABBCCDD) == Color(0xAA, 0xBB, 0xCC, 0xDD))
    }

    @TestCase
    func stringToColor() {
        @Expect(SFMLUtils.stringToColor("0xAABBCC").getOrThrow() == Color(0xAA, 0xBB, 0xCC, 0xFF))
        @Expect(SFMLUtils.stringToColor("0xaabbcc").getOrThrow() == Color(0xAA, 0xBB, 0xCC, 0xFF))
        @Expect(SFMLUtils.stringToColor("0XAABBCC").getOrThrow() == Color(0xAA, 0xBB, 0xCC, 0xFF))
        @Expect(SFMLUtils.stringToColor("0xAABBCCDD").getOrThrow() == Color(0xAA, 0xBB, 0xCC, 0xDD))
        @Expect(SFMLUtils.stringToColor("0xaabbccdd").getOrThrow() == Color(0xAA, 0xBB, 0xCC, 0xDD))
        @Expect(SFMLUtils.stringToColor("0XAABBCCDD").getOrThrow() == Color(0xAA, 0xBB, 0xCC, 0xDD))
        @Expect(SFMLUtils.stringToColor("0XAABBCCDDD").isNone())
        @Expect(SFMLUtils.stringToColor("invalid").isNone())
    }

    @TestCase
    func spriteCenterTexture() {
        try (img = SFMLImage(Vector2u(64, 64)), texture = Texture(img), sprite = Sprite(texture, IntRect(10, 10, 32, 32))) {
            var rect = sprite.textureRect
            var orig = sprite.origin

            @Expect(rect.position.x, 10)
            @Expect(rect.position.y, 10)
            @Expect(rect.size.x, 32)
            @Expect(rect.size.y, 32)
            @Expect(orig.x, 0.0)
            @Expect(orig.y, 0.0)

            SFMLUtils.spriteCenterTexture(sprite)
            rect = sprite.textureRect
            orig = sprite.origin

            @Expect(rect.position.x, 16)
            @Expect(rect.position.y, 16)
            @Expect(rect.size.x, 32)
            @Expect(rect.size.y, 32)
            @Expect(orig.x, 0.0)
            @Expect(orig.y, 0.0)

            sprite.textureRect = IntRect(0, 0, 80, 80)
            SFMLUtils.spriteCenterTexture(sprite)
            rect = sprite.textureRect
            orig = sprite.origin

            @Expect(rect.position.x, 0)
            @Expect(rect.position.y, 0)
            @Expect(rect.size.x, 80)
            @Expect(rect.size.y, 80)
            @Expect(orig.x, -8.0)
            @Expect(orig.y, -8.0)
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
