package dgengine

import cjsfml.graphics.*
import std.math.*

public abstract class ActMenuAppendOrSetText <: ActTextAppendOrSetText {
    protected let index: Int64

    public init(id: String, index: Int64, text: String, textOp: TextOp) {
        super(id, text, textOp)
        this.index = index
    }

    public init(id: String, index: Int64, text: String, query: String) {
        super(id, text, query)
        this.index = index
    }

    public init(id: String, index: Int64, format: String, bindings: Array<String>) {
        super(id, format, bindings)
        this.index = index
    }
}

public class ActMenuAppendText <: ActMenuAppendOrSetText {
    public init(id: String, index: Int64, text: String, textOp: TextOp) {
        super(id, index, text, textOp)
    }

    public init(id: String, index: Int64, text: String, query: String) {
        super(id, index, text, query)
    }

    public init(id: String, index: Int64, format: String, bindings: Array<String>) {
        super(id, index, format, bindings)
    }

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            if (let Some(button) <- menu.getItem(index)) {
                let str = Box(button.text)
                TextUtils.appendText(game, textOp, str, textFormat, bindings.iterator())
                button.text = str.value
            }
        }
        return true
    }
}

public class ActMenuClick <: Action {
    public ActMenuClick(
        private let id: String,
        private let index: Int64,
        private let playSound: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            if (let Some(button) <- menu.getItem(index)) {
                button.click(game, playSound: playSound)
            }
        }
        return true
    }
}

public class ActMenuClickVisible <: Action {
    public ActMenuClickVisible(
        private let id: String,
        private let index: Int64,
        private let playSound: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            if (let Some(button) <- menu.getVisibleItem(index)) {
                button.click(game, playSound: playSound)
            }
        }
        return true
    }
}

public class ActMenuMoveScrollbar <: Action {
    public ActMenuMoveScrollbar(
        private let idMenu: String,
        private let idScrollbar: String,
        private let idAnchorTo: String,
        private let range: UInt32,
        private let focus: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(idMenu)) {
            if (let Some(scrollBar) <- game.resources.getDrawable<Menu>(idScrollbar)) {
                if (let Some(anchorTo) <- game.resources.getDrawable<Menu>(idAnchorTo)) {
                    if (let Some(focused) <- game.resources.getFocused<Button>()) {
                        var pos = anchorTo.drawPosition
                        let newRange = min(range - UInt32(scrollBar.size.y), range)
                        let itemCount = menu.itemCount
                        if (focus == true && menu.isFocusEnabled == true) {
                            let offset = scrollBar.drawPosition.y - pos.y
                            let menuIdx = Int64(round((offset * Float32(itemCount - 1)) / Float32(newRange)))
                            if (let Some(btn) <- menu.getItem(menuIdx)) {
                                if (isObjEq(btn, focused) == false) {
                                    game.resources.setFocused(btn)
                                    btn.focus(game)
                                }
                            }
                        }
                        if (itemCount > 1) {
                            let currIdx = menu.getItemPosition(focused)
                            pos.y += round(Float32(newRange) * Float32(currIdx / (itemCount - 1)))
                        }
                        scrollBar.position = pos
                    }
                }
            }
        }
        return true
    }
}

public class ActMenuRightClick <: Action {
    public ActMenuRightClick(
        private let id: String,
        private let index: Int64,
        private let playSound: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            if (let Some(button) <- menu.getItem(index)) {
                button.rightClick(game, playSound: playSound)
            }
        }
        return true
    }
}

public class ActMenuRightClickVisible <: Action {
    public ActMenuRightClickVisible(
        private let id: String,
        private let index: Int64,
        private let playSound: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            if (let Some(button) <- menu.getVisibleItem(index)) {
                button.rightClick(game, playSound: playSound)
            }
        }
        return true
    }
}

public class ActMenuSetColor <: Action {
    public ActMenuSetColor(
        private let id: String,
        private let index: Int64,
        private let color: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            menu.setColor(color, index)
        }
        return true
    }
}

public class ActMenuSetFont <: Action {
    public ActMenuSetFont(
        private let id: String,
        private let index: Int64,
        private let idFont: String
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            if (let Some(font) <- game.resources.getFont(idFont)) {
                menu.setFont(font, index)
            }
        }
        return true
    }
}

public class ActMenuSetIndex <: Action {
    public ActMenuSetIndex(
        private let id: String,
        private let indexVar: Variable,
        private let focus: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            let index = game.getVarOrPropInt64V(indexVar)
            menu.setCurrentIdx(index)
            if (focus == true && menu.isFocusEnabled == true) {
                if (let Some(btn) <- menu.getItem()) {
                    if (let Some(focused) <- game.resources.getFocused<Button>()) {
                        if (isObjEq(btn, focused) == false) {
                            game.resources.setFocused(btn)
                            btn.focus(game)
                        }
                    }
                }
            }
        }
        return true
    }
}

public class ActMenuSetText <: ActMenuAppendOrSetText {
    public init(id: String, index: Int64, text: String, textOp: TextOp) {
        super(id, index, text, textOp)
    }

    public init(id: String, index: Int64, text: String, query: String) {
        super(id, index, text, query)
    }

    public init(id: String, index: Int64, format: String, bindings: Array<String>) {
        super(id, index, format, bindings)
    }

    public operator func ()(game: Game): Bool {
        if (let Some(menu) <- game.resources.getDrawable<Menu>(id)) {
            if (let Some(button) <- menu.getItem(index)) {
                button.text = TextUtils.getText(game, textOp, textFormat, bindings.iterator())
            }
        }
        return true
    }
}
