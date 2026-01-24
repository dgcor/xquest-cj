package dgengine.test

import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestParseTexturePack {
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
    func test_parseTexturePack() {
        try (game = Game()) {
            parseFile(game, "json/texturePacks.json")

            // imageContainer
            // existing id (doesn't override first resource parsed with the same id)
            match (game.resources.getTexturePack("key01")) {
                case Some(texturePack) => @Expect(texturePack.size, 4)
                case _ => @Fail("Expected TexturePack: key01")
            }

            // fromId
            match ((game.resources.getTexturePack("key01"), game.resources.getTexturePack("key02"))) {
                case (Some(texturePack), Some(texturePack2)) => @Expect(isObjEq(texturePack, texturePack2))
                case _ => @Fail("Expected TexturePacks: key01, key02")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
