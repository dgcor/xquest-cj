package physfs4cj

import cenum.CEnum
import std.time.DateTime

foreign {
    // Initialization and Deinitialization

    func PHYSFS_init(argv0: CString): Int32

    func PHYSFS_deinit(): Int32

    func PHYSFS_isInit(): Int32

    // Error Handling

    func PHYSFS_getLastErrorCode(): PhysFSErrorCode

    @FastNative
    func PHYSFS_getErrorByCode(code: PhysFSErrorCode): CString

    func PHYSFS_setErrorCode(code: PhysFSErrorCode): Unit

    // Memory Management

    func PHYSFS_getAllocator(): CPointer<PhysFSAllocator>

    func PHYSFS_setAllocator(allocator: CPointer<PhysFSAllocator>): Int32

    func PHYSFS_freeList(listVar: CPointer<Unit>): Unit

    // Version and Info

    func PHYSFS_getLinkedVersion(ver: CPointer<PhysFSVersion>): Unit

    func PHYSFS_supportedArchiveTypes(): CPointer<CPointer<PhysFSArchiveInfo>>

    // Directory and Path Management

    func PHYSFS_getDirSeparator(): CString

    func PHYSFS_getCdRomDirs(): CPointer<CString>

    func PHYSFS_getBaseDir(): CString

    func PHYSFS_getWriteDir(): CString

    func PHYSFS_setWriteDir(newDir: CString): Int32

    // Mounting

    func PHYSFS_mount(newDir: CString, mountPoint: CString, appendToPath: Int32): Int32

    func PHYSFS_unmount(oldDir: CString): Int32

    func PHYSFS_getMountPoint(dir: CString): CString

    func PHYSFS_getSearchPath(): CPointer<CString>

    func PHYSFS_setSaneConfig(org: CString, appName: CString, archiveExt: CString, includeCdRoms: Int32,
        archivesFirst: Int32): Int32

    // File System Operations

    func PHYSFS_mkdir(dirName: CString): Int32

    func PHYSFS_delete(filename: CString): Int32

    func PHYSFS_exists(filename: CString): Int32

    func PHYSFS_getRealDir(filename: CString): CString

    func PHYSFS_enumerateFiles(dir: CString): CPointer<CString>

    // Symbolic Links

    func PHYSFS_permitSymbolicLinks(allow: Int32): Unit

    func PHYSFS_symbolicLinksPermitted(): Int32

    // File I/O (Handles are CPointer<Unit>)

    func PHYSFS_openWrite(filename: CString): CPointer<Unit>

    func PHYSFS_openAppend(filename: CString): CPointer<Unit>

    func PHYSFS_openRead(filename: CString): CPointer<Unit>

    func PHYSFS_close(handle: CPointer<Unit>): Int32

    func PHYSFS_stat(fname: CString, stat: CPointer<PhysFSStat>): Int32

    func PHYSFS_readBytes(handle: CPointer<Unit>, buffer: CPointer<Byte>, len: UInt64): Int64

    func PHYSFS_writeBytes(handle: CPointer<Unit>, buffer: CPointer<Byte>, len: UInt64): Int64

    func PHYSFS_seek(handle: CPointer<Unit>, pos: UInt64): Int32

    func PHYSFS_eof(handle: CPointer<Unit>): Int32

    func PHYSFS_tell(handle: CPointer<Unit>): Int64

    func PHYSFS_fileLength(handle: CPointer<Unit>): Int64

    func PHYSFS_setBuffer(handle: CPointer<Unit>, bufsize: UInt64): Int32

    func PHYSFS_flush(handle: CPointer<Unit>): Int32

    // Preferences

    func PHYSFS_getPrefDir(org: CString, app: CString): CString

    // Register Archives

    func PHYSFS_registerArchiver(archiver: CPointer<PhysFSArchiver>): Int32

    func PHYSFS_deregisterArchiver(ext: CString): Int32

    func PHYSFS_setRoot(archive: CString, subdir: CString): Int32
}

