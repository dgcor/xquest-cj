package cjsfml.graphics

import cenum.CEnum

/**
 * Enumeration of the blending factors.
 *
 * The factors are mapped directly to their OpenGL equivalents,
 * specified by `glBlendFunc()` or `glBlendFuncSeparate()`.
 */
@CEnum[public BlendFactor](
    Zero // (0, 0, 0, 0)
    One // (1, 1, 1, 1)
    SrcColor // (src.r, src.g, src.b, src.a)
    OneMinusSrcColor // (1, 1, 1, 1) - (src.r, src.g, src.b, src.a)
    DstColor // (dst.r, dst.g, dst.b, dst.a)
    OneMinusDstColor // (1, 1, 1, 1) - (dst.r, dst.g, dst.b, dst.a)
    SrcAlpha // (src.a, src.a, src.a, src.a)
    OneMinusSrcAlpha // (1, 1, 1, 1) - (src.a, src.a, src.a, src.a)
    DstAlpha // (dst.a, dst.a, dst.a, dst.a)
    OneMinusDstAlpha // (1, 1, 1, 1) - (dst.a, dst.a, dst.a, dst.a)
)

/**
 * Enumeration of the blending equations.
 *
 * The equations are mapped directly to their OpenGL equivalents,
 * specified by `glBlendEquation()` or `glBlendEquationSeparate()`.
 */
@CEnum[public BlendEquation](
    Add // Pixel = Src * SrcFactor + Dst * DstFactor
    Subtract // Pixel = Src * SrcFactor - Dst * DstFactor
    ReverseSubtract // Pixel = Dst * DstFactor - Src * SrcFactor
    Min // Pixel = min(Dst, Src)
    Max // Pixel = max(Dst, Src)
)

/**
 * Blending modes for drawing.
 *
 * `BlendMode` is a class that represents a blend mode. A blend
 * mode determines how the colors of an object you draw are
 * mixed with the colors that are already in the buffer.
 *
 * The class is composed of 6 components, each of which has its
 * own public member variable:
 * - Color Source Factor (`colorSrcFactor`)
 * - Color Destination Factor (`colorDstFactor`)
 * - Color Blend Equation (`colorEquation`)
 * - Alpha Source Factor (`alphaSrcFactor`)
 * - Alpha Destination Factor (`alphaDstFactor`)
 * - Alpha Blend Equation (`alphaEquation`)
 *
 * The source factor specifies how the pixel you are drawing contributes
 * to the final color. The destination factor specifies how the pixel
 * already drawn in the buffer contributes to the final color.
 *
 * The color channels RGB (red, green, blue; simply referred to as
 * color) and A (alpha; the transparency) can be treated separately. This
 * separation can be useful for specific blend modes, but most often you
 * won't need it and will simply treat the color as a single unit.
 *
 * The blend factors and equations correspond to their OpenGL equivalents.
 * In general, the color of the resulting pixel is calculated according
 * to the following formula (`src` is the color of the source pixel, `dst`
 * the color of the destination pixel, the other variables correspond to the
 * public members, with the equations being + or - operators):
 * ```
 * dst.rgb = colorSrcFactor * src.rgb (colorEquation) colorDstFactor * dst.rgb
 * dst.a   = alphaSrcFactor * src.a   (alphaEquation) alphaDstFactor * dst.a
 * ```
 * All factors and colors are represented as floating point numbers between
 * 0 and 1. Where necessary, the result is clamped to fit in that range.
 *
 * The most common blending modes are defined as constants:
 *
 * ```
 * let alphaBlending          = BlendMode.ALPHA;
 * let additiveBlending       = BlendMode.ADD;
 * let multiplicativeBlending = BlendMode.MULTIPLY;
 * let noBlending             = BlendMode.NONE;
 * ```
 *
 * In SFML, a blend mode can be specified every time you draw a `Drawable`
 * object to a render target. It is part of the `RenderStates` compound
 * that is passed to the member function `RenderTarget.draw()`.
 *
 * @see `RenderStates`, `RenderTarget`
 */
@C
public struct BlendMode {
    /**
     * Source blending factor for the color channels.
     */
    public let colorSrcFactor: BlendFactor
    /**
     * Destination blending factor for the color channels.
     */
    public let colorDstFactor: BlendFactor
    /**
     * Blending equation for the color channels.
     */
    public let colorEquation: BlendEquation
    /**
     * Source blending factor for the alpha channel.
     */
    public let alphaSrcFactor: BlendFactor
    /**
     * Destination blending factor for the alpha channel.
     */
    public let alphaDstFactor: BlendFactor
    /**
     * Blending equation for the alpha channel.
     */
    public let alphaEquation: BlendEquation

