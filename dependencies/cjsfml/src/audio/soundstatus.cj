package cjsfml.audio

import cenum.CEnum

/**
 * Enumeration of the sound source states.
 */
@CEnum[public SoundStatus](
    Stopped // Sound is not playing
    Paused // Sound is paused
    Playing // Sound is playing
)