public type PhysFSEnumerateCallback = CFunc<(data: CPointer<Unit>, origdir: CString, fname: CString) -> PhysFSEnumerateCallbackResult>

@CEnum[public PhysFSEnumerateCallbackResult](
    ERROR = -1 // Stop enumerating, report error to app.
    STOP = 0 // Stop enumerating, report success to app.
    OK = 1 // Keep enumerating, no problems.
)

@CEnum[public PhysFSErrorCode](
    OK // Success; no error.
    OTHER_ERROR // Error not otherwise covered here.
    OUT_OF_MEMORY // Memory allocation failed.
    NOT_INITIALIZED // PhysicsFS is not initialized.
    IS_INITIALIZED // PhysicsFS is already initialized.
    ARGV0_IS_NULL // Needed argv[0], but it is NULL.
    UNSUPPORTED // Operation or feature unsupported.
    PAST_EOF // Attempted to access past end of file.
    FILES_STILL_OPEN // Files still open.
    INVALID_ARGUMENT // Bad parameter passed to an function.
    NOT_MOUNTED // Requested archive/dir not mounted.
    NOT_FOUND // File (or whatever) not found.
    SYMLINK_FORBIDDEN // Symlink seen when not permitted.
    NO_WRITE_DIR // No write dir has been specified.
    OPEN_FOR_READING // Wrote to a file opened for reading.
    OPEN_FOR_WRITING // Read from a file opened for writing.
    NOT_A_FILE // Needed a file, got a directory (etc).
    READ_ONLY // Wrote to a read-only filesystem.
    CORRUPT // Corrupted data encountered.
    SYMLINK_LOOP // Infinite symbolic link loop.
    IO // i/o error (hardware failure, etc).
    PERMISSION // Permission denied.
    NO_SPACE // No space (disk full, over quota, etc)
    BAD_FILENAME // Filename is bogus/insecure.
    BUSY // Tried to modify a file the OS needs.
    DIR_NOT_EMPTY // Tried to delete dir with files in it.
    OS_ERROR // Unspecified OS-level error.
    DUPLICATE // Duplicate entry.
    BAD_PASSWORD // Bad password.
    APP_CALLBACK // Application callback reported error.
)

@CEnum[public PhysFSFileType](
    REGULAR // a normal file
    DIRECTORY // a directory
    SYMLINK // a symlink
    OTHER // something completely different like a device
)

@C
public struct PhysFSAllocator {
    public PhysFSAllocator(
        public let initialize!: CFunc<() -> Int32>, // Initialize. Can be NULL. Zero on failure.
        public let deinit!: CFunc<() -> Unit>, // Deinitialize your allocator. Can be NULL.
        public let malloc!: CFunc<(size: UInt64) -> CPointer<Unit>>, // Allocate like malloc().
        public let realloc!: CFunc<(ptr: CPointer<Unit>, newSize: UInt64) -> CPointer<Unit>>, // Reallocate like realloc().
        public let free!: CFunc<(ptr: CPointer<Unit>) -> Unit> // Free memory from Malloc or Realloc.
    ) {}
}

@C
public struct PhysFSArchiveInfo {
    public PhysFSArchiveInfo(
        public let extension!: CString, // Archive file extension: "ZIP", for example.
        public let description!: CString, // Human-readable archive description.
        public let author!: CString, // Person who did support for this archive.
        public let url!: CString, // URL related to this archive.
        public let supportsSymlinks!: Int32 // non-zero if archive offers symbolic links.
    ) {}

    public func getExtension(): String {
        extension.toString()
    }

    public func getDescription(): String {
        description.toString()
    }

    public func getAuthor(): String {
        author.toString()
    }

    public func getUrl(): String {
        url.toString()
    }

    public func getSupportsSymlinks(): Bool {
        supportsSymlinks != 0
    }
}

