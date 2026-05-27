package customiterators

/**
 * @brief An iterator wrapper that allows peeking at the next element without consuming it.
 *
 * This class wraps a standard iterator and buffers the next element, allowing
 * inspection of the future element via `peek()`.
 *
 * @param T The type of elements being iterated over.
 */
public class PeekIterator<T> <: Iterator<T> {
    private let m_iterator: Iterator<T>
    private var m_next: ?T

    /**
     * @brief Constructs a new `PeekIterator` wrapping the provided iterator.
     *
     * Initializes the buffer with the first element from the source iterator.
     *
     * @param iterator The source iterator to wrap.
     */
    public init(iterator: Iterator<T>) {
        m_iterator = iterator
        m_next = iterator.next()
    }

    /**
     * @brief Returns the next element in the iteration and advances the iterator.
     *
     * @return The next element, or `None` if there are no more elements.
     */
    public func next(): ?T {
        let current = m_next
        m_next = m_iterator.next()
        return current
    }

    /**
     * @brief Returns the next element in the iteration without consuming it.
     *
     * This method allows looking ahead to see what `next()` will return
     * without actually advancing the iterator.
     *
     * @return The next element, or `None` if there are no more elements.
     */
    public func peek(): ?T {
        m_next
    }
}

/**
 * @brief Creates a `PeekIterator` from an `Iterable`.
 *
 * This utility function allows easy creation of a `PeekIterator` for any
 * standard collection or iterable type.
 *
 * @param T The type of elements in the iterable.
 * @param iterable The source iterable.
 *
 * @return A new `PeekIterator` instance.
 */
public func peek<T>(iterable: Iterable<T>): PeekIterator<T> {
    PeekIterator(iterable.iterator())
}
