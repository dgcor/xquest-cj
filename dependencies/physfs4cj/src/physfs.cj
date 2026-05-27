package physfs4cj

import std.collection.ArrayList

extend Bool {
    func toInt32(): Int32 {
        return match (this) {
            case true => 1
            case false => 0
        }
    }
}

extend Int32 {
    func toBool(): Bool {
        return match (this) {
            case 0 => false
            case _ => true
        }
    }
}

/**
 * Represents an exception thrown by the PhysicsFS library.
 * This corresponds to errors reported by PHYSFS_getLastErrorCode().
 */
public class PhysFSException <: Exception {
    public let code: PhysFSErrorCode

    /**
     * Creates a PhysFSException with the last error reported by PhysicsFS.
     * This constructor retrieves the error code and message automatically.
     */
    public init() {
        this(PhysFS.getLastErrorCode())
    }

    /**
     * Creates a PhysFSException with a specific error code.
     *
     * @param code The specific PhysFSErrorCode.
     */
    private init(code: PhysFSErrorCode) {
        this(code, PhysFS.getErrorByCode(code))
    }

    /**
     * Creates a PhysFSException with a specific error code and message.
     *
     * @param code The specific PhysFSErrorCode.
     * @param message The error message.
     */
    public init(code: PhysFSErrorCode, message: String) {
        super(message)
        this.code = code
    }
}

/**
 * High level wrapper for PhysicsFS functionality.
 */
public class PhysFS {
    /**
     * Get the version of PhysicsFS that is linked against your program.
     *
     * @return A PhysFSVersion struct containing the major, minor, and patch versions.
     */
    public static func getLinkedVersion(): PhysFSVersion {
        var version = PhysFSVersion()
        unsafe { PHYSFS_getLinkedVersion(inout version) }
        return version
    }

    /**
     * Initialize the PhysicsFS library.
     * This must be called before any other PhysicsFS function.
     *
     * @param argv0 The argv[0] string passed to your program's mainline. This may be None on most platforms.
     *
     * @throws PhysFSException if initialization fails.
     */
    public static func initialize(argv0!: ?String = None): Unit {
        let result = match (argv0) {
            case Some(argv0) => unsafe {
                var result = 0i32
                try (argv0Res = LibC.mallocCString(argv0).asResource()) {
                    result = PHYSFS_init(argv0Res.value)
                }
                result
            }
            case None => unsafe { PHYSFS_init(CString(CPointer<UInt8>())) }
        }
        if (result == 0) {
            throw PhysFSException()
        }
    }

    /**
     * Deinitialize the PhysicsFS library.
     * This closes any files opened via PhysicsFS, blanks the search/write paths, and frees memory.
     *
     * @throws PhysFSException if deinitialization fails.
     */
    public static func deinitialize(): Unit {
        unsafe {
            let result = PHYSFS_deinit()
            if (result == 0) {
                throw PhysFSException()
            }
        }
    }

    /**
     * Discover the current allocator.
     *
     * @return The current allocator, or None if the library is not initialized.
     */
    public static func getAllocator(): ?PhysFSAllocator {
        unsafe {
            let allocatorPtr = PHYSFS_getAllocator() // cjlint-ignore !G.VAR.02 minimize scope
            if (allocatorPtr.isNotNull()) {
                let allocator = allocatorPtr.read()
                return allocator
            }
            return None
        }
    }

    /**
     * Hook your own allocation routines into PhysicsFS.
     * This allows the application to redirect PhysicsFS to use custom allocation routines.
     * You can only call this function before PHYSFS_init(); if the library is
     * initialized, it'll reject your efforts to change the allocator mid-stream.
     *
     * @param allocator Structure containing your allocator's entry points.
     *
     * @throws PhysFSException if setting the allocator fails.
     */
    public static func setAllocator(allocator: PhysFSAllocator): Unit {
        unsafe {
            var allocator2 = allocator // cjlint-ignore !G.VAR.02 minimize scope
            if (PHYSFS_setAllocator(inout allocator2) == 0) {
                throw PhysFSException()
            }
        }
    }

