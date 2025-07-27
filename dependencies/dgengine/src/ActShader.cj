package dgengine

import cjsfml.graphics.*

public class ActShaderSetGameShader <: Action {
    public ActShaderSetGameShader(
        private let id: String,
        private let gameShaderId: String
    ) {}

    public operator func ()(game: Game): Bool {
        let shader = game.resources.shaders.get(id)
        game.shaders.set(gameShaderId, shader)
        return true
    }
}

public class ActShaderSetBool <: Action {
    public ActShaderSetBool(
        private let id: String,
        private let key: String,
        private let value: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(gameShader) <- game.resources.shaders.get(id)) {
            gameShader.shader.setUniform(key, value)
        }
        return true
    }
}

public class ActShaderSetColor <: Action {
    public ActShaderSetColor(
        private let id: String,
        private let key: String,
        private let value: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(gameShader) <- game.resources.shaders.get(id)) {
            gameShader.shader.setUniform(key, value)
        }
        return true
    }
}

public class ActShaderSetFloat <: Action {
    public ActShaderSetFloat(
        private let id: String,
        private let key: String,
        private let value: Float32
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(gameShader) <- game.resources.shaders.get(id)) {
            gameShader.shader.setUniform(key, value)
        }
        return true
    }
}

public class ActShaderSetVec2 <: Action {
    public ActShaderSetVec2(
        private let id: String,
        private let key: String,
        private let value: GlslVec2
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(gameShader) <- game.resources.shaders.get(id)) {
            gameShader.shader.setUniform(key, value)
        }
        return true
    }
}

public class ActShaderSetVec3 <: Action {
    public ActShaderSetVec3(
        private let id: String,
        private let key: String,
        private let value: GlslVec3
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(gameShader) <- game.resources.shaders.get(id)) {
            gameShader.shader.setUniform(key, value)
        }
        return true
    }
}

public class ActShaderSetVec4 <: Action {
    public ActShaderSetVec4(
        private let id: String,
        private let key: String,
        private let value: GlslVec4
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(gameShader) <- game.resources.shaders.get(id)) {
            gameShader.shader.setUniform(key, value)
        }
        return true
    }
}
