package dgengine

import cjsfml.graphics.*

public interface DrawableText <: UIObject {
    func clone(): DrawableText

    prop text: String
    func setText(str: String): Bool

    prop localBounds: FloatRect
    prop globalBounds: FloatRect

    prop lineCount: UInt32
    mut prop color: Color

    mut prop horizontalAlign: HorizontalAlign
    mut prop verticalAlign: VerticalAlign

    mut prop horizontalSpaceOffset: Int32
    mut prop verticalSpaceOffset: Int32
}
