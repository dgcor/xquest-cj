package dgengine

import cjsfml.audio.*
import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import cjsfml.window.Event as SFMLEvent
import customiterators.*
import std.collection.*
import std.runtime.*

public class ResourceManager <: Iterable<ResourceBundle> & Resource {
    private var m_resources: ArrayList<ResourceBundle> = ArrayList<ResourceBundle>(1, {_ => ResourceBundle()})
    private var m_shaders: ShaderManager = ShaderManager()
    private var m_cursors: ArrayList<?Image> = ArrayList<?Image>()
    private var m_activeInputEvents: ArrayList<String> = ArrayList<String>()
    private var m_playingSounds: LinkedList<Sound> = LinkedList<Sound>()
    private var m_currentLevel: ?UIObject = None

    // Resource

    public func isClosed(): Bool {
        m_shaders.isClosed()
    }

    public func close(): Unit {
        if (m_shaders.isClosed()) {
            return
        }
        for (sound in m_playingSounds) {
            sound.close()
        }
        for (cursor in m_cursors |> reverse) {
            cursor?.close()
        }
        m_shaders.close()
        for (res in m_resources |> reverse) {
            res.close()
        }
    }

    // ResourceBundles

    public operator func [](index: Int64): ResourceBundle {
        m_resources[index]
    }

    public func iterator(): Iterator<ResourceBundle> {
        m_resources.iterator()
    }

    public func reverseIterator(): Iterator<ResourceBundle> {
        ReverseArrayListIterator(m_resources)
    }

    public prop size: Int64 {
        get() {
            m_resources.size
        }
    }

    public func addResource(id: String): Unit {
        m_resources.add(ResourceBundle(id))
    }

    public func popResource(): Unit {
        if (m_resources.size > 0) {
            m_resources.remove(at: m_resources.size - 1).closeSongs()
            gc()
        }
    }

    public func popResource(id: String): Unit {
        for ((index, res) in m_resources |> enumerate) {
            if (res.id == id) {
                m_resources.remove(at: index).closeSongs()
                gc()
                return
            }
        }
    }

    public func popAllResources(id: String): Unit {
        for ((index, res) in m_resources |> enumerate) {
            if (res.id == id && index > 0) {
                for (res in m_resources[index..]) {
                    res.closeSongs()
                }
                m_resources.remove(index..m_resources.size)
                gc()
                return
            }
        }
    }

    public func popAllResources(popBaseResources: Bool): Unit {
        for (res in m_resources[1..]) {
            res.closeSongs()
        }
        m_resources.remove(1..m_resources.size)
        if (popBaseResources) {
            m_resources[0].closeSongs()
            m_resources[0] = ResourceBundle()
            m_currentLevel = None
        }
        gc()
    }

    public func ignoreResources(id: String, ignore: IgnoreResource): Unit {
        for (res in m_resources |> reverse) {
            if (res.id == id) {
                res.ignore = ignore
                return
            }
        }
    }

    public func ignoreTopResource(ignore: IgnoreResource): Unit {
        if (m_resources.size > 0) {
            m_resources.back.ignore = ignore
        }
    }

    public func resourceExists(id: String): Bool {
        for (res in m_resources) {
            if (res.id == id) {
                return true
            }
        }
        return false
    }

    public func bringResourceToFront(id: String): Unit {
        for ((index, res) in m_resources |> enumerate) {
            if (res.id == id && index > 0) {
                m_resources[index] = m_resources.back
                m_resources.back = res
                return
            }
        }
    }

    // Shaders

    public prop shaders: ShaderManager {
        get() {
            m_shaders
        }
    }

    // Cursors

    public func getCursor(): ?Image {
        match (m_cursors.size) {
            case 0 => None
            case size => m_cursors[size - 1]
        }
    }

    public func addCursor(cursor: ?Image): Unit {
        m_cursors.add(cursor)
    }

    public func popCursor(popAll!: Bool = false): Unit {
        if (m_cursors.isEmpty() == true) {
            return
        }
        if (popAll) {
            m_cursors.clear()
        } else {
            m_cursors.remove(at: m_cursors.size - 1)
        }
    }

    public func popAllCursors(): Unit {
        m_cursors.clear()
    }

    public prop cursorCount: Int64 {
        get() {
            m_cursors.size
        }
    }

    // Actions

