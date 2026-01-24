package dgengine

import cjsfml.window.*
import cjsfml.window.Event as SFMLEvent
import stdx.encoding.json.*
import std.collection.*

public func updateKeyEvent(evt: KeyEvent): KeyEvent {
    match (evt.code) {
        case _ where evt.code == KeyCode.LControl || evt.code == KeyCode.RControl =>
            var evt2 = evt
            evt2.control = true
            return evt2
        case _ where evt.code == KeyCode.LShift || evt.code == KeyCode.RShift =>
            var evt2 = evt
            evt2.shift = true
            return evt2
        case _ where evt.code == KeyCode.LAlt || evt.code == KeyCode.RAlt =>
            var evt2 = evt
            evt2.alt = true
            return evt2
        case _ where evt.code == KeyCode.LSystem || evt.code == KeyCode.RSystem =>
            var evt2 = evt
            evt2.system = true
            return evt2
        case _ => return evt
    }
}

public func parseInputEvents(elem: JsonValue): ArrayList<SFMLEvent> {
    let inputEvents = ArrayList<SFMLEvent>()

    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("key") == false && elem.containsKey("scancode") == false) {
            return inputEvents
        }

        var evt = KeyEvent(
            alt: getBoolKey(elem, "alt"),
            control: getBoolKey(elem, "control"),
            shift: getBoolKey(elem, "shift"),
            system: getBoolKey(elem, "system")
        )
        let isKeyReleasedEvt = getBoolKey(elem, "keyUp")

        if (elem.containsKey("key") == true) {
            let keyElem = elem["key"]
            if (let Some(keyElem) <- getValidArray(keyElem)) {
                for (arrVal in keyElem.getItems()) {
                    let keyCode = getKeyCodeVal(arrVal)
                    if (keyCode != KeyCode.Unknown) {
                        evt.code = keyCode
                        if (isKeyReleasedEvt == false) {
                            inputEvents.add(EvtKeyPressed(updateKeyEvent(evt)))
                        } else {
                            inputEvents.add(EvtKeyReleased(updateKeyEvent(evt)))
                        }
                    }
                }
            } else {
                let keyCode = getKeyCodeVal(keyElem)
                if (keyCode != KeyCode.Unknown) {
                    evt.code = keyCode
                    if (isKeyReleasedEvt == false) {
                        inputEvents.add(EvtKeyPressed(updateKeyEvent(evt)))
                    } else {
                        inputEvents.add(EvtKeyReleased(updateKeyEvent(evt)))
                    }
                }
            }
        }

        if (elem.containsKey("scancode") == true) {
            evt.code = KeyCode.Unknown
            let scanCodeElem = elem["scancode"]
            if (let Some(scanCodeElem) <- getValidArray(scanCodeElem)) {
                for (arrVal in scanCodeElem.getItems()) {
                    let scanCode = getScanCodeVal(arrVal)
                    if (scanCode != Scancode.Unknown) {
                        evt.scancode = scanCode
                        if (isKeyReleasedEvt == false) {
                            inputEvents.add(EvtKeyPressed(updateKeyEvent(evt)))
                        } else {
                            inputEvents.add(EvtKeyReleased(updateKeyEvent(evt)))
                        }
                    }
                }
            } else {
                let scanCode = getScanCodeVal(scanCodeElem)
                if (scanCode != Scancode.Unknown) {
                    evt.scancode = scanCode
                    if (isKeyReleasedEvt == false) {
                        inputEvents.add(EvtKeyPressed(updateKeyEvent(evt)))
                    } else {
                        inputEvents.add(EvtKeyReleased(updateKeyEvent(evt)))
                    }
                }
            }
        }
    }
    return inputEvents
}

private func getInputEvents(game: Game, elem: JsonValue): ArrayList<SFMLEvent> {
    var inputEvents = ArrayList<SFMLEvent>()

    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("gameInputEvent") == true) {
            let gameInputElem = elem["gameInputEvent"]
            if (let Some(str) <- getValidString(gameInputElem)) {
                inputEvents = game.gameInputEvents.get(str)
            }
            if (let Some(array) <- getValidArray(gameInputElem)) {
                for (elem in array.getItems()) {
                    let vec = game.gameInputEvents.get(getStringChar(elem))
                    inputEvents.add(all: vec)
                }
            }
        }
    } else {
        inputEvents = parseInputEvents(elem)
    }
    return inputEvents
}

public func parseActionKey(game: Game, elem: JsonValue): Unit {
    let inputEvents = getInputEvents(game, elem)
    if (inputEvents.isEmpty() == false) {
        let action = getActionKey(game, elem, "action")
        for (evt in inputEvents) {
            game.resources.setInputAction(evt, action)
        }
    }
}

public func parseEventKey(game: Game, elem: JsonValue): Unit {
    let inputEvents = getInputEvents(game, elem)
    if (inputEvents.isEmpty() == false) {
        if (let Some(evtName) <- getValidString(elem, "event")) {
            for (evt in inputEvents) {
                match (evt) {
                    case EvtKeyPressed(evt) =>
                        if (evt.code != KeyCode.Unknown) {
                            game.resources.setInputEvent(InputKeyboard(evt.code.value), evtName)
                        } else {
                            game.resources.setInputEvent(InputScancode(evt.scancode.value), evtName)
                        }
                    case EvtKeyReleased(evt) =>
                        if (evt.code != KeyCode.Unknown) {
                            game.resources.setInputEvent(InputKeyboard(evt.code.value), evtName)
                        } else {
                            game.resources.setInputEvent(InputScancode(evt.scancode.value), evtName)
                        }
                    case _ => ()
                }
            }
        }
    }
}

public func parseInputEvent(game: Game, elem: JsonValue): Unit {
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("action") == true) {
            parseActionKey(game, elem)
        } else if (elem.containsKey("event") == true) {
            parseEventKey(game, elem)
        }
    }
}
