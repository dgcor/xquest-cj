package cjsfml.graphics

import cenum.CEnum

/**
 * Enumeration of the stencil test comparisons that can be performed.
 *
 * The comparisons are mapped directly to their OpenGL equivalents,
 * specified by `glStencilFunc()`.
 */
@CEnum[public StencilComparison](
    Never // The stencil test never passes
    Less // The stencil test passes if the new value is less than the value in the stencil buffer
    LessEqual // The stencil test passes if the new value is less than or equal to the value in the stencil buffer
    Greater // The stencil test passes if the new value is greater than the value in the stencil buffer
    GreaterEqual // The stencil test passes if the new value is greater than or equal to the value in the stencil buffer
    Equal // The stencil test passes if the new value is strictly equal to the value in the stencil buffer
    NotEqual // The stencil test passes if the new value is strictly unequal to the value in the stencil buffer
    Always // The stencil test always passes
)

/**
 * Enumeration of the stencil buffer update operations.
 *
 * The update operations are mapped directly to their OpenGL equivalents,
 * specified by `glStencilOp()`.
 */
@CEnum[public StencilUpdateOperation](
    Keep // If the stencil test passes, the value in the stencil buffer is not modified
    Zero // If the stencil test passes, the value in the stencil buffer is set to zero
    Replace // If the stencil test passes, the value in the stencil buffer is set to the new value
    Increment // If the stencil test passes, the value in the stencil buffer is incremented and if required clamped
    Decrement // If the stencil test passes, the value in the stencil buffer is decremented and if required clamped
    Invert // If the stencil test passes, the value in the stencil buffer is bitwise inverted
)

