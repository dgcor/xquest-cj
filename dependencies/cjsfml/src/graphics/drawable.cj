package cjsfml.graphics

// cjlint-ignore -start !G.ITF.04 using interface as type parameter

/**
 * Interface for objects that can be drawn to a render target.
 *
 * `Drawable` is a very simple interface that allows objects
 * of derived classes to be drawn to a `RenderTarget`.
 *
 * All you have to do in your derived class is to override the
 * draw virtual function.
 *
 * Note that inheriting from `Drawable` is not mandatory,
 * but it allows this nice syntax `window.draw(object)` rather
 * than `object.draw(window)`, which is more consistent with other
 * SFML classes.
 *
 * Example:
 * ```
 * class MyDrawable <: Drawable {
 *     public func draw(target: RenderTarget, states: RenderStates): Unit {
 *         // You can draw other high-level objects
 *         target.draw(m_sprite, states);
 *
 *         // ... or use the low-level API
 *         // states.texture = m_texture;
 *         target.draw(m_vertices, states);
 *
 *         // ... or draw with OpenGL directly
 *         // glBegin(GL_TRIANGLES);
 *         // ...
 *         // glEnd();
 *     }
 *
 *     private var m_sprite: Sprite
 *     private var m_texture: Texture
 *     private var m_vertices: VertexArray
 * }
 * ```
 *
 * @see `RenderTarget`
 */
public interface Drawable {
    /**
     * Draw the object to a render target.
     *
     * @param target Render target to draw to
     */
    func draw(target: RenderTarget): Unit {
        draw(target, RenderStates.DEFAULT)
    }

    /**
     * Draw the object to a render target.
     *
     * @param target Render target to draw to
     * @param states Current render states
     */
    func draw(target: RenderTarget, states: RenderStates): Unit
}

/**
 * Interface for objects that can be drawn to a render window or texture.
 *
 * `RenderTargetDrawable` is an Interface that allows objects
 * of derived classes to be drawn to specific render targets like
 * `RenderWindow` or `RenderTexture`.
 */
public interface RenderTargetDrawable <: Drawable {
    func draw(target: RenderTarget, states: RenderStates): Unit {
        target.drawRenderTarget(this, states)
    }

    /**
     * Draw the object to a render texture.
     *
     * @param window Render texture to draw to
     * @param states Current render states
     */
    func draw(window: RenderTexture, states: RenderStates): Unit

    /**
     * Draw the object to a render window.
     *
     * @param window Render window to draw to
     * @param states Current render states
     */
    func draw(window: RenderWindow, states: RenderStates): Unit
}

// cjlint-ignore -end using interface as type parameter
