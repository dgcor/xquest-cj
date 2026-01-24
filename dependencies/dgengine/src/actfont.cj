package dgengine

import cjsfml.graphics.*

public class ActFontSetPaletteOrColor <: Action {
    public ActFontSetPaletteOrColor(
        private let id: String,
        private let idPalette: String,
        private let color: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(font) <- game.resources.getFont(id)) {
            match (font) {
                case FontBitmap(font) =>
                    if (font.palette.isSome()) {
                        if (let Some(palette) <- game.resources.getPalette(idPalette)) {
                            font.palette = palette
                        }
                    } else {
                        font.color = color
                    }
                case FontFreeType(font) => font.color = color
            }
        }
        return true
    }
}

public class ActFontSetSmooth <: Action {
    public ActFontSetSmooth(
        private let id: String,
        private let smooth: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(font) <- game.resources.getFont(id)) {
            if (let FontFreeType(font) <- font) {
                font.font.smooth = smooth
            }
        }
        return true
    }
}
