package dgengine

import stdx.encoding.json.*

public func parseLoadingScreenClear(): ?Action {
    ActLoadingScreenClear()
}

public func parseLoadingScreenSetProgress(elem: JsonValue): ?Action {
    ActLoadingScreenSetProgress(getIntKey(elem, "progress"))
}
