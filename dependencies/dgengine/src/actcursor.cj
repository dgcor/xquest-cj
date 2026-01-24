package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.math.*

public class ActCursorCenterOnDrawable <: Action {
    public ActCursorCenterOnDrawable(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(obj) <- game.resources.getDrawable(id)) {
            let centerPos = obj.position
            let centerSize = obj.size
            let newPos = Vector2i(
                Int32(round(centerPos.x + (centerSize.x / 2.0))),
                Int32(round(centerPos.y + (centerSize.y / 2.0)))
            )
            game.setMousePosition(newPos)
        }
        return true
    }
}

public class ActCursorEnableOutline <: Action {
    public ActCursorEnableOutline(private let enable: Bool) {}

    public operator func ()(game: Game): Bool {
        if (let Some(cursor) <- game.resources.getCursor()) {
            cursor.outlineEnabled = enable
        }
        return true
    }
}

public class ActCursorPop <: Action {
    public ActCursorPop(private let popAll: Bool) {}

    public operator func ()(game: Game): Bool {
        game.resources.popCursor(popAll: popAll)
        game.updateCursorPosition()
        return true
    }
}

public class ActCursorSetColor <: Action {
    public ActCursorSetColor(private let color: Color) {}

    public operator func ()(game: Game): Bool {
        if (let Some(cursor) <- game.resources.getCursor()) {
            cursor.color = color
        }
        return true
    }
}

public class ActCursorSetOutline <: Action {
    public ActCursorSetOutline(
        private let outline: Color,
        private let ignore: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(cursor) <- game.resources.getCursor()) {
            cursor.setOutline(outline, ignore)
        }
        return true
    }
}

public class ActCursorSetPalette <: Action {
    public ActCursorSetPalette(
        private let idPalette: String,
        private let color: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(cursor) <- game.resources.getCursor()) {
            if (cursor.palette.isSome()) {
                if (let Some(palette) <- game.resources.getPalette(idPalette)) {
                    cursor.palette = palette
                }
            } else {
                cursor.color = color
            }
        }
        return true
    }
}

public class ActCursorSetPosition <: Action {
    public ActCursorSetPosition(private let pos: Vector2i) {}

    public operator func ()(game: Game): Bool {
        game.setMousePosition(pos)
        return true
    }
}

public class ActCursorShow <: Action {
    public ActCursorShow(private let show: Bool) {}

    public operator func ()(game: Game): Bool {
        game.mouseCursorVisible = show
        return true
    }
}