    /**
     * Get a list of supported archive types.
     *
     * @return An array of PhysFSArchiveInfo structures.
     */
    public static func supportedArchiveTypes(): Array<PhysFSArchiveInfo> {
        unsafe {
            let result = ArrayList<PhysFSArchiveInfo>()
            let archiveTypesPtr = PHYSFS_supportedArchiveTypes() // cjlint-ignore !G.VAR.02 minimize scope
            if (archiveTypesPtr.isNotNull()) {
                var index = 0 // cjlint-ignore !G.VAR.02 minimize scope
                while (true) {
                    let archiveTypePtr = archiveTypesPtr.read(index)
                    index++
                    if (archiveTypePtr.isNull()) {
                        break
                    }
                    let archiveType = archiveTypePtr.read()
                    result.add(archiveType)
                }
            }
            return result.toArray()
        }
    }

    /**
     * Determine if the PhysicsFS library is initialized.
     *
     * @return true if library is initialized, false if library is not.
     */
    public static func isInitialized(): Bool {
        unsafe { PHYSFS_isInit().toBool() }
    }

    /**
     * Enable or disable following of symbolic links.
     *
     * @param allow true to permit symlinks, false to deny linking.
     */
    public static func permitSymbolicLinks(allow: Bool): Unit {
        unsafe { PHYSFS_permitSymbolicLinks(allow.toInt32()) }
    }

    /**
     * Determine if the symbolic links are permitted.
     *
     * @return true if symlinks are permitted, false if not.
     */
    public static func symbolicLinksPermitted(): Bool {
        unsafe { PHYSFS_symbolicLinksPermitted().toBool() }
    }

    /**
     * Get platform-dependent dir separator string.
     *
     * @return The platform's dir separator string.
     */
    public static func getDirSeparator(): String {
        unsafe { PHYSFS_getDirSeparator().toString() }
    }

    /**
     * Get an array of paths to available CD-ROM drives.
     * Dirs are only returned if there is a disc ready and accessible in the drive.
     *
     * @return An array of strings representing CD-ROM paths.
     */
    public static func getCdRomDirs(): Array<String> {
        unsafe {
            let result = ArrayList<String>()
            let dirsPtr = PHYSFS_getCdRomDirs() // cjlint-ignore !G.VAR.02 minimize scope
            if (dirsPtr.isNotNull()) {
                try {
                    var index = 0 // cjlint-ignore !G.VAR.02 minimize scope
                    while (true) {
                        let dirPtr = dirsPtr.read(index)
                        index++
                        if (dirPtr.isNull()) {
                            break
                        }
                        result.add(dirPtr.toString())
                    }
                } finally {
                    PHYSFS_freeList(CPointer(dirsPtr)) // cjlint-ignore !FFI.C.7
                }
            }
            return result.toArray()
        }
    }

    /**
     * Get the path where the application resides.
     *
     * @return The base dir in platform-dependent notation.
     */
    public static func getBaseDir(): String {
        unsafe { PHYSFS_getBaseDir().toString() }
    }

    /**
     * Get path where PhysicsFS will allow file writing.
     *
     * @return The write dir in platform-dependent notation, or None if no write path is currently set.
     */
    public static func getWriteDir(): ?String {
        unsafe {
            let writeDirPtr = PHYSFS_getWriteDir()
            match (writeDirPtr.isNull()) {
                case false => writeDirPtr.toString()
                case true => None
            }
        }
    }

    /**
     * Tell PhysicsFS where it may write files.
     *
     * @param newDir The new directory to be the root of the write dir, specified in platform-dependent notation.
     *
     * @throws PhysFSException if setting the write directory fails.
     */
    public static func setWriteDir(newDir: ?String): Unit {
        unsafe {
            let result = match (newDir) {
                case Some(newDir) =>
                    var result = 0i32
                    try (filePathRes = LibC.mallocCString(newDir).asResource()) {
                        result = PHYSFS_setWriteDir(filePathRes.value)
                    }
                    result
                case None => PHYSFS_setWriteDir(CString(CPointer()))
            }
            if (result == 0) {
                throw PhysFSException()
            }
        }
    }