@C
public struct PhysFSArchiver {
    public PhysFSArchiver(
        public let version!: UInt32 = 0,
        public let info!: PhysFSArchiveInfo,
        public let openArchive!: CFunc<(io: CPointer<PhysFSIo>, name: CString, forWriting: Int32, claimed: CPointer<Int32>) -> CPointer<Unit>>,
        public let enumerate!: CFunc<(opaque: CPointer<Unit>, dirname: CString, cb: PhysFSEnumerateCallback, origdir: CString,
            callbackdata: CPointer<Unit>) -> PhysFSEnumerateCallbackResult>,
        public let openRead!: CFunc<(opaque: CPointer<Unit>, fileName: CString) -> CPointer<PhysFSIo>>,
        public let openWrite!: CFunc<(opaque: CPointer<Unit>, fileName: CString) -> CPointer<PhysFSIo>>,
        public let openAppend!: CFunc<(opaque: CPointer<Unit>, fileName: CString) -> CPointer<PhysFSIo>>,
        public let remove!: CFunc<(opaque: CPointer<Unit>, fileName: CString) -> Int32>,
        public let mkdir!: CFunc<(opaque: CPointer<Unit>, fileName: CString) -> Int32>,
        public let stat!: CFunc<(opaque: CPointer<Unit>, fileName: CString, stat: CPointer<PhysFSStat>) -> Int32>,
        public let closeArchive!: CFunc<(opaque: CPointer<Unit>) -> Unit>
    ) {}
}

@C
public struct PhysFSIo {
    public PhysFSIo(
        public let version!: UInt32 = 0,
        public let opaque!: CPointer<Unit>,
        public let read!: CFunc<(io: CPointer<PhysFSIo>, buffer: CPointer<Unit>, length: UInt64) -> Int64>,
        public let write!: CFunc<(io: CPointer<PhysFSIo>, buffer: CPointer<Unit>, length: UInt64) -> Int64>,
        public let seek!: CFunc<(io: CPointer<PhysFSIo>, offset: UInt64) -> Int32>,
        public let tell!: CFunc<(io: CPointer<PhysFSIo>) -> Int64>,
        public let length!: CFunc<(io: CPointer<PhysFSIo>) -> Int64>,
        public let duplicate!: CFunc<(io: CPointer<PhysFSIo>) -> CPointer<PhysFSIo>>,
        public let flush!: CFunc<(io: CPointer<PhysFSIo>) -> Int32>,
        public let destroy!: CFunc<(io: CPointer<PhysFSIo>) -> Unit>
    ) {}
}

@C
public struct PhysFSStat {
    public PhysFSStat(
        public let fileSize!: Int64 = -1, // size in bytes, -1 for non-files and unknown
        public let modTime!: Int64 = -1, // last modification time
        public let createTime!: Int64 = -1, // like modtime, but for file creation time
        public let accessTime!: Int64 = -1, // like modtime, but for file access time
        public let fileType!: PhysFSFileType = PhysFSFileType.REGULAR, // File? Directory? Symlink?
        public let readOnly!: Int32 = 1 // non-zero if read only, zero if writable.
    ) {}

    public func getFileSize(): ?Int64 {
        match (fileSize) {
            case -1 => None
            case _ => fileSize
        }
    }

    public func getModTime(): ?DateTime {
        match (modTime) {
            case -1 => None
            case _ => DateTime.fromUnixTimeStamp(modTime * Duration.second)
        }
    }

    public func getCreateTime(): ?DateTime {
        match (createTime) {
            case -1 => None
            case _ => DateTime.fromUnixTimeStamp(createTime * Duration.second)
        }
    }

    public func getAccessTime(): ?DateTime {
        match (accessTime) {
            case -1 => None
            case _ => DateTime.fromUnixTimeStamp(accessTime * Duration.second)
        }
    }

    public func isReadOnly(): Bool {
        readOnly != 0
    }
}

@C
public struct PhysFSVersion {
    public PhysFSVersion(
        public let major!: UInt8 = 0, // major revision
        public let minor!: UInt8 = 0, // minor revision
        public let patch!: UInt8 = 0 // patchlevel
    ) {}
}
