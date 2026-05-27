package dgengine

import cjsfml.system.*
import physfs4cj.{PhysFS, PhysFSFile, PhysFSFileType, PhysFSStat}
import std.collection.*
import std.env.*
import std.fs.*
import std.io.*

public class FileUtils {
    public static func initPhysFS(argv0!: ?String = None): Unit {
        deinitPhysFS()
        LOGGER.debug("initPhysFS")
        PhysFS.initialize(argv0: argv0)
        if (let Some(registerArchivers) <- Hooks.registerArchivers) {
            LOGGER.debug("RegisterArchivers")
            registerArchivers()
        }
        PhysFS.permitSymbolicLinks(true)
    }

    public static func deinitPhysFS(): Unit {
        if (PhysFS.isInitialized()) {
            LOGGER.debug("deinitPhysFS")
            PhysFS.deinitialize()
        }
    }

    public static func gamefileExists(filePath: String): Bool {
        try {
            var path = Path(filePath)
            if (exists(path)) {
                return true
            }
            if (path.extensionName.isEmpty() == false) {
                path = path.parent.join(path.fileNameWithoutExtension)
                if (exists(path)) {
                    return true
                }
            }
            for (ext in Defaults.ARCHIVE_EXTENSIONS) {
                let path = path.join(ext)
                if (exists(path)) {
                    return true
                }
            }
        } catch (ex: Exception) {
            LOGGER.debug("gamefileExists error: ${filePath} - ${ex}")
        }
        LOGGER.debug("gamefile doesn't exist: ${filePath}")
        return false
    }

    // concatenates physfs path and file/folder
    public static func makePhysfsPath(path: String, file: String): String {
        var filePath = path
        if (filePath.isEmpty() == false && filePath.endsWith('/') == false) {
            filePath += '/'
        }
        filePath += file
        return filePath
    }

    // concatenates local OS path and file/folder
    public static func makeSystemPath(path: String, file: String): String {
        var filePath = path
        if (filePath.isEmpty() == false && filePath.endsWith('\\') == false && filePath.endsWith('/') == false) {
            filePath += PhysFS.getDirSeparator()
        }
        filePath += file
        return filePath
    }

    // add folder or archive to the search path.
    public static func mount(filePath: String, mountPoint: String, appendToSearchPath: Bool): Bool {
        if (PhysFS.tryMount(filePath, mountPoint: mountPoint, appendToPath: appendToSearchPath)) {
            LOGGER.info("mount: \"${filePath}\" -> \"${mountPoint}\"")
            return true
        }
        var path = Path(filePath)
        if (path.extensionName.isEmpty() == false) {
            path = path.parent.join(path.fileNameWithoutExtension)
            let pathStr = path.toString()
            if (PhysFS.tryMount(pathStr, mountPoint: mountPoint, appendToPath: appendToSearchPath)) {
                LOGGER.info("mount: \"${pathStr}\" -> \"${mountPoint}\"")
                return true
            }
        }
        let pathStr = path.toString()
        for (ext in Defaults.ARCHIVE_EXTENSIONS) {
            let pathStr = pathStr + ext
            if (PhysFS.tryMount(pathStr, mountPoint: mountPoint, appendToPath: appendToSearchPath)) {
                LOGGER.info("mount: \"${pathStr}\" -> \"${mountPoint}\"")
                return true
            }
        }
        LOGGER.error('mount failed: \"${filePath}\" -> \"${mountPoint}\"')
        return false
    }

    // remove folder or archive from the search path.
    // only call after all file handles for the search path are closed.
    public static func unmount(filePath: String): Bool {
        if (PhysFS.tryUnmount(filePath)) {
            LOGGER.info("unmount: ${filePath}")
            return true
        }
        var path = Path(filePath)
        if (path.extensionName.isEmpty() == false) {
            path = path.parent.join(path.fileNameWithoutExtension)
            let pathStr = path.toString()
            if (PhysFS.tryUnmount(pathStr)) {
                LOGGER.info("unmount: \"${pathStr}\"")
                return true
            }
        }
        let pathStr = path.toString()
        for (ext in Defaults.ARCHIVE_EXTENSIONS) {
            let pathStr = pathStr + ext
            if (PhysFS.tryUnmount(pathStr)) {
                LOGGER.info("unmount: \"${pathStr}\"")
                return true
            }
        }
        LOGGER.error('unmount failed: \"${filePath}\"')
        return false
    }

    // removes all folders and archives from the search path.
    // only call after all file handles are closed.
    public static func unmountAll(): Unit {
        LOGGER.debug("unmountAll")
        initPhysFS()
    }