/**
 * Stencil modes for drawing.
 *
 * `StencilMode` is a class that controls stencil testing.
 *
 * In addition to drawing to the visible portion of a render target,
 * there is the possibility to "draw" to a so-called stencil buffer.
 * The stencil buffer is a special non-visible buffer that can contain
 * a single value per pixel that is drawn. This can be thought of as a
 * fifth value in addition to red, green, blue and alpha values. The maximum
 * value that can be represented depends on what is supported by the system.
 * Typically support for a 8-bit stencil buffer should always be available.
 * This will also have to be requested when creating a render target via
 * the `ContextSettings` that is passed during creation. Stencil testing
 * will not work if there is no stencil buffer available in the target
 * that is being drawn to.
 *
 * Initially, just like with the visible color buffer, the stencil value of
 * each pixel is set to an undefined value. Calling `RenderTarget.clear`
 * will set each pixel's stencil value to 0. `RenderTarget.clear` can be
 * called at any time to reset the stencil values back to 0.
 *
 * When drawing an object, before each pixel of the color buffer is updated
 * with its new color value, the stencil test is performed. During this test
 * 2 values are compared with each other: the reference value that is passed
 * via `StencilMode` and the value that is currently in the stencil buffer.
 * The arithmetic comparison that is performed on the 2 values can also be
 * controlled via `StencilMode`. Depending on whether the test passes i.e.
 * the comparison yields `true`, the color buffer is updated with its new RGBA
 * value and if set in `StencilMode` the stencil buffer is updated
 * accordingly. The new stencil value will be used during stencil testing the
 * next time the pixel is drawn to.
 *
 * The class is composed of 5 components, each of which has its
 * own public member variable:
 * - Stencil Comparison (`stencilComparison`)
 * - Stencil Update Operation (`stencilUpdateOperation`)
 * - Stencil Reference Value (`stencilReference`)
 * - Stencil Mask Value (`stencilMask`)
 * - Stencil Only Update (`stencilOnly`)
 *
 * The stencil comparison specifies the comparison that is performed between
 * the reference value of the currently active `StencilMode` and the value
 * that is currently in the stencil buffer. This comparison determines whether
 * the stencil test passes or fails.
 *
 * The stencil update operation specifies how the stencil buffer is updated if
 * the stencil test passes. If the stencil test fails, neither the color or
 * stencil buffers will be modified. If incrementing or decrementing the
 * stencil value, the new value will be clamped to the range from 0 to the
 * maximum representable value given the bit width of the stencil buffer
 * e.g. 255 if an 8-bit stencil buffer is being used.
 *
 * The reference value is used both during the comparison with the current
 * stencil buffer value and as the new value to be written when the operation
 * is set to Replace.
 *
 * The mask value is used to mask the bits of both the reference value and
 * the value in the stencil buffer during the comparison and when updating.
 * The mask can be used to e.g. segment the stencil value bits into separate
 * regions that are used for different purposes.
 *
 * In certain situations, it might make sense to only write to the stencil
 * buffer and not the color buffer during a draw. The written stencil buffer
 * value can then be used in subsequent draws as a masking region.
 *
 * In SFML, a stencil mode can be specified every time you draw a `Drawable`
 * object to a render target. It is part of the `RenderStates` compound
 * that is passed to the member function `RenderTarget.draw()`.
 *
 * Usage example:
 * ```
 * // Make sure we create a RenderTarget with a stencil buffer by specifying it via the context settings
 * let window = RenderWindow(VideoMode(Vector2u(250, 200)), "Stencil Window", WindowStyle.Default,
 *     ContextSettings(stencilBits: 8));
 *
 * ...
 *
 * // Left circle
 * let left = CircleShape(100.0);
 * left.fillColor = Color.GREEN;
 * left.position = Vector2f(0.0, 0.0);
 *
 * // Middle circle
 * let middle = CircleShape(100.0);
 * middle.fillColor = Color.YELLOW;
 * middle.position = Vector2f(25.0, 0.0);
 *
 * // Right circle
 * let right = CircleShape(100.0);
 * right.fillColor = Color.RED;
 * right.position = Vector2f(50.0, 0.0);
 *
 * ...
 *
 * // Clear the stencil buffer to 0 at the start of every frame
 * window.clear(Color.BLACK, 0);
 *
 * ...
 *
 * // Draw the middle circle in a stencil-only pass and write the value 1
 * // to the stencil buffer for every pixel the circle would have affected
 * window.draw(middle, StencilMode(StencilComparison.Always, StencilUpdateOperation.Replace, 1, 0xFF, true));
 *
 * // Draw the left and right circles
 * // Only allow rendering to pixels whose stencil value is not
 * // equal to 1 i.e. weren't written when drawing the middle circle
 * window.draw(left, StencilMode(StencilComparison.NotEqual, StencilUpdateOperation.Keep, 1, 0xFF, false));
 * window.draw(right, StencilMode(StencilComparison.NotEqual, StencilUpdateOperation.Keep, 1, 0xFF, false));
 * ```
 *
 * @see `RenderStates`, `RenderTarget`
 */
@C
public struct StencilMode {
    /**
     * Construct the stencil mode.
     *
     * @param stencilComparison      The comparison we're performing the stencil test with
     * @param stencilUpdateOperation The update operation to perform if the stencil test passes
     * @param stencilReference       The reference value we're performing the stencil test with
     * @param stencilMask            The mask to apply to both the reference value and the value in the stencil buffer
     * @param stencilOnly            Whether we should update the color buffer in addition to the stencil buffer
     */
    public const StencilMode(
        public let stencilComparison!: StencilComparison = StencilComparison.Always,
        public let stencilUpdateOperation!: StencilUpdateOperation = StencilUpdateOperation.Keep,
        public let stencilReference!: UInt32 = 0,
        public let stencilMask!: UInt32 = 0xFFFFFFFF,
        public let stencilOnly!: Bool = false
    ) {}

    public const operator func ==(right: StencilMode): Bool {
        (stencilComparison.value == right.stencilComparison.value && stencilUpdateOperation.value == right
            .stencilUpdateOperation.value && stencilReference == right.stencilReference && stencilMask == right
            .stencilMask && stencilOnly == right.stencilOnly)
    }

    public const operator func !=(right: StencilMode): Bool {
        (stencilComparison.value != right.stencilComparison.value || stencilUpdateOperation.value != right
            .stencilUpdateOperation.value || stencilReference != right.stencilReference || stencilMask != right
            .stencilMask || stencilOnly != right.stencilOnly)
    }

    /**
     * Default stencil mode.
     */
    public static const DEFAULT: StencilMode = StencilMode()
}
