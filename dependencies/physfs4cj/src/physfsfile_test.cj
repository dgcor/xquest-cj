package physfs4cj

import std.fs.OpenMode
import std.io.SeekPosition

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestPhysFSFile {
    @BeforeAll
    func prepareData() {
        PhysFS.initialize()
        PhysFS.mount("test_data")
        PhysFS.setWriteDir("test_data")
    }

    @AfterAll
    func cleanup() {
        PhysFS.deinitialize()
    }

    @TestCase
    func test_read_existing_file() {
        try (file = PhysFSFile("text.txt", OpenMode.Read)) {
            @Expect(!file.isClosed())

            let buffer = Array<Byte>(16, repeat: 0)
            let count = file.read(buffer)

            @Expect(count == 16)
            @Expect(String.fromUtf8(buffer), "this is a text.\n")

            // Read again to check position/EOF behavior
            let count2 = file.read(buffer)
            // If file was smaller than buffer, second read is likely 0 (EOF)
            // If exact fit, depends on implementation, but usually safe to expect 0 eventually
            // For a small text file, we expect 0 now.
            @Expect(count2 == 0)
        }
    }

    @TestCase
    func test_write_and_verify() {
        let filename = "dir1/test_write_io.txt"
        let content = "PhysFS Write Test\n"
        let contentBytes = content.toArray()

        // 1. Write
        try (writeFile = PhysFSFile(filename, OpenMode.Write)) {
            writeFile.write(contentBytes)
            writeFile.flush()
        }

        // 2. Verify content by reading back
        try (readFile = PhysFSFile(filename, OpenMode.Read)) {
            let buffer = Array<Byte>(contentBytes.size, repeat: 0)
            let count = readFile.read(buffer)

            @Expect(count == contentBytes.size)
            @Expect(String.fromUtf8(buffer), content)
        }
        // Cleanup
        PhysFS.delete(filename)
    }

    @TestCase
    func test_seek_and_tell() {
        try (file = PhysFSFile("dir1/file2.json", OpenMode.Read)) {
            file.seek(Begin(5))
            @Expect(file.position == 5)

            let buffer = Array<Byte>(1, repeat: 0)
            file.read(buffer)
            @Expect(buffer, "y".toArray())

            file.seek(Current(2))
            @Expect(file.position == 8)
        }
    }

    @TestCase
    func test_seek_end() {
        try (file = PhysFSFile("text.txt", OpenMode.Read)) {
            file.seek(End(-6))
            @Expect(file.position == 10)

            let buffer = Array<Byte>(6, repeat: 0)
            let count = file.read(buffer)
            @Expect(count == 6)
            @Expect(String.fromUtf8(buffer), "text.\n")
        }
    }

    @TestCase
    func test_seek_begin_rewrite() {
        let filename = "dir1/test_seek_rewrite.txt"
        let initialContent = "AAAA"
        let overwriteContent = "BB"

        // Write initial content
        try (file = PhysFSFile(filename, OpenMode.Write)) {
            file.write(initialContent.toArray())
        }

        // Reopen for writing (which truncates usually, but let's test append/write mix or just seek in Write mode)
        // Note: PhysicsFS Write mode usually truncates.
        // To test seek-in-write, we need to use Append or ensure Write mode doesn't truncate immediately on open.
        // However, standard behavior for "Write" is create/truncate.
        // Let's test Append mode seeking.
        try (file = PhysFSFile(filename, OpenMode.Append)) {
            // Appending "BB" to "AAAA"
            file.write(overwriteContent.toArray())
        }

        try (file = PhysFSFile(filename, OpenMode.Read)) {
            let buffer = Array<Byte>(6, repeat: 0)
            file.read(buffer)
            @Expect(String.fromUtf8(buffer), "AAAABB")
        }

        // Now test seeking backwards in a file opened for modification (if supported, usually Append allows seek)
        // Let's test Read-Modify-Write simulation (Read, seek, Write not directly supported in one handle easily in PhysFS without specific setup, usually separate handles)
        // But we can test Seek on a Write handle.
        try (file = PhysFSFile(filename, OpenMode.Write)) {
            // This overwrites the file.
            file.write("123456".toArray())
            // Seek back to start and write
            file.seek(Begin(0))
            file.write("XX".toArray())
        }

        try (file = PhysFSFile(filename, OpenMode.Read)) {
            let buffer = Array<Byte>(6, repeat: 0)
            file.read(buffer)
            @Expect(String.fromUtf8(buffer), "XX3456")
        }

        PhysFS.delete(filename)
    }

    @TestCase
    func test_seek_relative_negative() {
        try (file = PhysFSFile("text.txt", OpenMode.Read)) {
            var buffer = Array<Byte>(4, repeat: 0)
            file.read(buffer)
            @Expect(file.position == 4)

            file.seek(Current(-2))
            @Expect(file.position == 2)

            buffer = Array<Byte>(2, repeat: 0)
            file.read(buffer)
            @Expect(String.fromUtf8(buffer), "is")
        }
    }

    @TestCase
    func test_seek_past_eof() {
        // PhysFS allows seeking past the end of a file in write mode (extends file),
        // but behavior in read mode is usually to just move the pointer or fail.
        // Let's check if it allows setting position past end in Read mode.
        try (file = PhysFSFile("text.txt", OpenMode.Read)) {
            file.seek(Begin(100))
            @Expect(file.position == 100)

            // Reading at EOF should return 0 bytes
            let buffer = Array<Byte>(10, repeat: 0)
            let count = file.read(buffer)
            @Expect(count == 0)
        }
    }

    @TestCase
    func test_length_and_remain() {
        try (file = PhysFSFile("text.txt", OpenMode.Read)) {
            @Expect(file.length == 16)
            @Expect(file.remainLength == 16)

            file.seek(Begin(10))
            @Expect(file.length == 16)
            @Expect(file.remainLength == 6)
        }
    }

    @TestCase
    func test_open_non_existent_throws() {
        @ExpectThrows[PhysFSException](PhysFSFile("invalidFile.txt", OpenMode.Read))
    }

    @TestCase
    func test_read_from_write_only_throws() {
        let filename = "dir1/test_ro.txt"
        try (file = PhysFSFile(filename, OpenMode.Write)) {
            let buffer = Array<Byte>(10, repeat: 0)
            @ExpectThrows[PhysFSException](file.read(buffer))
        }
        PhysFS.delete(filename)
    }
}

// cjlint-ignore -end function names should be lower camel case
