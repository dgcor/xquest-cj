package dgengine

import cjsfml.audio.*
import stdjson2.*

public func parseAudioTimeSpan(elem: JsonValue): TimeSpan {
    TimeSpan(
        offset: getTimeUKey(elem, "offset"),
        length: getTimeUKey(elem, "length")
    )
}
