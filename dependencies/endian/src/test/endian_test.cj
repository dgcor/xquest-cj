package endian.test

import endian.{BigEndianReader, EndianReader, LittleEndianReader}
import endian.utils.ReadEndian
import std.binary.LittleEndianOrder
import std.io.ByteBuffer

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

let DATA: Array<Byte> = [2, 0, 0, 0, 0, 0, 0, 2, 1, 2, 3]

@Test
class TestBigEndianReader {
    @TestCase
    func test_BigEndianReader() {
        let reader = BigEndianReader(ByteBuffer(DATA))

        @Expect(reader.position, 0)
        var value = reader.read<Int32>()
        @Expect(value.isSome(), true)
        @Expect(value.getOrThrow(), 33554432)

        @Expect(reader.position, 4)
        value = reader.peek()
        @Expect(value.isSome(), true)
        @Expect(value.getOrThrow(), 2)

        @Expect(reader.position, 4)
        value = reader.read()
        @Expect(value.isSome(), true)
        @Expect(value.getOrThrow(), 2)

        @Expect(reader.position, 8)
        value = reader.peek()
        @Expect(value.isNone(), true)

        @Expect(reader.position, 8)
        value = reader.read()
        @Expect(value.isNone(), true)
        @Expect(reader.position, DATA.size)

        @Expect(reader.position, DATA.size)
        value = reader.peek()
        @Expect(value.isNone(), true)

        @Expect(reader.position, DATA.size)
        value = reader.read()
        @Expect(value.isNone(), true)
        @Expect(reader.position, DATA.size)
    }
}

@Test
class TestLittleEndianReader {
    @TestCase
    func test_LittleEndianReader() {
        let reader = LittleEndianReader(ByteBuffer(DATA))

        @Expect(reader.position, 0)
        var value = reader.read<Int32>()
        @Expect(value.isSome(), true)
        @Expect(value.getOrThrow(), 2)

        @Expect(reader.position, 4)
        value = reader.peek()
        @Expect(value.isSome(), true)
        @Expect(value.getOrThrow(), 33554432)

        @Expect(reader.position, 4)
        value = reader.read()
        @Expect(value.isSome(), true)
        @Expect(value.getOrThrow(), 33554432)

        @Expect(reader.position, 8)
        value = reader.peek()
        @Expect(value.isNone(), true)

        @Expect(reader.position, 8)
        value = reader.read()
        @Expect(value.isNone(), true)

        @Expect(reader.position, DATA.size)
        value = reader.peek()
        @Expect(value.isNone(), true)

        @Expect(reader.position, DATA.size)
        value = reader.read()
        @Expect(value.isNone(), true)
        @Expect(reader.position, DATA.size)
    }
}

@Test
class TestEndianReader {
    @TestCase
    func test_EndianReader() {
        let reader = EndianReader(ByteBuffer(DATA))

        @Expect(reader.position, 0)
        var value = reader.read<Int32>()
        @Expect(value.isSome(), true)
        match (Endian.Platform) {
            case Big => @Expect(value.getOrThrow(), 33554432)
            case Little => @Expect(value.getOrThrow(), 2)
        }
        @Expect(value.getOrThrow(), 2)

        @Expect(reader.position, 4)
        value = reader.peek()
        @Expect(value.isSome(), true)
        match (Endian.Platform) {
            case Big => @Expect(value.getOrThrow(), 2)
            case Little => @Expect(value.getOrThrow(), 33554432)
        }

        @Expect(reader.position, 4)
        value = reader.read()
        @Expect(value.isSome(), true)
        match (Endian.Platform) {
            case Big => @Expect(value.getOrThrow(), 2)
            case Little => @Expect(value.getOrThrow(), 33554432)
        }

        @Expect(reader.position, 8)
        value = reader.read()
        @Expect(value.isNone(), true)

        @Expect(reader.position, DATA.size)
        value = reader.peek()
        @Expect(value.isNone(), true)

        @Expect(reader.position, DATA.size)
        value = reader.read()
        @Expect(value.isNone(), true)
        @Expect(reader.position, DATA.size)
    }
}

@Test
class TestReadEndian {
    @TestCase
    func ReadEndian() {
        let arr: Array<Byte> = [2, 0, 0, 0]
        let value = @ReadEndian[Int32](arr)
        match (Endian.Platform) {
            case Big => @Expect(value, 33554432)
            case Little => @Expect(value, 2)
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
