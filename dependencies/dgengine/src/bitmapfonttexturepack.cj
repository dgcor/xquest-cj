package dgengine

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import std.collection.*

public class BitmapFontTexturePack <: TexturePack {
    protected let m_texture: Texture
    protected let m_palette: ?Palette
    protected var m_charRects: ArrayList<IntRect>

    public init(texture: Texture, palette: ?Palette, charRects: ArrayList<IntRect>) {
        m_texture = texture
        m_palette = palette
        m_charRects = charRects
    }

    public init(texture: Texture, palette: ?Palette, rows: Int32, columns: Int32, newLine: Int16, space: Int16,
        tab: Int16, verticalDirection: Bool) {
        m_texture = texture
        m_palette = palette
        m_charRects = ArrayList<IntRect>()
        try (img = texture.copyToImage()) {
            calculateCharSizes(img, rows, columns, newLine, space, tab, verticalDirection)
        }
    }

    public init(texture: Texture, palette: ?Palette, rows: Int32, columns: Int32, newLine: Int16, space: Int16,
        tab: Int16, verticalDirection: Bool, charSizes: Array<UInt8>, startPos: UInt32, stepNBytes: UInt32) {
        m_texture = texture
        m_palette = palette
        m_charRects = ArrayList<IntRect>()

        var charStartIdx = 0
        if (charSizes.size == 130 || charSizes.size == 258) {
            charStartIdx = 2
        } else if ((charSizes.size == 128 || charSizes.size == 256) == false && charSizes.size <= 256) {
            try (img = texture.copyToImage()) {
                calculateCharSizes(img, rows, columns, newLine, space, tab, verticalDirection)
            }
            return
        } else {
            charStartIdx = Int64(startPos)
        }
        var stepNBytes2 = Int64(stepNBytes)
        if (stepNBytes == 0) {
            stepNBytes2 = 1
        }

        m_charRects = ArrayList<IntRect>(Int64(rows * columns), {_ => IntRect()})

        let cellW = Int32(texture.size.x) / columns
        let cellH = Int32(texture.size.y) / rows
        var iRow = 0i32
        var iCol = 0i32
        for (index in 0..m_charRects.size) {
            var rect = m_charRects[index]
            rect.position.x = cellW * iCol
            rect.position.y = cellH * iRow
            let charSizeIdx = (index * stepNBytes2) + charStartIdx
            if (charSizeIdx < charSizes.size) {
                rect.size.x = Int32(charSizes[charSizeIdx])
            } else {
                rect.size.x = 0
            }
            rect.size.y = cellH
            m_charRects[index] = rect

            if (verticalDirection == false) {
                iCol++
                if (iCol >= columns) {
                    iCol = 0
                    iRow++
                }
            } else {
                iRow++
                if (iRow >= rows) {
                    iRow = 0
                    iCol++
                }
            }
        }

        if (newLine > 0) {
            let index = Int64(UInt32(r'\n'))
            var rect = m_charRects[index]
            rect.size.y = Int32(newLine)
            m_charRects[index] = rect
        } else if (charStartIdx == 2 && (charSizes.size == 130 || charSizes.size == 258)) {
            let index = Int64(UInt32(r'\n'))
            var rect = m_charRects[index]
            rect.size.y = Int32(charSizes[1])
            m_charRects[index] = rect
        }

        if (space > 0) {
            let index = Int64(UInt32(r' '))
            var rect = m_charRects[index]
            rect.size.x = Int32(space)
            m_charRects[index] = rect
        } else if (charStartIdx == 2 && (charSizes.size == 130 || charSizes.size == 258)) {
            let index = Int64(UInt32(r' '))
            var rect = m_charRects[index]
            rect.size.x = Int32(charSizes[0])
            m_charRects[index] = rect
        }

        if (tab > 0) {
            let index = Int64(UInt32(r'\t'))
            var rect = m_charRects[index]
            rect.size.x = Int32(tab)
            m_charRects[index] = rect
        }
    }

