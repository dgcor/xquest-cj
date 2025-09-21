package dgengine

import std.collection.*
import std.sort.*

public struct RectPackItem {
    public RectPackItem(
        public let index!: Int64,
        public let x!: Int64,
        public let y!: Int64,
        public let width!: Int64,
        public let height!: Int64
    ) {}
}

public func packRectangles(rectangles: ArrayList<(Int64, Int64)>, maxSize: (Int64, Int64)): (ArrayList<RectPackItem>, (width: Int64, 
    height: Int64)) {
    let packedRectangles = ArrayList<RectPackItem>()
    var currentX = 0
    var currentY = 0
    var maxHeight = 0
    var maxWidth = 0

    let rectanglesIndexes = ArrayList(rectangles.size, {index => (index, rectangles[index][0], rectangles[index][1])})

    sort(
        rectanglesIndexes,
        stable: true,
        by: {
            a, b =>
                let areaA = a[1] * a[2]
                let areaB = b[1] * b[2]
                if (areaA > areaB) {
                    return Ordering.GT
                } else if (areaA == areaB) {
                    return Ordering.EQ
                }
                return Ordering.LT
        }
    )

    for ((index, rectWidth, rectHeight) in rectanglesIndexes) {
        if (currentX + rectWidth > maxSize[0]) {
            currentX = 0
            currentY += maxHeight
            maxHeight = 0
        }

        packedRectangles.add(
            RectPackItem(
                index: index,
                x: currentX,
                y: currentY,
                width: rectWidth,
                height: rectHeight
            )
        )
        currentX += rectWidth
        maxHeight = max(maxHeight, rectHeight)
        maxWidth = max(maxWidth, currentX)
    }
    let packedSize = (maxWidth, currentY + maxHeight)
    if (packedSize[0] > maxSize[0] || packedSize[1] > maxSize[1]) {
        throw OverflowException("packRectangles: unable to pack all rects inside (${maxSize[0]}, ${maxSize[1]})")
    }

    sort(
        packedRectangles,
        by: {
            a, b =>
                if (a.index > b.index) {
                    return Ordering.GT
                } else if (a.index == b.index) {
                    return Ordering.EQ
                }
                return Ordering.LT
        }
    )

    return (packedRectangles, packedSize)
}
