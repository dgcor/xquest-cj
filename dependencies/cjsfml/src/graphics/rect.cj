package cjsfml.graphics

import cjsfml.system.{Vector2f, Vector2i}
import ctemplate.Template

/**
 * Utility class for manipulating 2D axis aligned rectangles.
 *
 * A rectangle is defined by its top-left corner and its size.
 * It is a very simple class defined for convenience, so
 * its member variables (position and size) are public
 * and can be accessed directly, just like the vector classes
 * (`Vector2` and `Vector3`).
 *
 * To keep things simple, `Rect` doesn't define
 * functions to emulate the properties that are not directly
 * members (such as right, bottom, etc.), it rather
 * only provides intersection functions.
 *
 * `Rect` uses the usual rules for its boundaries:
 * - The left and top edges are included in the rectangle's area
 * - The right and bottom edges are excluded from the rectangle's area
 *
 * This means that `IntRect(Vector2i(0, 0), Vector2i(1, 1))` and `IntRect(Vector2i(1, 1), Vector2i(1, 1))`
 * don't intersect.
 *
 * `Rect` is a template and may be used with any numeric type, but
 * for simplicity type aliases for the instantiations used by SFML are given:
 * - `Rect<Int32>` is `IntRect`
 * - `Rect<Float32>` is `FloatRect`
 *
 * So that you don't have to care about the template syntax.
 *
 * Usage example:
 * ```
 * // Define a rectangle, located at (0, 0) with a size of 20x5
 * let r1 = IntRect(0, 0, 20, 5);
 *
 * // Define another rectangle, located at (4, 2) with a size of 18x10
 * let position = Vector2i(4, 2);
 * let size = Vector2i(18, 10);
 * let r2 = IntRect(position, size);
 *
 * // Test intersections with the point (3, 1)
 * let b1 = r1.contains(3, 1); // true
 * let b2 = r2.contains(3, 1); // false
 *
 * // Test the intersection between r1 and r2
 * let result = r1.findIntersection(r2);
 * // result != None
 * // result.value == IntRect(4, 2, 16, 3)
 * ```
 */
@Template[ClassName, NumType, VectorType: FloatRect, Float32, Vector2f ; IntRect, Int32, Vector2i](
@C
public struct ClassName {
    public var position: VectorType
    public var size: VectorType

    /**
     * Default constructor.
     *
     * Creates an empty rectangle.
     */
    public const init() {
        this.position = VectorType()
        this.size = VectorType()
    }

    /**
     * Construct the rectangle from its coordinates.
     *
     * Be careful, the last two parameters are the size,
     * not the bottom-right corner!
     *
     * @param left   Left coordinate of the rectangle
     * @param top    Top coordinate of the rectangle
     * @param width  Width of the rectangle
     * @param height Height of the rectangle
     */
    public const init(left: NumType, top: NumType, width: NumType, height: NumType) {
        this.position = VectorType(left, top)
        this.size = VectorType(width, height)
    }

    public const init(rect: (NumType, NumType, NumType, NumType)) {
        this.position = VectorType(rect[0], rect[1])
        this.size = VectorType(rect[2], rect[3])
    }

    /**
     * Construct the rectangle from position and size.
     *
     * Be careful, the last parameter is the size,
     * not the bottom-right corner!
     *
     * @param position Position of the top-left corner of the rectangle
     * @param size     Size of the rectangle
     */
    public const init(position: VectorType, size: VectorType) {
        this.position = position
        this.size = size
    }

    public const init(position: (NumType, NumType), size: (NumType, NumType)) {
        this.position = VectorType(position[0], position[1])
        this.size = VectorType(size[0], size[1])
    }

    /**
     * Check if a point is inside the rectangle's area.
     *
     * This check is non-inclusive. If the point lies on the
     * edge of the rectangle, this function will return `false`.
     *
     * @param x X coordinate of the point to test
     * @param y Y coordinate of the point to test
     *
     * @return `true` if the point is inside, `false` otherwise
     *
     * @see `findIntersection`
     */
    public func contains(x: NumType, y: NumType): Bool {
        let minX = min(position.x, position.x + size.x)
        let maxX = max(position.x, position.x + size.x)
        let minY = min(position.y, position.y + size.y)
        let maxY = max(position.y, position.y + size.y)
        let x64 = x
        let y64 = y

        return (x64 >= minX) && (x64 < maxX) && (y64 >= minY) && (y64 < maxY)
    }

    /**
     * Check if a point is inside the rectangle's area.
     *
     * This check is non-inclusive. If the point lies on the
     * edge of the rectangle, this function will return `false`.
     *
     * @param point Point to test
     *
     * @return `true` if the point is inside, `false` otherwise
     *
     * @see `findIntersection`
     */
    public func contains(point: VectorType): Bool {
        return contains(point.x, point.y)
    }

    public func contains(point: (NumType, NumType)): Bool {
        return contains(point[0], point[1])
    }

    /**
     * Check the intersection between two rectangles.
     *
     * @param rectangle Rectangle to test
     *
     * @return Intersection rectangle if intersecting, `None` otherwise
     *
     * @see `contains`
     */
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

    public const operator func ==(right: ClassName): Bool {
        return position == right.position && size == right.size
    }

    public const operator func !=(right: ClassName): Bool {
        return position != right.position || size != right.size
    }

    public const operator func ==(right: (NumType, NumType, NumType, NumType)): Bool {
        return position.x == right[0] && position.y == right[1] && size.x == right[2] && size.y == right[3]
    }

    public const operator func !=(right: (NumType, NumType, NumType, NumType)): Bool {
        return position.x != right[0] || position.y != right[1] || size.x != right[2] || size.y != right[3]
    }

    public func toTuple(): (NumType, NumType, NumType, NumType) {
        (position.x, position.y, size.x, size.y)
    }
})
