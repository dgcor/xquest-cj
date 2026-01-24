package dgengine

public class ActPaletteReplace <: Action {
    public ActPaletteReplace(
        private let idDstPal: String,
        private let idSrcPal: String,
        private let srcStart: Int64,
        private let size: Int64,
        private let dstStart: Int64,
        private var step: Int64,
        private let stepReplace: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        let dstPal = game.resources.getPalette(idDstPal)
        let srcPal = game.resources.getPalette(idSrcPal)
        match ((dstPal, srcPal)) {
            case (Some(dstPal), Some(srcPal)) =>
                if (stepReplace == false) {
                    dstPal.replaceRange(srcPal, srcStart, size, dstStart)
                } else {
                    if (step > 0) {
                        step--
                        dstPal.replaceRange(srcPal, srcStart, size - step, dstStart)
                    }
                    if (step > 0) {
                        return false
                    }
                }
            case _ => ()
        }
        return true
    }
}

public class ActPaletteShiftLeft <: Action {
    public ActPaletteShiftLeft(
        private let id: String,
        private let shift: Int64,
        private let range: (Int64, Int64)
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(palette) <- game.resources.getPalette(id)) {
            palette.shiftLeft(shift, range[0], range[1])
        }
        return true
    }
}

public class ActPaletteShiftRight <: Action {
    public ActPaletteShiftRight(
        private let id: String,
        private let shift: Int64,
        private let range: (Int64, Int64)
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(palette) <- game.resources.getPalette(id)) {
            palette.shiftRight(shift, range[0], range[1])
        }
        return true
    }
}
