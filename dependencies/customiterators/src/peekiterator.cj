package customiterators

public class PeekIterator<T> <: Iterator<T> {
    private let m_iterator: Iterator<T>
    private var m_next: ?T

    public init(iterator: Iterator<T>) {
        m_iterator = iterator
        m_next = iterator.next()
    }

    public func next(): ?T {
        let current = m_next
        m_next = m_iterator.next()
        return current
    }

    public func peek(): ?T {
        m_next
    }
}

public func peek<T>(iterable: Iterable<T>): PeekIterator<T> {
    PeekIterator(iterable.iterator())
}