    /**
     * Add an archive or directory to the search path.
     *
     * @param newDir Directory or archive to add to the path, in platform-dependent notation.
     * @param mountPoint Location in the interpolated tree that this archive will be "mounted", in platform-independent notation.
     * @param appendToPath true to append to search path, false to prepend.
     *
     * @throws PhysFSException if mounting fails.
     */
    public static func mount(newDir: String, mountPoint!: ?String = None, appendToPath!: Bool = false): Unit {
        match (tryMount(newDir, mountPoint: mountPoint, appendToPath: appendToPath)) {
            case true => ()
            case false => throw PhysFSException()
        }
    }

    /**
     * Add an archive or directory to the search path.
     *
     * @param newDir Directory or archive to add to the path, in platform-dependent notation.
     * @param mountPoint Location in the interpolated tree that this archive will be "mounted", in platform-independent notation.
     * @param appendToPath true to append to search path, false to prepend.
     *
     * @return true if added to path, false on failure.
     */
    public static func tryMount(newDir: String, mountPoint!: ?String = None, appendToPath!: Bool = false): Bool {
        unsafe {
            let mountPoint = match (mountPoint) { // cjlint-ignore !G.VAR.02 minimize scope
                case Some(mountPoint) => mountPoint
                case None => ""
            }
            try (newDirRes = LibC.mallocCString(newDir).asResource(), mountPointRes = LibC.mallocCString(mountPoint)
                .asResource()) {
                return PHYSFS_mount(newDirRes.value, mountPointRes.value, appendToPath.toInt32()).toBool()
            }
            return false
        }
    }

    /**
     * Remove a directory or archive from the search path.
     *
     * @param oldDir Dir/archive to remove.
     *
     * @throws PhysFSException if unmounting fails.
     */
    public static func unmount(oldDir: String): Unit {
        match (tryUnmount(oldDir)) {
            case true => ()
            case false => throw PhysFSException()
        }
    }

    /**
     * Remove a directory or archive from the search path.
     *
     * @param oldDir Dir/archive to remove.
     *
     * @return true on success, false on failure.
     */
    public static func tryUnmount(oldDir: String): Bool {
        unsafe {
            try (oldDirRes = LibC.mallocCString(oldDir).asResource()) {
                return PHYSFS_unmount(oldDirRes.value).toBool()
            }
            return false
        }
    }

    /**
     * Determine a mounted archive's mountpoint.
     *
     * @param dir Directory or archive previously added to the path, in platform-dependent notation.
     *
     * @return The mount point if added to path.
     *
     * @throws PhysFSException if determining the mount point fails.
     */
    public static func getMountPoint(dir: String): String {
        unsafe {
            try (dirRes = LibC.mallocCString(dir).asResource()) {
                let strPtr = PHYSFS_getMountPoint(dirRes.value)
                if (strPtr.isNull()) {
                    throw PhysFSException()
                }
                return strPtr.toString()
            }
        }
        throw PhysFSException(PhysFSErrorCode.OTHER_ERROR, "Unknown error")
    }

    /**
     * Make a subdirectory of an archive its root directory.
     * This lets you narrow down the accessible files in a specific archive.
     *
     * @param archive dir/archive on which to change root.
     * @param subdir new subdirectory to make the root of this archive.
     *
     * @throws PhysFSException if setting the root fails.
     */
    public static func setRoot(archive: String, subdir: ?String): Unit {
        unsafe {
            try (archiveRes = LibC.mallocCString(archive).asResource()) {
                // Handle nullable subdir
                let result = match (subdir) {
                    case Some(s) =>
                        var res = 0i32
                        try (subdirRes = LibC.mallocCString(s).asResource()) {
                            res = PHYSFS_setRoot(archiveRes.value, subdirRes.value)
                        }
                        res
                    case None => PHYSFS_setRoot(archiveRes.value, CString(CPointer()))
                }

                if (result == 0) {
                    throw PhysFSException()
                }
            }
        }
    }

