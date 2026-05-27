package physfs4cj

import std.fs.OpenMode
import std.io.{IOStream, Seekable, SeekPosition}

/**
 * Represents a file handle opened via PhysicsFS.
 * This class implements Resource, IOStream, and Seekable to integrate with standard IO operations.
 */
public class PhysFSFile <: Resource & IOStream & Seekable {
    private var handle: CPointer<Unit>
    private let openMode: OpenMode

    /**
     * Opens a file for reading, writing, or appending.
     *
     * @param filename File to open.
     * @param openMode The mode in which to open the file (Read, Write, Append).
     *
     * @throws PhysFSException if the file cannot be opened or if an unsupported mode is requested.
     */
    public init(filename: String, openMode: OpenMode) {
        this.openMode = openMode
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                handle = match (openMode) {
                    case Read => PHYSFS_openRead(filenameRes.value)
                    case Write => PHYSFS_openWrite(filenameRes.value)
                    case Append => PHYSFS_openAppend(filenameRes.value)
                    case ReadWrite => throw PhysFSException(
                        PhysFSErrorCode.UNSUPPORTED,
                        "ReadWrite open mode not supported."
                    )
                }
                if (handle.isNull()) {
                    throw PhysFSException()
                }
                return
            }
            handle = CPointer()
        }
    }

    /**
     * Close a PhysicsFS filehandle.
     * This call is capable of failing if the operating system was buffering writes to the physical media.
     *
     * @throws PhysFSException if closing the file fails.
     */
    public func close(): Unit {
        if (handle.isNull()) {
            return
        }
        if (unsafe { PHYSFS_close(handle).toBool() }) {
            handle = CPointer()
        } else {
            throw PhysFSException()
        }
    }

    /**
     * Checks if the file handle is closed.
     *
     * @return true if the file is closed, false otherwise.
     */
    public func isClosed(): Bool {
        return handle.isNull()
    }

    // Seekable

    /**
     * Seek to a new position within a PhysicsFS filehandle.
     * The next read or write will occur at that place.
     *
     * @param sp The seek position (Begin, Current, or End).
     * @return The resulting offset in bytes from the start of the file or -1 on negative seek values.
     *
     * @throws PhysFSException if seeking fails.
     */
    public func seek(sp: SeekPosition): Int64 {
        unsafe {
            checkIfNull()
            let pos: Int64 = match (sp) {
                case Begin(offset) => offset
                case Current(offset) => this.position + offset
                case End(offset) => this.length + offset
            }
            if (pos < 0) {
                throw PhysFSException(PhysFSErrorCode.OTHER_ERROR,
                    "Can't move the position before the beginning of the file.")
            }
            if (PHYSFS_seek(handle, UInt64(pos)) == 0) {
                throw PhysFSException()
            }
            return pos
        }
    }

    /**
     * Determine current position within a PhysicsFS filehandle.
     *
     * @return Offset in bytes from start of file.
     */
    public prop position: Int64 {
        /**
         * @throws PhysFSException if determining the position fails.
         */
        get() {
            unsafe {
                checkIfNull()
                let pos = PHYSFS_tell(handle)
                if (pos < 0) {
                    throw PhysFSException()
                }
                return pos
            }
        }
    }

    /**
     * Returns the remaining length of the file from the current position.
     *
     * @return The remaining length in bytes.
     */
    public prop remainLength: Int64 {
        get() {
            this.length - this.position
        }
    }

    /**
     * Get total length of a file in bytes.
     *
     * @return Size in bytes of the file.
     */
    public prop length: Int64 {
        /**
         * @throws PhysFSException if the length cannot be determined.
         */
        get() {
            unsafe {
                checkIfNull()
                let len = PHYSFS_fileLength(handle)
                if (len < 0) {
                    throw PhysFSException()
                }
                return len
            }
        }
    }

    // InputStream

    /**
     * Read bytes from a PhysicsFS filehandle.
     *
     * @param buffer Buffer of at least (len) bytes to store read data into.
     *
     * @return Number of bytes read. This may be less than buffer size; this does not signify an error.
     *         Returns 0 on EOF.
     *
     * @throws PhysFSException if a complete failure occurs.
     */
    public func read(buffer: Array<Byte>): Int64 {
        unsafe {
            checkIfNull()
            let rawData = acquireArrayRawData(buffer)
            var readCount: Int64 = 0
            try {
                readCount = PHYSFS_readBytes(handle, rawData.pointer, UInt64(buffer.size))
            } finally {
                releaseArrayRawData(rawData)
            }
            if (readCount < 0) {
                throw PhysFSException()
            }
            return readCount
        }
    }

    // OutputStream

    /**
     * Write data to a PhysicsFS filehandle.
     *
     * @param buffer Buffer of bytes to write to the file.
     *
     * @throws PhysFSException if writing fails or if not all bytes could be written.
     */
    public func write(buffer: Array<Byte>): Unit {
        checkIfNull()
        unsafe {
            let rawData = acquireArrayRawData(buffer)
            var writeCount: Int64 = 0
            try {
                writeCount = PHYSFS_writeBytes(handle, rawData.pointer, UInt64(buffer.size))
            } finally {
                releaseArrayRawData(rawData)
            }
            if (writeCount < 0) {
                throw PhysFSException()
            }
            if (writeCount != buffer.size) {
                throw PhysFSException(PhysFSErrorCode.IO, "Failed to write complete buffer (disk full?)")
            }
        }
    }

    /**
     * Flush a buffered PhysicsFS file handle.
     * This will block until the buffer is flushed to the physical media.
     *
     * @throws PhysFSException if flushing fails.
     */
    public func flush(): Unit {
        checkIfNull()
        if (unsafe { PHYSFS_flush(handle) == 0 }) {
            throw PhysFSException()
        }
    }

    // PhysFSFile

    /**
     * Check for end-of-file state on a PhysicsFS filehandle.
     *
     * @return true if EOF, false if not.
     */
    public func isEOF(): Bool {
        checkIfNull()
        return unsafe { PHYSFS_eof(handle).toBool() }
    }

    /**
     * Set up buffering for a PhysicsFS file handle.
     *
     * @param bufsize Size, in bytes, of buffer to allocate.
     *
     * @throws PhysFSException if setting the buffer fails.
     */
    public func setBuffer(bufsize: UInt64): Unit {
        checkIfNull()
        if (unsafe { PHYSFS_setBuffer(handle, bufsize) == 0 }) {
            throw PhysFSException()
        }
    }

    /**
     * Check if handle is null.
     *
     * @throws PhysFSException if handle is null.
     */
    private func checkIfNull(): Unit {
        if (handle.isNull()) {
            throw PhysFSException(PhysFSErrorCode.OTHER_ERROR, "null file handle")
        }
    }
}
