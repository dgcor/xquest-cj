package dgengine

import cjsfml.system.*
import std.collection.*

public class GroupTexturePack <: TexturePackWrapper {
    private let m_groups = ArrayList<AnimationGroup>()

    public init(texturePack: TexturePack) {
        super(texturePack)
    }

    public func addGroup(group: AnimationGroup): Unit {
        m_groups.add(group)
    }

    public prop groupCount: UInt32 {
        get() {
            match (m_groups.size) {
                case 0 => m_texturePack.groupCount
                case value => UInt32(value)
            }
        }
    }

    public func getDirectionCount(groupIdx: UInt32): UInt32 {
        let index = Int64(groupIdx)
        if (index < m_groups.size) {
            return m_groups[index].directions
        }
        return m_texturePack.getDirectionCount(groupIdx)
    }

    public func getDirectionAnim(frameIdx: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        if (m_groups.isEmpty() == false) {
            for ((groupIdx, group) in m_groups |> enumerate) {
                let (direction, flags) = group.getDirectionAnim(frameIdx)
                if (flags.isSet(AnimationFlags.Valid)) {
                    return (UInt32(groupIdx), direction, flags)
                }
            }
            return (0, 0, AnimationFlags.Overflow)
        }
        return m_texturePack.getDirectionAnim(frameIdx)
    }

    public func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        let index = Int64(groupIdx)
        if (index >= 0 && index < m_groups.size) {
            return m_groups[index].getAnimation(0, directionIdx)
        }
        return m_texturePack.getAnimation(groupIdx, directionIdx)
    }
}
