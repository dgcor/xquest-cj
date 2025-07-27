package dgengine

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*

public open class SimpleImageContainer <: ImageContainer & Resource {
    protected let m_image: SFMLImage
    protected var m_maxFrames: UInt32 = 0
    protected var m_numFrames: UInt32 = 0
    protected var m_subImageSizeX: UInt32 = 0
    protected var m_subImageSizeY: UInt32 = 0
    protected var m_directions: UInt32 = 0
    protected let m_verticalDirection: Bool
    protected var m_blendMode: BlendModeType = BlendAlpha

    public init(file!: InputStream, xFrames!: UInt32, yFrames!: UInt32, directions!: UInt32, verticalDirection!: Bool,
        transparencyMask!: Color = Color.transparent) {
        m_verticalDirection = verticalDirection
        m_numFrames = xFrames * yFrames
        if (m_numFrames == 0) {
            m_image = SFMLImage()
            return
        }
        m_image = ImageUtils.loadImage(file, mask: transparencyMask) ?? SFMLImage()

        let imgSize = m_image.size

        if (imgSize.x == 0 || imgSize.y == 0 || xFrames > imgSize.x || yFrames > imgSize.y || imgSize.x % xFrames != 0 ||
            imgSize.y % yFrames != 0) {
            m_numFrames = 0
            return
        }

        m_maxFrames = match (verticalDirection) {
            case true => yFrames
            case false => xFrames
        }
        m_subImageSizeX = imgSize.x / xFrames
        m_subImageSizeY = imgSize.y / yFrames

        m_directions = match (directions) {
            case 0 => 1
            case _ => directions
        }
    }

    // Resource

    public func isClosed(): Bool {
        m_image.isClosed()
    }

    public func close(): Unit {
        m_image.close()
    }

    // ImageContainer

    public mut open prop blendMode: BlendModeType {
        get() {
            m_blendMode
        }
        set(value) {
            m_blendMode = value
        }
    }

    public open func get(index: UInt32, palette: ?PaletteArray): ?(SFMLImage, ImageInfo) {
        if (m_numFrames == 0 || index >= m_numFrames) {
            return None
        }

        let img = SFMLImage(m_subImageSizeX, m_subImageSizeY, Color.transparent)
        let imgInfo = ImageInfo(blendMode: m_blendMode)

        let (left, top) = match (m_verticalDirection) {
            case false => (Int32((index % m_maxFrames) * m_subImageSizeX), Int32((index / m_maxFrames) * m_subImageSizeY))
            case true => (Int32((index / m_maxFrames) * m_subImageSizeX), Int32((index % m_maxFrames) * m_subImageSizeY))
        }

        img.copy(m_image, 0, 0, sourceRect: IntRect(left, top, Int32(m_subImageSizeX), Int32(m_subImageSizeY)),
            applyAlpha: true)

        if (let Some(palette) <- palette) {
            for (j in 0..m_subImageSizeY) {
                for (i in 0..m_subImageSizeX) {
                    img.setPixel(i, j, palette[Int64(img.getPixel(i, j).r)])
                }
            }
        }
        return (img, imgInfo)
    }

    public override func getImageSize(index: UInt32): Vector2u {
        if (m_numFrames == 0 || index >= m_numFrames) {
            return Vector2u()
        }
        return Vector2u(m_subImageSizeX, m_subImageSizeY)
    }

    public open prop size: UInt32 {
        get() {
            m_numFrames
        }
    }

    public open prop directions: UInt32 {
        get() {
            m_directions
        }
    }
}
