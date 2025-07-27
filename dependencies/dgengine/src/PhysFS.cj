package dgengine

import cenum.*
import cjsfml.system.*
import std.collection.*
import std.fs.*

foreign {
    func PHYSFS_init(argv0: CString): Int32

    func PHYSFS_deinit(): Int32

    func PHYSFS_freeList(listVar: CPointer<Unit>): Unit

    func PHYSFS_getDirSeparator(): CString

    func PHYSFS_permitSymbolicLinks(allow: Int32): Unit

    func PHYSFS_getWriteDir(): CString

    func PHYSFS_setWriteDir(newDir: CString): Int32

    func PHYSFS_mkdir(dirName: CString): Int32

    func PHYSFS_delete(filename: CString): Int32

    func PHYSFS_getRealDir(filename: CString): CString

    func PHYSFS_enumerateFiles(dir: CString): CPointer<CString>

    func PHYSFS_exists(filename: CString): Int32

    func PHYSFS_openWrite(filename: CString): CPointer<Unit>

    func PHYSFS_openAppend(filename: CString): CPointer<Unit>

    func PHYSFS_openRead(filename: CString): CPointer<Unit>

    func PHYSFS_close(handle: CPointer<Unit>): Int32

    func PHYSFS_tell(handle: CPointer<Unit>): Int64

    func PHYSFS_seek(handle: CPointer<Unit>, pos: UInt64): Int32

    func PHYSFS_fileLength(handle: CPointer<Unit>): Int64

    func PHYSFS_isInit(): Int32

    func PHYSFS_mount(newDir: CString, mountPoint: CString, appendToPath: Int32): Int32

    func PHYSFS_unmount(oldDir: CString): Int32

    func PHYSFS_stat(fname: CString, stat: CPointer<PhysFSStat>): Int32

    func PHYSFS_readBytes(handle: CPointer<Unit>, buffer: CPointer<Byte>, len: UInt64): Int64

    func PHYSFS_writeBytes(handle: CPointer<Unit>, buffer: CPointer<Byte>, len: UInt64): Int64

    func PHYSFS_getLastErrorCode(): Int32

    func PHYSFS_getErrorByCode(code: Int32): CString

    func PHYSFS_getPrefDir(org: CString, app: CString): CString
}

@CEnum[public PhysFSFileType](
    Regular // a normal file
    Directory // a directory
    Symlink // a symlink
    Other // something completely different like a device
)

@C
public struct PhysFSStat {
    public PhysFSStat(
        public let filesize!: Int64 = 0, // size in bytes, -1 for non-files and unknown
        public let modtime!: Int64 = 0, // last modification time
        public let createtime!: Int64 = 0, // like modtime, but for file creation time
        public let accesstime!: Int64 = 0, // like modtime, but for file access time
        public let filetype!: PhysFSFileType = PhysFSFileType.Regular, // File? Directory? Symlink?
        public let readonly!: Int32 = 0 // non-zero if read only, zero if writable.
    ) {}
}

public class PhysFS {
    public static func `init`(argv0!: ?String = None): Unit {
        deinit()
        logger.debug("initPhysFS")
        var success = match (argv0) {
            case Some(value) => unsafe {
                var ret = 0i32
                try (argv0Res = LibC.mallocCString(value).asResource()) {
                    ret = PHYSFS_init(argv0Res.value)
                }
                ret != 0
            }
            case None => unsafe { PHYSFS_init(CString(CPointer<UInt8>())) } != 0
        }
        if (success) {
            if (let Some(registerArchivers) <- Hooks.registerArchivers) {
                logger.debug("RegisterArchivers")
                registerArchivers()
            }
            unsafe { PHYSFS_permitSymbolicLinks(1) }
        }
    }

    public static func deinit(): Unit {
        unsafe {
            if (PHYSFS_isInit() != 0) {
                logger.debug("deinitPhysFS")
                PHYSFS_deinit()
            }
        }
    }

    public static func makePhysfsPath(path: String, file: String): String {
        var filePath = path
        if (filePath.isEmpty() == false && filePath.endsWith('/') == false) {
            filePath += '/'
        }
        filePath += file
        return filePath
    }

