package xquest

import dgengine.*

class ActLevelAddHighScore <: Action {
    private let id: String
    private var levelScore: LevelScore

    init(id: String, name: String, level: Int64, score: Int64) {
        this.id = id
        levelScore = LevelScore()
        levelScore.name = name
        levelScore.level = level
        levelScore.score = score
    }

    public operator func ()(game: Game): Bool {
        if (let Some(level) <- game.resources.getLevel<Level>(id)) {
            level.highScores.add(levelScore)
        }
        return true
    }
}

class ActLevelLoadGame <: Action {
    ActLevelLoadGame(
        private let id: String,
        private let file: String
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(level) <- game.resources.getLevel<Level>(id)) {
            level.loadGame(game, GameUtils.replaceStringWithVarOrProp(file, game))
        }
        return true
    }
}

class ActLevelNewGame <: Action {
    ActLevelNewGame(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(level) <- game.resources.getLevel<Level>(id)) {
            level.newGame(game)
        }
        return true
    }
}

class ActLevelPause <: Action {
    ActLevelPause(
        private let id: String,
        private let pause: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(level) <- game.resources.getLevel<Level>(id)) {
            level.pause = pause
        }
        return true
    }
}

class ActLevelSaveGame <: Action {
    ActLevelSaveGame(
        private let id: String,
        private let file: String
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(level) <- game.resources.getLevel<Level>(id)) {
            level.saveGame(GameUtils.replaceStringWithVarOrProp(file, game))
        }
        return true
    }
}

class ActLevelSetShader <: Action {
    ActLevelSetShader(
        private let id: String,
        private let idShader: String
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(level) <- game.resources.getLevel<Level>(id)) {
            let shader = game.resources.shaders.get(idShader)
            level.gameShader = shader
        }
        return true
    }
}
