package dgengine

import cjsfml.audio.*
import stdx.encoding.json.*

public func parseAudioTimeSpan(elem: JsonValue): TimeSpan {
    TimeSpan(
        offset: getTimeUKey(elem, "offset"),
        length: getTimeUKey(elem, "length")
    )
}
