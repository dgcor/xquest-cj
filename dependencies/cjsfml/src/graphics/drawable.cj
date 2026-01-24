package cjsfml.graphics

// cjlint-ignore -start !G.ITF.04 using interface as type parameter

public interface Drawable {
    func draw(target: RenderTarget): Unit {
        draw(target, RenderStates.DEFAULT)
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

// cjlint-ignore -end using interface as type parameter
