package cjsfml.system

foreign func memcpy(dest: CPointer<Unit>, src: CPointer<Unit>, count: UIntNative): CPointer<Unit>

@C
private func memoryInputStreamRead(data: CPointer<Byte>, size: UIntNative, userData: CPointer<Unit>): Int64 {
    let memoryPtr = CPointer<MemoryStruct>(userData) // cjlint-ignore !FFI.C.7
    if (memoryPtr.isNull()) {
        return -1
    }
    unsafe {
        let size = Int64(size)
        var memory = memoryPtr.read()
        let endPosition = memory.offset + size
        let count = match (endPosition <= memory.size) { // cjlint-ignore !G.EXP.07
            case true => size
            case false => memory.size - memory.offset
        }
        if (count > 0) {
            memcpy(CPointer(data), CPointer(memory.data + memory.offset), UIntNative(count)) // cjlint-ignore !FFI.C.7
            memory.offset += count
        }
        memoryPtr.write(memory)
        return count
    }
}

@C
private func memoryInputStreamSeek(position: UIntNative, userData: CPointer<Unit>): Int64 {
    let memoryPtr = CPointer<MemoryStruct>(userData) // cjlint-ignore !FFI.C.7
    if (memoryPtr.isNull()) {
        return -1
    }
    unsafe {
        let position = Int64(position)
        var memory = memoryPtr.read()
        if (position < 0) {
            return -1
        } else if (position < memory.size) { // cjlint-ignore !G.EXP.07
            memory.offset = position
        } else {
            memory.offset = memory.size
        }
        memoryPtr.write(memory)
        return memory.offset
    }
}

@C
private func memoryInputStreamTell(userData: CPointer<Unit>): Int64 {
    let memoryPtr = CPointer<MemoryStruct>(userData) // cjlint-ignore !FFI.C.7
    if (memoryPtr.isNull()) {
        return -1
    }
    unsafe {
        return memoryPtr.read().offset
    }
}

@C
private func memoryInputStreamGetSize(userData: CPointer<Unit>): Int64 {
    unsafe {
        let memoryPtr = CPointer<MemoryStruct>(userData) // cjlint-ignore !FFI.C.7
        if (memoryPtr.isNull()) {
            return -1
        }
        return memoryPtr.read().size
    }
}

@C
private struct MemoryStruct {
    public var size: Int64 = 0
    public var offset: Int64 = 0
    public var data: CPointer<Byte>

    public init(rawBuffer: CPointerHandle<Byte>) {
        unsafe {
            size = rawBuffer.array.size
            data = rawBuffer.pointer
        }
    }
}

/**
 * Implementation of input stream based on a memory chunk.
 *
 * This class is a specialization of `InputStream` that
 * reads from data in memory.
 *
 * It wraps a memory chunk in the common `InputStream` interface
 * and therefore allows to use generic classes or functions
 * that accept such a stream, with content already loaded in memory.
 *
 * In addition to the virtual functions inherited from
 * `InputStream`, `MemoryInputStream` adds a function to
 * specify the pointer and size of the data in memory.
 *
 * SFML resource classes can usually be loaded directly from
 * memory, so this class shouldn't be useful to you unless
 * you create your own algorithms that operate on an InputStream.
 *
 * Usage example:
 * ```
 * func process(stream: InputStream) {
 *     // ...
 * }
 *
 * let stream = MemoryInputStream(theBuffer)
 * process(stream)
 * ```
 *
 * @see `InputStream`, `FileInputStream`
 */
public class MemoryInputStream <: InputStream {
    private var m_buffer: Array<Byte>
    private var m_rawData: CPointerHandle<Byte>
    private var m_memoryInputStream: CPointer<MemoryStruct>

    /**
     * Construct the stream from its data.
     *
     * @param buffer Buffer containing the data in memory
     *
     * @throws SFMLException if the buffer is empty
     */
    public init(buffer: Array<Byte>) {
        super(
            InputStreamData(memoryInputStreamRead, memoryInputStreamSeek, memoryInputStreamTell,
                memoryInputStreamGetSize, CPointer()))

        if (buffer.isEmpty()) {
            throw SFMLException("Empty array")
        }

        m_buffer = buffer
        unsafe {
            m_rawData = acquireArrayRawData(m_buffer)
            m_memoryInputStream = LibC.malloc<MemoryStruct>()
            var memory = MemoryStruct(m_rawData)
            m_memoryInputStream.write(memory)
            m_stream.userData = CPointer(m_memoryInputStream) // cjlint-ignore !FFI.C.7
        }
    }

    ~init() {
        if (m_stream.userData.isNull()) {
            return
        }
        m_stream.userData = CPointer()
        unsafe {
            LibC.free(m_memoryInputStream)
            releaseArrayRawData(m_rawData)
        }
        m_buffer = Array<Byte>()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        m_stream.userData = CPointer()
        unsafe {
            LibC.free(m_memoryInputStream)
            releaseArrayRawData(m_rawData)
        }
        m_buffer = Array<Byte>()
    }
}
