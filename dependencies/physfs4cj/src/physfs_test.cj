package physfs4cj

import std.fs.FileInfo

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestPhysFS {
    @BeforeAll
    func prepareData() {
        PhysFS.initialize()
        PhysFS.mount("test_data")
    }

    @AfterAll
    func cleanup() {
        PhysFS.deinitialize()
    }

    @TestCase
    func test_getLinkedVersion() {
        let version = PhysFS.getLinkedVersion()
        @Expect(version.major, 3)
        @Expect(version.minor, 3)
        @Expect(version.patch, 0)
    }

    @TestCase
    func test_supportedArchiveTypes() {
        let archiveTypes = PhysFS.supportedArchiveTypes()
        @Expect(archiveTypes.size, 2)

        @Expect(archiveTypes[0].getExtension(), "ZIP")
        @Expect(archiveTypes[0].getDescription(), "PkZip/WinZip/Info-Zip compatible")
        @Expect(archiveTypes[0].getAuthor(), "Ryan C. Gordon <icculus@icculus.org>")
        @Expect(archiveTypes[0].getUrl(), "https://icculus.org/physfs/")
        @Expect(archiveTypes[0].getSupportsSymlinks(), true)

        @Expect(archiveTypes[1].getExtension(), "7Z")
        @Expect(archiveTypes[1].getDescription(), "7zip archives")
        @Expect(archiveTypes[1].getAuthor(), "Ryan C. Gordon <icculus@icculus.org>")
        @Expect(archiveTypes[1].getUrl(), "https://icculus.org/physfs/")
        @Expect(archiveTypes[1].getSupportsSymlinks(), false)
    }

    @TestCase
    func test_isInitialized() {
        @Expect(PhysFS.isInitialized(), true)
    }

    @TestCase
    func test_symbolicLinks() {
        @Expect(PhysFS.symbolicLinksPermitted(), false)

        PhysFS.permitSymbolicLinks(true)
        @Expect(PhysFS.symbolicLinksPermitted(), true)

        PhysFS.permitSymbolicLinks(false)
        @Expect(PhysFS.symbolicLinksPermitted(), false)
    }

    @TestCase
    func test_getDirSeparator() {
        @Expect(["\\", "/"].contains(PhysFS.getDirSeparator()))
    }

    @TestCase
    func test_getBaseDir() {
        @Expect(PhysFS.getBaseDir().size > 0, true)
    }

    @TestCase
    func test_getCdRomDirs() {
        let dirs = PhysFS.getCdRomDirs()
        @Expect(dirs.size >= 0)
    }

    @TestCase
    func test_getAllocator() {
        @Expect(PhysFS.getAllocator().isSome())
    }

    @TestCase
    func test_exists() {
        @Expect(PhysFS.exists("text.txt"), true)
        @Expect(PhysFS.exists("unknown.file"), false)
    }

    @TestCase
    func test_stat() {
        @Expect(PhysFS.tryStat("unknown.file").isNone())

        var stat = PhysFS.tryStat("text.txt")
        var fileInfo = FileInfo("test_data/text.txt")
        match (stat) {
            case Some(stat) =>
                @Expect(stat.getFileSize(), Some(fileInfo.size))
                @Expect(stat.getModTime(), Some(fileInfo.lastModificationTime))
                @Expect(stat.getCreateTime(), Some(fileInfo.creationTime))
                @Expect(stat.getAccessTime(), Some(fileInfo.lastAccessTime))
                @Expect(stat.fileType == PhysFSFileType.REGULAR)
                @Expect(stat.isReadOnly() == fileInfo.isReadOnly())
            case None => @Fail("test_stat: Expected PhysFSStat for text.txt")
        }

        stat = PhysFS.tryStat("dir1")
        fileInfo = FileInfo("test_data/dir1")
        match (stat) {
            case Some(stat) =>
                @Expect(stat.getFileSize(), Some(0))
                @Expect(stat.getModTime(), Some(fileInfo.lastModificationTime))
                @Expect(stat.getCreateTime(), Some(fileInfo.creationTime))
                @Expect(stat.getAccessTime(), Some(fileInfo.lastAccessTime))
                @Expect(stat.fileType == PhysFSFileType.DIRECTORY)
                @Expect(stat.isReadOnly() == fileInfo.isReadOnly())
            case None => @Fail("test_stat: Expected PhysFSStat for dir1")
        }
    }

    @TestCase
    func test_enumerateFiles() {
        @Expect(PhysFS.enumerateFiles(""), ["dir1", "dir2", "text.txt"])
        @Expect(PhysFS.enumerateFiles("dir1"), ["file1.txt", "file2.json", "subdir1", "subdir2"])
        @Expect(PhysFS.enumerateFiles("dir1/subdir1"), ["dummy.txt"])
        @Expect(PhysFS.enumerateFiles("unknownDir").size, 0)
    }

    @TestCase
    func test_writeDir() {
        @ExpectThrows[PhysFSException](PhysFS.setWriteDir("invalidDir"))
        @Expect(PhysFS.getWriteDir(), None)

        PhysFS.setWriteDir("test_data/dir1")
        @Expect(PhysFS.getWriteDir(), Some("test_data/dir1"))

        PhysFS.setWriteDir(None)
        @Expect(PhysFS.getWriteDir(), None)
    }

    @TestCase
    func test_mount_unmount() {
        @Expect(PhysFS.tryMount("invalidDir"), false)
        @Expect(PhysFS.tryMount("test_data/dir1"), true)

        @Expect(PhysFS.tryUnmount("test_data/dir1"), true)
        @Expect(PhysFS.tryUnmount("test_data/dir1"), false)

        @ExpectThrows[PhysFSException](PhysFS.mount("invalidDir"))
        @ExpectThrows[PhysFSException](PhysFS.unmount("invalidDir"))
    }

    @TestCase
    func test_getMountPoint() {
        PhysFS.mount("test_data/dir1")
        @Expect(PhysFS.getMountPoint("test_data/dir1"), "/")

        PhysFS.unmount("test_data/dir1")
        @ExpectThrows[PhysFSException](PhysFS.getMountPoint("test_data/dir1"))
    }

    @TestCase
    func test_setRoot() {
        PhysFS.mount("test_data/dir1", mountPoint: "root_test")
        @Expect(PhysFS.exists("root_test/file1.txt"), true)
        @Expect(PhysFS.exists("root_test/subdir1"), true)

        PhysFS.setRoot("test_data/dir1", "subdir1")
        @Expect(PhysFS.exists("root_test/file1.txt"), false)
        @Expect(PhysFS.exists("root_test/dummy.txt"), true)

        PhysFS.setRoot("test_data/dir1", None)
        @Expect(PhysFS.exists("root_test/file1.txt"), true)
        @Expect(PhysFS.exists("root_test/subdir1/dummy.txt"), true)

        PhysFS.unmount("test_data/dir1")
    }

    @TestCase
    func test_mkdir_delete() {
        PhysFS.setWriteDir("test_data")

        if (PhysFS.exists("delete_test_dir")) {
            PhysFS.delete("delete_test_dir")
        }

        @Expect(PhysFS.mkdir("delete_test_dir"), true)
        @Expect(PhysFS.exists("delete_test_dir"), true)

        PhysFS.delete("delete_test_dir")
        @Expect(PhysFS.exists("delete_test_dir"), false)

        @ExpectThrows[PhysFSException](PhysFS.delete("non_existent_path_for_delete"))

        PhysFS.setWriteDir(None)
    }

    @TestCase
    func test_getRealDir() {
        let dir = PhysFS.getRealDir("text.txt") ?? ""
        @Expect(dir.contains("test_data"))

        @Expect(PhysFS.getRealDir("non_existent.file").isNone())
    }

    @TestCase
    func test_getPrefDir() {
        let dir = PhysFS.getPrefDir("MyOrg", "MyApp") ?? ""
        // @Expect(dir.contains("MyOrg"))
        @Expect(dir.contains("MyApp"))

        @Expect(PhysFS.getPrefDir("", "MyApp").isNone())
        @Expect(PhysFS.getPrefDir("MyOrg", "").isNone())
    }

    @TestCase
    func test_getError() {
        @Expect(PhysFS.tryMount("invalidDir"), false)

        var lastErrorCode = PhysFS.getLastErrorCode()
        @Expect(lastErrorCode == PhysFSErrorCode.NOT_FOUND)
        @Expect(PhysFS.getErrorByCode(lastErrorCode), "not found")

        @Expect(PhysFS.tryMount("test_data/dir1"), true)

        lastErrorCode = PhysFS.getLastErrorCode()
        @Expect(lastErrorCode == PhysFSErrorCode.OK)
        @Expect(PhysFS.getErrorByCode(lastErrorCode), "no error")

        PhysFS.unmount("test_data/dir1")
    }

    @TestCase
    func test_getSearchPath() {
        var paths = PhysFS.getSearchPath()
        @Expect(paths, ["test_data"])

        @Expect(PhysFS.tryMount("test_data/dir1", mountPoint: None, appendToPath: false), true)

        paths = PhysFS.getSearchPath()
        @Expect(paths, ["test_data/dir1", "test_data"])

        @Expect(PhysFS.tryMount("test_data/dir2", mountPoint: "", appendToPath: true), true)

        paths = PhysFS.getSearchPath()
        @Expect(paths, ["test_data/dir1", "test_data", "test_data/dir2"])

        @Expect(PhysFS.tryMount("test_data/dir1/subdir1", mountPoint: "test_data/dir2", appendToPath: true), true)

        paths = PhysFS.getSearchPath()
        @Expect(paths, ["test_data/dir1", "test_data", "test_data/dir2", "test_data/dir1/subdir1"])

        PhysFS.unmount("test_data/dir1")
        PhysFS.unmount("test_data/dir1/subdir1")
        PhysFS.unmount("test_data/dir2")

        paths = PhysFS.getSearchPath()
        @Expect(paths, ["test_data"])
    }

    @TestCase
    func test_setSaneConfig() {
        @Expect(PhysFS.setSaneConfig("MyOrg", "MyApp", "zip", false, false), true)

        let writeDir = PhysFS.getWriteDir() ?? ""
        // @Expect(writeDir.contains("MyOrg"))
        @Expect(writeDir.contains("MyApp"))

        var paths = PhysFS.getSearchPath()
        @Expect(paths.size > 0)
        @Expect(paths[0], writeDir)
    }
}

// cjlint-ignore -end function names should be lower camel case
