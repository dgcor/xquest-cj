package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class ActGameFade <: Action {
    public ActGameFade(
        private let color: Color,
        private let isFadeOut: Bool,
        private let enableInput: Bool,
        private let fadeOffset: UInt8,
        private let refresh: Time,
        private var action!: ?Action = None
    ) {}

    public func setAction(action: ?Action): Unit {
        this.action = action
    }

    public operator func ()(game: Game): Bool {
        game.fadeObj.reset(
            color: color,
            fadeType: FadeType.get(isFadeOut),
            enableInput: enableInput,
            fadeOffset: fadeOffset,
            timeout: refresh,
            action: action
        )
        return true
    }
}