    public func setAction(key: String, obj: ?Action): Unit {
        match (obj) {
            case Some(obj) => m_resources.back.actions.add(key, obj)
            case None => m_resources.back.actions.remove(key)
        }
    }

    public func getAction(key: String): ?Action {
        for (res in m_resources |> reverse) {
            let action = res.actions.get(key)
            if (action.isSome()) {
                return action
            }
        }
        return None
    }

    // InputActions

    public func setInputAction(key: SFMLEvent, obj: ?Action): Unit {
        match (key) {
            case EvtKeyPressed(event) where event.code == KeyCode.Count || event.scancode == Scancode.Count =>
                m_resources.back.anyKeyAction = obj
                return
            case _ => match (obj) {
                case Some(obj) => m_resources.back.inputActions.add(key, obj)
                case None => m_resources.back.inputActions.remove(key)
            }
        }
    }

    public func getInputAction(key: SFMLEvent): ?Action {
        for (res in m_resources |> reverse) {
            match (key) {
                case EvtKeyPressed(event) where res.anyKeyAction.isSome() => return res.anyKeyAction
                case _ => ()
            }

            var (evt, keyPressed) = match (key) {
                case EvtKeyPressed(event) => (event, true)
                case EvtKeyReleased(event) => (event, false)
                case _ => return res.inputActions.get(key)
            }
            var keyCode = evt.code
            evt.code = KeyCode.Unknown

            var action = match (keyPressed) {
                case true => res.inputActions.get(EvtKeyPressed(evt))
                case false => res.inputActions.get(EvtKeyReleased(evt))
            }
            if (action.isSome()) {
                return action
            }

            if (keyCode != KeyCode.Unknown) {
                evt.code = keyCode
                evt.scancode = Scancode.Unknown
                var action = match (keyPressed) {
                    case true => res.inputActions.get(EvtKeyPressed(evt))
                    case false => res.inputActions.get(EvtKeyReleased(evt))
                }
                if (action.isSome()) {
                    return action
                }
            }
        }
        return None
    }

    // InputEvents

    public func setInputEvent(event: InputEvent, name: String): Unit {
        m_resources.back.inputEvents.add((event, name))
    }

    public func hasActiveInputEvents(): Bool {
        m_activeInputEvents.isEmpty() == false
    }

    public func hasActiveInputEvents(names: Array<String>): Bool {
        var count = 0
        for (inputEvent in m_activeInputEvents) {
            if (names.contains(inputEvent)) {
                count++
            }
        }
        return count >= names.size
    }

    public func updateActiveInputEvents(): Unit {
        m_activeInputEvents.clear()
        let used = ArrayList<InputEvent>()
        for (res in m_resources |> reverse) {
            if (res.anyKeyAction.isSome()) {
                return
            }
            for ((event, name) in res.inputEvents) {
                if (event.isActive() == true && used.contains(event) == false) {
                    m_activeInputEvents.add(name)
                    used.add(event)
                }
            }
        }
    }

    // Resources

    public func addResource(key: String, obj: ResourceItem, resourceId!: String): Bool {
        if (resourceId.isEmpty() == true) {
            return m_resources.back.addResource(key, obj)
        } else {
            for (res in m_resources |> reverse) {
                if (res.id == resourceId) {
                    return res.addResource(key, obj)
                }
            }
        }
        return false
    }

    public func addFileBytes(key: String, obj: Array<Byte>, resourceId!: String = String.empty): Bool {
        return addResource(key, ResFileBytes(obj), resourceId: resourceId)
    }

    public func addFont(key: String, obj: Font, resourceId!: String = String.empty): Bool {
        return addResource(key, ResFont(obj), resourceId: resourceId)
    }

    public func addTexture(key: String, obj: Texture, resourceId!: String = String.empty): Bool {
        return addResource(key, ResTexture(obj), resourceId: resourceId)
    }

    public func addAudioSource(key: String, obj: AudioSource, resourceId!: String = String.empty): Bool {
        return addResource(key, ResAudioSource(obj), resourceId: resourceId)
    }

    public func addPalette(key: String, obj: Palette, resourceId!: String = String.empty): Bool {
        return addResource(key, ResPalette(obj), resourceId: resourceId)
    }

    public func addImageContainer(key: String, obj: ImageContainer, resourceId!: String = String.empty): Bool {
        return addResource(key, ResImageContainer(obj), resourceId: resourceId)
    }

