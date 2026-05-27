package cjsfml.graphics

import cenum.CEnum

/**
 * Types of texture coordinates that can be used for rendering.
 *
 * @see `Texture.bind`
 */
@CEnum[public CoordinateType](
    Normalized // Texture coordinates in range [0 .. 1]
    Pixels // Texture coordinates in range [0 .. size]
)
