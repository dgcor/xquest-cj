package dgengine

import cjsfml.system.*
import physfs4cj.PhysFSException

foreign {
    func PHYSFS_openRead(filename: CString): CPointer<Unit>

    func PHYSFS_close(handle: CPointer<Unit>): Int32

    func PHYSFS_tell(handle: CPointer<Unit>): Int64

    func PHYSFS_seek(handle: CPointer<Unit>, pos: UInt64): Int32

    func PHYSFS_fileLength(handle: CPointer<Unit>): Int64

    func PHYSFS_readBytes(handle: CPointer<Unit>, buffer: CPointer<Byte>, len: UInt64): Int64
}

@C
private func physfsInputStreamRead(data: CPointer<Byte>, size: UIntNative, userData: CPointer<Unit>): Int64 {
    unsafe { PHYSFS_readBytes(userData, data, UInt64(size)) }
}

@C
private func physfsInputStreamSeek(position: UIntNative, userData: CPointer<Unit>): Int64 {
    unsafe {
        if (PHYSFS_seek(userData, UInt64(position)) == 0) {
            return -1
        }
        return Int64(position)
    }
}

public class PhysFSStream <: InputStream {
    /**
     * @throws PhysFSException
     */
    public init(fileName: String) {
        super(
            InputStreamData(
                physfsInputStreamRead,
                physfsInputStreamSeek,
                PHYSFS_tell,
                PHYSFS_fileLength,
                CPointer()
            )
        )

        var handle: CPointer<Unit> = CPointer()
        unsafe {
            try (fileNameRes = LibC.mallocCString(fileName).asResource()) {
                handle = PHYSFS_openRead(fileNameRes.value)
            }
        }
        if (handle.isNull()) {
            throw PhysFSException()
        }
        m_stream.userData = handle
    }

    ~init() {
        if (m_stream.userData.isNull()) {
            return
        }
        unsafe { PHYSFS_close(m_stream.userData) }
        m_stream.userData = CPointer()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { PHYSFS_close(m_stream.userData) }
        m_stream.userData = CPointer()
    }
}
