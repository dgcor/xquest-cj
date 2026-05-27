package xquest

import dgengine.*

func registerHooks(): Unit {
    Hooks.getImageContainerObj = getImageContainerObj
    Hooks.parseActionElem = parseActionElem
    Hooks.parseDocumentElem = parseDocumentElem
    Hooks.parseTextureImg = parseTextureImg

    Defaults.GAME_SIZE_X = 320
    Defaults.GAME_SIZE_Y = 240

    Defaults.GAME_MIN_SIZE_X = 320
    Defaults.GAME_MIN_SIZE_Y = 240

    Defaults.GAME_REF_SIZE_X = 320
    Defaults.GAME_REF_SIZE_Y = 240
}
