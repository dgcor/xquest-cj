package endian

import endian.utils.*
import std.binary.*
import std.io.*

private func readEndian<U>(inputStream: InputStream): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return @ReadEndian[U](buffer)
    }
    return None
}

private func readBigEndian<U>(inputStream: InputStream): ?U where U <: CType & BigEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return U.readBigEndian(buffer)
    }
    return None
}

private func readLittleEndian<U>(inputStream: InputStream): ?U where U <: CType & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return U.readLittleEndian(buffer)
    }
    return None
}

public class EndianReader<T> where T <: InputStream & Seekable {
    private let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        readEndian(inputStream)
    }

    public func readBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }

    public func readLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }

    public prop length: Int64 {
        get() {
            inputStream.length
        }
    }

    public prop position: Int64 {
        get() {
            inputStream.position
        }
    }

    public prop remainLength: Int64 {
        get() {
            inputStream.remainLength
        }
    }

    public func seek(sp: SeekPosition): Int64 {
        inputStream.seek(sp)
    }
}

public class EndianInputStream<T> where T <: InputStream {
    private let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        readEndian(inputStream)
    }

    public func readBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }

    public func readLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}

public class BigEndianReader<T> where T <: InputStream & Seekable {
    private let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }

    public prop length: Int64 {
        get() {
            inputStream.length
        }
    }

    public prop position: Int64 {
        get() {
            inputStream.position
        }
    }

    public prop remainLength: Int64 {
        get() {
            inputStream.remainLength
        }
    }

    public func seek(sp: SeekPosition): Int64 {
        inputStream.seek(sp)
    }
}

public class BigEndianInputStream<T> where T <: InputStream {
    private let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }
}

public class LittleEndianReader<T> where T <: InputStream & Seekable {
    private let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public func read<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }

    public prop length: Int64 {
        get() {
            inputStream.length
        }
    }

    public prop position: Int64 {
        get() {
            inputStream.position
        }
    }

    public prop remainLength: Int64 {
        get() {
            inputStream.remainLength
        }
    }

    public func seek(sp: SeekPosition): Int64 {
        inputStream.seek(sp)
    }
}

public class LittleEndianInputStream<T> where T <: InputStream {
    private let inputStream: T

    public init(input: T) {
        inputStream = input
    }

    public func read<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}
