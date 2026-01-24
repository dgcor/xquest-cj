package cjsfml.graphics

import cjsfml.system.{Vector2f, Vector2i}
import ctemplate.Template

@Template[ClassName, NumType, VectorType: FloatRect, Float32, Vector2f ; IntRect, Int32, Vector2i](
@C
public struct ClassName {
    public var position: VectorType
    public var size: VectorType

    public const init() {
        this.position = VectorType()
        this.size = VectorType()
    }

    public const init(left: NumType, top: NumType, width: NumType, height: NumType) {
        this.position = VectorType(left, top)
        this.size = VectorType(width, height)
    }

    public const init(rect: (NumType, NumType, NumType, NumType)) {
        this.position = VectorType(rect[0], rect[1])
        this.size = VectorType(rect[2], rect[3])
    }

    public const init(position: VectorType, size: VectorType) {
        this.position = position
        this.size = size
    }

    public const init(position: (NumType, NumType), size: (NumType, NumType)) {
        this.position = VectorType(position[0], position[1])
        this.size = VectorType(size[0], size[1])
    }

    public func contains(x: NumType, y: NumType): Bool {
        let minX = min(position.x, position.x + size.x)
        let maxX = max(position.x, position.x + size.x)
        let minY = min(position.y, position.y + size.y)
        let maxY = max(position.y, position.y + size.y)
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

    public func findIntersection(rectangle: ClassName): ?ClassName {
        // Rectangles with negative dimensions are allowed, so we must handle them correctly

        // Compute the min and max of the first rectangle on both axes
        let r1MinX = min(position.x, position.x + size.x)
        let r1MaxX = max(position.x, position.x + size.x)
        let r1MinY = min(position.y, position.y + size.y)
        let r1MaxY = max(position.y, position.y + size.y)
        let r2MinX = min(rectangle.position.x, rectangle.position.x + rectangle.size.x)
        let r2MaxX = max(rectangle.position.x, rectangle.position.x + rectangle.size.x)
        let r2MinY = min(rectangle.position.y, rectangle.position.y + rectangle.size.y)
        let r2MaxY = max(rectangle.position.y, rectangle.position.y + rectangle.size.y)
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

    public operator const func ==(right: ClassName): Bool {
        return position == right.position && size == right.size
    }

    public operator const func !=(right: ClassName): Bool {
        return position != right.position || size != right.size
    }

    public operator const func ==(right: (NumType, NumType, NumType, NumType)): Bool {
        return position.x == right[0] && position.y == right[1] && size.x == right[2] && size.y == right[3]
    }

    public operator const func !=(right: (NumType, NumType, NumType, NumType)): Bool {
        return position.x != right[0] || position.y != right[1] || size.x != right[2] || size.y != right[3]
    }

    public func toTuple(): (NumType, NumType, NumType, NumType) {
        (position.x, position.y, size.x, size.y)
    }
})
