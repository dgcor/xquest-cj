package customiterators

import std.collection.ArrayList

/**
 * @brief An iterator that traverses an `Array` in reverse order.
 *
 * @param T The type of elements in the array.
 */
public class ReverseArrayIterator<T> <: Iterator<T> {
    private let m_array: Array<T>
    private var m_index: Int64

    /**
     * @brief Constructs a new `ReverseArrayIterator` for the given array.
     *
     * Initializes the iterator starting from the last element.
     *
     * @param array The array to iterate over.
     */
    public init(array: Array<T>) {
        m_array = array
        m_index = array.size - 1
    }

    /**
     * @brief Returns the next element in the reverse iteration.
     *
     * @return The next element, or `None` if the beginning of the array has been reached.
     */
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

/**
 * @brief An iterator that traverses an `ArrayList` in reverse order.
 *
 * @param T The type of elements in the list.
 */
public class ReverseArrayListIterator<T> <: Iterator<T> {
    private let m_array: ArrayList<T>
    private var m_index: Int64

    /**
     * @brief Constructs a new `ReverseArrayListIterator` for the given list.
     *
     * Initializes the iterator starting from the last element.
     *
     * @param arrayList The `ArrayList` to iterate over.
     */
    public init(arrayList: ArrayList<T>) {
        m_array = arrayList
        m_index = arrayList.size - 1
    }

    /**
     * @brief Returns the next element in the reverse iteration.
     *
     * @return The next element, or `None` if the beginning of the list has been reached.
     */
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

/**
 * @brief Creates a reverse iterator for an `Array`.
 *
 * @param T The type of elements in the array.
 * @param array The array to iterate over.
 *
 * @return A `ReverseArrayIterator` instance.
 */
public func reverse<T>(array: Array<T>): ReverseArrayIterator<T> {
    ReverseArrayIterator<T>(array)
}

/**
 * @brief Creates a reverse iterator for an `ArrayList`.
 *
 * @param T The type of elements in the list.
 * @param arrayList The `ArrayList` to iterate over.
 *
 * @return A `ReverseArrayListIterator` instance.
 */
public func reverse<T>(arrayList: ArrayList<T>): ReverseArrayListIterator<T> {
    ReverseArrayListIterator<T>(arrayList)
}
