package XQuest

import stdx.encoding.json.*

extend JsonValue {
    public func isArray(): Bool {
        match (kind()) {
            case JsArray => true
            case _ => false
        }
    }

    public func isBool(): Bool {
        match (kind()) {
            case JsBool => true
            case _ => false
        }
    }

    public func isInt(): Bool {
        match (kind()) {
            case JsInt => true
            case _ => false
        }
    }

    public func isUInt(): Bool {
        match (kind()) {
            case JsInt where asInt().getValue() >= 0 => true
            case _ => false
        }
    }

    public func isFloat(): Bool {
        match (kind()) {
            case JsFloat => true
            case _ => false
        }
    }

    public func isNull(): Bool {
        match (kind()) {
            case JsNull => true
            case _ => false
        }
    }

    public func isNumber(): Bool {
        match (kind()) {
            case JsInt | JsFloat => true
            case _ => false
        }
    }

    public func isObject(): Bool {
        match (kind()) {
            case JsObject => true
            case _ => false
        }
    }

    public func isString(): Bool {
        match (kind()) {
            case JsString => true
            case _ => false
        }
    }
}
