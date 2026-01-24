package dgengine

import cjsfml.system.*
import std.math.*

public class ActDrawableAddToPosition <: Action {
    public ActDrawableAddToPosition(
        private let id: String,
        private let offset: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            item.position = item.position + offset
        }
        return true
    }
}

public class ActDrawableAddToSize <: Action {
    public ActDrawableAddToSize(
        private let id: String,
        private let offset: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            item.size = item.size + offset
        }
        return true
    }
}

public class ActDrawableAnchor <: Action {
    public ActDrawableAnchor(
        private let id: String,
        private let idAnchor: String,
        private let anchor: Anchor,
        private let offset: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(itemAnchor) <- game.resources.getDrawable(idAnchor)) {
            if (let Some(itemToChange) <- game.resources.getDrawable(id)) {
                let pos = anchor.getPosition(
                    itemToChange.size,
                    itemAnchor.drawPosition + offset,
                    itemAnchor.size
                )
                itemToChange.position = pos
            }
        }
        return true
    }
}

public class ActDrawableAnchorSizeXY <: Action {
    public ActDrawableAnchorSizeXY(
        private let id: String,
        private let idAnchorTo: String,
        private let offset: Float32,
        private let applyToY: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemAnchorTo) <- game.resources.getDrawable(idAnchorTo)) {
                let posA = itemAnchorTo.position
                let posB = item.position
                var newSize = 0.0f32
                if (applyToY == false) {
                    newSize = (posA.x - posB.x) + offset
                } else {
                    newSize = (posA.y - posB.y) + offset
                }
                if (newSize < 0.0) {
                    newSize = 0.0
                }
                var size = item.size
                if (applyToY == false) {
                    size.x = newSize
                } else {
                    size.y = newSize
                }
                item.size = size
            }
        }
        return true
    }
}

public class ActDrawableAnchorToFocused <: Action {
    public ActDrawableAnchorToFocused(
        private let id: String,
        private let anchor: Anchor,
        private let offset: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(itemAnchor) <- game.resources.getFocused()) {
            if (let Some(itemToChange) <- game.resources.getDrawable(id)) {
                let pos = anchor.getPosition(
                    itemToChange.size,
                    itemAnchor.drawPosition + offset,
                    itemAnchor.size
                )
                itemToChange.position = pos
            }
        }
        return true
    }
}

public class ActDrawableBringToFront <: Action {
    public ActDrawableBringToFront(private let id: String) {}

    public operator func ()(game: Game): Bool {
        game.resources.bringDrawableToFront(id)
        return true
    }
}

public class ActDrawableCenter <: Action {
    public ActDrawableCenter(
        private let id: String,
        private let idCenterOn: String,
        private let offset: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemCenter) <- game.resources.getDrawable(idCenterOn)) {
                let centerPos = itemCenter.position
                let centerSize = itemCenter.size
                let itemSize = item.size
                let newPos = Vector2f(
                    round(centerPos.x + (centerSize.x / 2.0) - (itemSize.x / 2.0)),
                    round(centerPos.y + (centerSize.y / 2.0) - (itemSize.y / 2.0))
                )
                item.position = newPos + offset
            }
        }
        return true
    }
}

public class ActDrawableCenterOnMouseX <: Action {
    public ActDrawableCenterOnMouseX(
        private let id: String,
        private let idAnchorTo: String,
        private let range: UInt32,
        private let steps: Variable
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemAnchor) <- game.resources.getDrawable(idAnchorTo)) {
                var itemPos = itemAnchor.position
                let itemSize = item.size.x
                let newRange = min(range - UInt32(itemSize), range)
                var offset = clamp(game.mousePositionf.x - itemPos.x, 0.0, Float32(range))
                let numSteps = game.getVarOrProp(steps, default: -1)
                var newPos = itemPos.x
                offset = clamp(offset - round(itemSize / 2.0), 0.0, Float32(newRange))
                if (numSteps > 1 && newRange > 0) {
                    let idx = round((offset * Float32(numSteps - 1)) / Float32(newRange))
                    newPos += round((idx * Float32(newRange)) / Float32(numSteps - 1))
                } else if (numSteps < 0) {
                    newPos += offset
                    if (newPos < itemPos.x) {
                        newPos = itemPos.x
                    }
                    let maxPos = (itemPos.x + Float32(newRange)) - itemSize
                    if (newPos > maxPos) {
                        newPos = maxPos
                    }
                }
                if (item.position.x != newPos) {
                    itemPos.x = newPos
                    item.position = itemPos
                }
            }
        }
        return true
    }
}

