package cjsfml.window

import cjsfml.system.*

public interface SFMLWindow <: ResourceHandle {
    mut prop size: Vector2u

    func setVerticalSyncEnabled(enabled: Bool): Unit

    prop isOpen: Bool

    func pollEvent(): ?Event

    func closeWindow(): Unit

    func display(): Unit
}
