package dgengine

import cjsfml.system.*
import endian.*
import std.binary.*
import std.convert.*
import std.collection.*
import std.io.{ByteBuffer, StringReader}

// loads list of numbers from file.
public class NumberVector<T> <: Collection<T> where T <: CType & LittleEndianOrder<T> & Parsable<T> {
    private var m_data: Array<T> = Array<T>()

    public init() {}

    // calls load
    public init(fileName: String, default!: T = unsafe { zeroValue<T>() }, maxNumElements!: UInt32 = UInt32.Max) {
        load(fileName, default: default, maxNumElements: maxNumElements)
    }

    // loads fileName as a text file if the file extension is .txt
    // or as a little endian binary file otherwise.
    public func load(fileName: String, default!: T = unsafe { zeroValue<T>() }, maxNumElements!: UInt32 = UInt32.Max): Unit {
        if (fileName.endsWith(".txt")) {
            loadText(fileName, default: default, maxNumElements: maxNumElements)
        } else {
            loadBinary(fileName, maxNumElements: maxNumElements)
        }
    }

    // loads a list of numbers from a little endian binary file.
    public func loadBinary(fileName: String, maxNumElements!: UInt32 = UInt32.Max): Unit {
        try (file = PhysFSStream(fileName)) {
            loadBinary(file, maxNumElements: maxNumElements)
        } catch (_: Exception) {}
    }

    // loads a list of numbers from a little endian binary fileStream.
    public func loadBinary(file: InputStream, maxNumElements!: UInt32 = UInt32.Max): Unit {
        let size = file.length
        if (size < 0 || size < Int64(sizeOf<T>())) {
            return
        }
        let numElements = min((Int64(size)) / Int64(sizeOf<T>()), Int64(maxNumElements))
        m_data = Array<T>(numElements, repeat: unsafe { zeroValue<T>() })

        let inputStream = LittleEndianReader(file)
        for (i in 0..m_data.size) {
            if (let Some(value) <- inputStream.read<T>()) {
                m_data[i] = value
            }
        }
    }

    // loads a list of numbers from a new line (\n) separated text file.
    // number separtor characters: whitespace, tab and comma
    public func loadText(fileName: String, default!: T = unsafe { zeroValue<T>() }, maxNumElements!: UInt32 = UInt32.Max): Unit {
        let byteBuffer = ByteBuffer(FileUtils.readBytes(fileName))
        let stringReader = StringReader(byteBuffer)
        let arrayList = ArrayList<T>()

        while (let Some(line) <- stringReader.readln()) {
            if (line.isEmpty() == true) {
                arrayList.add(default)
            } else {
                let numbersStr = splitString(line, "\t ,")
                for (numberStr in numbersStr) {
                    if (numberStr.isEmpty() == true) {
                        continue
                    }
                    arrayList.add(T.tryParse(numberStr) ?? default)
                    if (arrayList.size >= Int64(maxNumElements)) {
                        break
                    }
                }
            }
            if (arrayList.size >= Int64(maxNumElements)) {
                break
            }
        }
        m_data = arrayList.toArray()
    }

    public func get(index: Int64): T {
        if (index >= data.size) {
            return unsafe { zeroValue<T>() }
        } else {
            return m_data[index]
        }
    }

    public operator func [](index: Int64): T {
        m_data[index]
    }

    public func iterator(): Iterator<T> {
        m_data.iterator()
    }

    public prop size: Int64 {
        get() {
            m_data.size
        }
    }

    public func isEmpty(): Bool {
        m_data.isEmpty()
    }

    public func toArray(): Array<T> {
        m_data.toArray()
    }

    public prop data: Array<T> {
        get() {
            m_data
        }
    }
}