    /**
     * Default constructor.
     *
     * Constructs a blending mode that does alpha blending.
     */
    public const init() {
        colorSrcFactor = BlendFactor.SrcAlpha
        colorDstFactor = BlendFactor.OneMinusSrcAlpha
        colorEquation = BlendEquation.Add
        alphaSrcFactor = BlendFactor.One
        alphaDstFactor = BlendFactor.OneMinusSrcAlpha
        alphaEquation = BlendEquation.Add
    }

    /**
     * Construct the blend mode given the factors and equation.
     *
     * @param colorSourceFactor      Specifies how to compute the source factor for the color channels.
     * @param colorDestinationFactor Specifies how to compute the destination factor for the color channels.
     * @param colorBlendEquation     Specifies how to combine the source and destination colors.
     * @param alphaSourceFactor      Specifies how to compute the source factor for the alpha channel.
     * @param alphaDestinationFactor Specifies how to compute the destination factor for the alpha channel.
     * @param alphaBlendEquation     Specifies how to combine the source and destination alphas.
     */
    public const init(colorSourceFactor: BlendFactor, colorDestinationFactor: BlendFactor,
        colorBlendEquation: BlendEquation, alphaSourceFactor: BlendFactor, alphaDestinationFactor: BlendFactor,
        alphaBlendEquation: BlendEquation) {
        colorSrcFactor = colorSourceFactor
        colorDstFactor = colorDestinationFactor
        colorEquation = colorBlendEquation
        alphaSrcFactor = alphaSourceFactor
        alphaDstFactor = alphaDestinationFactor
        alphaEquation = alphaBlendEquation
    }

    /**
     * Construct the blend mode given the factors and equation.
     *
     * This constructor uses the same factors and equation for both
     * color and alpha components. It also defaults to the Add equation.
     *
     * @param sourceFactor      Specifies how to compute the source factor for the color and alpha channels.
     * @param destinationFactor Specifies how to compute the destination factor for the color and alpha channels.
     * @param blendEquation     Specifies how to combine the source and destination colors and alpha.
     */
    public const init(sourceFactor: BlendFactor, destinationFactor: BlendFactor, blendEquation: BlendEquation) {
        colorSrcFactor = sourceFactor
        colorDstFactor = destinationFactor
        colorEquation = blendEquation
        alphaSrcFactor = sourceFactor
        alphaDstFactor = destinationFactor
        alphaEquation = blendEquation
    }

    /**
     * Overload of the `operator==`.
     *
     * @param right Right operand
     *
     * @return `true` if blending modes are equal, `false` if they are different
     */
    public const operator func ==(right: BlendMode): Bool {
        (colorSrcFactor.value == right.colorSrcFactor.value && colorDstFactor.value == right.colorDstFactor.value &&
            colorEquation.value == right.colorEquation.value && alphaSrcFactor.value == right.alphaSrcFactor.value &&
            alphaDstFactor.value == right.alphaDstFactor.value && alphaEquation.value == right.alphaEquation.value)
    }

    /**
     * Overload of the `operator!=`.
     *
     * @param right Right operand
     *
     * @return `true` if blending modes are different, `false` if they are equal
     */
    public const operator func !=(right: BlendMode): Bool {
        (colorSrcFactor.value != right.colorSrcFactor.value || colorDstFactor.value != right.colorDstFactor.value ||
            colorEquation.value != right.colorEquation.value || alphaSrcFactor.value != right.alphaSrcFactor.value ||
            alphaDstFactor.value != right.alphaDstFactor.value || alphaEquation.value != right.alphaEquation.value)
    }

    /**
     * Blend source and dest according to dest alpha.
     */
    public static const ALPHA: BlendMode = BlendMode(BlendFactor.SrcAlpha, BlendFactor.OneMinusSrcAlpha,
        BlendEquation.Add, BlendFactor.One, BlendFactor.OneMinusSrcAlpha, BlendEquation.Add)

    /**
     * Add source to dest.
     */
    public static const ADD: BlendMode = BlendMode(BlendFactor.SrcAlpha, BlendFactor.One, BlendEquation.Add,
        BlendFactor.One, BlendFactor.One, BlendEquation.Add)

    /**
     * Multiply source and dest.
     */
    public static const MULTIPLY: BlendMode = BlendMode(BlendFactor.DstColor, BlendFactor.Zero, BlendEquation.Add)

    /**
     * Take minimum between source and dest.
     */
    public static const MIN: BlendMode = BlendMode(BlendFactor.One, BlendFactor.One, BlendEquation.Min)

    /**
     * Take maximum between source and dest.
     */
    public static const MAX: BlendMode = BlendMode(BlendFactor.One, BlendFactor.One, BlendEquation.Max)

    /**
     * Overwrite dest with source.
     */
    public static const NONE: BlendMode = BlendMode(BlendFactor.One, BlendFactor.Zero, BlendEquation.Add)
}
