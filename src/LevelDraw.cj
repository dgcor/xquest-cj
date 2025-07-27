package XQuest

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.collection.*
import std.math.*

class LevelDraw {
    public static func draw(level: Level, game: Game, target: RenderTarget): Unit {
        if (level.visible == false) {
            return
        }

        let origView = target.view

        level.m_surface.clear(Color.transparent)

        // level.m_surface.draw(game, level.map.Stars());

        // for (const auto& border : level.map.Borders())
        // {
        //     level.surface.draw(game, border);
        // }

        // for (const auto& obj : level.map.LevelObjects())
        // {
        //     obj->draw(game, target);
        // }

        // level.map.Ship()->draw(game, target);

        var surfaceStates = RenderStates.default
        if (let Some(gameShader) <- level.m_gameShader) {
            let shader = gameShader.shader
            surfaceStates.shader = shader
            for (uniform in gameShader.uniforms) {
                match (uniform) {
                    case "elapsedTime" => shader.setUniform("elapsedTime", game.totalElapsedTime.seconds)
                    case "mousePosition" =>
                        if (level.m_hasMouseInside == true) {
                            let surfacePos = level.m_surface.position
                            let surfaceSize = level.m_surface.size
                            shader.setUniform(
                                "mousePosition",
                                GlslVec2(
                                    (game.mousePositionf.x - surfacePos.x) / surfaceSize.x,
                                    (game.mousePositionf.y - surfacePos.y) / surfaceSize.y
                                )
                            )
                        }
                    case "textureSize" => shader.setUniform("textureSize", level.m_surface.size)
                    case "visibleRect" =>
                        let rect = level.m_surface.visibleRect
                        shader.setUniform(
                            "visibleRect",
                            GlslVec4(
                                rect.left,
                                rect.top,
                                rect.width,
                                rect.height
                            )
                        )
                    case _ => ()
                }
            }
        }
        level.m_surface.draw(target, states: surfaceStates)

        target.view = origView
    }
}
