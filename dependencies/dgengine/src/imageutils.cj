package dgengine

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import std.collection.*

public class ImageUtils {
    public static func applyMask(image: SFMLImage, mask!: Color = Color.TRANSPARENT): Unit {
        if (mask != Color.TRANSPARENT) {
            let imgSize = image.size
            let size = Int64(imgSize.x) * Int64(imgSize.y) * 4
            if (size > 0) {
                let pixelPtr = image.pixelsPtr
                var color = Color(0, 0, 0, 0)
                for (index in 0..size : 4) {
                    unsafe {
                        color.r = pixelPtr.read(index + 0)
                        color.g = pixelPtr.read(index + 1)
                        color.b = pixelPtr.read(index + 2)
                        color.a = pixelPtr.read(index + 3)
                        if (color.r == mask.r && color.g == mask.g && color.b == mask.b && color.a == mask.a) {
                            pixelPtr.write(index + 0, 0)
                            pixelPtr.write(index + 1, 0)
                            pixelPtr.write(index + 2, 0)
                            pixelPtr.write(index + 3, 0)
                        }
                    }
                }
            }
        }
    }

    public static func loadImage(inputStream: InputStream, mask!: Color = Color.TRANSPARENT): ?SFMLImage {
        var image: ?SFMLImage = None
        try {
            if (let Some(decodeImage) <- Hooks.decodeImage) {
                image = decodeImage(inputStream)
            }
            if (image.isNone()) {
                image = SFMLImage(inputStream)
            }
            if (let Some(image) <- image) {
                applyMask(image, mask: mask)
            }
        } catch (ex: Exception) {
            logger.debug("loadImage error: ${ex}")
        }
        return image
    }

    public static func loadImage(fileName: String, mask!: Color = Color.TRANSPARENT): ?SFMLImage {
        try (file = PhysFSStream(fileName)) {
            return loadImage(file, mask: mask)
        } catch (ex: Exception) {
            logger.debug("loadImage error: ${fileName} -> ${ex}")
        }
        return None
    }

    public static func loadImage(imgContainer: ImageContainer, pal: ?Palette): ?SFMLImage {
        try {
            if (imgContainer.size == 1) {
                return imgContainer.get(0, pal?.palette)?[0].clone()
            }

            try (imgCache = CachedImagePack(imgContainer, pal)) {
                var imgWidth = 0u32
                var imgHeight = 0u32
                for (img in imgCache) {
                    let frameSize = img.size
                    if (imgWidth < frameSize.x) {
                        imgWidth = frameSize.x
                    }
                    imgHeight += frameSize.y
                }

                let img = SFMLImage(Vector2u(imgWidth, imgHeight), Color.TRANSPARENT)

                var maxHeight = 0u32
                for (frame in imgCache) {
                    let frameSize = frame.size
                    for (j in 0..frameSize.y) {
                        for (i in 0..frameSize.x) {
                            img.setPixel(Vector2u(i, maxHeight + j), frame.getPixel(Vector2u(i, j)))
                        }
                    }
                    maxHeight += frameSize.y
                }
                return img
            }
        } catch (ex: Exception) {
            logger.debug("loadImage error (ImageContainer): ${ex}")
        }
        return None
    }

    public static func loadImageFrame(imgContainer: ImageContainer, pal: ?Palette, frameIdx: UInt32): ?SFMLImage {
        try {
            if (imgContainer.size > 0 && frameIdx < imgContainer.size) {
                return imgContainer.get(frameIdx, pal?.palette)?[0].clone()
            }
        } catch (ex: Exception) {
            logger.debug("loadImageFrame error: ${ex}")
        }
        return None
    }

