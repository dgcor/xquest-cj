package cjsfml.window

import cenum.*

@CFlagEnum[public WindowStyle](
    None       = 0
    Titlebar   = 1 << 0
    Resize     = 1 << 1
    Close      = 1 << 2
    Fullscreen = 1 << 3
    Default    = Titlebar.value | Resize.value | Close.value
)
