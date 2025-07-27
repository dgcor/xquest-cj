# endian

endian is a cangjie package that implements big and little endian streams.

## Classes

* EndianInputStream - current platform's endiannness class that implements InputStream
* EndianReader - current platform's endiannness class that implements InputStream & Seekable
* BigEndianInputStream - big endian class that implements InputStream
* BigEndianReader - big endian class that implements InputStream & Seekable
* LittleEndianInputStream - little endian class that implements InputStream
* LittleEndianReader - little endian class that implements InputStream & Seekable

## Macros

* ReadEndian - read value in the current platform's endianness

## Examples

### BigEndianReader

```
let data: Array<Byte> = [2, 0, 0, 0, 0, 0, 0, 2, 1, 2, 3]

let byteArrayStream = ByteArrayStream()
byteArrayStream.write(data)
let reader = LittleEndianReader(byteArrayStream)

var value = reader.read<Int32>()
@Expect(value.isSome(), true)
@Expect(value.getOrThrow(), 2)

value = reader.read()
@Expect(value.isSome(), true)
@Expect(value.getOrThrow(), 33554432)

value = reader.read()
@Expect(value.isNone(), true)
```

### ReadEndian macro

```
let arr: Array<Byte> = [2, 0, 0, 0]
let value = @ReadEndian[Int32](arr)
match (Endian.Platform) {
    case Big => @Expect(value, 33554432)
    case Little => @Expect(value, 2)
}
```

## License

MIT No Attribution
