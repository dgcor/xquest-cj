package cjsfml.window

import cenum.CFlagEnum

/**
 * Enumeration of the context attribute flags
 */
@CFlagEnum[public ContextAttribute](
    Default = 0, // Non-debug, compatibility context (this and the core attribute are mutually exclusive)
    Core    = 1 << 0, // Core attribute
    Debug   = 1 << 2 // Debug attribute
)
