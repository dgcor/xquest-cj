package xquest

import dgengine.*

class LevelObjectClass <: Equatable<LevelObjectClass> {
    let texturePack: TexturePack
    let texturePackDestroy: TexturePack

    var id: String = String.empty
    var clsType: String = String.empty

    var points: Int64 = 0
    var speed: Int32 = 0
    var speed2: Int32 = 0
    var curve: Int32 = 0
    var curve2: Int32 = 0
    var hits: Int32 = 1
    var firetype: Int32 = 0
    var deathsound: String = String.empty
    var fireprob: Float32 = 0.0
    var changedir: Float32 = 0.0
    var changecurve: Float32 = 0.0
    var follow: Float32 = 0.0
    var maxspeed: Bool = false
    var numframes: Int32 = 0
    var framespeed: Int32 = 0

    var fires: Bool = false
    var follows: Bool = false
    var explodes: Bool = false
    var laysmines: Bool = false
    var curves: Bool = false
    var shootback: Bool = false
    var rebounds: Bool = false
    var zoom: Bool = false
    var tribbles: Bool = false
    var repulses: Bool = false

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
