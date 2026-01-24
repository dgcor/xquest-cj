package dgengine

import cjsfml.graphics.*

public abstract class ActTextAppendOrSetText <: Action {
    protected let id: String
    protected let textFormat: String
    protected let bindings: Array<String>
    protected var textOp: TextOp

    public init(id: String, text: String, textOp: TextOp) {
        this.id = id
        this.textFormat = text
        this.bindings = Array<String>()
        this.textOp = textOp
    }

    public init(id: String, text: String, query: String) {
        this.id = id
        this.textFormat = text
        this.bindings = [query]
        this.textOp = TextOp.Query
    }

    public init(id: String, format: String, bindings: Array<String>) {
        this.id = id
        this.textFormat = format
        this.bindings = bindings
        this.textOp = TextOp.FormatString
    }

    public func removeEmptyLines(): Unit {
        textOp = textOp.set(TextOp.RemoveEmptyLines)
    }

    public func replaceAll(): Unit {
        textOp = textOp.set(TextOp.ReplaceAll)
    }

    public func trim(): Unit {
        textOp = textOp.set(TextOp.Trim)
    }
}

public class ActTextAppendText <: ActTextAppendOrSetText {
    public init(id: String, text: String, textOp: TextOp) {
        super(id, text, textOp)
    }

    public init(id: String, text: String, query: String) {
        super(id, text, query)
    }

    public init(id: String, format: String, bindings: Array<String>) {
        super(id, format, bindings)
    }

    public operator func ()(game: Game): Bool {
        if (let Some(text) <- game.resources.getDrawable<BindableText>(id)) {
            let str = Box(text.text)
            TextUtils.appendText(game, textOp, str, textFormat, bindings.iterator())
            text.text = str.value
        }
        return true
    }
}

public class ActTextSetColor <: Action {
    public ActTextSetColor(
        private let id: String,
        private let color: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(text) <- game.resources.getDrawable<Text>(id)) {
            text.color = color
        }
        return true
    }
}

public class ActTextSetFont <: Action {
    public ActTextSetFont(
        private let id: String,
        private let idFont: String
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(text) <- game.resources.getDrawable<Text>(id)) {
            if (let Some(font) <- game.resources.getFont(idFont)) {
                text.font = font
            }
        }
        return true
    }
}

public class ActTextSetSpacing <: Action {
    public ActTextSetSpacing(
        private let id: String,
        private var horizSpaceOffset!: ?Int32 = None,
        private var vertSpaceOffset!: ?Int32 = None
    ) {}

    public func setHorizontalSpaceOffset(offset: Int32): Unit {
        horizSpaceOffset = offset
    }

    public func setVerticalSpaceOffset(offset: Int32): Unit {
        vertSpaceOffset = offset
    }

    public operator func ()(game: Game): Bool {
        if (let Some(text) <- game.resources.getDrawable<Text>(id)) {
            if (let Some(horizSpaceOffset) <- horizSpaceOffset) {
                text.horizontalSpaceOffset = horizSpaceOffset
            }
            if (let Some(vertSpaceOffset) <- vertSpaceOffset) {
                text.verticalSpaceOffset = vertSpaceOffset
            }
        }
        return true
    }
}

public class ActTextSetText <: ActTextAppendOrSetText {
    public init(id: String, text: String, textOp: TextOp) {
        super(id, text, textOp)
    }

    public init(id: String, text: String, query: String) {
        super(id, text, query)
    }

    public init(id: String, format: String, bindings: Array<String>) {
        super(id, format, bindings)
    }

    public operator func ()(game: Game): Bool {
        if (let Some(text) <- game.resources.getDrawable<BindableText>(id)) {
            text.text = TextUtils.getText(game, textOp, textFormat, bindings.iterator())
        }
        return true
    }
}
