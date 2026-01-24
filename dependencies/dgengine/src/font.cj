package dgengine

public enum Font <: Resource {
    | FontBitmap(BitmapFont)
    | FontFreeType(FreeTypeFont)

    public func isClosed(): Bool {
        match (this) {
            case FontFreeType(obj) => obj.isClosed()
            case _ => false
        }
    }

    public func close(): Unit {
        match (this) {
            case FontFreeType(obj) => obj.close()
            case _ => ()
        }
    }
}