    protected func calculateCharSizes(img: SFMLImage, rows: Int32, columns: Int32, newLine: Int16, space: Int16,
        tab: Int16, verticalDirection: Bool): Unit {
        // Set the cell dimensions
        let cellW = Int32(img.size.x) / columns
        let cellH = Int32(img.size.y) / rows

        if (cellW <= 0 || cellH <= 0) {
            return
        }

        m_charRects = ArrayList<IntRect>(Int64(rows * columns), {_ => IntRect()})

        // New line variables
        var top = cellH
        var baseA = cellH

        // Go through the cell rows
        var iRow = 0i32
        var iCol = 0i32
        for (index in 0..m_charRects.size) {
            var rect = m_charRects[index]

            // Set the character offset
            rect.position.x = cellW * iCol
            rect.position.y = cellH * iRow

            // Set the dimensions of the character
            rect.size.x = cellW
            rect.size.y = cellH

            // Find Left Side
            // Go through pixel columns
            var pCol = 0i32
            while (pCol < cellW) {
                // Go through pixel rows
                var pRow = 0i32
                while (pRow < cellH) {
                    // Get the pixel offsets
                    let pX = (cellW * iCol) + pCol
                    let pY = (cellH * iRow) + pRow

                    // If a non colorkey pixel is found
                    if (img.getPixel(Vector2u(UInt32(pX), UInt32(pY))).a != 0) {
                        // Set the x offset
                        rect.position.x = pX

                        // Break the loops
                        pCol = cellW
                        pRow = cellH
                    } else {
                        pRow++
                    }
                }
                pCol++
            }

            // Find Right Side
            // Go through pixel columns
            var pColW = cellW - 1
            while (pColW >= 0) {
                // Go through pixel rows
                var pRowW = 0i32
                while (pRowW < cellH) {
                    // Get the pixel offsets
                    let pX = (cellW * iCol) + pColW
                    let pY = (cellH * iRow) + pRowW

                    // If a non colorkey pixel is found
                    if (img.getPixel(Vector2u(UInt32(pX), UInt32(pY))).a != 0) {
                        // Set the width
                        rect.size.x = (pX - rect.position.x) + 1

                        // Break the loops
                        pColW = -1
                        pRowW = cellH
                    }
                    pRowW++
                }
                pColW--
            }
            m_charRects[index] = rect

            // Find Top
            // Go through pixel rows
            var pRow = 0i32
            while (pRow < cellH) {
                // Go through pixel columns
                var pCol = 0i32
                while (pCol < cellW) {
                    // Get the pixel offsets
                    let pX = UInt32((cellW * iCol) + pCol)
                    let pY = UInt32((cellH * iRow) + pRow)

                    // If a non colorkey pixel is found
                    if (img.getPixel(Vector2u(pX, pY)).a != 0) {
                        // If new top is found
                        if (pRow < top) {
                            top = pRow
                        }

                        // Break the loops
                        pCol = cellW
                        pRow = cellH
                    } else {
                        pCol++
                    }
                }
                pRow++
            }

            if (verticalDirection == false) {
                iCol++
                if (iCol >= columns) {
                    iCol = 0
                    iRow++
                }
            } else {
                iRow++
                if (iRow >= rows) {
                    iRow = 0
                    iCol++
                }
            }
        }

        // Calculate new line
        let indexA = Int64(UInt32(r'A'))
        if (newLine < 0 && m_charRects.size > indexA) {
            // Find Bottom of A
            let rect = m_charRects[indexA]

            // Go through pixel rows
            var pRow = rect.size.y - 1
            while (pRow >= 0) {
                // Go through pixel columns
                var pCol = 0i32
                while (pCol < rect.size.x) {
                    // Get the pixel offsets
                    let pX = rect.position.x + pCol
                    let pY = rect.position.y + pRow

                    // If a non colorkey pixel is found
                    if (img.getPixel(Vector2u(UInt32(pX), UInt32(pY))).a != 0) {
                        // Bottom of a is found
                        baseA = pRow

                        // Break the loops
                        pCol = rect.size.x
                        pRow = -1
                    } else {
                        pCol++
                    }
                }
                pRow--
            }
            let indexNL = Int64(UInt32(r'\n'))
            var charRectNL = m_charRects[indexNL]
            charRectNL.size.y = baseA - top
            m_charRects[indexNL] = charRectNL
        } else if (newLine > 0) {
            let indexNL = Int64(UInt32(r'\n'))
            var charRectNL = m_charRects[indexNL]
            charRectNL.size.y = Int32(newLine)
            m_charRects[indexNL] = charRectNL
        }

        // Calculate space
        if (space < 0) {
            let index = Int64(UInt32(r' '))
            var rect = m_charRects[index]
            rect.size.x = cellW / 2
            m_charRects[index] = rect
        } else if (space > 0) {
            let index = Int64(UInt32(r' '))
            var rect = m_charRects[index]
            rect.size.x = Int32(space)
            m_charRects[index] = rect
        }

        // Calculate tab
        if (tab < 0) {
            let index = Int64(UInt32(r'\t'))
            var rect = m_charRects[index]
            rect.size.x = cellW * 2
            m_charRects[index] = rect
        } else if (tab > 0) {
            let index = Int64(UInt32(r'\t'))
            var rect = m_charRects[index]
            rect.size.x = Int32(tab)
            m_charRects[index] = rect
        }

        // Loop off excess top pixels
        for (index in 0..m_charRects.size) {
            var rect = m_charRects[index]
            rect.position.y += top
            rect.size.y -= top
            m_charRects[index] = rect
        }
    }

    public func get(index: UInt32): ?TextureInfo {
        let idx = Int64(index)
        if (idx < m_charRects.size) {
            return TextureInfo(m_texture, textureRect: m_charRects[idx], palette: m_palette)
        }
        return None
    }

    public func getTextureSize(index: UInt32): Vector2i {
        let idx = Int64(index)
        if (idx < m_charRects.size) {
            return m_charRects[idx].size
        }
        return Vector2i()
    }

    public prop texture: ?Texture {
        get() {
            m_texture
        }
    }

    public prop palette: ?Palette {
        get() {
            m_palette
        }
    }

    public prop size: UInt32 {
        get() {
            UInt32(m_charRects.size)
        }
    }
}