    public func addTexturePack(key: String, obj: TexturePack, resourceId!: String = String.empty): Bool {
        return addResource(key, ResTexturePack(obj), resourceId: resourceId)
    }

    public func getResource<T>(key: String): ?T where T <: Any {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.getResource<T>(key)) {
                return obj
            }
        }
        return None
    }

    public func getResourceItem<T>(key: String): ?ResourceItem where T <: Any {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.getResourceItem<T>(key)) {
                return obj
            }
        }
        return None
    }

    public func getFileBytes(key: String): ?Array<Byte> {
        getResource<Array<Byte>>(key)
    }

    public func getFont(key: String): ?Font {
        getResource<Font>(key)
    }

    public func getTexture(key: String): ?Texture {
        getResource<Texture>(key)
    }

    public func getAudioSource(key: String): ?AudioSource {
        getResource<AudioSource>(key)
    }

    public func getSoundBuffer(key: String): ?SoundBuffer {
        match (getResource<AudioSource>(key)) {
            case Some(source) => match (source) {
                case AuSoundBuffer(value) => value
                case _ => None
            }
            case _ => None
        }
    }

    public func getPalette(key: String): ?Palette {
        getResource<Palette>(key)
    }

    public func getImageContainer(key: String): ?ImageContainer {
        getResource<ImageContainer>(key)
    }

    public func getTexturePack(key: String): ?TexturePack {
        getResource<TexturePack>(key)
    }

    public func hasResource<T>(key: String, checkTopOnly!: Bool): Bool where T <: Any {
        for (res in m_resources |> reverse) {
            if (res.hasResource<T>(key) == true) {
                return true
            }
            if (checkTopOnly == true) {
                return false
            }
        }
        return false
    }

    public func hasFileBytes(key: String): Bool {
        hasResource<Array<Byte>>(key, checkTopOnly: false)
    }

    public func hasFont(key: String): Bool {
        hasResource<Font>(key, checkTopOnly: false)
    }

    public func hasTexture(key: String): Bool {
        hasResource<Texture>(key, checkTopOnly: false)
    }

    public func hasAudioSource(key: String): Bool {
        hasResource<AudioSource>(key, checkTopOnly: false)
    }

    public func hasPalette(key: String): Bool {
        hasResource<Palette>(key, checkTopOnly: false)
    }

    public func hasImageContainer(key: String): Bool {
        hasResource<ImageContainer>(key, checkTopOnly: false)
    }

    public func hasTexturePack(key: String): Bool {
        hasResource<TexturePack>(key, checkTopOnly: false)
    }

    // Songs

    public func addSong(key: String, obj: Music, resourceId!: String = String.empty): Bool {
        if (resourceId.isEmpty() == true) {
            return m_resources.back.songs.addIfAbsent(key, obj).isNone()
        } else {
            for (res in m_resources |> reverse) {
                if (res.id == resourceId) {
                    return res.songs.addIfAbsent(key, obj).isNone()
                }
            }
        }
        return false
    }

    public func getSong(key: String): ?Music {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.songs.get(key)) {
                return obj
            }
        }
        return None
    }

    public func hasSong(key: String, checkTopOnly!: Bool = false): Bool {
        for (res in m_resources |> reverse) {
            if (res.songs.contains(key) == true) {
                return true
            }
            if (checkTopOnly == true) {
                return false
            }
        }
        return false
    }

    public func play(key: String): Unit {
        if (let Some(song) <- m_resources.back.songs.get(key)) {
            song.play()
        }
    }

    public func playPaused(restart!: Bool): Unit {
        for (res in m_resources) {
            for (song in res.songs.values()) {
                if (song.status == SoundStatus.Paused) {
                    if (restart) {
                        song.playingOffset = Time.ZERO
                    }
                    song.play()
                }
            }
        }
    }

    public func pauseSongs(): Unit {
        for (res in m_resources) {
            for (song in res.songs.values()) {
                if (song.status == SoundStatus.Playing) {
                    song.pause()
                }
            }
        }
    }

    public func stopSongs(): Unit {
        for (res in m_resources) {
            for (song in res.songs.values()) {
                if (song.status == SoundStatus.Playing) {
                    song.stop()
                }
            }
        }
    }

    public func deleteSong(key: String): Unit {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.songs.remove(key)) {
                obj.close()
                if (let Some(audioSource) <- res.deleteResource<AudioSource>(key)) {
                    audioSource.close()
                }
                return
            }
        }
    }

    // Drawables

    private func addDrawable(res: ResourceBundle, key: String, obj: UIObject, manageObjDrawing!: Bool): Unit {
        if (res.drawableIds.addIfAbsent(key, obj).isNone()) {
            if (manageObjDrawing == true) {
                res.drawables.add(obj)
            }
        }
    }

    public func addDrawable(key: String, obj: UIObject, manageObjDrawing!: Bool, resourceId!: String = String.empty): Unit {
        if (resourceId.isEmpty() == true) {
            addDrawable(m_resources.back, key, obj, manageObjDrawing: manageObjDrawing)
            return
        }
        for (res in m_resources |> reverse) {
            if (res.id == resourceId) {
                addDrawable(res, key, obj, manageObjDrawing: manageObjDrawing)
                return
            }
        }
    }

    public func hasDrawable(key: String): Bool {
        for (res in m_resources) {
            if (res.drawableIds.contains(key) == true) {
                return true
            }
        }
        return false
    }

    public func bringDrawableToFront(id: String): Unit {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.drawableIds.remove(id)) {
                for ((index, drawable) in res.drawables |> enumerate) {
                    if (isObjEq(drawable, obj) == true) {
                        res.drawables[index] = res.drawables.back
                        res.drawables.back = drawable
                        break
                    }
                }
            }
        }
    }

    public func sendDrawableToBack(id: String): Unit {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.drawableIds.remove(id)) {
                for ((index, drawable) in res.drawables |> enumerate) {
                    if (isObjEq(drawable, obj) == true) {
                        res.drawables[index] = res.drawables[0]
                        res.drawables[0] = drawable
                        break
                    }
                }
            }
        }
    }

    public func getDrawable<T>(key: String): ?T where T <: UIObject {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.drawableIds.get(key)) {
                return obj as T
            }
        }
        return None
    }

    // deletes a drawable from drawableIds and drawables vector
    public func deleteDrawable(id: String, closeResource!: Bool = true): Unit {
        for (res in m_resources |> reverse) {
            if (let Some(obj) <- res.drawableIds.remove(id)) {
                for ((index, drawable) in res.drawables |> enumerate) {
                    if (isObjEq(drawable, obj) == true) {
                        res.drawables.remove(at: index)
                        break
                    }
                }
                if (closeResource == true) {
                    if (let Some(resource) <- (obj as Resource)) {
                        resource.close()
                    }
                }
                return
            }
        }
    }

    // deletes a drawable from the drawables vector (and not from drawableIds)
    public func deleteDrawable(obj: UIObject): Unit {
        for (res in m_resources |> reverse) {
            for ((index, drawable) in res.drawables |> enumerate) {
                if (isObjEq(drawable, obj) == true) {
                    res.drawables.remove(at: index)
                    break
                }
            }
        }
    }

    // FocusButtons

    private func addFocused(res: ResourceBundle, obj: Button): Unit {
        for (focusBtn in res.focusButtons) {
            if (isObjEq(focusBtn, obj) == true) {
                return
            }
        }
        res.focusButtons.add(obj)
    }

    public func addFocused(obj: Button, resourceId!: String = String.empty): Unit {
        if (resourceId.isEmpty() == true) {
            return addFocused(m_resources.back, obj)
        } else {
            for (res in m_resources |> reverse) {
                if (res.id == resourceId) {
                    addFocused(res, obj)
                    return
                }
            }
        }
    }

    public func clickFocused(game: Game, playSound!: Bool): Unit {
        if (let Some(focus) <- getFocused<Button>()) {
            focus.click(game, playSound: playSound)
        }
    }

    public func rightClickFocused(game: Game, playSound!: Bool): Unit {
        if (let Some(focus) <- getFocused<Button>()) {
            focus.rightClick(game, playSound: playSound)
        }
    }

    private func removeUnusedFocused(res: ResourceBundle): Unit {
        for (index in res.focusButtons.size - 1..=0 : -1) {
            let btn = res.focusButtons[index]
            if (let Some(resource) <- (btn as Resource)) {
                if (resource.isClosed()) {
                    res.focusButtons.remove(at: index)
                    if (res.focusButtons.isEmpty() == false && res.focusIdx >= res.focusButtons.size) {
                        res.focusIdx--
                    }
                }
            }
        }
    }

    public func getFocused<T>(): ?T where T <: UIObject {
        for (res in m_resources |> reverse) {
            if (res.ignore != IgnoreResource.None) {
                continue
            }
            removeUnusedFocused(res)
            if (res.focusButtons.isEmpty() == false && res.focusIdx < res.focusButtons.size) {
                return res.focusButtons[res.focusIdx] as T
            }
            break
        }
        return None
    }

    public func setFocused(obj: Button): Unit {
        for (res in m_resources |> reverse) {
            if (res.ignore != IgnoreResource.None) {
                continue
            }
            if (res.focusButtons.isEmpty() == false) {
                for ((index, btn) in res.focusButtons |> enumerate) {
                    if (isObjEq(btn, obj) == true) {
                        res.focusIdx = index
                        return
                    }
                }
            }
            break
        }
    }

    public func moveFocusDown(game: Game): Unit {
        for (res in m_resources |> reverse) {
            if (res.ignore != IgnoreResource.None) {
                continue
            }
            removeUnusedFocused(res)
            if (res.focusButtons.isEmpty() == false) {
                var idx = res.focusIdx
                while (true) {
                    if (idx + 1 < res.focusButtons.size) {
                        idx++
                    } else {
                        idx = 0
                    }
                    if (res.focusButtons[idx].isEnabled == true || idx == res.focusIdx) {
                        break
                    }
                }
                let btn = res.focusButtons[idx]
                if (btn.isEnabled == true && idx != res.focusIdx) {
                    res.focusIdx = idx
                    btn.focus(game)
                }
            }
            break
        }
    }

    public func moveFocusUp(game: Game): Unit {
        for (res in m_resources |> reverse) {
            if (res.ignore != IgnoreResource.None) {
                continue
            }
            removeUnusedFocused(res)
            if (res.focusButtons.isEmpty() == false) {
                var idx = res.focusIdx
                while (true) {
                    if (idx > 0) {
                        idx--
                    } else {
                        idx = res.focusButtons.size - 1
                    }
                    if (res.focusButtons[idx].isEnabled == true || idx == res.focusIdx) {
                        break
                    }
                }
                let btn = res.focusButtons[idx]
                if (btn.isEnabled == true && idx != res.focusIdx) {
                    res.focusIdx = idx
                    btn.focus(game)
                }
            }
            break
        }
    }

    public func updateFocus(): Unit {
        for (res in m_resources |> reverse) {
            if (res.ignore != IgnoreResource.None) {
                continue
            }
            removeUnusedFocused(res)
            if (res.focusButtons.isEmpty() == false) {
                if (res.focusButtons[res.focusIdx].isEnabled == true) {
                    break
                }
                var idx = res.focusIdx
                while (true) {
                    if (idx + 1 < res.focusButtons.size) {
                        idx++
                    } else {
                        idx = 0
                    }
                    if (res.focusButtons[idx].isEnabled == true || idx == res.focusIdx) {
                        break
                    }
                }
                let btn = res.focusButtons[idx]
                if (btn.isEnabled == true && idx != res.focusIdx) {
                    res.focusIdx = idx
                }
            }
            break
        }
    }

    // PlayingSounds

    public func addPlayingSound(obj: Sound, unique!: Bool = false, seek!: Time = Time.ZERO): Unit {
        if (unique == true) {
            for (snd in m_playingSounds) {
                match ((snd.buffer, obj.buffer)) {
                    case (Some(obj1), Some(obj2)) where obj1 == obj2 => return
                    case _ => ()
                }
            }
        }
        m_playingSounds.addLast(obj)
        obj.play()
        obj.playingOffset = seek
    }

    public func clearFinishedSounds(): Unit {
        m_playingSounds.removeIf(
            {
                snd =>
                    if (snd.status != SoundStatus.Playing) {
                        snd.close()
                        return true
                    }
                    return false
            }
        )
    }

    public func clearPlayingSounds(): Unit {
        for (snd in m_playingSounds) {
            snd.close()
        }
        m_playingSounds.clear()
    }

    // CurrentLevel

    public func setCurrentLevel(level: ?UIObject): Unit {
        m_currentLevel = level
    }

    public func getCurrentLevel<T>(): ?T where T <: UIObject {
        if (let Some(currentLevel) <- m_currentLevel) {
            return currentLevel as T
        }
        return None
    }

    public func getLevel<T>(id: String): ?T where T <: UIObject {
        if (id.isEmpty() == true) {
            return getCurrentLevel<T>()
        }
        return getDrawable<T>(id)
    }
}
