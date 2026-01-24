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

public abstract class InputStream <: Resource & IStream & Seekable {
    protected var m_stream: InputStreamData

    public init(stream: InputStreamData) {
        m_stream = stream
    }

    public func isClosed(): Bool {
        m_stream.userData.isNull()
    }

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

    public prop length: Int64 {
        get() {
            unsafe { m_stream.getSize(m_stream.userData) }
        }
    }

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
