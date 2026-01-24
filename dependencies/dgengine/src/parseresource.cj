package dgengine

import stdx.encoding.json.*

public func parseResourceFromId<T>(resources: ResourceManager, elem: JsonValue): Bool where T <: Any {
    if (let Some(fromId) <- getValidString(elem, "fromId")) {
        if (let Some(id) <- getValidString(elem, "id")) {
            if (fromId != id && isValidId(id) == true) {
                if (let Some(obj) <- resources.getResourceItem<T>(fromId)) {
                    resources.addResource(id, obj, resourceId: getStringCharKey(elem, "resource"))
                }
            }
        }
        return true
    }
    return false
}
