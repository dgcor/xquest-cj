package cjsfml.audio

type EffectProcessor = CFunc<(inputFrames: CPointer<Float32>, inputFrameCount: CPointer<UInt32>, outputFrames: CPointer<Float32>,
    outputFrameCount: CPointer<UInt32>, frameChannelCount: UInt32) -> Unit>
