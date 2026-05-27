package cjsfml.window

import cenum.CFlagEnum

/**
 * Enumeration of the window styles
 */
@CFlagEnum[public WindowStyle](
    None       = 0 // No border / title bar (this flag and all others are mutually exclusive)
    Titlebar   = 1 << 0 // Title bar + fixed border
    Resize     = 1 << 1 // Title bar + resizable border + maximize button
    Close      = 1 << 2 // Title bar + close button
    Default    = Titlebar.value | Resize.value | Close.value // Default window style
)
