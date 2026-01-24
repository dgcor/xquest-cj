package cjsfml.system

import std.io.SeekPosition

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestMemoryInputStream {
    let bytes: Array<Byte> = [0, 1, 2, 3, 45, 6, 78, 9, 8, 8, 8, 99, 8, 8, 112]

    @TestCase
    func empty_buffer() {
        @ExpectThrows[SFMLException](MemoryInputStream(Array<Byte>()))
    }

    @TestCase
    func read() {
        try (stream = MemoryInputStream(bytes)) {
            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, bytes.size)
            @Expect(stream.position, 0)

            var array = Array<Byte>(4, repeat: 0)
            var bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 11)
            @Expect(stream.position, 4)
            @Expect(bytesRead, 4)
            @Expect(array[0..bytesRead], [0u8, 1, 2, 3])

            bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 7)
            @Expect(stream.position, 8)
            @Expect(bytesRead, 4)
            @Expect(array[0..bytesRead], [45u8, 6, 78, 9])

            bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 3)
            @Expect(stream.position, 12)
            @Expect(bytesRead, 4)
            @Expect(array[0..bytesRead], [8u8, 8, 8, 99])

            bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 0)
            @Expect(stream.position, 15)
            @Expect(bytesRead, 3)
            @Expect(array[0..bytesRead], [8u8, 8, 112])

            bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 0)
            @Expect(stream.position, 15)
            @Expect(bytesRead, 0)
            @Expect(array, [8u8, 8, 112, 99])
        }
    }

    @TestCase
    func seek() {
        try (stream = MemoryInputStream(bytes)) {
            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, bytes.size)
            @Expect(stream.position, 0)

            var seekPos = stream.seek(End(-4))

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 4)
            @Expect(stream.position, 11)
            @Expect(seekPos, 11)

            var array = Array<Byte>(4, repeat: 0)
            var bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 0)
            @Expect(stream.position, 15)
            @Expect(bytesRead, 4)
            @Expect(array[0..bytesRead], [99u8, 8, 8, 112])

            seekPos = stream.seek(Begin(2))

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 13)
            @Expect(stream.position, 2)
            @Expect(seekPos, 2)

            bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 9)
            @Expect(stream.position, 6)
            @Expect(bytesRead, 4)
            @Expect(array[0..bytesRead], [2u8, 3, 45, 6])

            seekPos = stream.seek(Current(-1))

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 10)
            @Expect(stream.position, 5)
            @Expect(seekPos, 5)

            bytesRead = stream.read(array)

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 6)
            @Expect(stream.position, 9)
            @Expect(bytesRead, 4)
            @Expect(array[0..bytesRead], [6u8, 78, 9, 8])
        }
    }

    @TestCase
    func seek_negative() {
        try (stream = MemoryInputStream(bytes)) {
            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, bytes.size)
            @Expect(stream.position, 0)

            var seekPos = stream.seek(Begin(-2))

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, bytes.size)
            @Expect(stream.position, 0)
            @Expect(seekPos, -1)
        }
    }

    @TestCase
    func seek_past_end() {
        try (stream = MemoryInputStream(bytes)) {
            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, bytes.size)
            @Expect(stream.position, 0)

            var seekPos = stream.seek(End(1))

            @Expect(stream.length, bytes.size)
            @Expect(stream.remainLength, 0)
            @Expect(stream.position, 15)
            @Expect(seekPos, 15)
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
