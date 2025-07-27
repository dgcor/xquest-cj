package dgengine

import stdx.encoding.json.*
import std.collection.*

public func parseCompositeTexturePack(compTexture: CompositeTexturePack, game: Game, elem: JsonValue): Bool {
    if (let Some(id) <- getValidString(elem)) {
        if (let Some(texturePack) <- game.resources.getTexturePack(id)) {
            compTexture.addTexturePack(texturePack)
            return true
        }
    }
    return false
}

public func parseCompositeTexturePacks(compTexture: CompositeTexturePack, game: Game, elem: JsonObject): Unit {
    if (let Some(texturePacksElem) <- elem.get("texturePacks")) {
        if (isValidString(texturePacksElem) == true) {
            parseCompositeTexturePack(compTexture, game, texturePacksElem)
        } else if (let Some(texturePacksElem) <- getValidArray(texturePacksElem)) {
            for (val in texturePacksElem.getItems()) {
                parseCompositeTexturePack(compTexture, game, val)
            }
        }
    }
}

public func parseCompositeTexturePackDirectionLayerOrders(compTexture: CompositeTexturePack, elem: JsonObject): Unit {
    let groupIdx = compTexture.compositeTextureGroupSize

    if (compTexture.addGroup() == true) {
        if (let Some(elem) <- getValidArray(elem, "directionLayerOrders")) {
            let layerOrder = ArrayList<Int8>()
            let numLayers = compTexture.getLayerCount(groupIdx)
            var orderIdx = 0u32
            for (layerOrderElem in elem.getItems()) {
                if (let Some(layerOrderElem) <- getValidArray(layerOrderElem)) {
                    let newSize = layerOrder.size + Int64(numLayers)
                    if (layerOrder.size > newSize) {
                        layerOrder.remove(newSize..layerOrder.size)
                    } else if (layerOrder.size < newSize) {
                        for (_ in layerOrder.size..newSize) {
                            layerOrder.add(-1)
                        }
                    }
                    var subOrderIdx = Int64(orderIdx)
                    var layerIdx = 0u32
                    for (val in layerOrderElem.getItems()) {
                        if (val.isNumber() == true) {
                            let newIdx = Int8(clamp(getIntVal(val, default: -1), -1, 127))
                            if (Int64(newIdx) < Int64(numLayers)) {
                                layerOrder[subOrderIdx] = newIdx
                                subOrderIdx++
                                layerIdx++
                            }
                            if (layerIdx >= numLayers) {
                                break
                            }
                        }
                    }
                    orderIdx += numLayers
                }
            }
            compTexture.setLayersOrders(layerOrder)
        }
    }
}

public func parseCompositeTexturePackGroup(compTexture: CompositeTexturePack, game: Game, elem: JsonObject): Unit {
    parseCompositeTexturePacks(compTexture, game, elem)

    if (compTexture.texturePackCount == 0) {
        return
    }

    parseCompositeTexturePackDirectionLayerOrders(compTexture, elem)
}

public func getCompositeTexturePackObj(game: Game, elem: JsonObject): ?TexturePack {
    let compTexture = CompositeTexturePack()

    if (let Some(elem) <- getValidArray(elem, "groups")) {
        for (val in elem.getItems()) {
            if (let Some(val) <- getValidObject(val)) {
                parseCompositeTexturePackGroup(compTexture, game, val)
            }
        }
    } else if (let Some(elem) <- getValidObject(elem)) {
        parseCompositeTexturePackGroup(compTexture, game, elem)
    }
    if (compTexture.size == 0) {
        return None
    }
    return compTexture
}
