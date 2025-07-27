package dgengine

import stdx.log.*
import stdx.logger.*
import std.env.*

public var logger: Logger = SimpleLogger(getStdOut())
