package dgengine

import stdx.encoding.json.*

public func parseShader(game: Game, elem: JsonValue): Unit {
    let id = parseValidId(elem)
    if (id.isEmpty() == true) {
        return
    }
    if (game.resources.shaders.has(id) == false) {
        var shader: ?GameShader = None
        if (let Some(fragmentShaderPath) <- getValidString(elem, "fragmentFile")) {
            let fragmentShaderText = FileUtils.readText(fragmentShaderPath)
            let uniforms = getValidStringVectorKey(elem, "uniforms").toArray()

            if (let Some(vertexShaderPath) <- getValidString(elem, "vertexFile")) {
                let vertexShaderText = FileUtils.readText(vertexShaderPath)
                if (let Some(geometryShaderPath) <- getValidString(elem, "geometryFile")) {
                    let geometryShaderText = FileUtils.readText(geometryShaderPath)
                    shader = GameShader.create(
                        vertexShader: vertexShaderText,
                        geometryShader: geometryShaderText,
                        fragmentShader: fragmentShaderText,
                        uniforms: uniforms
                    )
                } else {
                    shader = GameShader.create(
                        vertexShader: vertexShaderText,
                        fragmentShader: fragmentShaderText,
                        uniforms: uniforms
                    )
                }
            } else {
                shader = GameShader.create(
                    fragmentShader: fragmentShaderText,
                    uniforms: uniforms
                )
            }
        }
        if (let Some(shader) <- shader) {
            game.resources.shaders.add(id, shader)
        }
    }
    if (let Some(shaderId) <- getValidString(elem, "setShader")) {
        let shader = game.resources.shaders.get(id)
        game.shaders.set(shaderId, shader)
    }
}
