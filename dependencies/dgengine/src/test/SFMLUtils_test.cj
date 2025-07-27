package dgengine.test

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import dgengine.*
import std.unittest.*

@Test
class TestSFMLUtils {
    @TestCase
    func toBlendMode() {
        @Expect(BlendAlpha.toBlendMode() == BlendMode.alpha)
        @Expect(BlendAdd.toBlendMode() == BlendMode.add)
        @Expect(BlendMultiply.toBlendMode() == BlendMode.multiply)
        @Expect(BlendMin.toBlendMode() == BlendMode.min)
        @Expect(BlendMax.toBlendMode() == BlendMode.max)
        @Expect(BlendNone.toBlendMode() == BlendMode.none)
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
        try (img = SFMLImage(64, 64), texture = Texture(img), sprite = Sprite(texture, IntRect(10, 10, 32, 32))) {
            var rect = sprite.textureRect
            var orig = sprite.origin

            @Expect(rect.left, 10)
            @Expect(rect.top, 10)
            @Expect(rect.width, 32)
            @Expect(rect.height, 32)
            @Expect(orig.x, 0.0)
            @Expect(orig.y, 0.0)

            SFMLUtils.spriteCenterTexture(sprite)
            rect = sprite.textureRect
            orig = sprite.origin

            @Expect(rect.left, 16)
            @Expect(rect.top, 16)
            @Expect(rect.width, 32)
            @Expect(rect.height, 32)
            @Expect(orig.x, 0.0)
            @Expect(orig.y, 0.0)

            sprite.textureRect = IntRect(0, 0, 80, 80)
            SFMLUtils.spriteCenterTexture(sprite)
            rect = sprite.textureRect
            orig = sprite.origin

            @Expect(rect.left, 0)
            @Expect(rect.top, 0)
            @Expect(rect.width, 80)
            @Expect(rect.height, 80)
            @Expect(orig.x, -8.0)
            @Expect(orig.y, -8.0)
        }
    }
}