public class ActDrawableCenterOnMouseY <: Action {
    public ActDrawableCenterOnMouseY(
        private let id: String,
        private let idAnchorTo: String,
        private let range: UInt32,
        private let steps: Variable
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemAnchor) <- game.resources.getDrawable(idAnchorTo)) {
                var itemPos = itemAnchor.position
                let itemSize = item.size.y
                let newRange = min(range - UInt32(itemSize), range)
                var offset = clamp(game.mousePositionf.y - itemPos.y, 0.0, Float32(range))
                let numSteps = game.getVarOrProp(steps, default: -1)
                var newPos = itemPos.y
                offset = clamp(offset - round(itemSize / 2.0), 0.0, Float32(newRange))
                if (numSteps > 1 && newRange > 0) {
                    let idx = round((offset * Float32(numSteps - 1)) / Float32(newRange))
                    newPos += round((idx * Float32(newRange)) / Float32(numSteps - 1))
                } else if (numSteps < 0) {
                    newPos += offset
                    if (newPos < itemPos.y) {
                        newPos = itemPos.y
                    }
                    let maxPos = (itemPos.y + Float32(newRange)) - itemSize
                    if (newPos > maxPos) {
                        newPos = maxPos
                    }
                }
                if (item.position.y != newPos) {
                    itemPos.y = newPos
                    item.position = itemPos
                }
            }
        }
        return true
    }
}

public class ActDrawableDelete <: Action {
    public ActDrawableDelete(private let id: String) {}

    public operator func ()(game: Game): Bool {
        game.resources.deleteDrawable(id)
        return true
    }
}

public class ActDrawableExecuteAction <: Action {
    public ActDrawableExecuteAction(
        private let id: String,
        private let actionName: String
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(item) <- (item as ActionQueryable)) {
                if (let Some(action) <- item.getAction(id)) {
                    return action(game)
                }
            }
        }
        return true
    }
}

public class ActDrawableHorizontalAnchorToFocused <: Action {
    public ActDrawableHorizontalAnchorToFocused(
        private let id: String,
        private let offset: Float32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(itemAnchor) <- game.resources.getFocused()) {
            if (let Some(itemToChange) <- game.resources.getDrawable(id)) {
                var pos = itemToChange.position
                pos.x = itemAnchor.drawPosition.x + offset
                itemToChange.position = pos
            }
        }
        return true
    }
}

public class ActDrawableMoveX <: Action {
    public ActDrawableMoveX(
        private let id: String,
        private let idAnchorTo: String,
        private let range: UInt32,
        private let position: Variable,
        private let minVal: UInt32,
        private let maxVal: UInt32,
        private let steps: Variable
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemAnchor) <- game.resources.getDrawable(idAnchorTo)) {
                var itemPos = itemAnchor.drawPosition
                let itemAnchorPos = itemPos
                let newRange = Float32(max(0, Int32(range) - Int32(item.size.x)))
                var offset = Float32(clamp(UInt32(game.getVarOrProp(position, default: 0)), minVal, maxVal) - minVal)
                let newMax = maxVal - minVal
                offset = round((offset * newRange) / Float32(newMax))
                let numSteps = game.getVarOrProp(steps, default: -1)
                if (numSteps > 1) {
                    let tmp = round((offset * Float32(numSteps - 1)) / newRange)
                    offset = round((tmp * newRange) / Float32(numSteps - 1))
                }
                itemPos.x += offset
                if (itemPos.x < itemAnchorPos.x) {
                    itemPos.x = itemAnchorPos.x
                }
                let maxPos = itemAnchorPos.x + newRange
                if (itemPos.x > maxPos) {
                    itemPos.x = maxPos
                }
                item.position = itemPos
            }
        }
        return true
    }
}

