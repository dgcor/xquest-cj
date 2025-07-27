package cjsfml.graphics

public interface Drawable {
    func draw(target: RenderTarget): Unit {
        draw(target, RenderStates.default)
    }

    func draw(target: RenderTarget, states: RenderStates): Unit
}

public interface RenderTargetDrawable <: Drawable {
    func draw(target: RenderTarget, states: RenderStates): Unit {
        target.drawRenderTarget(this, states)
    }

    func draw(window: RenderTexture, states: RenderStates): Unit

    func draw(window: RenderWindow, states: RenderStates): Unit
}
