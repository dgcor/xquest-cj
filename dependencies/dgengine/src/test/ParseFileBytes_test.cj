package dgengine.test

import dgengine.*
import std.unittest.*

@Test
class TestParseFileBytes {
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
    func test_parseFileBytes() {
        try (game = Game()) {
            parseFile(game, "json/files.json")

            // invalid id from file
            @Expect(game.resources.getFileBytes("invalid-id").isNone())

            // id from file
            match (game.resources.getFileBytes("pal")) {
                case Some(bytes) =>
                    @Expect(bytes.size, 768)
                    @Expect(bytes[0], 0xFF)
                    @Expect(bytes[1], 0x00)
                    @Expect(bytes[2], 0x00)
                case _ => @Fail("Expected FileBytes: pal")
            }

            // binary
            match (game.resources.getFileBytes("key01")) {
                case Some(bytes) =>
                    @Expect(bytes.size, 768)
                    @Expect(bytes[0], 0xFF)
                    @Expect(bytes[1], 0x00)
                    @Expect(bytes[2], 0x00)
                case _ => @Fail("Expected FileBytes: key01")
            }

            // startPosition + bytesToRead
            match (game.resources.getFileBytes("key02")) {
                case Some(bytes) =>
                    @Expect(bytes.size, 2054)
                    @Expect(bytes[0], "2"[0])
                    @Expect(bytes[1], "5"[0])
                    @Expect(bytes[2], "5"[0])
                case _ => @Fail("Expected FileBytes: key02")
            }

            // startPosition + bytesToRead
            match (game.resources.getFileBytes("key03")) {
                case Some(bytes) =>
                    @Expect(bytes.size, 3)
                    @Expect(bytes[0], "5"[0])
                    @Expect(bytes[1], "5"[0])
                    @Expect(bytes[2], ","[0])
                case _ => @Fail("Expected FileBytes: key03")
            }

            // startPosition + bytesToRead out of range
            match (game.resources.getFileBytes("key04")) {
                case Some(bytes) =>
                    @Expect(bytes.size, 2051)
                    @Expect(bytes[0], ","[0])
                    @Expect(bytes[1], " "[0])
                    @Expect(bytes[2], "0"[0])
                case _ => @Fail("Expected FileBytes: key04")
            }

            // startPosition out of range + bytesToRead
            @Expect(game.resources.getFileBytes("key05").isNone())

            // no clone
            @Expect(game.resources.getFileBytes("key06").isNone())

            // fromId
            @Expect(game.resources.getFileBytes("pal").getOrThrow(), game.resources.getFileBytes("key07").getOrThrow())
        }
    }
}
