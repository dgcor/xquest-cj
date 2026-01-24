package dgengine

import cjsfml.audio.*
import cjsfml.graphics.Texture
import cjsfml.window.Event as SFMLEvent
import std.collection.*

public enum ResourceItem <: Resource {
    | ResFileBytes(Array<Byte>)
    | ResFont(Font)
    | ResTexture(Texture)
    | ResAudioSource(AudioSource)
    | ResPalette(Palette)
    | ResImageContainer(ImageContainer)
    | ResTexturePack(TexturePack)

    public func isClosed(): Bool {
        match (this) {
            case ResFont(obj) => obj.isClosed()
            case ResTexture(obj) => obj.isClosed()
            case ResAudioSource(obj) => obj.isClosed()
            case ResPalette(obj) => obj.isClosed()
            case ResImageContainer(obj) =>
                if (let Some(obj) <- (obj as Resource)) {
                    obj.isClosed()
                } else {
                    false
                }
            case ResTexturePack(obj) =>
                if (let Some(obj) <- (obj as Resource)) {
                    obj.isClosed()
                } else {
                    false
                }
            case _ => false
        }
    }

    public func close(): Unit {
        match (this) {
            case ResFont(obj) => obj.close()
            case ResTexture(obj) => obj.close()
            case ResAudioSource(obj) => obj.close()
            case ResPalette(obj) => obj.close()
            case ResImageContainer(obj) =>
                if (let Some(obj) <- (obj as Resource)) {
                    obj.close()
                }
            case ResTexturePack(obj) =>
                if (let Some(obj) <- (obj as Resource)) {
                    obj.close()
                }
            case _ => ()
        }
    }
}

public class ResourceBundle <: Resource {
    public var ignore: IgnoreResource = IgnoreResource.None
    public var id: String = String.empty
    public var anyKeyAction: ?Action = None
    public var actions: HashMap<String, Action> = HashMap<String, Action>()
    public var inputActions: HashMap<SFMLEvent, Action> = HashMap<SFMLEvent, Action>()
    public var inputEvents: ArrayList<(InputEvent, String)> = ArrayList<(InputEvent, String)>()
    public var resources: HashMap<String, ArrayList<ResourceItem>> = HashMap<String, ArrayList<ResourceItem>>()
    public var songs: HashMap<String, Music> = HashMap<String, Music>()
    public var drawableIds: HashMap<String, UIObject> = HashMap<String, UIObject>()
    public var drawables: ArrayList<UIObject> = ArrayList<UIObject>()
    public var focusButtons: ArrayList<Button> = ArrayList<Button>()
    public var focusIdx: Int64 = 0
    private var m_closed = false

    public init() {}

    public init(id: String) {
        this.id = id
    }

    // Resource

    public func isClosed(): Bool {
        m_closed
    }

    // closes everything (resources, songs)
    public func close(): Unit {
        if (m_closed) {
            return
        }
        for (song in songs.values()) {
            song.close()
        }
        m_closed = true
    }

    // only closes songs, not resources
    public func closeSongs(): Unit {
        if (m_closed) {
            return
        }
        for (song in songs.values()) {
            song.close()
        }
        for (resItems in resources.values()) {
            for (res in resItems) {
                res.close()
            }
        }
        m_closed = true
    }

    // ResourceBundle

    // Add obj to bundle if no existing obj with the same id exists
    public func addResource(key: String, obj: ResourceItem): Bool {
        if (let Some(resItems) <- resources.get(key)) {
            for (res in resItems) {
                match ((res, obj)) {
                    case (ResFileBytes(_), ResFileBytes(_)) => return false
                    case (ResFont(_), ResFont(_)) => return false
                    case (ResTexture(_), ResTexture(_)) => return false
                    case (ResAudioSource(_), ResAudioSource(_)) => return false
                    case (ResPalette(_), ResPalette(_)) => return false
                    case (ResImageContainer(_), ResImageContainer(_)) => return false
                    case (ResTexturePack(_), ResTexturePack(_)) => return false
                    case _ => ()
                }
            }
            resItems.add(obj)
            return true
        } else {
            resources.add(key, ArrayList(1, {_ => obj}))
            return true
        }
        return false
    }

    public func hasResource<T>(key: String): Bool where T <: Any {
        getResource<T>(key).isSome()
    }

    public func getResource<T>(key: String): ?T where T <: Any {
        if (let Some(resItems) <- resources.get(key)) {
            for (res in resItems) {
                match (res) {
                    case ResFileBytes(value) where value is T => return value as T
                    case ResFont(value) where value is T => return value as T
                    case ResTexture(value) where value is T => return value as T
                    case ResAudioSource(value) where value is T => return value as T
                    case ResPalette(value) where value is T => return value as T
                    case ResImageContainer(value) where value is T => return value as T
                    case ResTexturePack(value) where value is T => return value as T
                    case _ => ()
                }
            }
        }
        return None
    }

    public func getResourceItem<T>(key: String): ?ResourceItem where T <: Any {
        if (let Some(resItems) <- resources.get(key)) {
            for (res in resItems) {
                match (res) {
                    case ResFileBytes(value) where value is T => return res
                    case ResFont(value) where value is T => return res
                    case ResTexture(value) where value is T => return res
                    case ResAudioSource(value) where value is T => return res
                    case ResPalette(value) where value is T => return res
                    case ResImageContainer(value) where value is T => return res
                    case ResTexturePack(value) where value is T => return res
                    case _ => ()
                }
            }
        }
        return None
    }

    public func deleteResource<T>(key: String): ?T where T <: Any {
        if (let Some(resItems) <- resources.get(key)) {
            for ((index, res) in resItems |> enumerate) {
                match (res) {
                    case ResFileBytes(value) where value is T =>
                        resItems.remove(at: index)
                        return value as T
                    case ResFont(value) where value is T =>
                        resItems.remove(at: index)
                        return value as T
                    case ResTexture(value) where value is T =>
                        resItems.remove(at: index)
                        return value as T
                    case ResAudioSource(value) where value is T =>
                        resItems.remove(at: index)
                        return value as T
                    case ResPalette(value) where value is T =>
                        resItems.remove(at: index)
                        return value as T
                    case ResImageContainer(value) where value is T =>
                        resItems.remove(at: index)
                        return value as T
                    case ResTexturePack(value) where value is T =>
                        resItems.remove(at: index)
                        return value as T
                    case _ => ()
                }
            }
        }
        return None
    }
}
