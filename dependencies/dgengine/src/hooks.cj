package dgengine

import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import stdjson2.*

private type InitializeShaderManagerFunc = (shaderManager: ShaderManager) -> Unit

private type ParseDocumentElemFunc = (game: Game, name: String, elem: JsonValue, replaceVars: Box<ReplaceVars>) -> Bool

private type ParseActionElemFunc = (game: Game, name: String, elem: JsonValue) -> ?Action

private type GetPredicateObjFunc = (game: Game, name: String, elem: JsonValue) -> ?Predicate

private type GetImageContainerObjFunc = (fileBytes: Array<Byte>, fileName: String, elem: JsonValue) -> ?ImageContainer

private type DecodeImageFunc = (file: InputStream) -> ?SFMLImage

private type ParseTextureImgFunc = (game: Game, elem: JsonValue, img: Box<?SFMLImage>) -> Bool

private type RegisterArchiversFunc = () -> Unit

public class Hooks {
    public static var initializeShaderManager: ?InitializeShaderManagerFunc = None
    public static var parseDocumentElem: ?ParseDocumentElemFunc = None
    public static var parseActionElem: ?ParseActionElemFunc = None
    public static var getPredicateObj: ?GetPredicateObjFunc = None
    public static var getImageContainerObj: ?GetImageContainerObjFunc = None
    public static var decodeImage: ?DecodeImageFunc = None
    public static var parseTextureImg: ?ParseTextureImgFunc = None
    public static var registerArchivers: ?RegisterArchiversFunc = None
}

public class Defaults {
    public static var ARCHIVE_EXTENSIONS: Array<String> = [".zip", ".7z"]
    public static var GAME_SIZE_X: UInt32 = 640
    public static var GAME_SIZE_Y: UInt32 = 480
    public static var GAME_MIN_SIZE_X: UInt32 = 640
    public static var GAME_MIN_SIZE_Y: UInt32 = 480
    public static var GAME_REF_SIZE_X: UInt32 = 640
    public static var GAME_REF_SIZE_Y: UInt32 = 480
    public static var FADE_STEP: UInt32 = 25
    public static var FADE_REFRESH: Time = Time(milliseconds: 15)
}
