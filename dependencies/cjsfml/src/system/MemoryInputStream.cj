package cjsfml.system

foreign func memcpy(dest: CPointer<Unit>, src: CPointer<Unit>, count: UIntNative): CPointer<Unit>

@C
private func memoryInputStream_read(data: CPointer<Byte>, size: Int64, userData: CPointer<Unit>): Int64 {
    let memoryPtr = CPointer<MemoryStruct>(userData)
    if (memoryPtr.isNull()) {
        return -1
    }
    unsafe {
        var memory = memoryPtr.read()
        let endPosition = memory.offset + size
        let count = match (endPosition <= memory.size) {
            case true => size
            case false => memory.size - memory.offset
        }
        if (count > 0) {
            memcpy(CPointer(data), CPointer(memory.data + memory.offset), UIntNative(count))
            memory.offset += count
        }
        memoryPtr.write(memory)
        return count
    }
}

@C
private func memoryInputStream_seek(position: Int64, userData: CPointer<Unit>): Int64 {
    let memoryPtr = CPointer<MemoryStruct>(userData)
    if (memoryPtr.isNull()) {
        return -1
    }
    unsafe {
        var memory = memoryPtr.read()
        if (position < 0) {
            memory.offset = 0
        } else if (position < memory.size) {
            memory.offset = position
        } else {
            memory.offset = memory.size
        }
        memoryPtr.write(memory)
        return memory.offset
    }
}

@C
private func memoryInputStream_tell(userData: CPointer<Unit>): Int64 {
    let memoryPtr = CPointer<MemoryStruct>(userData)
    if (memoryPtr.isNull()) {
        return -1
    }
    unsafe {
        return memoryPtr.read().offset
    }
}

@C
private func memoryInputStream_getSize(userData: CPointer<Unit>): Int64 {
    unsafe {
        let memoryPtr = CPointer<MemoryStruct>(userData)
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

public class MemoryInputStream <: InputStream {
    private var m_buffer: Array<Byte>
    private var m_rawData: CPointerHandle<Byte>
    private var m_memoryInputStream: CPointer<MemoryStruct>

    public init(buffer: Array<Byte>) {
        super(
            InputStreamData(memoryInputStream_read, memoryInputStream_seek, memoryInputStream_tell,
                memoryInputStream_getSize, CPointer()))

        if (buffer.isEmpty()) {
            throw SFMLException("Empty array")
        }

        m_buffer = buffer
        unsafe {
            m_rawData = acquireArrayRawData(m_buffer)
            m_memoryInputStream = LibC.malloc<MemoryStruct>()
            var memory = MemoryStruct(m_rawData)
            m_memoryInputStream.write(memory)
            m_stream.userData = CPointer(m_memoryInputStream)
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