    public static func mount(filePath: String, mountPoint: String, appendToSearchPath: Bool): Bool {
        unsafe {
            try (mountPointRes = LibC.mallocCString(mountPoint).asResource()) {
                let append: Int32 = match (appendToSearchPath) {
                    case false => 0
                    case true => 1
                }
                try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                    if (PHYSFS_mount(filePathRes.value, mountPointRes.value, append) != 0) {
                        logger.info('mount: \"${filePath}\" -> \"${mountPoint}\"')
                        return true
                    }
                }
                var path = Path(filePath)
                if (path.extensionName.isEmpty() == false) {
                    path = path.parent.join(path.fileNameWithoutExtension)
                    let pathStr = path.toString()
                    try (pathRes = LibC.mallocCString(pathStr).asResource()) {
                        if (PHYSFS_mount(pathRes.value, mountPointRes.value, append) != 0) {
                            logger.info('mount: \"${pathStr}\" -> \"${mountPoint}\"')
                            return true
                        }
                    }
                }
                let pathStr = path.toString()
                for (ext in Hooks.archiveExtensions) {
                    let pathStr = pathStr + ext
                    try (pathRes = LibC.mallocCString(pathStr).asResource()) {
                        if (PHYSFS_mount(pathRes.value, mountPointRes.value, append) != 0) {
                            logger.info('mount: \"${pathStr}\" -> \"${mountPoint}\"')
                            return true
                        }
                    }
                }
            } catch (_: Exception) {
                logger.debug('mount error: \"${filePath}\" -> \"${mountPoint}\"')
            }
            logger.error('mount failed: \"${filePath}\" -> \"${mountPoint}\"')
            return false
        }
    }

    public static func unmount(filePath: String): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                if (PHYSFS_unmount(filePathRes.value) != 0) {
                    logger.info("unmount: ${filePath}")
                    return true
                }
                var path = Path(filePath)
                if (path.extensionName.isEmpty() == false) {
                    path = path.parent.join(path.fileNameWithoutExtension)
                    let pathStr = path.toString()
                    try (pathRes = LibC.mallocCString(pathStr).asResource()) {
                        if (PHYSFS_unmount(pathRes.value) != 0) {
                            logger.info("unmount: ${pathStr}")
                            return true
                        }
                    }
                }
                let pathStr = path.toString()
                for (ext in Hooks.archiveExtensions) {
                    let pathStr = pathStr + ext
                    try (pathRes = LibC.mallocCString(pathStr).asResource()) {
                        if (PHYSFS_unmount(pathRes.value) != 0) {
                            logger.info("unmount: ${pathStr}")
                            return true
                        }
                    }
                }
            } catch (_: Exception) {
                logger.debug("unmount error: ${filePath}")
            }
        }
        logger.error("unmount: ${filePath}")
        return false
    }

    public static func unmountAll(): Unit {
        logger.debug("unmountAll")
        `init`()
    }

    public static func copyDir(dirSrcName: String, dirDstName: String): Bool {
        unsafe {
            var stat: PhysFSStat = PhysFSStat()
            try (dirSrcNameRes = LibC.mallocCString(dirSrcName).asResource()) {
                if (PHYSFS_stat(dirSrcNameRes.value, inout stat) == 0 || stat.filetype != PhysFSFileType.Directory) {
                    return false
                }
                try (dirDstNameRes = LibC.mallocCString(dirDstName).asResource()) {
                    if (PHYSFS_stat(dirDstNameRes.value, inout stat) != 0 && stat.filetype != PhysFSFileType.Directory) {
                        return false
                    }
                }

                mkdir(dirDstName)

                var paths = PHYSFS_enumerateFiles(dirSrcNameRes.value)
                if (paths.isNotNull()) {
                    var index = 0
                    var fileStat: PhysFSStat = PhysFSStat()
                    while (true) {
                        let path = paths.read(index)
                        index++
                        if (path.isNull() == true) {
                            break
                        }

                        let pathStr = path.toString()
                        let fullSrcPath = makePhysfsPath(dirSrcName, pathStr)
                        let fullDstPath = makePhysfsPath(dirDstName, pathStr)

                        try (fullSrcPathRes = LibC.mallocCString(fullSrcPath).asResource()) {
                            if (PHYSFS_stat(fullSrcPathRes.value, inout fileStat) == 0) {
                                continue
                            }
                            if (fileStat.filetype == PhysFSFileType.Directory) {
                                copyDir(fullSrcPath, fullDstPath)
                            } else {
                                // copy file (read source file and write destination)
                                try (fileRead = PhysFSStream(fullSrcPath)) {
                                    try (fullDstPathRes = LibC.mallocCString(fullDstPath).asResource()) {
                                        let fileWrite = PHYSFS_openWrite(fullDstPathRes.value)
                                        if (fileWrite.isNotNull()) {
                                            try {
                                                let data = Array<Byte>(fileRead.length, repeat: 0)
                                                fileRead.read(data)
                                                let rawData = acquireArrayRawData(data)
                                                try {
                                                    PHYSFS_writeBytes(fileWrite, rawData.pointer, UInt64(data.size))
                                                } finally {
                                                    releaseArrayRawData(rawData)
                                                }
                                            } finally {
                                                PHYSFS_close(fileWrite)
                                            }
                                        }
                                    }
                                } catch (_: Exception) {}
                            }
                        }
                    }
                    PHYSFS_freeList(CPointer(paths))
                    return true
                }
            }
        }
        return false
    }

    public static func deleteAll(filePath: String, deleteRoot!: Bool): Bool {
        var ret = false
        unsafe {
            var fileStat: PhysFSStat = PhysFSStat()
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                if (PHYSFS_stat(filePathRes.value, inout fileStat) == 0) {
                    return false
                }
                if (fileStat.filetype == PhysFSFileType.Directory) {
                    let saveDir = writeDir
                    if (saveDir.isEmpty() == false) {
                        let paths = PHYSFS_enumerateFiles(filePathRes.value)
                        if (paths.isNotNull()) {
                            var index = 0
                            var fileStat: PhysFSStat = PhysFSStat()
                            while (true) {
                                let path = paths.read(index)
                                index++
                                if (path.isNull() == true) {
                                    break
                                }

                                let pathStr = path.toString()
                                let fullPath = makePhysfsPath(filePath, pathStr)

                                try (fullPathRes = LibC.mallocCString(fullPath).asResource()) {
                                    if (PHYSFS_stat(fullPathRes.value, inout fileStat) == 0) {
                                        continue
                                    }
                                    if (fileStat.filetype == PhysFSFileType.Directory) {
                                        deleteAll(fullPath, deleteRoot: true)
                                    } else {
                                        let realDir = PHYSFS_getRealDir(fullPathRes.value).toString()
                                        if (realDir.isEmpty() == false) {
                                            if (saveDir == realDir) {
                                                ret = PHYSFS_delete(fullPathRes.value) != 0
                                            }
                                        }
                                    }
                                }
                            }
                            PHYSFS_freeList(CPointer(paths))
                        }
                        if (deleteRoot == true) {
                            ret = PHYSFS_delete(filePathRes.value) != 0
                        }
                    }
                } else {
                    ret = PHYSFS_delete(filePathRes.value) != 0
                }
            }
        }
        return ret
    }

    public static func getDirList(path: String, onlyWritableDirs!: Bool): ArrayList<String> {
        var saveDir = String.empty
        if (onlyWritableDirs == true) {
            saveDir = writeDir
        }

        let list = ArrayList<String>()
        unsafe {
            var dirs = CPointer<CString>()
            try (pathRes = LibC.mallocCString(path).asResource()) {
                dirs = PHYSFS_enumerateFiles(pathRes.value)
            }
            if (dirs.isNotNull()) {
                var index = 0
                var fileStat: PhysFSStat = PhysFSStat()
                while (true) {
                    let dir = dirs.read(index)
                    index++
                    if (dir.isNull() == true) {
                        break
                    }

                    let dirStr = dir.toString()
                    let dirPath = makePhysfsPath(path, dirStr)

                    try (dirPathRes = LibC.mallocCString(dirPath).asResource()) {
                        if (PHYSFS_stat(dirPathRes.value, inout fileStat) == 0) {
                            continue
                        }
                        if (fileStat.filetype != PhysFSFileType.Directory) {
                            continue
                        }
                        if (dirStr.startsWith(".")) {
                            continue
                        }
                        if (onlyWritableDirs == true) {
                            let realDir = PHYSFS_getRealDir(dir).toString()
                            if (realDir.isEmpty() == false && saveDir != realDir) {
                                continue
                            }
                        }
                        list.add(dirStr)
                    }
                }
                PHYSFS_freeList(CPointer(dirs))
            }
        }
        return list
    }

    public static func getFileList(path: String, fileExt: String, getFullPath!: Bool): ArrayList<String> {
        let list = ArrayList<String>()
        unsafe {
            var files = CPointer<CString>()
            try (pathRes = LibC.mallocCString(path).asResource()) {
                files = PHYSFS_enumerateFiles(pathRes.value)
            }
            if (files.isNotNull()) {
                var index = 0
                var fileStat: PhysFSStat = PhysFSStat()
                while (true) {
                    let file = files.read(index)
                    index++
                    if (file.isNull() == true) {
                        break
                    }

                    let fileStr = file.toString()
                    let fullPath = makePhysfsPath(path, fileStr)

                    if (fullPath.endsWith(fileExt) == false) {
                        continue
                    }
                    try (fullPathRes = LibC.mallocCString(fullPath).asResource()) {
                        if (PHYSFS_stat(fullPathRes.value, inout fileStat) == 0) {
                            continue
                        }
                        if (fileStat.filetype == PhysFSFileType.Regular) {
                            if (getFullPath == true) {
                                list.add(fullPath)
                            } else {
                                list.add(fileStr)
                            }
                        }
                    }
                }
                PHYSFS_freeList(CPointer(files))
            }
        }
        return list
    }

    public static prop dirSeparator: String {
        get() {
            unsafe { PHYSFS_getDirSeparator().toString() }
        }
    }

    public static prop writeDir: String {
        get() {
            unsafe { PHYSFS_getWriteDir().toString() }
        }
    }

    public static func setWriteDir(filePath: ?String): Bool {
        unsafe {
            if (let Some(filePath) <- filePath) {
                try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                    return PHYSFS_setWriteDir(filePathRes.value) != 0
                }
            } else {
                return PHYSFS_setWriteDir(CString(CPointer())) != 0
            }
        }
        return false
    }

    public static func mkdir(filePath: String): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                return PHYSFS_mkdir(filePathRes.value) != 0
            }
        }
        return false
    }

    public static func delete(filePath: String): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                return PHYSFS_delete(filePathRes.value) != 0
            }
        }
        return false
    }

    public static func getRealDir(filePath: String): String {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                return PHYSFS_getRealDir(filePathRes.value).toString()
            }
        }
        return String.empty
    }

    public static func exists(filePath: String): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                return PHYSFS_exists(filePathRes.value) != 0
            }
        }
        return false
    }

    public static func writeBytes(filePath: String, bytes: Array<Byte>): Bool {
        unsafe {
            try (filePathRes = LibC.mallocCString(filePath).asResource()) {
                let file = PHYSFS_openWrite(filePathRes.value)
                if (file.isNotNull()) {
                    var bytesWritten = 0
                    try {
                        let rawData = acquireArrayRawData(bytes)
                        try {
                            bytesWritten = PHYSFS_writeBytes(file, rawData.pointer, UInt64(bytes.size))
                        } finally {
                            releaseArrayRawData(rawData)
                        }
                    } finally {
                        let success = PHYSFS_close(file) != 0
                        return success && bytesWritten == bytes.size
                    }
                }
            }
        }
        return false
    }

    public static prop lastError: String {
        get() {
            unsafe { PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()).toString() }
        }
    }

    public static func getPrefDir(org: String, app: String): String {
        unsafe {
            try (orgRes = LibC.mallocCString(org).asResource(), appRes = LibC.mallocCString(app).asResource()) {
                return PHYSFS_getPrefDir(orgRes.value, appRes.value).toString()
            }
        }
        return String.empty
    }
}