public class ActDrawableMoveY <: Action {
    public ActDrawableMoveY(
        private let id: String,
        private let idAnchorTo: String,
        private let range: UInt32,
        private let position: Variable,
        private let minVal: UInt32,
        private let maxVal: UInt32,
        private let steps: Variable
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemAnchor) <- game.resources.getDrawable(idAnchorTo)) {
                var itemPos = itemAnchor.drawPosition
                let itemAnchorPos = itemPos
                let newRange = Float32(max(0, Int32(range) - Int32(item.size.y)))
                var offset = Float32(clamp(UInt32(game.getVarOrProp(position, default: 0)), minVal, maxVal) - minVal)
                let newMax = maxVal - minVal
                offset = round((offset * newRange) / Float32(newMax))
                let numSteps = game.getVarOrProp(steps, default: -1)
                if (numSteps > 1) {
                    let tmp = round((offset * Float32(numSteps - 1)) / newRange)
                    offset = round((tmp * newRange) / Float32(numSteps - 1))
                }
                itemPos.y += offset
                if (itemPos.y < itemAnchorPos.y) {
                    itemPos.y = itemAnchorPos.y
                }
                let maxPos = itemAnchorPos.y + newRange
                if (itemPos.y > maxPos) {
                    itemPos.y = maxPos
                }
                item.position = itemPos
            }
        }
        return true
    }
}

public class ActDrawableMoveStepX <: Action {
    public ActDrawableMoveStepX(
        private let id: String,
        private let idAnchorTo: String,
        private let range: UInt32,
        private let steps: Variable,
        private let stepOffset: Int32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemAnchor) <- game.resources.getDrawable(idAnchorTo)) {
                var itemPos = itemAnchor.drawPosition // cjlint-ignore !G.VAR.02 minimize scope
                var numSteps = Float32(game.getVarOrProp(steps, default: -1))
                if (numSteps > 1.0) {
                    numSteps -= 1.0
                    let newRange = max(0.0, Float32(range) - item.size.x)
                    let currSize = item.drawPosition.x - itemPos.x
                    let currStep = round((currSize * numSteps) / newRange)
                    var newStep = currStep + Float32(stepOffset)
                    if (newStep < 0.0) {
                        newStep = 0.0
                    } else if (newStep > numSteps) {
                        newStep = numSteps
                    }
                    if (newStep >= 1.0) {
                        itemPos.x += round((newStep * newRange) / numSteps)
                    }
                }
                item.position = itemPos
            }
        }
        return true
    }
}

public class ActDrawableMoveStepY <: Action {
    public ActDrawableMoveStepY(
        private let id: String,
        private let idAnchorTo: String,
        private let range: UInt32,
        private let steps: Variable,
        private let stepOffset: Int32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemAnchor) <- game.resources.getDrawable(idAnchorTo)) {
                var itemPos = itemAnchor.drawPosition // cjlint-ignore !G.VAR.02 minimize scope
                var numSteps = Float32(game.getVarOrProp(steps, default: -1))
                if (numSteps > 1.0) {
                    numSteps -= 1.0
                    let newRange = max(0.0, Float32(range) - item.size.y)
                    let currSize = item.drawPosition.y - itemPos.y
                    let currStep = round((currSize * numSteps) / newRange)
                    var newStep = currStep + Float32(stepOffset)
                    if (newStep < 0.0) {
                        newStep = 0.0
                    } else if (newStep > numSteps) {
                        newStep = numSteps
                    }
                    if (newStep >= 1.0) {
                        itemPos.y += round((newStep * newRange) / numSteps)
                    }
                }
                item.position = itemPos
            }
        }
        return true
    }
}

public class ActDrawableResizeXY <: Action {
    public ActDrawableResizeXY(
        private let id: String,
        private let size: Variable,
        private let inputRangeMin: Variable,
        private let inputRangeMax: Variable,
        private let sizeRange: Vector2i,
        private let applyToY: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (sizeRange.y > sizeRange.x) {
            if (let Some(item) <- game.resources.getDrawable(id)) {
                let inputRange = Vector2i(
                    Int32(game.getVarOrPropInt64V(inputRangeMin)),
                    Int32(game.getVarOrPropInt64V(inputRangeMax))
                )

                if (inputRange.y > inputRange.x) {
                    var newSize = game.getVarOrPropInt64V(size)
                    newSize = normalizeNumber(newSize, inputRange, sizeRange)

                    var itemSize = item.size
                    if (applyToY == false) {
                        itemSize.x = Float32(newSize)
                    } else {
                        itemSize.y = Float32(newSize)
                    }
                    item.size = itemSize
                }
            }
        }
        return true
    }
}

