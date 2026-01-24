package dgengine

import stdx.encoding.json.*

public func parseIcon(game: Game, elem: JsonValue): Unit {
    if (let Some(file) <- getValidString(elem)) {
        if (let Some(icon) <- ImageUtils.loadImage(file)) {
            try (icon = icon) {
                let iconSize = icon.size
                if (iconSize.x == 0 || iconSize.y == 0) {
                    return
                }
                game.setIcon(iconSize, icon.pixelsPtr)
            }
        }
    }
}
