package cjsfml.graphics

import cjsfml.system.*
import ctemplate.*

@Template[ClassName, NumType, VectorType, DefaultValue: FloatRect, Float32, Vector2f, 0.0 ; IntRect, Int32, Vector2i, 0](
@C
public struct ClassName {
    public var left: NumType = DefaultValue
    public var top: NumType = DefaultValue
    public var width: NumType = DefaultValue
    public var height: NumType = DefaultValue

    public const init() {}
    public const init(left: NumType, top: NumType, width: NumType, height: NumType) {
        this.left = left
        this.top = top
        this.width = width
        this.height = height
    }

    public const init(rect: (NumType, NumType, NumType, NumType)) {
        left = rect[0]
        top = rect[1]
        width = rect[2]
        height = rect[3]
    }

    public const init(position: VectorType, size: VectorType) {
        left = position.x
        top = position.y
        width = size.x
        height = size.y
    }

    public const init(position: (NumType, NumType), size: (NumType, NumType)) {
        left = position[0]
        top = position[1]
        width = size[0]
        height = size[1]
    }

    public func contains(x: NumType, y: NumType): Bool {
        let minX = min(left, left + width)
        let maxX = max(left, left + width)
        let minY = min(top, top + height)
        let maxY = max(top, top + height)
        let x64 = x
        let y64 = y

        return (x64 >= minX) && (x64 < maxX) && (y64 >= minY) && (y64 < maxY)
    }

    public func contains(point: VectorType): Bool {
        return contains(point.x, point.y)
    }

    public func contains(point: (NumType, NumType)): Bool {
        return contains(point[0], point[1])
    }

    public func intersects(rectangle: ClassName): ?ClassName {
        // Rectangles with negative dimensions are allowed, so we must handle them correctly

        // Compute the min and max of the first rectangle on both axes
        let r1MinX = min(left, left + width)
        let r1MaxX = max(left, left + width)
        let r1MinY = min(top, top + height)
        let r1MaxY = max(top, top + height)
        let r2MinX = min(rectangle.left, rectangle.left + rectangle.width)
        let r2MaxX = max(rectangle.left, rectangle.left + rectangle.width)
        let r2MinY = min(rectangle.top, rectangle.top + rectangle.height)
        let r2MaxY = max(rectangle.top, rectangle.top + rectangle.height)
        let interLeft = max(r1MinX, r2MinX)
        let interTop = max(r1MinY, r2MinY)
        let interRight = min(r1MaxX, r2MaxX)
        let interBottom = min(r1MaxY, r2MaxY)

        // If the intersection is valid (positive non zero area), then there is an intersection
        if ((interLeft < interRight) && (interTop < interBottom)) {
            return ClassName(NumType(interLeft), NumType(interTop), NumType(interRight - interLeft),
                NumType(interBottom - interTop))
        }
        return None
    }

    public prop position: VectorType {
        get() {
            VectorType(left, top)
        }
    }

    public prop size: VectorType {
        get() {
            VectorType(width, height)
        }
    }

    public operator const func ==(right: ClassName): Bool {
        return left == right.left && top == right.top && width == right.width && height == right.height
    }

    public operator const func !=(right: ClassName): Bool {
        return left != right.left || top != right.top || width != right.width || height != right.height
    }

    public operator const func ==(right: (NumType, NumType, NumType, NumType)): Bool {
        return left == right[0] && top == right[1] && width == right[2] && height == right[3]
    }

    public operator const func !=(right: (NumType, NumType, NumType, NumType)): Bool {
        return left != right[0] || top != right[1] || width != right[2] || height != right[3]
    }

    public func toTuple(): (NumType, NumType, NumType, NumType) {
        (left, top, width, height)
    }
})
