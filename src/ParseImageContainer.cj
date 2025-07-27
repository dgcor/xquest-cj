package XQuest

import dgengine.*
import stdx.encoding.json.*

private enum ImageContainerType {
    | ImageContainerUnknown
    | ImageContainerFNT
    | ImageContainerGFX
    | ImageContainerPBM
}

private func getImageContainerType(fileName: String, elem: JsonValue): ImageContainerType {
    var fileType = String.empty

    if (let Some(str) <- getValidString(elem, "type")) {
        fileType = str.toAsciiLower()
    } else {
        fileType = FileUtils.getFileExtension(fileName).toAsciiLower()
    }

    if (fileType.startsWith('.')) {
        fileType = fileType[1..]
    }

    return match (fileType) {
        case "fnt" => ImageContainerFNT
        case "gfx" => ImageContainerGFX
        case "pbm" => ImageContainerPBM
        case _ => ImageContainerUnknown
    }
}

func getImageContainerObj(fileBytes: Array<Byte>, fileName: String, elem: JsonValue): ?ImageContainer {
    match (getImageContainerType(fileName, elem)) {
        case ImageContainerFNT => FNTImageContainer(fileBytes)
        case ImageContainerGFX => GFXImageContainer(fileBytes)
        case ImageContainerPBM => PBMImageContainer(fileBytes)
        case _ => None
    }
}
