package dgengine

import stdx.encoding.json.*

public func parseActionElem(game: Game, elem: JsonValue): ?Action {
    match (getValidString(elem, "name")) {
        case Some(name) => match (name) {
            case "==" => parseIfCondition("==", game, elem)
            case "!=" => parseIfCondition("!=", game, elem)
            case ">" => parseIfCondition(">", game, elem)
            case ">=" => parseIfCondition(">=", game, elem)
            case "<" => parseIfCondition("<", game, elem)
            case "<=" => parseIfCondition("<=", game, elem)
            case "action.set" => parseActionSet(game, elem)
            case "animation.pause" => parseAnimationPause(elem)
            case "animation.set" => parseAnimationSetAnimation(elem)
            case "animation.setRefresh" => parseAnimationSetRefresh(elem)
            case "audio.delete" => parseAudioDelete(elem)
            case "audio.pause" => parseAudioPause(elem)
            case "audio.pauseAll" => parseAudioPauseAll()
            case "audio.play" => parseAudioPlay(elem)
            case "audio.resumeAll" => parseAudioResumeAll(elem)
            case "audio.seek" => parseAudioSeek(elem)
            case "audio.setVolume" => parseAudioSetVolume(elem)
            case "audio.stop" => parseAudioStop(elem)
            case "audio.stopAll" => parseAudioStopAll()
            case "button.click" => parseButtonClick(elem)
            case "button.enable" => parseButtonEnable(elem)
            case "button.rightClick" => parseButtonRightClick(elem)
            case "button.setColor" => parseButtonSetColor(elem)
            case "condition" => parseIfCondition(getStringCharKey(elem, "condition"), game, elem)
            case "cursor.centerOnDrawable" => parseCursorCenterOnDrawable(elem)
            case "cursor.enableOutline" => parseCursorEnableOutline(elem)
            case "cursor.pop" => parseCursorPop(elem)
            case "cursor.setColor" => parseCursorSetColor(elem)
            case "cursor.setOutline" => parseCursorSetOutline(elem)
            case "cursor.setPalette" => parseCursorSetPalette(elem)
            case "cursor.setPosition" => parseCursorSetPosition(elem)
            case "cursor.show" => parseCursorShow(elem)
            case "dir.copy" => parseDirCopy(elem)
            case "dir.create" => parseDirCreate(elem)
            case "drawable.addToPosition" | "drawable.move" => parseDrawableAddToPosition(elem)
            case "drawable.addToSize" => parseDrawableAddToSize(elem)
            case "drawable.anchor" => parseDrawableAnchor(elem)
            case "drawable.anchorSizeX" => parseDrawableAnchorSizeX(elem)
            case "drawable.anchorSizeY" => parseDrawableAnchorSizeY(elem)
            case "drawable.anchorToFocused" => parseDrawableAnchorToFocused(elem)
            case "drawable.bringToFront" => parseDrawableBringToFront(elem)
            case "drawable.center" => parseDrawableCenter(elem)
            case "drawable.centerOnMouseX" => parseDrawableCenterOnMouseX(elem)
            case "drawable.centerOnMouseY" => parseDrawableCenterOnMouseY(elem)
            case "drawable.delete" => parseDrawableDelete(elem)
            case "drawable.executeAction" => parseDrawableExecuteAction(elem)
            case "drawable.horizontalAnchorToFocused" => parseDrawableHorizontalAnchorToFocused(elem)
            case "drawable.moveX" => parseDrawableMoveX(elem)
            case "drawable.moveY" => parseDrawableMoveY(elem)
            case "drawable.moveStepX" => parseDrawableMoveStepX(elem)
            case "drawable.moveStepY" => parseDrawableMoveStepY(elem)
            case "drawable.resizeX" => parseDrawableResizeX(elem)
            case "drawable.resizeY" => parseDrawableResizeY(elem)
            case "drawable.resizeOnMouseX" => parseDrawableResizeOnMouseX(elem)
            case "drawable.resizeOnMouseY" => parseDrawableResizeOnMouseY(elem)
            case "drawable.resizeToPositionX" => parseDrawableResizeToPositionX(elem)
            case "drawable.resizeToPositionY" => parseDrawableResizeToPositionY(elem)
            case "drawable.sendToBack" => parseDrawableSendToBack(elem)
            case "drawable.setAction" => parseDrawableSetAction(game, elem)
            case "drawable.setPosition" => parseDrawableSetPosition(elem)
            case "drawable.setPositionX" => parseDrawableSetPositionX(elem)
            case "drawable.setPositionY" => parseDrawableSetPositionY(elem)
            case "drawable.setSize" => parseDrawableSetSize(elem)
            case "drawable.setSizeX" => parseDrawableSetSizeX(elem)
            case "drawable.setSizeY" => parseDrawableSetSizeY(elem)
            case "drawable.toggleVisible" => parseToggleVisible(elem)
            case "drawable.verticalAnchorToFocused" => parseDrawableVerticalAnchorToFocused(elem)
            case "drawable.visible" => parseSetVisible(elem)
            case "event.add" => parseEventAdd(game, elem)
            case "event.delete" => parseEventDelete(elem)
            case "event.deleteAll" => parseEventDeleteAll()
            case "event.resetTime" => parseEventResetTime(elem)
            case "event.timeout" => parseEventTimeout(elem)
            case "file.copy" => parseFileCopy(elem)
            case "focus.add" => parseFocusAdd(elem)
            case "focus.click" => parseFocusClick(elem)
            case "focus.moveDown" => parseFocusMoveDown()
            case "focus.moveUp" => parseFocusMoveUp()
            case "focus.rightClick" => parseFocusRightClick(elem)
            case "focus.set" => parseFocusSet(elem)
            case "focus.update" => parseFocusUpdate(elem)
            case "font.setColor" | "font.setPalette" => parseFontSetPaletteOrColor(elem)
            case "font.setSmooth" => parseFontSetSmooth(elem)
            case "game.addToProperty" => parseGameAddToProperty(elem)
            case "game.clearPlayingSounds" => parseGameClearPlayingSounds()
            case "game.close" => parseGameClose()
            case "game.draw" => parseGameDraw()
            case "game.enableInput" => parseGameEnableInput(elem)
            case "game.fadeIn" => parseGameFadeIn(game, elem)
            case "game.fadeOut" => parseGameFadeOut(game, elem)
            case "game.GC" => parseGameGC()
            case "game.load" => parseGameLoad(elem)
            case "game.setGamma" => parseGameSetGamma(elem)
            case "game.setMusicVolume" => parseGameSetMusicVolume(elem)
            case "game.setProperty" => parseGameSetProperty(elem)
            case "game.setShader" => parseShaderSetGameShader(elem)
            case "game.setSoundVolume" => parseGameSetSoundVolume(elem)
            case "if" => parseMultiIfCondition(game, elem)
            case "if.equal" => parseIfCondition("==", game, elem)
            case "if.greater" => parseIfCondition(">", game, elem)
            case "if.inList" => parseInListCondition(game, elem)
            case "if.lower" => parseIfCondition("<", game, elem)
            case "if.notEqual" => parseIfCondition("!=", game, elem)
            case "if.regex" => parseIfCondition("regex", game, elem)
            case "image.enableOutline" => parseImageEnableOutline(elem)
            case "image.inverseResizeX" => parseImageInverseResizeX(elem)
            case "image.inverseResizeY" => parseImageInverseResizeY(elem)
            case "image.setOutline" => parseImageSetOutline(elem)
            case "image.setPalette" => parseImageSetPalette(elem)
            case "image.setTexture" => parseImageSetTexture(elem)
            case "image.setTextureRect" => parseImageSetTextureRect(elem)
            case "inputText.click" => parseInputTextClick(elem)
            case "io.delete" => parseIODelete(elem)
            case "io.deleteAll" => parseIODeleteAll(elem)
            case "load" => parseLoad(elem)
            case "loadingScreen.clear" => parseLoadingScreenClear()
            case "loadingScreen.setProgress" => parseLoadingScreenSetProgress(elem)
            case "loadJson" => parseLoadJson(elem)
            case "loadRandom" => parseLoadRandom(elem)
            case "menu.appendText" => parseMenuAppendText(elem)
            case "menu.click" => parseMenuClick(elem)
            case "menu.clickVisible" => parseMenuClickVisible(elem)
            case "menu.moveScrollbar" => parseMenuMoveScrollbar(elem)
            case "menu.rightClick" => parseMenuRightClick(elem)
            case "menu.rightClickVisible" => parseMenuRightClickVisible(elem)
            case "menu.setColor" => parseMenuSetColor(elem)
            case "menu.setFont" => parseMenuSetFont(elem)
            case "menu.setIndex" => parseMenuSetIndex(elem)
            case "menu.setText" => parseMenuSetText(elem)
            case "mount" => parseMount(elem)
            case "movie.pause" => parseMoviePause(elem)
            case "movie.play" => parseMoviePlay(elem)
            case "palette.replace" => parsePaletteReplace(elem)
            case "palette.shiftLeft" => parsePaletteShiftLeft(elem)
            case "palette.shiftRight" => parsePaletteShiftRight(elem)
            case "panel.addDrawable" => parsePanelAddDrawable(elem)
            case "random" => parseRandom(game, elem)
            case "randomList" => parseRandomList(game, elem)
            case "resource.add" => parseResourceAdd(elem)
            case "resource.bringToFront" => parseResourceBringToFront(elem)
            case "resource.ignore" => parseResourceIgnore(elem)
            case "resource.pop" => parseResourcePop(elem)
            case "resource.popAll" => parseResourcePopAll(elem)
            case "scrollable.setSpeed" => parseScrollableSetSpeed(elem)
            case "shader.setBool" => parseShaderSetBool(elem)
            case "shader.setColor" => parseShaderSetColor(elem)
            case "shader.setFloat" => parseShaderSetFloat(elem)
            case "shader.setVec2" => parseShaderSetVec2(elem)
            case "shader.setVec3" => parseShaderSetVec3(elem)
            case "shader.setVec4" => parseShadersetVec4(elem)
            case "sound.loadPlay" => parseSoundLoadPlay(elem)
            case "sound.play" => parseSoundPlay(elem)
            case "switch" => parseSwitchCondition(game, elem)
            case "text.appendText" => parseTextAppendText(elem)
            case "text.setColor" => parseTextSetColor(elem)
            case "text.setFont" => parseTextSetFont(elem)
            case "text.setSpacing" => parseTextSetSpacing(elem)
            case "text.setText" => parseTextSetText(elem)
            case "unmount" => parseUnmount(elem)
            case "unmountAll" => parseUnmountAll()
            case "variable.add" => parseVariableAdd(elem)
            case "variable.clear" => parseVariableClear(elem)
            case "variable.save" => parseVariableSave(elem)
            case "variable.set" => parseVariableSet(elem)
            case "variable.setIfNull" => parseVariableSetIfNull(elem)
            case _ => match (Hooks.parseActionElem) {
                case Some(parseActionElem) => parseActionElem(game, name, elem)
                case None => None
            }
        }
        case None => None
    }
}

