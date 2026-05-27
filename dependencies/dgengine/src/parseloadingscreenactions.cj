package dgengine

import stdjson2.*

public func parseLoadingScreenClear(): ?Action {
    ActLoadingScreenClear()
}

public func parseLoadingScreenSetProgress(elem: JsonValue): ?Action {
    ActLoadingScreenSetProgress(getIntKey(elem, "progress"))
}
