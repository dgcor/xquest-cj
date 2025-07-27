package XQuest

import dgengine.*

func registerHooks(): Unit {
    Hooks.getImageContainerObj = getImageContainerObj
    // Hooks.parseActionElem = parseActionElem
    Hooks.parseDocumentElem = parseDocumentElem
    Hooks.parseTextureImg = parseTextureImg

    Game.DefaultSizeX = 320
    Game.DefaultSizeY = 240

    Game.MinSizeX = 320
    Game.MinSizeY = 240

    Game.RefSizeX = 320
    Game.RefSizeY = 240
}
