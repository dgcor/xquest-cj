package customiterators

import std.collection.ArrayList

public class ReverseArrayIterator<T> <: Iterator<T> {
    private let m_array: Array<T>
    private var m_index: Int64

    public init(array: Array<T>) {
        m_array = array
        m_index = array.size - 1
    }

    public func next(): ?T {
        if (m_index < 0) {
            return None
        }
        if (m_index < m_array.size) {
            let item = m_array[m_index]
            m_index--
            return item
        }
        return None
    }
}

public class ReverseArrayListIterator<T> <: Iterator<T> {
    private let m_array: ArrayList<T>
    private var m_index: Int64

    public init(arrayList: ArrayList<T>) {
        m_array = arrayList
        m_index = arrayList.size - 1
    }

    public func next(): ?T {
        if (m_index < 0) {
            return None
        }
        if (m_index < m_array.size) {
            let item = m_array[m_index]
            m_index--
            return item
        }
        return None
    }
}

public func reverse<T>(array: Array<T>): ReverseArrayIterator<T> {
    ReverseArrayIterator<T>(array)
}

public func reverse<T>(arrayList: ArrayList<T>): ReverseArrayListIterator<T> {
    ReverseArrayListIterator<T>(arrayList)
}