    public static func loadBitmapFontImage(imgContainer: ImageContainer, fileNameCharMap: String, pal: ?Palette): ?SFMLImage {
        try (imgCache = CachedImagePack(imgContainer, pal)) {
            let cacheSize = imgCache.size
            if (cacheSize == 0) {
                return None
            }
            let firstImgSize = imgCache[0].size
            let img = SFMLImage(Vector2u(firstImgSize.x * 16, firstImgSize.y * 16), Color.TRANSPARENT)
            let charMapping = NumberVector<UInt8>(fileNameCharMap, default: 0, maxNumElements: 256)

            var xx = 0u32
            var yy = 0u32
            for (charMap in charMapping) {
                if (charMap != 0xFF && UInt32(charMap) < cacheSize) {
                    let frame = imgCache[Int64(charMap)]
                    let frameSize = frame.size

                    for (j in 0..frameSize.y) {
                        for (i in 0..frameSize.x) {
                            img.setPixel(
                                Vector2u(frameSize.x * xx + i, frameSize.y * yy + j),
                                frame.getPixel(Vector2u(i, j))
                            )
                        }
                    }
                }
                xx++
                if (xx == 16) {
                    xx = 0
                    yy++
                }
            }
            return img
        } catch (ex: Exception) {
            logger.debug("loadBitmapFontImage error: ${ex}")
        }
        return None
    }

    public static func packImages(imgContainer: ImageContainer, pal: ?Palette): (?SFMLImage, ArrayList<IntRect>) {
        try (imgCache = CachedImagePack(imgContainer, pal)) {
            let rectangles = ArrayList<(Int64, Int64)>()
            for (frame in imgCache) {
                let frameSize = frame.size
                rectangles.add((Int64(frameSize.x), Int64(frameSize.y)))
            }

            let maxSize = Int64(Texture.maximumSize)
            let (packRects, packedSize) = packRectangles(rectangles, (maxSize, maxSize))

            let rects = ArrayList<IntRect>()
            let img = SFMLImage(Vector2u(UInt32(packedSize[0]), UInt32(packedSize[1])), Color.TRANSPARENT)

            for (rect in packRects) {
                let frame = imgCache[rect.index]
                img.copy(frame, Vector2u(UInt32(rect.x), UInt32(rect.y)))
                rects.add(IntRect(Int32(rect.x), Int32(rect.y), Int32(rect.width), Int32(rect.height)))
            }
            return (img, rects)
        } catch (ex: Exception) {
            logger.debug("packImages error: ${ex}")
        }
        return (None, ArrayList<IntRect>())
    }

    // splits a 2x2 image into a 1x4 image (2 pieces)
    public static func splitImageHorizontal(img: SFMLImage, pieces!: UInt32 = 1): ?SFMLImage {
        if (pieces <= 1) {
            return None
        }

        let size = img.size
        if (pieces > size.x) {
            return None
        }

        let newX = size.x / pieces
        if (size.x % pieces != 0) {
            return None
        }

        let newY = size.y * pieces
        try {
            let newImg = SFMLImage(Vector2u(newX, newY))
            var rect = IntRect(0, 0, Int32(newX), Int32(size.y))
            for (index in 0..pieces) {
                rect.position.x = Int32(index * newX)
                newImg.copy(img, Vector2u(0, index * size.y), sourceRect: rect)
            }
            return newImg
        } catch (ex: Exception) {
            logger.debug("splitImageHorizontal error: ${ex}")
        }
        return None
    }

    // splits a 2x2 image into a 4x1 image (2 pieces)
    public static func splitImageVertical(img: SFMLImage, pieces!: UInt32 = 1): ?SFMLImage {
        if (pieces <= 1) {
            return None
        }

        let size = img.size
        if (pieces > size.y) {
            return None
        }

        let newY = size.y / pieces
        if (size.y % pieces != 0) {
            return None
        }

        let newX = size.x * pieces
        try {
            let newImg = SFMLImage(Vector2u(newX, newY))
            var rect = IntRect(0, 0, Int32(size.x), Int32(newY))
            for (index in 0..pieces) {
                rect.position.y = Int32(index * newY)
                newImg.copy(img, Vector2u(index * size.x, 0), sourceRect: rect)
            }
            return newImg
        } catch (ex: Exception) {
            logger.debug("splitImageVertical error: ${ex}")
        }
        return None
    }
}