    public static func copyDir(dirSrcName: String, dirDstName: String): Bool {
        match (PhysFS.tryStat(dirSrcName)) {
            case Some(stat) where stat.fileType != PhysFSFileType.DIRECTORY => return false
            case None => return false
            case _ => ()
        }
        match (PhysFS.tryStat(dirDstName)) {
            case Some(stat) where stat.fileType != PhysFSFileType.DIRECTORY => return false
            case None => return false
            case _ => ()
        }

        PhysFS.mkdir(dirDstName)

        for (path in PhysFS.enumerateFiles(dirSrcName)) {
            let fullSrcPath = makePhysfsPath(dirSrcName, path)
            let fullDstPath = makePhysfsPath(dirDstName, path)
            match (PhysFS.tryStat(fullSrcPath)) {
                case Some(stat) where stat.fileType == PhysFSFileType.DIRECTORY => copyDir(fullSrcPath, fullDstPath)
                case Some(_) =>
                    // copy file (read source file and write destination)
                    try (fileRead = PhysFSFile(fullSrcPath, OpenMode.Read), fileWrite = PhysFSFile(
                    fullDstPath, OpenMode.Write)) {
                    let data = Array<Byte>(fileRead.length, repeat: 0)
                    fileRead.read(data)
                    fileWrite.write(data)
                } catch (ex: Exception) {
                    LOGGER.debug("copyDir error: ${dirSrcName} -> ${dirDstName} - ${ex}")
                }
                case None => ()
            }
        }
        return true
    }

    public static func createDir(FilePath: String): Bool {
        let success = PhysFS.mkdir(FilePath)
        LOGGER.debug("createDir (${success}): ${FilePath}")
        return success
    }

    // deletes all files in folder. if deleteRoot is false,
    // the directory "filePath" is empty, but isn't deleted.
    // if the filePath to delete is in a mount point, it will fail.
    public static func deleteAll(filePath: String, deleteRoot!: Bool = true): Bool {
        var ret = false
        match (PhysFS.tryStat(filePath)) {
            case Some(stat) where stat.fileType == PhysFSFileType.DIRECTORY =>
                if (let Some(saveDir) <- PhysFS.getWriteDir()) {
                    for (path in PhysFS.enumerateFiles(filePath)) {
                        let fullPath = makePhysfsPath(filePath, path)
                        match (PhysFS.tryStat(fullPath)) {
                            case Some(stat) where stat.fileType == PhysFSFileType.DIRECTORY => deleteAll(fullPath,
                                deleteRoot: true)
                            case Some(_) =>
                                if (let Some(realDir) <- PhysFS.getRealDir(fullPath)) {
                                    if (saveDir == realDir) {
                                        ret = PhysFS.tryDelete(fullPath)
                                    }
                                }
                            case None => ()
                        }
                    }
                }
                if (deleteRoot == true) {
                    ret = PhysFS.tryDelete(filePath)
                }
            case Some(_) => return PhysFS.tryDelete(filePath)
            case None => return false
        }
        return ret
    }

    // if the filePath to delete is in a mount point, it will fail.
    public static func deleteFile(filePath: String): Bool {
        let writeDir = PhysFS.getWriteDir()
        let realDir = PhysFS.getRealDir(filePath)
        return match ((writeDir, realDir)) {
            case (Some(writeDir), Some(realDir)) where writeDir.isEmpty() == false && writeDir == realDir => PhysFS
                .tryDelete(filePath)
            case _ => false
        }
    }

    // get list of dirs in path.
    public static func getDirList(path: String, onlyWritableDirs!: Bool): ArrayList<String> {
        let saveDir: ?String = match (onlyWritableDirs) {
            case true => PhysFS.getWriteDir()
            case false => None
        }
        let list = ArrayList<String>()
        for (dirPath in PhysFS.enumerateFiles(path)) {
            let fullPath = makePhysfsPath(path, dirPath)
            match (PhysFS.tryStat(fullPath)) {
                case Some(stat) where stat.fileType == PhysFSFileType.DIRECTORY =>
                    if (dirPath.startsWith(".")) {
                        continue
                    }
                    if (onlyWritableDirs == true) {
                        let realDir = PhysFS.getRealDir(dirPath)
                        if (realDir.isSome() && saveDir != realDir) {
                            continue
                        }
                    }
                    list.add(dirPath)
                case _ => ()
            }
        }
        return list
    }

    // get list of fileNames or fullPaths in path
    public static func getFileList(path: String, fileExt: String, getFullPath!: Bool): ArrayList<String> {
        let list = ArrayList<String>()
        for (filePath in PhysFS.enumerateFiles(path)) {
            let fullPath = makePhysfsPath(path, filePath)
            if (fullPath.endsWith(fileExt)) {
                match (PhysFS.tryStat(fullPath)) {
                    case Some(stat) where stat.fileType == PhysFSFileType.REGULAR =>
                        if (getFullPath == true) {
                            list.add(fullPath)
                        } else {
                            list.add(filePath)
                        }
                    case _ => ()
                }
            }
        }
        return list
    }

    public static func getFileName(filePath: String): String {
        Path(filePath).fileName
    }

