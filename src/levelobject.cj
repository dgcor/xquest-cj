package xquest

import cjsfml.system.*
import dgengine.*

class LevelObject <: Animation & TextureQueryable {
    let cls: LevelObjectClass
    var mapPosition: (Int64, Int64)
    var movement: (Float32, Float32)
    var points: Int64
    private var m_deleted = false

    init(cls: LevelObjectClass, mapPosition!: (Int64, Int64) = (0, 0), movement!: (Float32, Float32) = (-1.0, -1.0)) {
        this.cls = cls
        this.mapPosition = mapPosition
        this.movement = movement
        this.points = cls.points
        updateAnimation()
    }

    private func updateAnimation() {
        var (texturePack, animInfo) = match (m_deleted) {
            case true =>
                let texturePack = cls.texturePackDestroy
                var animInfo = texturePack.getAnimation(0, 0)
                animInfo.animType = AnimationType.PlayOnce
                (texturePack, animInfo)
            case false =>
                let texturePack = cls.texturePack
                let animInfo = texturePack.getAnimation(0, 0)
                (texturePack, animInfo)
        }
        if (animInfo.refresh == Time.ZERO) {
            animInfo.refresh = Time(milliseconds: 50)
        }
        setAnimation(texturePack, animInfo)
    }

    // prop isDeleted: Bool {
    //     get() {
    //         m_deleted
    //     }
    // }

    // func delete(): Bool {
    //     if (m_deleted == false) {
    //         m_deleted = true
    //         updateAnimation()
    //         return true
    //     }
    //     return false
    // }

    func move(pos: (Float32, Float32)) {
        movement = pos
        this.position = Vector2f(pos[0], pos[1])
    }

    public override func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "movement" => Variable.getTuple2fProp(movement, props[1])
            case "points" => VaInteger(points)
            case "type" => VaString(cls.clsType)
            case _ => super.getProperty(propName)
        }
    }

    public override func getTexture(textureNumber: UInt32): ?TextureInfo {
        cls.texturePack.get(textureNumber)
    }
}
