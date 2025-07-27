package dgengine

import cjsfml.graphics.Image as SFMLImage
import std.collection.*

public class CachedImagePackIterator <: Iterator<SFMLImage> {
    private let m_imgCache: CachedImagePack
    private var m_index: Int64 = 0

    public init(imgCache: CachedImagePack) {
        m_imgCache = imgCache
    }

    public func next(): ?SFMLImage {
        if (m_index < Int64(m_imgCache.size)) {
            let img = m_imgCache[m_index]
            m_index++
            return img
        } else if (m_index >= 0) {
            m_index = -1
        }
        return None
    }
}

public class CachedImagePack <: Iterable<SFMLImage> & Resource {
    private let m_imgContainer: ImageContainer
    private let m_palette: ?Palette
    private let m_isIndexed: Bool
    private let m_cache: Array<?SFMLImage>
    private var m_isClosed = false

    public init(imgContainer: ImageContainer, palette: ?Palette, isIndexed!: Bool = false) {
        m_imgContainer = imgContainer
        m_palette = palette
        m_isIndexed = match ((isIndexed, palette.isNone())) {
            case (false, true) => true
            case _ => isIndexed
        }
        m_cache = Array<?SFMLImage>(Int64(imgContainer.size), {_ => None})
    }

    // Resource

    public func isClosed(): Bool {
        return m_isClosed
    }

    public func close(): Unit {
        if (m_isClosed == false) {
            if (let Some(imgContainer) <- (m_imgContainer as Resource)) {
                imgContainer.close()
            }
            for (img in m_cache) {
                img?.close()
            }
            m_isClosed = true
        }
    }

    // Iterable

    public func iterator(): Iterator<SFMLImage> {
        CachedImagePackIterator(this)
    }

    // CachedImagePack

    public operator func [](index: Int64): SFMLImage {
        if (index >= 0 && index < m_cache.size) {
            if (m_cache[index].isNone()) {
                let img = match (m_isIndexed) {
                    case true => m_imgContainer.get(UInt32(index), None)?[0]
                    case false => m_imgContainer.get(UInt32(index), m_palette?.palette)?[0]
                }
                if (let Some(img) <- img) {
                    m_cache[index] = img
                    return img
                }
                throw NoneValueException()
            }
            return m_cache[index].getOrThrow()
        }
        throw IndexOutOfBoundsException()
    }

    public prop palette: ?Palette {
        get() {
            m_palette
        }
    }

    public prop isIndexed: Bool {
        get() {
            m_isIndexed
        }
    }

    public prop size: UInt32 {
        get() {
            m_imgContainer.size
        }
    }
}
