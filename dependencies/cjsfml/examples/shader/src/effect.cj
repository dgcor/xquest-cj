package shader

import cjsfml.graphics.Drawable

// Base class for effects
interface Effect <: Drawable & Resource {
    func update(time: Float32, x: Float32, y: Float32): Unit
}
