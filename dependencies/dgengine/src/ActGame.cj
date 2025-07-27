package dgengine

import cjsfml.system.*
import std.math.*
import std.runtime.*

public class ActGameAddToProperty <: Action {
    public ActGameAddToProperty(
        private let propName: String,
        private let value: Variable
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(propVal) <- game.getGameProperty(propName)) {
            match (propVal) {
                case VaInteger(val) => match (value) {
                    case VaInteger(val2) =>
                        let value = VaInteger(val + val2)
                        game.setGameProperty(propName, value)
                    case VaDouble(val2) =>
                        let value = VaInteger(Int64(round(Float64(val) + val2)))
                        game.setGameProperty(propName, value)
                    case _ => ()
                }
                case VaDouble(val) => match (value) {
                    case VaInteger(val2) =>
                        let value = VaDouble(val + Float64(val2))
                        game.setGameProperty(propName, value)
                    case VaDouble(val2) =>
                        let value = VaDouble(val + val2)
                        game.setGameProperty(propName, value)
                    case _ => ()
                }
                case _ => ()
            }
        }
        return true
    }
}

public class ActGameClearPlayingSounds <: Action {
    public operator func ()(game: Game): Bool {
        game.resources.clearPlayingSounds()
        return true
    }
}

public class ActGameClose <: Action {
    public operator func ()(game: Game): Bool {
        game.closeGame()
        return true
    }
}

public class ActGameDraw <: Action {
    public operator func ()(game: Game): Bool {
        game.draw()
        return true
    }
}

public class ActGameEnableInput <: Action {
    public ActGameEnableInput(private let enable: Bool) {}

    public operator func ()(game: Game): Bool {
        game.enableInput = enable
        return true
    }
}

public class ActGameGC <: Action {
    public operator func ()(_: Game): Bool {
        gc()
        return true
    }
}

public class ActGameLoad <: Action {
    public ActGameLoad(
        private let file: String,
        private let mainFile: String
    ) {}

    public operator func ()(game: Game): Bool {
        game.load(game.path + file, mainFile)
        return true
    }
}

public class ActGameSetGamma <: Action {
    public ActGameSetGamma(private let gamma: Variable) {}

    public operator func ()(game: Game): Bool {
        let val = UInt32(game.getVarOrProp(gamma, default: 0))
        game.gamma = val
        return true
    }
}

public class ActGameSetMusicVolume <: Action {
    public ActGameSetMusicVolume(private let volume: Variable) {}

    public operator func ()(game: Game): Bool {
        let val = UInt32(game.getVarOrProp(volume, default: 100))
        game.musicVolume = val
        return true
    }
}

public class ActGameSetProperty <: Action {
    public ActGameSetProperty(
        private let propName: String,
        private let value: Variable,
        private var propRange!: ?Vector2i = None,
        private var valueRange!: ?Vector2i = None
    ) {}

    public func setPropRange(propRange: Vector2i): Unit {
        this.propRange = propRange
    }

    public func setValueRange(valueRange: Vector2i): Unit {
        this.valueRange = valueRange
    }

    public operator func ()(game: Game): Bool {
        var value2 = game.getVarOrProp(value)
        if (let VaInteger(val) <- value2) {
            if (let Some(propRange) <- propRange) {
                if (let Some(valueRange) <- valueRange) {
                    let val = normalizeNumber(val, valueRange, propRange)
                    value2 = VaInteger(val)
                }
            }
        }
        game.setGameProperty(propName, value2)
        return true
    }
}

public class ActGameSetSoundVolume <: Action {
    public ActGameSetSoundVolume(private let volume: Variable) {}

    public operator func ()(game: Game): Bool {
        let val = UInt32(game.getVarOrProp(volume, default: 100))
        game.soundVolume = val
        return true
    }
}