    public static func getFileNameWithoutExt(filePath: String): String {
        try {
            let path = Path(filePath)
            if (path.fileNameWithoutExtension.isEmpty() == false) {
                return path.fileNameWithoutExtension
            }
            if (path.fileName.isEmpty() == false) {
                return path.fileName
            }
        } catch (ex: Exception) {
            LOGGER.debug("getFileNameWithoutExt error: ${filePath} - ${ex}")
        }
        return String.empty
    }

    public static func getFileExtension(filePath: String): String {
        let ext = Path(filePath).extensionName
        if (ext.isEmpty() == false) {
            return ".${ext}"
        } else if (filePath.endsWith(".")) {
            return "."
        }
        return String.empty
    }

    public static func getFilePath(filePath: String): String {
        Path(filePath).parent.toString()
    }

    public static func readBytes(filePath: String, startPosition!: Int64 = 0, maxNumBytes!: Int64 = 0xFFFFFFFF): Array<Byte> {
        var data = Array<Byte>()
        try (ifs = PhysFSStream(filePath)) {
            let fileSize = ifs.length

            let startPosition = min(startPosition, fileSize)
            let maxNumBytes = min(maxNumBytes, fileSize)
            let endPosition = min(startPosition + maxNumBytes, fileSize)

            let size = endPosition - startPosition
            if (size == 0) {
                LOGGER.debug("readBytes empty range: ${filePath}")
                return data
            }

            data = Array<Byte>(size, repeat: 0)
            if (startPosition > 0) {
                ifs.seek(Begin(startPosition))
            }
            ifs.read(data)
        } catch (ex: Exception) {
            LOGGER.debug("readBytes error: ${filePath} - ${ex}")
        }
        return data
    }

    public static func readText(filePath: String): String {
        try (ifs = PhysFSStream(filePath)) {
            let data = Array<Byte>(ifs.length, repeat: 0)
            ifs.read(data)
            return String.fromUtf8(data)
        } catch (ex: Exception) {
            LOGGER.debug("readText error: ${filePath} - ${ex}")
        }
        return String.empty
    }

    public static func getSaveDir(): ?String {
        if (let Some(writeDir) <- PhysFS.getWriteDir()) {
            return makeSystemPath(writeDir, "")
        }
        return None
    }

    public static func setSaveDir(dirName: String): Bool {
        try {
            var userDir = String.empty
            var portablePath = getWorkingDirectory().join("portable")
            if (exists(portablePath) == true) {
                portablePath = portablePath.join(dirName)
                if (exists(portablePath) == false) {
                    Directory.create(portablePath, recursive: true)
                }
                userDir = portablePath.toString()
            }

            if (userDir.isEmpty()) {
                userDir = PhysFS.getPrefDir("DGEngine", dirName) ?? ""
            }
            if (userDir.isEmpty()) {
                return false
            }
            PhysFS.setWriteDir(userDir)
            return true
        } catch (ex: Exception) {
            LOGGER.debug("setSaveDir error: ${dirName} - ${ex}")
        }
        return false
    }

    // creates path if it doesn't exist
    public static func saveBytes(filePath: String, bytes: Array<Byte>): Bool {
        try {
            let path = Path(filePath)
            if (exists(path)) {
                return true
            }
            let dir = path.parent.toString()
            if (dir.isEmpty() == false) {
                createDir(dir)
            }
            return writeBytes(filePath, bytes)
        } catch (ex: Exception) {
            LOGGER.debug("saveBytes error: ${filePath} - ${ex}")
        }
        LOGGER.warn("saveBytes failed: ${filePath}")
        return false
    }

    // creates path if it doesn't exist
    public static func saveText(filePath: String, str: String): Bool {
        unsafe {
            let rawStr = acquireArrayRawData(str.rawData())
            try {
                return saveBytes(filePath, rawStr.array)
            } finally {
                releaseArrayRawData(rawStr)
            }
        }
    }

    // writes file to a filesystem path (not to physfs's write dir path).
    public static func exportFile(infilePath: String, outfilePath: String): Bool {
        try {
            let inPath = Path(infilePath)
            var outPath = Path(outfilePath)

            if (exists(outPath) == true) {
                if (inPath.fileName.isEmpty() == false) {
                    outPath = outPath.join(inPath.fileName)
                }
            }

            let data = readBytes(infilePath)
            File.writeTo(outPath, data)
            return true
        } catch (ex: Exception) {
            LOGGER.warn("exportFile failed: \"${infilePath}\" -> \"${outfilePath}\" - ${ex}")
            LOGGER.debug("${ex}")
        }
        return false
    }

    public static func writeBytes(filePath: String, bytes: Array<Byte>): Bool {
        try (file = PhysFSFile(filePath, OpenMode.Write)) {
            file.write(bytes)
            return true
        } catch (ex: Exception) {
            LOGGER.warn("writeBytes failed: \"${filePath}\" - ${ex}")
            LOGGER.debug("${ex}")
        }
        return false
    }
}