public func getActionVal(game: Game, elem: JsonValue): ?Action {
    if (elem.isNull()) {
        return None
    } else if (let Some(str) <- getValidString(elem)) {
        if (Rune(str[0]) != r'#') {
            return game.resources.getAction(str)
        } else {
            return game.getQueryAction(str[1..str.size])
        }
    } else if (elem.isObject()) {
        return parseActionElem(game, elem)
    } else if (let Some(elem) <- getValidArray(elem)) {
        let actionList = ActionList()
        for (elem in elem.getItems()) {
            if (let Some(action) <- getActionVal(game, elem)) {
                actionList.add(action)
            }
        }
        if (actionList.isEmpty() == false) {
            return actionList
        }
    }
    return None
}

public func getActionKey(game: Game, elem: JsonValue, key: String): ?Action {
    if (let Some(elem) <- getValidObject(elem)) {
        if (let Some(elem) <- elem.get(key)) {
            return getActionVal(game, elem)
        }
    }
    return None
}

public func parseActionAndExecute(game: Game, elem: JsonValue): Unit {
    match (elem.kind()) {
        case JsString =>
            if (let Some(action) <- game.resources.getAction(getStringChar(elem))) {
                action(game)
            }
        case JsObject =>
            if (let Some(action) <- parseActionElem(game, elem)) {
                action(game)
            }
        case JsArray => for (elem in elem.asArray().getItems()) {
            if (let Some(action) <- getActionVal(game, elem)) {
                action(game)
            }
        }
        case _ => ()
    }
}
