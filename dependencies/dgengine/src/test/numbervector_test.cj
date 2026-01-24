package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.collection.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestNumberVector {
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
    func init_default() {
        let vec = NumberVector<Int32>()

        @Expect(vec.isEmpty(), true)
        @Expect(vec.size, 0)
        @Expect(vec.get(0), 0)
        @Expect(vec.get(1), 0)
    }

    @TestCase
    func init_binary_file() {
        let vec = NumberVector<UInt8>("res/numberVector.bin")

        @Expect(vec.isEmpty(), false)
        @Expect(vec.size, 5)
        for ((index, value) in vec |> enumerate) {
            @Expect(vec.get(index), "1"[0] + UInt8(index))
        }
        @Expect(vec.get(5), 0)
    }

    @TestCase
    func init_invalid_file() {
        let vec = NumberVector<UInt8>("res/invalidFile")

        @Expect(vec.isEmpty(), true)
        @Expect(vec.size, 0)
        @Expect(vec.get(0), 0)
    }

    @TestCase
    func init_binary_file_with_max() {
        let vec = NumberVector<UInt8>("res/numberVector.bin", default: 10, maxNumElements: 2)

        @Expect(vec.isEmpty(), false)
        @Expect(vec.size, 2)
        @Expect(vec.get(0), "1"[0])
        @Expect(vec.get(1), "2"[0])
        @Expect(vec.get(2), 0)
    }

    @TestCase
    func init_text_file() {
        let vec = NumberVector<Int32>("res/numberVector.txt")

        @Expect(vec.isEmpty(), false)
        @Expect(vec.size, 5)
        @Expect(vec.get(0), 1)
        @Expect(vec.get(1), 2)
        @Expect(vec.get(2), -3)
        @Expect(vec.get(3), 1000)
        @Expect(vec.get(4), 2000)
        @Expect(vec.get(5), 0)
    }

    @TestCase
    func init_text_file_with_default_value() {
        let vec = NumberVector<Int32>("res/numberVector.txt", default: -10)

        @Expect(vec.isEmpty(), false)
        @Expect(vec.size, 5)
        @Expect(vec.get(0), 1)
        @Expect(vec.get(5), 0)
    }

    @TestCase
    func init_text_file_with_tabs_spaces_blanks() {
        let vec = NumberVector<Int32>("res/numberVector2.txt", default: -10)

        @Expect(vec.isEmpty(), false)
        @Expect(vec.size, 6)
        @Expect(vec.get(0), 1)
        @Expect(vec.get(1), 2)
        @Expect(vec.get(2), -3)
        @Expect(vec.get(3), 1000)
        @Expect(vec.get(4), -10)
        @Expect(vec.get(5), 2000)
        @Expect(vec.get(6), 0)
    }

    @TestCase
    func init_text_file_with_max() {
        let vec = NumberVector<Int32>("res/numberVector.txt", default: -10, maxNumElements: 2)

        @Expect(vec.isEmpty(), false)
        @Expect(vec.size, 2)
        @Expect(vec.get(0), 1)
        @Expect(vec.get(1), 2)
        @Expect(vec.get(2), 0)
    }

    @TestCase
    func loadBinary_valid_inputStream() {
        let data: Array<Byte> = [1, 2]
        try (inputStream = MemoryInputStream(data)) {
            let vec = NumberVector<UInt8>()
            vec.loadBinary(inputStream)

            @Expect(vec.isEmpty(), false)
            @Expect(vec.size, 2)
            @Expect(vec.get(0), 1)
            @Expect(vec.get(1), 2)
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
