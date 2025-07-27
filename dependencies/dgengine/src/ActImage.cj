package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class ActImageEnableOutline <: Action {
    public ActImageEnableOutline(
        private let id: String,
        private let enable: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
            image.outlineEnabled = enable
        }
        return true
    }
}

public class ActImageInverseResizeXY <: Action {
    public ActImageInverseResizeXY(
        private let id: String,
        private let size: Variable,
        private let inputRangeMin: Variable,
        private let inputRangeMax: Variable,
        private let sizeRange: Vector2i,
        private let applyToY: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (sizeRange.y > sizeRange.x) {
            if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
                let inputRange = Vector2i(
                    Int32(game.getVarOrPropInt64V(inputRangeMin)),
                    Int32(game.getVarOrPropInt64V(inputRangeMax))
                )

                if (inputRange.y > inputRange.x) {
                    let newSize64 = game.getVarOrPropInt64V(size)
                    let newSize = Int32(normalizeNumber(newSize64, inputRange, sizeRange))

                    var rect = image.textureRect
                    var diff = 0i32
                    if (applyToY == false) {
                        diff = rect.left - newSize
                        rect.left = newSize
                        rect.width += diff
                    } else {
                        diff = rect.top - newSize
                        rect.top = newSize
                        rect.height += diff
                    }
                    image.textureRect = rect

                    var pos = image.position
                    if (applyToY == false) {
                        pos.x -= Float32(diff)
                    } else {
                        pos.y -= Float32(diff)
                    }
                    image.position = pos
                }
            }
        }
        return true
    }
}

public class ActImageSetOutline <: Action {
    public ActImageSetOutline(
        private let id: String,
        private let outline: Color,
        private let ignore: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
            image.setOutline(outline, ignore)
        }
        return true
    }
}

public class ActImageSetPalette <: Action {
    public ActImageSetPalette(
        private let id: String,
        private let idPalette: String,
        private let color: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
            if (image.palette.isSome()) {
                if (let Some(palette) <- game.resources.getPalette(idPalette)) {
                    image.palette = palette
                }
            } else {
                image.color = color
            }
        }
        return true
    }
}

public class ActImageSetTexture <: Action {
    public ActImageSetTexture(
        private let id: String,
        private let idTexture: String,
        private let resetRect: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
            if (let Some(tex) <- game.resources.getTexture(idTexture)) {
                image.setTexture(tex, resetRect: resetRect)
                image.palette = None
            }
        }
        return true
    }
}

public class ActImageSetTextureFromPack <: Action {
    public ActImageSetTextureFromPack(
        private let id: String,
        private let idTexturePack: String,
        private let textureIdx: UInt32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
            if (let Some(tex) <- game.resources.getTexturePack(idTexturePack)) {
                if (let Some(ti) <- tex.get(textureIdx)) {
                    image.setTexture(ti)
                }
            }
        }
        return true
    }
}

public class ActImageSetTextureFromQueryable <: Action {
    public ActImageSetTextureFromQueryable(
        private let id: String,
        private let query: String,
        private let textureIdx: UInt32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
            if (let Some(obj) <- game.getQueryable(query)) {
                if (let Some(obj) <- (obj.getQueryable() as TextureQueryable)) {
                    if (let Some(ti) <- obj.getTexture(textureIdx)) {
                        image.setTexture(ti)
                    }
                }
            }
        }
        return true
    }
}

public class ActImageSetTextureRect <: Action {
    public ActImageSetTextureRect(
        private let id: String,
        private let rect: IntRect
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(image) <- game.resources.getDrawable<Image>(id)) {
            image.textureRect = rect
        }
        return true
    }
}
