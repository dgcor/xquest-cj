package dgengine.test

import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestFileUtils {
    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)
    }

    @AfterAll
    func cleanup() {
        FileUtils.deinitPhysFS()
    }

    @TestCase
    func test_exists() {
        @Expect(FileUtils.exists("text.txt"), true)
        @Expect(FileUtils.exists("unknown.file"), false)
    }

    @TestCase
    func test_makePhysfsPath() {
        @Expect(FileUtils.makePhysfsPath("", "file.txt"), "file.txt")
        @Expect(FileUtils.makePhysfsPath(".", "file.txt"), "./file.txt")
        @Expect(FileUtils.makePhysfsPath("path", "file.txt"), "path/file.txt")
        @Expect(FileUtils.makePhysfsPath("path/", "file.txt"), "path/file.txt")
        @Expect(FileUtils.makePhysfsPath("path\\", "file.txt"), "path\\/file.txt")
    }

    @TestCase
    func test_makeSystemPath() {
        @Expect(FileUtils.makeSystemPath("", "file.txt"), "file.txt")
        @Expect(FileUtils.makeSystemPath(".", "file.txt"), ".${PhysFS.getDirSeparator()}file.txt")
        @Expect(FileUtils.makeSystemPath("path", "file.txt"), "path${PhysFS.getDirSeparator()}file.txt")
        @Expect(FileUtils.makeSystemPath("path/", "file.txt"), "path/file.txt")
        @Expect(FileUtils.makeSystemPath("path\\", "file.txt"), "path\\file.txt")
    }

    @TestCase
    func test_getDirList() {
        @Expect(FileUtils.getDirList("", onlyWritableDirs: false).toArray(), ["dir1", "dir2", "json", "res"])
        @Expect(FileUtils.getDirList("dir1", onlyWritableDirs: false).toArray(), ["subdir1", "subdir2"])
        @Expect(FileUtils.getDirList("unknownDir", onlyWritableDirs: false).isEmpty(), true)
    }

    @TestCase
    func test_getFileList() {
        @Expect(FileUtils.getFileList("", "", getFullPath: false).toArray(), ["text.txt"])
        @Expect(FileUtils.getFileList("dir1", "", getFullPath: false).toArray(), ["file1.txt", "file2.json"])
        @Expect(FileUtils.getFileList("dir1", "txt", getFullPath: false).toArray(), ["file1.txt"])
        @Expect(FileUtils.getFileList("dir1", ".txt", getFullPath: false).toArray(), ["file1.txt"])
        @Expect(FileUtils.getFileList("dir1", "file1.txt", getFullPath: false).toArray(), ["file1.txt"])
        @Expect(FileUtils.getFileList("dir1", "TXT", getFullPath: false).isEmpty(), true)
        @Expect(FileUtils.getFileList("dir1", "json", getFullPath: false).toArray(), ["file2.json"])
        @Expect(FileUtils.getFileList("dir1", "json", getFullPath: true).toArray(), ["dir1/file2.json"])
    }

    @TestCase
    func test_getFileName() {
        @Expect(FileUtils.getFileName("file1"), "file1")
        @Expect(FileUtils.getFileName("file1.txt"), "file1.txt")
        @Expect(FileUtils.getFileName("/mnt/file1.txt"), "file1.txt")
        @Expect(FileUtils.getFileName("../file1.txt"), "file1.txt")
        @Expect(FileUtils.getFileName("../.txt"), ".txt")
    }

    @TestCase
    func test_getFileNameWithoutExt() {
        @Expect(FileUtils.getFileNameWithoutExt("file1"), "file1")
        @Expect(FileUtils.getFileNameWithoutExt("file1.txt"), "file1")
        @Expect(FileUtils.getFileNameWithoutExt("/mnt/file1.txt"), "file1")
        @Expect(FileUtils.getFileNameWithoutExt("../file1.txt"), "file1")
        @Expect(FileUtils.getFileNameWithoutExt("../.txt"), ".txt")
    }

    @TestCase
    func test_getFileExtension() {
        @Expect(FileUtils.getFileExtension("file1"), "")
        @Expect(FileUtils.getFileExtension("file1 "), "")
        @Expect(FileUtils.getFileExtension("file1."), ".")
        @Expect(FileUtils.getFileExtension("file1. "), ". ")
        @Expect(FileUtils.getFileExtension("file1.txt"), ".txt")
        @Expect(FileUtils.getFileExtension("/mnt/file1.txt"), ".txt")
        @Expect(FileUtils.getFileExtension("../file1.txt"), ".txt")
    }

    @TestCase
    func test_getFilePath() {
        @Expect(FileUtils.getFilePath("file1.txt"), "")
        @Expect(FileUtils.getFilePath("/mnt/file1.txt"), "/mnt")
        @Expect(FileUtils.getFilePath("../file1.txt"), "..")
        @Expect(FileUtils.getFilePath("dir1/../dir1/file1.txt"), "dir1/../dir1")
    }

    @TestCase
    func test_readBytes_filename() {
        var bytes = FileUtils.readBytes("text.txt")
        @Expect(bytes, [116u8, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 120, 116, 46, 10])

        bytes = FileUtils.readBytes("unknown.file")
        @Expect(bytes.isEmpty(), true)
    }

    @TestCase
    func test_readBytes_filename_maxNumBytes() {
        var bytes = FileUtils.readBytes("text.txt", maxNumBytes: 0)
        @Expect(bytes.isEmpty(), true)

        bytes = FileUtils.readBytes("text.txt", maxNumBytes: 2)
        @Expect(bytes, [116u8, 104])

        bytes = FileUtils.readBytes("text.txt", maxNumBytes: 50)
        @Expect(bytes, [116u8, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 120, 116, 46, 10])

        bytes = FileUtils.readBytes("unknown.file", maxNumBytes: 0)
        @Expect(bytes.isEmpty(), true)

        bytes = FileUtils.readBytes("unknown.file", maxNumBytes: 2)
        @Expect(bytes.isEmpty(), true)
    }

    @TestCase
    func test_readBytes_filename_startPosition_maxNumBytes() {
        var bytes = FileUtils.readBytes("text.txt", startPosition: 2, maxNumBytes: 0)
        @Expect(bytes.isEmpty(), true)

        bytes = FileUtils.readBytes("text.txt", startPosition: 2, maxNumBytes: 2)
        @Expect(bytes, [105u8, 115])

        bytes = FileUtils.readBytes("text.txt", startPosition: 15, maxNumBytes: 2)
        @Expect(bytes, [10u8])

        bytes = FileUtils.readBytes("text.txt", startPosition: 2, maxNumBytes: 50)
        @Expect(bytes, [105u8, 115, 32, 105, 115, 32, 97, 32, 116, 101, 120, 116, 46, 10])

        bytes = FileUtils.readBytes("text.txt", startPosition: 50, maxNumBytes: 0)
        @Expect(bytes.isEmpty(), true)

        bytes = FileUtils.readBytes("text.txt", startPosition: 50, maxNumBytes: 2)
        @Expect(bytes.isEmpty(), true)

        bytes = FileUtils.readBytes("unknown.file", startPosition: 0, maxNumBytes: 2)
        @Expect(bytes.isEmpty(), true)

        bytes = FileUtils.readBytes("unknown.file", startPosition: 2, maxNumBytes: 2)
        @Expect(bytes.isEmpty(), true)
    }

    @TestCase
    func test_readText() {
        const str = "this is a text.\n"

        @Expect(FileUtils.readText("text.txt"), str)
        @Expect(FileUtils.readText("unknown.file"), "")
    }

    @TestCase
    func test_saveDir_uninitialized() {
        @Expect(PhysFS.setWriteDir(None), true)
        @Expect(FileUtils.getSaveDir(), "")
    }

    @TestCase
    func test_saveDir_initialized() {
        @Expect(FileUtils.setSaveDir("invalidDir"), true)
        @Expect(FileUtils.getSaveDir().endsWith("invalidDir" + PhysFS.getDirSeparator()), true)
        @Expect(FileUtils.setSaveDir("dir1"), true)
        @Expect(FileUtils.getSaveDir().endsWith("dir1" + PhysFS.getDirSeparator()), true)
        @Expect(FileUtils.setSaveDir(""), false)
        @Expect(FileUtils.getSaveDir().endsWith("dir1" + PhysFS.getDirSeparator()), true)
    }

    @TestCase
    func test_CRUD() {
        // initialize

        @Expect(FileUtils.setSaveDir("dir1"), true)

        // create dir

        @Expect(FileUtils.createDir("newDir"), true)
        @Expect(FileUtils.createDir("newDir/subDir"), true)
        @Expect(FileUtils.exists("newDir"), false)
        @Expect(FileUtils.exists("newDir/subDir"), false)

        // mount save dir

        @Expect(FileUtils.mount(FileUtils.getSaveDir(), "save", false), true)
        @Expect(FileUtils.exists("save/newDir"), true)
        @Expect(FileUtils.exists("save/newDir/subDir"), true)

        // create files

        var bytes: Array<Byte> = [1, 2, 3]

        @Expect(FileUtils.saveBytes("newFile.bin", bytes), true)
        @Expect(FileUtils.exists("save/newFile.bin"), true)

        @Expect(FileUtils.saveText("newFile.txt", "saving text..."), true)
        @Expect(FileUtils.exists("save/newFile.txt"), true)

        // read files

        var bytesRead = FileUtils.readBytes("save/newFile.bin")
        @Expect(bytesRead, bytes)

        @Expect(FileUtils.readText("save/newFile.txt"), "saving text...")

        // read save dir

        @Expect(FileUtils.getDirList("", onlyWritableDirs: false).toArray(), ["dir1", "dir2", "json", "res", "save"])
        @Expect(FileUtils.getDirList("", onlyWritableDirs: true).toArray(), ["save"])
        @Expect(FileUtils.getDirList("save", onlyWritableDirs: false).toArray(), ["newDir"])
        @Expect(FileUtils.getDirList("save", onlyWritableDirs: true).toArray(), ["newDir"])

        // overwrite files"

        bytes = [4, 5, 6]

        @Expect(FileUtils.saveBytes("newFile.bin", bytes), true)
        @Expect(FileUtils.exists("save/newFile.bin"), true)

        @Expect(FileUtils.saveText("newFile.txt", "updating text..."), true)
        @Expect(FileUtils.exists("save/newFile.txt"), true)

        // read files

        bytesRead = FileUtils.readBytes("save/newFile.bin")
        @Expect(bytesRead, bytes)

        @Expect(FileUtils.readText("save/newFile.txt"), "updating text...")

        // delete files

        @Expect(FileUtils.deleteFile("save/invalidFile.txt"), false)
        @Expect(FileUtils.deleteFile("save/newFile.bin"), false)

        // save dir should only be mounted in "", so unmount "save" mountPoint and mount it in ""
        @Expect(FileUtils.unmount(FileUtils.getSaveDir()), true)
        @Expect(FileUtils.mount(FileUtils.getSaveDir(), "", false), true)

        @Expect(FileUtils.getDirList("", onlyWritableDirs: false).toArray(), ["dir1", "dir2", "json", "newDir", "res"])
        @Expect(FileUtils.getDirList("", onlyWritableDirs: true).toArray(), ["newDir"])
        @Expect(FileUtils.getDirList("newDir", onlyWritableDirs: false).toArray(), ["subDir"])
        @Expect(FileUtils.getDirList("newDir", onlyWritableDirs: true).toArray(), ["subDir"])

        @Expect(FileUtils.exists("newDir"), true)
        @Expect(FileUtils.exists("newFile.bin"), true)

        @Expect(FileUtils.deleteFile("newFile.bin"), true)

        @Expect(FileUtils.exists("newFile.bin"), false)
        @Expect(FileUtils.exists("newFile.txt"), true)

        @Expect(FileUtils.deleteAll("", deleteRoot: false), true)

        @Expect(FileUtils.exists("newDir"), false)
        @Expect(FileUtils.exists("newFile.txt"), false)
        @Expect(FileUtils.exists("text.txt"), true)

        // unmount save dir

        @Expect(FileUtils.unmount(FileUtils.getSaveDir()), true)
        @Expect(FileUtils.exists("text.txt"), true)
    }
}

// cjlint-ignore -end function names should be lower camel case
