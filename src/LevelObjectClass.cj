package XQuest

import dgengine.*

class LevelObjectClass <: Equatable<LevelObjectClass> {
    let texturePack: TexturePack
    let texturePackDestroy: TexturePack

    var id = String.empty
    var clsType = String.empty
    var points = 0

    var createAction: ?Action = None
    var destroyAction: ?Action = None

    public init(texturePack: TexturePack, texturePackDestroy: TexturePack) {
        this.texturePack = texturePack
        this.texturePackDestroy = texturePackDestroy
    }

    // Equal

    public operator func ==(right: LevelObjectClass): Bool {
        isObjEq(this, right)
    }

    public operator func !=(right: LevelObjectClass): Bool {
        !(this == right)
    }
}
