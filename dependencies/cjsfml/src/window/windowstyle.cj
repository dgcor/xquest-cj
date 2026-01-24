package cjsfml.window

import cenum.CFlagEnum

@CFlagEnum[public WindowStyle](
    None       = 0
    Titlebar   = 1 << 0
    Resize     = 1 << 1
    Close      = 1 << 2
    Default    = Titlebar.value | Resize.value | Close.value
)