public class ActDrawableResizeOnMouseX <: Action {
    public ActDrawableResizeOnMouseX(
        private let id: String,
        private let range: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            var newSize = game.mousePositionf.x - item.position.x
            if (newSize < range.x) {
                newSize = range.x
            }
            if (newSize > range.y) {
                newSize = range.y
            }
            var itemSize = item.size
            itemSize.x = newSize
            item.size = itemSize
        }
        return true
    }
}

public class ActDrawableResizeOnMouseY <: Action {
    public ActDrawableResizeOnMouseY(
        private let id: String,
        private let range: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            var newSize = game.mousePositionf.y - item.position.y
            if (newSize < range.x) {
                newSize = range.x
            }
            if (newSize > range.y) {
                newSize = range.y
            }
            var itemSize = item.size
            itemSize.y = newSize
            item.size = itemSize
        }
        return true
    }
}

public class ActDrawableResizeToPositionX <: Action {
    public ActDrawableResizeToPositionX(
        private let id: String,
        private let idToPosition: String,
        private let offset: Float32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemToPosition) <- game.resources.getDrawable(idToPosition)) {
                let newSize = itemToPosition.drawPosition.x - item.drawPosition.x
                var itemSize = item.size
                itemSize.x = newSize + offset
                item.size = itemSize
            }
        }
        return true
    }
}

public class ActDrawableResizeToPositionY <: Action {
    public ActDrawableResizeToPositionY(
        private let id: String,
        private let idToPosition: String,
        private let offset: Float32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(itemToPosition) <- game.resources.getDrawable(idToPosition)) {
                let newSize = itemToPosition.drawPosition.x - item.drawPosition.y
                var itemSize = item.size
                itemSize.y = newSize + offset
                item.size = itemSize
            }
        }
        return true
    }
}

public class ActDrawableSetAction <: Action {
    public ActDrawableSetAction(
        private let id: String,
        private let name: String,
        private let action: ?Action
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            if (let Some(item) <- (item as ActionQueryable)) {
                item.setAction(name, action)
            }
        }
        return true
    }
}

public class ActDrawableSendToBack <: Action {
    public ActDrawableSendToBack(private let id: String) {}

    public operator func ()(game: Game): Bool {
        game.resources.sendDrawableToBack(id)
        return true
    }
}

public class ActDrawableSetPosition <: Action {
    public ActDrawableSetPosition(
        private let id: String,
        private let pos: Vector2f,
        private let offset: Vector2f,
        private let relativeCoords: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            var newPos = Box(pos)
            if (relativeCoords == true && game.refSize != game.drawRegionSize) {
                let size = Box(item.size)
                item.anchor.getPosSize(newPos, size, game.refSize, game.drawRegionSize)
            }
            item.position = newPos.value + offset
        }
        return true
    }
}

public class ActDrawableSetPositionXY <: Action {
    public ActDrawableSetPositionXY(
        private let id: String,
        private let pos: Float32,
        private let applyToY: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            var pos_ = item.position
            if (applyToY == false) {
                pos_.x = pos
            } else {
                pos_.y = pos
            }
            item.position = pos_
        }
        return true
    }
}

public class ActDrawableSetSize <: Action {
    public ActDrawableSetSize(
        private let id: String,
        private let size: Vector2f
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            item.size = size
        }
        return true
    }
}

public class ActDrawableSetSizeXY <: Action {
    public ActDrawableSetSizeXY(
        private let id: String,
        private let size: Float32,
        private let applyToY: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            var size_ = item.size
            if (applyToY == false) {
                size_.x = size
            } else {
                size_.y = size
            }
            item.size = size_
        }
        return true
    }
}

public class ActDrawableVerticalAnchorToFocused <: Action {
    public ActDrawableVerticalAnchorToFocused(
        private let id: String,
        private let offset: Float32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(itemAnchor) <- game.resources.getFocused()) {
            if (let Some(itemToChange) <- game.resources.getDrawable(id)) {
                var pos = itemToChange.position
                pos.y = itemAnchor.drawPosition.y + offset
                itemToChange.position = pos
            }
        }
        return true
    }
}
