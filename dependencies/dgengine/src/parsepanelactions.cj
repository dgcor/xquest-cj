package dgengine

import stdjson2.*

public func parsePanelAddDrawable(elem: JsonValue): ?Action {
    ActPanelAddDrawable(getStringCharKey(elem, "id"), getStringCharKey(elem, "drawable"))
}
