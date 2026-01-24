package dgengine

import cjsfml.audio.*
import cjsfml.system.*

public enum AudioSource <: Resource {
    | AuSoundBuffer(SoundBuffer)
    | AuInputStream(InputStream)

    public func isClosed(): Bool {
        match (this) {
            case AuSoundBuffer(obj) => obj.isClosed()
            case AuInputStream(obj) => obj.isClosed()
        }
    }

    public func close(): Unit {
        match (this) {
            case AuSoundBuffer(obj) => obj.close()
            case AuInputStream(obj) => obj.close()
        }
    }
}
