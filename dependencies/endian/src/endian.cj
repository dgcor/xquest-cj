package endian

import endian.utils.ReadEndian
import std.binary.{BigEndianOrder, LittleEndianOrder}
import std.io.{InputStream, Seekable, SeekPosition}

/**
 * @brief Reads a value from a seekable stream in the platform's native endianness without advancing the stream position.
 *
 * This function reads the bytes required for type `U`, rewinds the stream,
 * and deserializes the value using the native byte order.
 *
 * @param seekableStream The stream to read from. Must be seekable.
 *
 * @return The read value, or `None` if the end of stream was reached or an error occurred.
 */
private func peekEndian<T, U>(seekableStream: T): ?U where T <: InputStream & Seekable,
    U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    let readBytes = seekableStream.read(buffer)
    if (readBytes > 0) {
        seekableStream.seek(Current(-readBytes))
    }
    if (readBytes == buffer.size) {
        return @ReadEndian[U](buffer)
    }
    return None
}

/**
 * @brief Reads a value from a seekable stream in Big Endian format without advancing the stream position.
 *
 * @param seekableStream The stream to read from.
 *
 * @return The read value, or `None` if the read failed.
 */
private func peekBigEndian<T, U>(seekableStream: T): ?U where T <: InputStream & Seekable,
    U <: CType & BigEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    let readBytes = seekableStream.read(buffer)
    if (readBytes > 0) {
        seekableStream.seek(Current(-readBytes))
    }
    if (readBytes == buffer.size) {
        return U.readBigEndian(buffer)
    }
    return None
}

/**
 * @brief Reads a value from a seekable stream in Little Endian format without advancing the stream position.
 *
 * @param seekableStream The stream to read from.
 *
 * @return The read value, or `None` if the read failed.
 */
private func peekLittleEndian<T, U>(seekableStream: T): ?U where T <: InputStream & Seekable,
    U <: CType & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    let readBytes = seekableStream.read(buffer)
    if (readBytes > 0) {
        seekableStream.seek(Current(-readBytes))
    }
    if (readBytes == buffer.size) {
        return U.readLittleEndian(buffer)
    }
    return None
}

/**
 * @brief Reads a value from an input stream in the platform's native endianness.
 *
 * @param inputStream The stream to read from.
 *
 * @return The read value, or `None` if the end of stream was reached.
 */
private func readEndian<U>(inputStream: InputStream): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return @ReadEndian[U](buffer)
    }
    return None
}

/**
 * @brief Reads a value from an input stream in Big Endian format.
 *
 * @param inputStream The stream to read from.
 *
 * @return The read value, or `None` if the read failed.
 */
private func readBigEndian<U>(inputStream: InputStream): ?U where U <: CType & BigEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return U.readBigEndian(buffer)
    }
    return None
}

/**
 * @brief Reads a value from an input stream in Little Endian format.
 *
 * @param inputStream The stream to read from.
 *
 * @return The read value, or `None` if the read failed.
 */
private func readLittleEndian<U>(inputStream: InputStream): ?U where U <: CType & LittleEndianOrder<U> {
    let buffer = Array<Byte>(Int64(sizeOf<U>()), repeat: 0)
    if (inputStream.read(buffer) == buffer.size) {
        return U.readLittleEndian(buffer)
    }
    return None
}

/**
 * @brief Endian reader base class that implements both InputStream and Seekable interfaces.
 *
 * This class wraps an input stream that is also seekable, providing the foundation
 * for readers that need to change position within the stream.
 *
 * @param T The type of the underlying input stream, which must implement both `InputStream` and `Seekable`.
 */
public abstract class BaseEndianReader<T> <: InputStream & Seekable where T <: InputStream & Seekable {
    protected let inputStream: T

    /**
     * @brief Constructs a new `BaseEndianReader` wrapping the provided stream.
     *
     * @param input The underlying input stream.
     */
    public init(input: T) {
        inputStream = input
    }

    /**
     * @brief Reads raw bytes from the underlying stream into the buffer.
     *
     * @param buffer The buffer to read data into.
     *
     * @return The number of bytes read.
     */
    public override func read(buffer: Array<UInt8>): Int64 {
        inputStream.read(buffer)
    }

    public override prop length: Int64 {
        get() {
            inputStream.length
        }
    }

    public override prop position: Int64 {
        get() {
            inputStream.position
        }
    }

    public override prop remainLength: Int64 {
        get() {
            inputStream.remainLength
        }
    }

    /**
     * @brief Seeks to a specific position in the underlying stream.
     *
     * @param sp The position to seek to.
     *
     * @return The new position in the stream.
     */
    public override func seek(sp: SeekPosition): Int64 {
        inputStream.seek(sp)
    }
}

/**
 * @brief Endian reader base class that implements the InputStream interface.
 *
 * This class wraps a standard input stream, providing the foundation for
 * readers that only need sequential access.
 *
 * @param T The type of the underlying input stream.
 */
public abstract class BaseEndianInputStream<T> <: InputStream where T <: InputStream {
    protected let inputStream: T

