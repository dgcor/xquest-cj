package dgengine.test

import cjsfml.system.*
import dgengine.*
import std.collection.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestGame {
    @BeforeAll
    func prepareData() {
        FileUtils.initPhysFS()
        FileUtils.mount("test_data", "", true)
    }

    @AfterAll
    func cleanup() {
        FileUtils.deinitPhysFS()
    }

    @TestCase
    func test_init_default() {
        try (game = Game()) {
            @Expect(game.size == (0, 0))
        }
    }

    @TestCase
    func test_init_reset() {
        try (game = Game(reset: true)) {
            @Expect(game.size == (640, 480))
        }
    }

    @TestCase
    func test_getGameProperty() {
        try (game = Game(reset: true)) {
            @Expect(game.getGameProperty("cursor").getOrThrow(), VaTuple2i((0, 0)))
            @Expect(game.getGameProperty("cursor.x").getOrThrow(), VaInteger(0))
            @Expect(game.getGameProperty("cursor.y").getOrThrow(), VaInteger(0))
            @Expect(game.getGameProperty("frameRate").getOrThrow(), VaInteger(60))
            @Expect(game.getGameProperty("fullScreen").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("gamma").getOrThrow(), VaInteger(0))
            @Expect(game.getGameProperty("hasAudio.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasDrawable.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasEvent.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasFont.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasGameShader").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasImageContainer.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasPalette.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasResource.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasShader.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasSong.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasSpriteShader").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasTexture.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("hasTexturePack.invalid").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("keepAR").getOrThrow(), VaBoolean(true))
            @Expect(game.getGameProperty("maxHeight").getOrThrow(), VaInteger(0))
            @Expect(game.getGameProperty("minSize").getOrThrow(), VaTuple2i((640, 480)))
            @Expect(game.getGameProperty("minSize.x").getOrThrow(), VaInteger(640))
            @Expect(game.getGameProperty("minSize.y").getOrThrow(), VaInteger(480))
            @Expect(game.getGameProperty("musicVolume").getOrThrow(), VaInteger(100))
            @Expect(game.getGameProperty("keepAR").getOrThrow(), VaBoolean(true))

            @Expect(game.getGameProperty("openGL.antialiasingLevel").isNone())
            @Expect(game.getGameProperty("openGL.depthBits").isNone())
            @Expect(game.getGameProperty("openGL.hasGeometryShaders").getOrThrow().isBool())
            @Expect(game.getGameProperty("openGL.hasShaders").getOrThrow().isBool())
            @Expect(game.getGameProperty("openGL.majorVersion").isNone())
            @Expect(game.getGameProperty("openGL.maxTextureSize").getOrThrow().isInteger())
            @Expect(game.getGameProperty("openGL.minorVersion").isNone())
            @Expect(game.getGameProperty("openGL.sRgbCapable").isNone())
            @Expect(game.getGameProperty("openGL.stencilBits").isNone())
            @Expect(game.getGameProperty("openGL.invalid").isNone())

            @Expect(game.getGameProperty("path").getOrThrow(), VaString(""))
            @Expect(game.getGameProperty("position").getOrThrow(), VaTuple2i((0, 0)))
            @Expect(game.getGameProperty("position.x").getOrThrow(), VaInteger(0))
            @Expect(game.getGameProperty("position.y").getOrThrow(), VaInteger(0))
            @Expect(game.getGameProperty("refSize").getOrThrow(), VaTuple2i((640, 480)))
            @Expect(game.getGameProperty("refSize.x").getOrThrow(), VaInteger(640))
            @Expect(game.getGameProperty("refSize.y").getOrThrow(), VaInteger(480))

            FileUtils.setSaveDir(".")
            @Expect(game.getGameProperty("saveDir").getOrThrow().isString())

            @Expect(game.getGameProperty("scancodeKey.enter").getOrThrow().isString())
            @Expect(game.getGameProperty("size").getOrThrow(), VaTuple2i((640, 480)))
            @Expect(game.getGameProperty("size.x").getOrThrow(), VaInteger(640))
            @Expect(game.getGameProperty("size.y").getOrThrow(), VaInteger(480))
            @Expect(game.getGameProperty("smoothScreen").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("soundVolume").getOrThrow(), VaInteger(100))
            @Expect(game.getGameProperty("stretchToFit").getOrThrow(), VaBoolean(false))
            @Expect(game.getGameProperty("title").getOrThrow(), VaString(""))
            @Expect(game.getGameProperty("version").getOrThrow(), VaString(""))
            @Expect(game.getGameProperty("windowedSize").getOrThrow(), VaTuple2i((640, 480)))
            @Expect(game.getGameProperty("windowedSize.x").getOrThrow(), VaInteger(640))
            @Expect(game.getGameProperty("windowedSize.y").getOrThrow(), VaInteger(480))
            @Expect(game.getGameProperty("invalid").isNone())
        }
    }

    @TestCase
    func test_getProperty() {
        try (game = Game(reset: true), obj = makeBitmapButton(game, "obj", makeTexture(game, "tex"))) {
            game.resources.setCurrentLevel(obj)
            game.resources.addFocused(obj)

            @Expect(game.getProperty("$.2 + 2").getOrThrow(), VaInteger(4))
            @Expect(game.getProperty("eval.2 + 2").getOrThrow(), VaInteger(4))
            @Expect(game.getProperty("evalMin.2 + :rnd(10)").getOrThrow(), VaInteger(2))
            @Expect(game.getProperty("evalMax.2 + :rnd(10)").getOrThrow(), VaInteger(11))
            @Expect(game.getProperty("$f.2 + 2").getOrThrow(), VaDouble(4.0))
            @Expect(game.getProperty("evalf.2 + 2").getOrThrow(), VaDouble(4.0))
            @Expect(game.getProperty("evalMinf.2 + :rnd(10)").getOrThrow(), VaDouble(2.0))
            @Expect(game.getProperty("evalMaxf.2 + :rnd(10)").getOrThrow(), VaDouble(11.0))
            @Expect(game.getProperty("game.keepAR").getOrThrow(), VaBoolean(true))
            @Expect(game.getProperty("currentLevel.enabled").getOrThrow(), VaBoolean(true))
            @Expect(game.getProperty("focus.enabled").getOrThrow(), VaBoolean(true))
            @Expect(game.getProperty("obj.enabled").getOrThrow(), VaBoolean(true))
            @Expect(game.getProperty("invalid").isNone())
            @Expect(game.getProperty("game").isNone())
            @Expect(game.getProperty("game.invalid").isNone())
            @Expect(game.getProperty("currentLevel").isNone())
            @Expect(game.getProperty("currentLevel.invalid").isNone())
            @Expect(game.getProperty("obj").isNone())
            @Expect(game.getProperty("obj.invalid").isNone())
        }
    }

    @TestCase
    func test_ActionQueryable() {
        try (game = Game(reset: true)) {
            let action = ActGameDraw()

            @Expect(game.setAction("close", action), true)
            @Expect(game.setAction("focusGain", action), true)
            @Expect(game.setAction("focusLoss", action), true)
            @Expect(game.setAction("resize", action), true)
            @Expect(game.setAction("invalid", action), false)

            @Expect(isObjEq((game.getAction("close").getOrThrow()), action))
            @Expect(isObjEq((game.getAction("focusGain").getOrThrow()), action))
            @Expect(isObjEq((game.getAction("focusLoss").getOrThrow()), action))
            @Expect(isObjEq((game.getAction("resize").getOrThrow()), action))
            @Expect(game.getAction("CLOSE").isNone())
            @Expect(game.getAction("invalid").isNone())
        }
    }

    @TestCase
    func test_getQueryAction() {
        try (game = Game(reset: true), obj = makeBitmapButton(game, "obj", makeTexture(game, "tex"))) {
            let action = ActGameDraw()

            @Expect(game.setAction("close", action), true)
            @Expect(obj.setAction("click", action), true)

            @Expect(game.getQueryAction("").isNone())
            @Expect(game.getQueryAction("invalid").isNone())
            @Expect(game.getQueryAction("game").isNone())
            @Expect(isObjEq(game.getQueryAction("game.close").getOrThrow(), action))
            @Expect(game.getQueryAction("obj").isNone())
            @Expect(isObjEq(game.getQueryAction("obj.click").getOrThrow(), action))
        }
    }

    @TestCase
    func test_getQueryable() {
        try (game = Game(reset: true), obj = makeBitmapButton(game, "obj", makeTexture(game, "tex"))) {
            @Expect(isObjEq(game.getQueryable("").getOrThrow().getQueryable(), game))
            @Expect(isObjEq(game.getQueryable("game").getOrThrow().getQueryable(), game))
            @Expect(isObjEq(game.getQueryable("obj").getOrThrow().getQueryable(), obj))
            @Expect(game.getQueryable("currentLevel").isNone())
            @Expect(game.getQueryable("focus").isNone())
            @Expect(game.getQueryable("invalid").isNone())

            game.resources.setCurrentLevel(obj)
            game.resources.addFocused(obj)

            @Expect(isObjEq(game.getQueryable("currentLevel").getOrThrow().getQueryable(), obj))
            @Expect(isObjEq(game.getQueryable("focus").getOrThrow().getQueryable(), obj))
        }
    }

    @TestCase
    func test_getQueryableList() {
        try (game = Game(reset: true)) {
            var vars = game.getQueryableList("")
            @Expect(vars.isEmpty())

            vars = game.getQueryableList("game.saveDirs")
            @Expect(vars.isEmpty())

            vars = game.getQueryableList("game.dirs")
            @Expect(vars.size, 4)
            @Expect((vars |> first).getOrThrow().toString(), "dir1")
            @Expect((vars |> last).getOrThrow().toString(), "res")

            vars = game.getQueryableList("game.dirs.dir1")
            @Expect(vars.size, 2)
            @Expect((vars |> first).getOrThrow().toString(), "subdir1")
            @Expect((vars |> last).getOrThrow().toString(), "subdir2")

            vars = game.getQueryableList("game.files.dir1")
            @Expect(vars.size, 2)
            @Expect((vars |> first).getOrThrow().toString(), "file1.txt")
            @Expect((vars |> last).getOrThrow().toString(), "file2.json")
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
