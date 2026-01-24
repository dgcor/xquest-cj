package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public interface UIObject <: Queryable & Resource {
    // gets common getProperty properties
    func getProperty(propName: String, propParams: String): ?Variable {
        match (propName) {
            case "drawPosition" => Variable.getTuple2iProp(drawPosition, propParams)
            case "position" => Variable.getTuple2iProp(position, propParams)
            case "size" => Variable.getTuple2iProp(size, propParams)
            case "visible" => VaBoolean(visible)
            case _ => None
        }
    }

    // Anchor
    mut prop anchor: Anchor
    func updateSize(game: Game): Unit

    // Move
    prop drawPosition: Vector2f
    mut prop position: Vector2f
    mut prop size: Vector2f

    // Draw and Update
    func draw(game: Game, target: RenderTarget): Unit
    func update(_: Game): Unit {}

    // Visible
    mut prop visible: Bool
}
