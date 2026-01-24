package cjsfml.window

import cenum.CEnum

foreign {
    func sfKeyboard_isKeyPressed(keycode: KeyCode): Bool

    func sfKeyboard_isScancodePressed(scancode: Scancode): Bool

    func sfKeyboard_localize(scancode: Scancode): KeyCode

    func sfKeyboard_delocalize(keyCode: KeyCode): Scancode

    func sfKeyboard_getDescription(scancode: Scancode): CString

    func sfKeyboard_setVirtualKeyboardVisible(visible: Bool): Unit
}

@CEnum[public KeyCode](
    Unknown = -1
    A = 0
    B
    C
    D
    E
    F
    G
    H
    I
    J
    K
    L
    M
    N
    O
    P
    Q
    R
    S
    T
    U
    V
    W
    X
    Y
    Z
    Num0
    Num1
    Num2
    Num3
    Num4
    Num5
    Num6
    Num7
    Num8
    Num9
    Escape
    LControl
    LShift
    LAlt
    LSystem
    RControl
    RShift
    RAlt
    RSystem
    Menu
    LBracket
    RBracket
    Semicolon
    Comma
    Period
    Apostrophe
    Slash
    Backslash
    Grave
    Equal
    Hyphen
    Space
    Enter
    Backspace
    Tab
    PageUp
    PageDown
    End
    Home
    Insert
    Delete
    Add
    Subtract
    Multiply
    Divide
    Left
    Right
    Up
    Down
    Numpad0
    Numpad1
    Numpad2
    Numpad3
    Numpad4
    Numpad5
    Numpad6
    Numpad7
    Numpad8
    Numpad9
    F1
    F2
    F3
    F4
    F5
    F6
    F7
    F8
    F9
    F10
    F11
    F12
    F13
    F14
    F15
    Pause
    Count
)

@CEnum[public Scancode](
    Unknown = -1
    A = 0
    B
    C
    D
    E
    F
    G
    H
    I
    J
    K
    L
    M
    N
    O
    P
    Q
    R
    S
    T
    U
    V
    W
    X
    Y
    Z
    Num1
    Num2
    Num3
    Num4
    Num5
    Num6
    Num7
    Num8
    Num9
    Num0
    Enter
    Escape
    Backspace
    Tab
    Space
    Hyphen
    Equal
    LBracket
    RBracket
    Backslash
    Semicolon
    Apostrophe
    Grave
    Comma
    Period
    Slash
    F1
    F2
    F3
    F4
    F5
    F6
    F7
    F8
    F9
    F10
    F11
    F12
    F13
    F14
    F15
    F16
    F17
    F18
    F19
    F20
    F21
    F22
    F23
    F24
    CapsLock
    PrintScreen
    ScrollLock
    Pause
    Insert
    Home
    PageUp
    Delete
    End
    PageDown
    Right
    Left
    Down
    Up
    NumLock
    NumpadDivide
    NumpadMultiply
    NumpadMinus
    NumpadPlus
    NumpadEqual
    NumpadEnter
    NumpadDecimal
    Numpad1
    Numpad2
    Numpad3
    Numpad4
    Numpad5
    Numpad6
    Numpad7
    Numpad8
    Numpad9
    Numpad0
    NonUsBackslash
    Application
    Execute
    ModeChange
    Help
    Menu
    Select
    Redo
    Undo
    Cut
    Copy
    Paste
    VolumeMute
    VolumeUp
    VolumeDown
    MediaPlayPause
    MediaStop
    MediaNextTrack
    MediaPreviousTrack
    LControl
    LShift
    LAlt
    LSystem
    RControl
    RShift
    RAlt
    RSystem
    Back
    Forward
    Refresh
    Stop
    Search
    Favorites
    HomePage
    LaunchApplication1
    LaunchApplication2
    LaunchMail
    LaunchMediaSelect
    Count
)

public class Keyboard {
    public static func isKeyPressed(keycode: KeyCode): Bool {
        unsafe { sfKeyboard_isKeyPressed(keycode) }
    }

    public static func isKeyPressed(scancode: Scancode): Bool { // cjlint-ignore !G.DCL.01 function name already exists
        unsafe { sfKeyboard_isScancodePressed(scancode) }
    }

    public static func localize(scancode: Scancode): KeyCode {
        unsafe { sfKeyboard_localize(scancode) }
    }

    public static func delocalize(keyCode: KeyCode): Scancode {
        unsafe { sfKeyboard_delocalize(keyCode) }
    }

    public static func getDescription(scancode: Scancode): String {
        unsafe { sfKeyboard_getDescription(scancode).toString() }
    }

    public static func setVirtualKeyboardVisible(visible: Bool): Unit {
        unsafe { sfKeyboard_setVirtualKeyboardVisible(visible) }
    }
}
