package dgengine

import cjsfml.graphics.*
import cjsfml.graphics.View as SFMLView
import cjsfml.system.*
import std.convert.*
import std.math.*

public class SFMLUtils {
    public static func rgbToColor(value: UInt32): Color {
        let r = UInt8((value & 0x00FF0000) >> 16)
        let g = UInt8((value & 0x0000FF00) >> 8)
        let b = UInt8(value & 0x000000FF)
        return Color(r, g, b)
    }

    public static func rgbaToColor(value: UInt32): Color {
        let r = UInt8((value & 0xFF000000) >> 24)
        let g = UInt8((value & 0x00FF0000) >> 16)
        let b = UInt8((value & 0x0000FF00) >> 8)
        let a = UInt8(value & 0x000000FF)
        return Color(r, g, b, a)
    }

    public static func stringToColor(str: String): ?Color {
        if (let Some(num) <- UInt32.tryParse(str)) {
            return match (str.size) {
                case 8 => rgbToColor(num)
                case 10 => rgbaToColor(num)
                case _ => None
            }
        }
        return None
    }

    public static func spriteCenterTexture(sprite: Sprite): Unit {
        var origin = Vector2f()
        let texSize = sprite.texture.size
        var texRect = sprite.textureRect
        var updateTexRect = false

        let valX = round(-(Float32(texRect.width) / 2.0) + (Float32(texSize.x) / 2.0))
        if (Int32(texSize.x) <= texRect.width) {
            origin.x = valX
        } else {
            texRect.left = Int32(valX)
            updateTexRect = true
        }
        let valY = round(-(Float32(texRect.height) / 2.0) + (Float32(texSize.y) / 2.0))
        if (Int32(texSize.y) <= texRect.height) {
            origin.y = valY
        } else {
            texRect.top = Int32(valY)
            updateTexRect = true
        }
        sprite.origin = origin
        if (updateTexRect == true) {
            sprite.textureRect = texRect
        }
    }

    public static func getScaleToStretchAndKeepAR(size: Vector2u, windowSize: Vector2u): Float32 {
        let windowRatio = Float32(windowSize.x) / Float32(windowSize.y)
        let drawableRatio = Float32(size.x) / Float32(size.y)
        return match (windowRatio < drawableRatio) {
            case true => Float32(windowSize.y) / Float32(size.y)
            case false => Float32(windowSize.x) / Float32(size.x)
        }
    }

    public static func viewStretchKeepAR(view: SFMLView, windowSize: Vector2u,
        viewPort!: FloatRect = FloatRect(0.0, 0.0, 1.0, 1.0)): Unit {
        // Compares the aspect ratio of the window to the aspect ratio of the view,
        // and sets the view's viewport accordingly in order to archieve a letterbox effect.

        let windowRatio = Float32(windowSize.x) / Float32(windowSize.y)
        let viewSize = view.size
        let viewRatio = viewSize.x / viewSize.y

        var horizontalSpacing = true
        if (windowRatio < viewRatio) {
            horizontalSpacing = false
        }

        // If horizontalSpacing is true, the black bars will appear on the left and right side.
        // Otherwise, the black bars will appear on the top and bottom.

        var viewPort2 = viewPort
        if (horizontalSpacing == true) {
            viewPort2.width = viewRatio / windowRatio
            viewPort2.left = (1.0 - viewPort2.width) / 2.0
        } else {
            viewPort2.height = windowRatio / viewRatio
            viewPort2.top = (1.0 - viewPort2.height) / 2.0
        }
        view.viewport = viewPort2
    }
}
