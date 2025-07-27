package cjsfml.graphics

import cenum.*

@CEnum[public BlendFactor](
    Zero
    One
    SrcColor
    OneMinusSrcColor
    DstColor
    OneMinusDstColor
    SrcAlpha
    OneMinusSrcAlpha
    DstAlpha
    OneMinusDstAlpha
)

@CEnum[public BlendEquation](
    Add
    Subtract
    ReverseSubtract
    Min
    Max
)

@C
public struct BlendMode {
    public let colorSrcFactor: BlendFactor
    public let colorDstFactor: BlendFactor
    public let colorEquation: BlendEquation
    public let alphaSrcFactor: BlendFactor
    public let alphaDstFactor: BlendFactor
    public let alphaEquation: BlendEquation

    public const init() {
        colorSrcFactor = BlendFactor.SrcAlpha
        colorDstFactor = BlendFactor.OneMinusSrcAlpha
        colorEquation = BlendEquation.Add
        alphaSrcFactor = BlendFactor.One
        alphaDstFactor = BlendFactor.OneMinusSrcAlpha
        alphaEquation = BlendEquation.Add
    }

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

    public const init(sourceFactor: BlendFactor, destinationFactor: BlendFactor, blendEquation: BlendEquation) {
        colorSrcFactor = sourceFactor
        colorDstFactor = destinationFactor
        colorEquation = blendEquation
        alphaSrcFactor = sourceFactor
        alphaDstFactor = destinationFactor
        alphaEquation = blendEquation
    }

    public operator const func ==(right: BlendMode): Bool {
        (colorSrcFactor.value == right.colorSrcFactor.value && colorDstFactor.value == right.colorDstFactor.value &&
            colorEquation.value == right.colorEquation.value && alphaSrcFactor.value == right.alphaSrcFactor.value &&
            alphaDstFactor.value == right.alphaDstFactor.value && alphaEquation.value == right.alphaEquation.value)
    }

    public operator const func !=(right: BlendMode): Bool {
        (colorSrcFactor.value != right.colorSrcFactor.value || colorDstFactor.value != right.colorDstFactor.value ||
            colorEquation.value != right.colorEquation.value || alphaSrcFactor.value != right.alphaSrcFactor.value ||
            alphaDstFactor.value != right.alphaDstFactor.value || alphaEquation.value != right.alphaEquation.value)
    }

    public static const alpha = BlendMode(BlendFactor.SrcAlpha, BlendFactor.OneMinusSrcAlpha, BlendEquation.Add,
        BlendFactor.One, BlendFactor.OneMinusSrcAlpha, BlendEquation.Add)

    public static const add = BlendMode(BlendFactor.SrcAlpha, BlendFactor.One, BlendEquation.Add, BlendFactor.One,
        BlendFactor.One, BlendEquation.Add)

    public static const multiply = BlendMode(BlendFactor.DstColor, BlendFactor.Zero, BlendEquation.Add)

    public static const min = BlendMode(BlendFactor.One, BlendFactor.One, BlendEquation.Min)

    public static const max = BlendMode(BlendFactor.One, BlendFactor.One, BlendEquation.Max)

    public static const none = BlendMode(BlendFactor.One, BlendFactor.Zero, BlendEquation.Add)
}
