package cjsfml.system

import std.io.{InputStream as IStream, Seekable, SeekPosition}

type InputStreamReadFunc = CFunc<(data: CPointer<Byte>, size: UIntNative, userData: CPointer<Unit>) -> Int64>

type InputStreamSeekFunc = CFunc<(position: UIntNative, userData: CPointer<Unit>) -> Int64>

type InputStreamTellFunc = CFunc<(userData: CPointer<Unit>) -> Int64>

type InputStreamGetSizeFunc = CFunc<(userData: CPointer<Unit>) -> Int64>

@C
public struct InputStreamData {
    public let read: InputStreamReadFunc
    public let seek: InputStreamSeekFunc
    public let tell: InputStreamTellFunc
    public let getSize: InputStreamGetSizeFunc
    public var userData: CPointer<Unit> = CPointer()

    public init(read: InputStreamReadFunc, seek: InputStreamSeekFunc, tell: InputStreamTellFunc,
        getSize: InputStreamGetSizeFunc, userData: CPointer<Unit>) {
        this.read = read
        this.seek = seek
        this.tell = tell
        this.getSize = getSize
        this.userData = userData
    }
}

/**
 * Abstract class for custom file input streams.
 *
 * This class allows users to define their own file input sources
 * from which SFML can load resources.
 *
 * SFML resource classes like `Texture` and
 * `SoundBuffer` provide `loadFromFile` and `loadFromMemory` functions,
 * which read data from conventional sources. However, if you
 * have data coming from a different source (over a network,
 * embedded, encrypted, compressed, etc) you can derive your
 * own class from `InputStream` and load SFML resources with
 * their `loadFromStream` function.
 *
 * Usage example:
 * ```
 * // custom stream class that reads from inside a zip file
 * class ZipStream <: InputStream {
 *     // ... implementation details ...
 * }
 *
 * // now you can load textures...
 * let stream = ZipStream("resources.zip")
 *
 * if (!stream.open("images/img.png")) {
 *     // Handle error...
 * }
 *
 * let texture = Texture(stream)
 *
 * // musics...
 * let music = Music()
 * let stream2 = ZipStream("resources.zip")
 *
 * if (!stream2.open("musics/msc.ogg")) {
 *     // Handle error...
 * }
 *
 * if (!music.openFromStream(stream2)) {
 *     // Handle error...
 * }
 *
 * // etc.
 * ```
 *
 * @see `FileInputStream`, `MemoryInputStream`
 */
public abstract class InputStream <: Resource & IStream & Seekable {
    protected var m_stream: InputStreamData

    public init(stream: InputStreamData) {
        m_stream = stream
    }

    public func isClosed(): Bool {
        m_stream.userData.isNull()
    }

    /**
     * Read data from the stream.
     *
     * After reading, the stream's reading position must be
     * advanced by the amount of bytes read.
     *
     * @param buffer Buffer where to copy the read data
     * @return The number of bytes actually read, or -1 on error
     */
    public func read(buffer: Array<Byte>): Int64 {
        unsafe {
            let rawData = acquireArrayRawData(buffer)
            try {
                return m_stream.read(rawData.pointer, UIntNative(buffer.size), m_stream.userData)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Return the size of the stream.
     *
     * @return The total number of bytes available in the stream, or -1 on error
     */
    public prop length: Int64 {
        get() {
            unsafe { m_stream.getSize(m_stream.userData) }
        }
    }

    /**
     * Get the current reading position in the stream.
     *
     * @return The current position, or -1 on error.
     */
    public prop position: Int64 {
        get() {
            unsafe { m_stream.tell(m_stream.userData) }
        }
    }

    public prop remainLength: Int64 {
        get() {
            length - position
        }
    }

    /**
     * Change the current reading position.
     *
     * @param sp The position to seek to
     * @return The position actually sought to, or -1 on error
     */
    public func seek(sp: SeekPosition): Int64 {
        var seekPos = match (sp) {
            case Begin(offset) => offset
            case Current(offset) => position + offset
            case End(offset) => length + offset
        }
        if (seekPos < 0) {
            return -1
        }
        return unsafe { m_stream.seek(UIntNative(seekPos), m_stream.userData) }
    }

    public prop stream: InputStreamData {
        get() {
            m_stream
        }
    }
}
