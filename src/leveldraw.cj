package xquest

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.math.*

class LevelDraw {
    static func draw(level: Level, game: Game, target: RenderTarget): Unit {
        if (level.visible == false) {
            return
        }

        let origView = target.view

        level.surface.clear(Color.TRANSPARENT)

        level.surface.draw(game, level.map.stars)

        for (border in level.map.borders) {
            level.surface.draw(game, border)
        }

        for (obj in level.map.levelObjects) {
            obj.draw(game, target)
        }

        if (let Some(ship) <- level.map.m_ship) {
            ship.draw(game, target)
        }

        var surfaceStates = RenderStates.DEFAULT
        if (let Some(gameShader) <- level.gameShader) {
            let shader = gameShader.shader
            surfaceStates.shader = shader
            for (uniform in gameShader.uniforms) {
                match (uniform) {
                    case "elapsedTime" => shader.setUniform("elapsedTime", game.totalElapsedTime.seconds)
                    case "mousePosition" =>
                        if (level.hasMouseInside == true) {
                            let surfacePos = level.surface.position
                            let surfaceSize = level.surface.size
                            shader.setUniform(
                                "mousePosition",
                                GlslVec2(
                                    (game.mousePositionf.x - surfacePos.x) / surfaceSize.x,
                                    (game.mousePositionf.y - surfacePos.y) / surfaceSize.y
                                )
                            )
                        }
                    case "textureSize" => shader.setUniform("textureSize", level.surface.size)
                    case "visibleRect" =>
                        let rect = level.surface.visibleRect
                        shader.setUniform(
                            "visibleRect",
                            GlslVec4(
                                rect.position.x,
                                rect.position.y,
                                rect.size.x,
                                rect.size.y
                            )
                        )
                    case _ => ()
                }
            }
        }
        level.surface.draw(target, states: surfaceStates)

        target.view = origView
    }

    static func updateShip(level: Level, game: Game): Unit {
        var newPos = game.mousePositionf
        // 1. Keep the ship position strictly inside the map
        newPos.x = clamp(newPos.x, 0.0, Float32(level.map.size[0]))
        newPos.y = clamp(newPos.y, 0.0, Float32(level.map.size[1]))

        if (let Some(ship) <- level.map.m_ship) {
            ship.move((newPos.x, newPos.y))

            // 2. Determine the size of the visible area (camera view)
            // Assuming visibleRect.size gives the width and height
            let viewWidth = level.surface.visibleRect.size.x
            let viewHeight = level.surface.visibleRect.size.y

            // 3. Calculate the desired center (usually the ship position)
            var targetCenter = newPos

            // 4. Clamp the camera center to prevent drawing outside the map
            // The camera center must be at least half the view size away from 0
            // and at most half the view size away from the map edge.

            let minBoundX = viewWidth / 2.0
            let maxBoundX = Float32(level.map.size[0]) - viewWidth / 2.0
            let minBoundY = viewHeight / 2.0
            let maxBoundY = Float32(level.map.size[1]) - viewHeight / 2.0

            targetCenter.x = clamp(targetCenter.x, minBoundX, maxBoundX)
            targetCenter.y = clamp(targetCenter.y, minBoundY, maxBoundY)

            // 5. Apply the calculated center
            level.surface.center = targetCenter
            level.surface.updateDrawView()
        }
    }
}