    /**
     * @brief Constructs a new `BaseEndianInputStream` wrapping the provided stream.
     *
     * @param input The underlying input stream.
     */
    public init(input: T) {
        inputStream = input
    }

    /**
     * @brief Reads raw bytes from the underlying stream into the buffer.
     *
     * @param buffer The buffer to read data into.
     *
     * @return The number of bytes read.
     */
    public override func read(buffer: Array<UInt8>): Int64 {
        inputStream.read(buffer)
    }
}

/**
 * @brief Native endian reader class for streamable and seekable objects (current system endian).
 *
 * This class provides methods to read values in the system's native byte order,
 * as well as explicitly in Big or Little Endian formats, while supporting seeking.
 *
 * @param T The type of the underlying stream.
 */
public class EndianReader<T> <: BaseEndianReader<T> where T <: InputStream & Seekable {
    public init(input: T) {
        super(input)
    }

    /**
     * @brief Peeks a value of type `U` in native endianness without advancing the stream position.
     *
     * @return The peeked value, or `None` if reading failed.
     */
    public func peek<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        peekEndian(inputStream)
    }

    /**
     * @brief Peeks a value of type `U` in Big Endian format without advancing the stream position.
     *
     * @return The peeked value, or `None` if reading failed.
     */
    public func peekBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        peekBigEndian(inputStream)
    }

    /**
     * @brief Peeks a value of type `U` in Little Endian format without advancing the stream position.
     *
     * @return The peeked value, or `None` if reading failed.
     */
    public func peekLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        peekLittleEndian(inputStream)
    }

    /**
     * @brief Reads a value of type `U` in native endianness from the stream.
     *
     * @return The read value, or `None` if the end of stream was reached.
     */
    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        readEndian(inputStream)
    }

    /**
     * @brief Reads a value of type `U` in Big Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func readBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }

    /**
     * @brief Reads a value of type `U` in Little Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func readLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}

/**
 * @brief Native endian class for streamable objects (current system endian).
 *
 * This class provides methods to read values in the system's native byte order
 * from a sequential input stream.
 *
 * @param T The type of the underlying stream.
 */
public class EndianInputStream<T> <: BaseEndianInputStream<T> where T <: InputStream {
    public init(input: T) {
        super(input)
    }

    /**
     * @brief Reads a value of type `U` in native endianness from the stream.
     *
     * @return The read value, or `None` if the end of stream was reached.
     */
    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> & LittleEndianOrder<U> {
        readEndian(inputStream)
    }

    /**
     * @brief Reads a value of type `U` in Big Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func readBigEndian<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }

    /**
     * @brief Reads a value of type `U` in Little Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func readLittleEndian<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}

/**
 * @brief Big endian reader class for streamable and seekable objects.
 *
 * This class provides methods to read values in Big Endian format
 * from a seekable input stream.
 *
 * @param T The type of the underlying stream.
 */
public class BigEndianReader<T> <: BaseEndianReader<T> where T <: InputStream & Seekable {
    public init(input: T) {
        super(input)
    }

    /**
     * @brief Peeks a value of type `U` in Big Endian format without advancing the stream position.
     *
     * @return The peeked value, or `None` if reading failed.
     */
    public func peek<U>(): ?U where U <: CType & BigEndianOrder<U> {
        peekBigEndian(inputStream)
    }

    /**
     * @brief Reads a value of type `U` in Big Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }
}

/**
 * @brief Big endian class for streamable objects.
 *
 * This class provides methods to read values in Big Endian format
 * from a sequential input stream.
 *
 * @param T The type of the underlying stream.
 */
public class BigEndianInputStream<T> <: BaseEndianInputStream<T> where T <: InputStream {
    public init(input: T) {
        super(input)
    }

    /**
     * @brief Reads a value of type `U` in Big Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func read<U>(): ?U where U <: CType & BigEndianOrder<U> {
        readBigEndian(inputStream)
    }
}

/**
 * @brief Little endian class for streamable and seekable objects.
 *
 * This class provides methods to read values in Little Endian format
 * from a seekable input stream.
 *
 * @param T The type of the underlying stream.
 */
public class LittleEndianReader<T> <: BaseEndianReader<T> where T <: InputStream & Seekable {
    public init(input: T) {
        super(input)
    }

    /**
     * @brief Peeks a value of type `U` in Little Endian format without advancing the stream position.
     *
     * @return The peeked value, or `None` if reading failed.
     */
    public func peek<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        peekLittleEndian(inputStream)
    }

    /**
     * @brief Reads a value of type `U` in Little Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func read<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}

/**
 * @brief Little endian class for streamable objects.
 *
 * This class provides methods to read values in Little Endian format
 * from a sequential input stream.
 *
 * @param T The type of the underlying stream.
 */
public class LittleEndianInputStream<T> <: BaseEndianInputStream<T> where T <: InputStream {
    public init(input: T) {
        super(input)
    }

    /**
     * @brief Reads a value of type `U` in Little Endian format from the stream.
     *
     * @return The read value, or `None` if reading failed.
     */
    public func read<U>(): ?U where U <: CType & LittleEndianOrder<U> {
        readLittleEndian(inputStream)
    }
}