    /**
     * Create a directory.
     *
     * @param filePath New dir to create.
     *
     * @return true on success, false on error.
     */
    public static func mkdir(filePath: String): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                return PHYSFS_mkdir(filePathRes.value).toBool()
            }
        }
        return false
    }

    /**
     * Delete a file or directory.
     *
     * @param filePath Filename to delete.
     *
     * @throws PhysFSException if deletion fails.
     */
    public static func delete(filePath: String): Unit {
        if (!tryDelete(filePath)) {
            throw PhysFSException()
        }
    }

    /**
     * Delete a file or directory.
     *
     * @param filePath Filename to delete.
     *
     * @return true on success, false on error.
     */
    public static func tryDelete(filePath: String): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                return PHYSFS_delete(filePathRes.value).toBool()
            }
        }
        return false
    }

    /**
     * Determine if a file exists in the search path.
     *
     * @param filePath Filename in platform-independent notation.
     *
     * @return true if filename exists, false otherwise.
     */
    public static func exists(filePath: String): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                return PHYSFS_exists(filePathRes.value).toBool()
            }
        }
        return false
    }

    /**
     * Get various information about a directory or a file.
     *
     * @param fname Filename to check, in platform-indepedent notation.
     *
     * @return A PhysFSStat struct containing file metadata.
     *
     * @throws PhysFSException if stating the file fails.
     */
    public static func stat(fname: String): PhysFSStat {
        match (tryStat(fname)) {
            case Some(fileStat) => return fileStat
            case None => throw PhysFSException()
        }
    }

    /**
     * Get various information about a directory or a file.
     *
     * @param fname Filename to check, in platform-indepedent notation.
     *
     * @return A PhysFSStat struct containing file metadata, or None on failure.
     */
    public static func tryStat(fname: String): ?PhysFSStat {
        unsafe {
            try (fnameRes = LibC.mallocCString(fname).asResource()) { // cjlint-ignore !G.VAR.02 minimize scope
                var fileStat = PhysFSStat() // cjlint-ignore !G.VAR.02 minimize scope
                if (PHYSFS_stat(fnameRes.value, inout fileStat).toBool()) {
                    return fileStat
                }
            }
            return None
        }
    }

    /**
     * Figure out where in the search path a file resides.
     *
     * @param filePath File to look for.
     *
     * @return The element of search path containing the the file in question, or None if not found.
     */
    public static func getRealDir(filePath: String): ?String {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                let strPtr = PHYSFS_getRealDir(filePathRes.value) // cjlint-ignore !G.VAR.02 minimize scope
                if (!strPtr.isNull()) {
                    return strPtr.toString()
                }
            }
            return None
        }
    }

    /**
     * Get the current search path.
     *
     * @return An array of strings representing the search path.
     */
    public static func getSearchPath(): Array<String> {
        unsafe {
            let result = ArrayList<String>()
            let pathsPtr = PHYSFS_getSearchPath() // cjlint-ignore !G.VAR.02 minimize scope
            if (pathsPtr.isNotNull()) {
                try {
                    var index = 0 // cjlint-ignore !G.VAR.02 minimize scope
                    while (true) {
                        let pathPtr = pathsPtr.read(index)
                        index++
                        if (pathPtr.isNull()) {
                            break
                        }
                        result.add(pathPtr.toString())
                    }
                } finally {
                    PHYSFS_freeList(CPointer(pathsPtr)) // cjlint-ignore !FFI.C.7
                }
            }
            return result.toArray()
        }
    }

    /**
     * Get a file listing of a search path's directory.
     *
     * @param dir Directory in platform-independent notation to enumerate.
     *
     * @return An array of strings representing the files in the directory.
     */
    public static func enumerateFiles(dir: String): Array<String> {
        unsafe {
            let result = ArrayList<String>()
            try (dirRes = LibC.mallocCString(dir).asResource()) {
                let filesPtr = PHYSFS_enumerateFiles(dirRes.value) // cjlint-ignore !G.VAR.02 minimize scope
                if (filesPtr.isNotNull()) {
                    try {
                        var index = 0 // cjlint-ignore !G.VAR.02 minimize scope
                        while (true) {
                            let filePtr = filesPtr.read(index)
                            index++
                            if (filePtr.isNull()) {
                                break
                            }
                            result.add(filePtr.toString())
                        }
                    } finally {
                        PHYSFS_freeList(CPointer(filesPtr)) // cjlint-ignore !FFI.C.7
                    }
                }
            }
            return result.toArray()
        }
    }

    /**
     * Set up sane, default paths.
     *
     * @param org Name of your company/group/etc to be used as a dirname.
     * @param appName Program-specific name of your program.
     * @param archiveExt File extension used by your program to specify an archive.
     * @param includeCdRoms true to include CD-ROMs in the search path.
     * @param archivesFirst true to prepend the archives to the search path.
     *
     * @return true on success, false on error.
     */
    public static func setSaneConfig(org: String, appName: String, archiveExt: String, includeCdRoms: Bool,
        archivesFirst: Bool): Bool {
        unsafe {
            try (orgRes = LibC.mallocCString(org).asResource(), appRes = LibC.mallocCString(appName).asResource(), extRes = LibC
                .mallocCString(archiveExt).asResource()) {
                return PHYSFS_setSaneConfig(
                    orgRes.value,
                    appRes.value,
                    extRes.value,
                    includeCdRoms.toInt32(),
                    archivesFirst.toInt32()
                ).toBool()
            }
        }
        return false
    }

    /**
     * Get machine-readable error information.
     *
     * @return Enumeration value that represents last reported error.
     */
    public static func getLastErrorCode(): PhysFSErrorCode {
        unsafe { PHYSFS_getLastErrorCode() }
    }

    /**
     * Get human-readable description string for a given error code.
     *
     * @param code Error code to convert to a string.
     *
     * @return The requested error message.
     */
    public static func getErrorByCode(code: PhysFSErrorCode): String {
        unsafe { PHYSFS_getErrorByCode(code).toString() }
    }

    /**
     * Set the current thread's error code.
     *
     * @param code Error code to become the current thread's new error state.
     */
    public static func setErrorCode(code: PhysFSErrorCode): Unit {
        unsafe { PHYSFS_setErrorCode(code) }
    }

    /**
     * Get the user-and-app-specific path where files can be written.
     *
     * @param org The name of your organization.
     * @param app The name of your application.
     *
     * @return The user dir in platform-dependent notation, or None if there's a problem.
     */
    public static func getPrefDir(org: String, app: String): ?String {
        unsafe {
            try (orgRes = LibC.mallocCString(org).asResource(), appRes = LibC.mallocCString(app).asResource()) {
                let strPtr = PHYSFS_getPrefDir(orgRes.value, appRes.value) // cjlint-ignore !G.VAR.02 minimize scope
                if (!strPtr.isNull()) {
                    return strPtr.toString()
                }
            }
            return None
        }
    }

    /**
     * Add a new archiver to the system.
     *
     * @param archiver The archiver to register.
     */
    public static func registerArchiver(archiver: PhysFSArchiver): Unit {
        unsafe {
            var archiver2 = archiver
            PHYSFS_registerArchiver(inout archiver2)
        }
    }

    /**
     * Remove an archiver from the system.
     *
     * @param ext Filename extension that the archiver handles.
     *
     * @throws PhysFSException if deregistration fails.
     */
    public static func deregisterArchiver(ext: String): Unit {
        unsafe {
            try (extRes = LibC.mallocCString(ext).asResource()) { // cjlint-ignore !G.VAR.02 minimize scope
                if (PHYSFS_deregisterArchiver(extRes.value) == 0) {
                    throw PhysFSException()
                }
            }
        }
    }
}
