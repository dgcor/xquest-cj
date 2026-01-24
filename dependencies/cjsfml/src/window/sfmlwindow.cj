package cjsfml.window

import cjsfml.system.{ResourceHandle, Time, Vector2i, Vector2u}

public interface SFMLWindow <: ResourceHandle {
    func closeWindow(): Unit

    prop isOpen: Bool

    func pollEvent(): ?Event

    func waitEvent(): ?Event {
        waitEvent(Time.ZERO)
    }

    func waitEvent(timeout: Time): ?Event

    mut prop position: Vector2i

    mut prop size: Vector2u

    func setMinimumSize(size: ?Vector2u): Unit

    func setMaximumSize(size: ?Vector2u): Unit

    func setTitle(title: String): Unit

    func setIcon(size: Vector2u, pixels: Array<UInt8>): Unit

    func setIcon(size: Vector2u, pixels: CPointer<UInt8>): Unit

    func setVisible(visible: Bool): Unit

    func setMouseCursorVisible(visible: Bool): Unit

    func setMouseCursorGrabbed(grabbed: Bool): Unit

    func setMouseCursor(cursor: Cursor): Unit

    func setKeyRepeatEnabled(enabled: Bool): Unit

    func setJoystickThreshold(threshold: Float32): Unit

    func requestFocus(): Unit

    prop hasFocus: Bool

    prop nativeHandle: CPointer<Unit>

    // extra

    func setVerticalSyncEnabled(enabled: Bool): Unit

    func display(): Unit
}
