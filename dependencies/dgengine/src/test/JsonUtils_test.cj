package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import stdx.encoding.json.*
import std.unittest.*

@Test
class TestJsonUtils {
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
    func test_replaceStringValueWithQueryable() {
        let json = ##"
        {
          "key01": "circle radius: %radius%",
          "key02": "circle radius: %radius%",
          "key03": 12,
          "key04": "%radius%",
          "key05": "%radius%",
          "key06": "%radius% ",
          "key07": "%radius% ",
          "key08": { "subKey1": "%radius%" },
          "key09": "%%radius%",
          "key10": "%radius%%",
          "key11": "%%radius%%"
        }"##

        if (let Some(elem) <- JsonUtils.loadJson(json)) {
            try (obj = Circle(2.0, pointCount: 30)) {
                let doc = elem.asObject()

                doc.put(
                    "key01",
                    JsonUtils.replaceStringValueWithQueryable(doc["key01"], obj)
                )
                doc.put(
                    "key02",
                    JsonUtils.replaceStringValueWithQueryable(doc["key02"], obj, changeValueType: true)
                )
                doc.put(
                    "key03",
                    JsonUtils.replaceStringValueWithQueryable(doc["key03"], obj)
                )
                doc.put(
                    "key04",
                    JsonUtils.replaceStringValueWithQueryable(doc["key04"], obj)
                )
                doc.put(
                    "key05",
                    JsonUtils.replaceStringValueWithQueryable(doc["key05"], obj, changeValueType: true)
                )
                doc.put(
                    "key06",
                    JsonUtils.replaceStringValueWithQueryable(doc["key06"], obj)
                )
                doc.put(
                    "key07",
                    JsonUtils.replaceStringValueWithQueryable(doc["key07"], obj, changeValueType: true)
                )
                doc.put(
                    "key08",
                    JsonUtils.replaceStringValueWithQueryable(doc["key08"], obj)
                )
                doc.put(
                    "key09",
                    JsonUtils.replaceStringValueWithQueryable(doc["key09"], obj)
                )
                doc.put(
                    "key10",
                    JsonUtils.replaceStringValueWithQueryable(doc["key10"], obj)
                )
                doc.put(
                    "key11",
                    JsonUtils.replaceStringValueWithQueryable(doc["key11"], obj)
                )

                @Expect(getStringCharKey(doc, "key01"), "circle radius: 2")
                @Expect(getStringCharKey(doc, "key02"), "circle radius: 2")
                @Expect(getIntKey(doc, "key03"), 12)
                @Expect(getStringCharKey(doc, "key04"), "2")
                @Expect(getIntKey(doc, "key05"), 2)
                @Expect(getStringCharKey(doc, "key06"), "2 ")
                @Expect(getStringCharKey(doc, "key07"), "2 ")
                @Expect(getStringCharKey(doc["key08"], "subKey1"), "%radius%")
                @Expect(getStringCharKey(doc, "key09"), "%%radius%")
                @Expect(getStringCharKey(doc, "key10"), "2%")
                @Expect(getStringCharKey(doc, "key11"), "%%radius%%")
            }
        }
    }

    @TestCase
    func test_replaceStringValueWithVariable() {
        let json = ##"
        {
          "key01": 12,
          "key02": "text", "key03": "text", "key04": "text", "key05": "text",
          "key06": "text", "key07": "text", "key08": "text", "key09": "text",
          "key10": "text", "key11": "text", "key12": "text", "key13": "text",
          "key14": "text", "key15": "text", "key16": "text", "key17": "text",
          "key18": "text", "key19": "text", "key20": "text", "key21": "text",
          "key22": { "subKey01": "text" }
        }"##

        if (let Some(elem) <- JsonUtils.loadJson(json)) {
            var doc = elem.asObject()

            doc.put(
                "key01",
                JsonUtils.replaceStringValueWithVariable(doc["key01"], "text", VaString("game"))
            )
            doc.put(
                "key02",
                JsonUtils.replaceStringValueWithVariable(doc["key02"], "text", VaString("game"))
            )
            doc.put(
                "key03",
                JsonUtils.replaceStringValueWithVariable(doc["key03"], "text", VaString("game"), changeValueType: true)
            )
            doc.put(
                "key04",
                JsonUtils.replaceStringValueWithVariable(doc["key04"], "text", VaInteger(15))
            )
            doc.put(
                "key05",
                JsonUtils.replaceStringValueWithVariable(doc["key05"], "text", VaInteger(15), changeValueType: true)
            )
            doc.put(
                "key06",
                JsonUtils.replaceStringValueWithVariable(doc["key06"], "text", VaDouble(1.5))
            )
            doc.put(
                "key07",
                JsonUtils.replaceStringValueWithVariable(doc["key07"], "text", VaDouble(1.5), changeValueType: true)
            )
            doc.put(
                "key08",
                JsonUtils.replaceStringValueWithVariable(doc["key08"], "text", VaBoolean(true))
            )
            doc.put(
                "key09",
                JsonUtils.replaceStringValueWithVariable(doc["key09"], "text", VaBoolean(true), changeValueType: true)
            )
            doc.put(
                "key10",
                JsonUtils.replaceStringValueWithVariable(doc["key10"], "text", VaTuple2i((1, 1)))
            )
            doc.put(
                "key11",
                JsonUtils.replaceStringValueWithVariable(doc["key11"], "text", VaTuple2i((1, 1)), changeValueType: true)
            )
            doc.put(
                "key12",
                JsonUtils.replaceStringValueWithVariable(doc["key12"], "text", VaTuple3i((1, 1, 1)))
            )
            doc.put(
                "key13",
                JsonUtils.replaceStringValueWithVariable(doc["key13"], "text", VaTuple3i((1, 1, 1)),
                    changeValueType: true)
            )
            doc.put(
                "key14",
                JsonUtils.replaceStringValueWithVariable(doc["key14"], "text", VaTuple4i((1, 1, 1, 1)))
            )
            doc.put(
                "key15",
                JsonUtils.replaceStringValueWithVariable(doc["key15"], "text", VaTuple4i((1, 1, 1, 1)),
                    changeValueType: true)
            )
            doc.put(
                "key16",
                JsonUtils.replaceStringValueWithVariable(doc["key16"], "text", VaTuple2f((1.5, 1.0)))
            )
            doc.put(
                "key17",
                JsonUtils.replaceStringValueWithVariable(doc["key17"], "text", VaTuple2f((1.5, 1.0)),
                    changeValueType: true)
            )
            doc.put(
                "key18",
                JsonUtils.replaceStringValueWithVariable(doc["key18"], "text", VaTuple3f((1.5, 1.0, 1.0)))
            )
            doc.put(
                "key19",
                JsonUtils.replaceStringValueWithVariable(doc["key19"], "text", VaTuple3f((1.5, 1.0, 1.0)),
                    changeValueType: true)
            )
            doc.put(
                "key20",
                JsonUtils.replaceStringValueWithVariable(doc["key20"], "text", VaTuple4f((1.5, 1.0, 1.0, 1.0)))
            )
            doc.put(
                "key21",
                JsonUtils.replaceStringValueWithVariable(doc["key21"], "text", VaTuple4f((1.5, 1.0, 1.0, 1.0)),
                    changeValueType: true)
            )
            doc.put(
                "key22",
                JsonUtils.replaceStringValueWithVariable(doc["key22"], "text", VaString("game"))
            )

            @Expect(getIntKey(doc, "key01"), 12)
            @Expect(getStringCharKey(doc, "key02"), "game")
            @Expect(getStringCharKey(doc, "key03"), "game")
            @Expect(getStringCharKey(doc, "key04"), "15")
            @Expect(getIntKey(doc, "key05"), 15)
            @Expect(getStringCharKey(doc, "key06"), "1.5")
            @Expect(getDoubleKey(doc, "key07"), 1.5)
            @Expect(getStringCharKey(doc, "key08"),"true")
            @Expect(getBoolKey(doc, "key09"), true)
            @Expect(getStringCharKey(doc, "key10"), "[1, 1]")
            @Expect(getVector2iKey(doc, "key11") == Vector2i(1, 1))
            @Expect(getStringCharKey(doc, "key12"), "[1, 1, 1]")
            @Expect(getVector3iKey(doc, "key13") == Vector3i(1, 1, 1))
            @Expect(getStringCharKey(doc, "key14"), "[1, 1, 1, 1]")
            @Expect(getVector4iKey(doc, "key15") == IntRect(1, 1, 1, 1))
            @Expect(getStringCharKey(doc, "key16"), "[1.5, 1.0]")
            @Expect(getVector2fKey(doc, "key17") == Vector2f(1.5, 1.0))
            @Expect(getStringCharKey(doc, "key18"), "[1.5, 1.0, 1.0]")
            @Expect(getVector3fKey(doc, "key19") == Vector3f(1.5, 1.0, 1.0))
            @Expect(getStringCharKey(doc, "key20"), "[1.5, 1.0, 1.0, 1.0]")
            @Expect(getVector4fKey(doc, "key21") == FloatRect(1.5, 1.0, 1.0, 1.0))
            @Expect(getStringCharKey(doc["key22"], "subKey01") == "text")
        }
    }

    @TestCase
    func test_replaceValueWithVariable() {
        let json = ##"
        {
          "key01": 10
        }"##

        if (let Some(elem) <- JsonUtils.loadJson(json)) {
            var doc = elem.asObject()
            // string
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaString("text")))
            @Expect(getStringCharKey(doc, "key01"), "text")

            // int64
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaInteger(1200)))
            @Expect(getIntKey(doc, "key01"), 1200)

            // double
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaDouble(1.5)))
            @Expect(getDoubleKey(doc, "key01"), 1.5)

            // bool
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaBoolean(true)))
            @Expect(getBoolKey(doc, "key01"), true)

            // tuple2i
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaTuple2i((1, 1))))
            @Expect(getVector2iKey(doc, "key01") == Vector2i(1, 1))

            // tuple3i
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaTuple3i((1, 1, 1))))
            @Expect(getVector3iKey(doc, "key01") == Vector3i(1, 1, 1))

            // tuple4i
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaTuple4i((1, 1, 1, 1))))
            @Expect(getVector4iKey(doc, "key01") == IntRect(1, 1, 1, 1))

            // tuple2f
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaTuple2f((1.5, 1.0))))
            @Expect(getVector2fKey(doc, "key01") == Vector2f(1.5, 1.0))

            // tuple3f
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaTuple3f((1.5, 1.0, 1.0))))
            @Expect(getVector3fKey(doc, "key01") == Vector3f(1.5, 1.0, 1.0))

            // tuple4f
            doc.put("key01", JsonUtils.replaceValueWithVariable(VaTuple4f((1.5, 1.0, 1.0, 1.0))))
            @Expect(getVector4fKey(doc, "key01") == FloatRect(1.5, 1.0, 1.0, 1.0))
        }
    }

    @TestCase
    func test_replaceValuesWithFunction() {
        let json = ##"
        {
          "key01": "text1",
          "key02": 12,
          "key03": "text2"
        }"##

        if (let Some(elem) <- JsonUtils.loadJson(json)) {
            let doc = JsonUtils.replaceValuesWithFunction(
                elem,
                {
                    val =>
                        if (let Some(str) <- getValidString(val)) {
                            if (str.endsWith("1")) {
                                return JsonString("game")
                            }
                        } else {
                            match (val.kind()) {
                                case JsInt => return JsonFloat(2.5)
                                case _ => ()
                            }
                        }
                        return val
                }
            )

            @Expect(getStringCharKey(doc, "key01"), "game")
            @Expect(getIntKey(doc, "key02"), 12)
            @Expect(getStringCharKey(doc, "key03"), "text2")
        }
    }

    @TestCase
    func test_replaceValuesWithString() {
        let json = ##"
        {
          "key01": "This text is good Text",
          "key02": 12,
          "key03": "text"
        }"##

        if (let Some(elem) <- JsonUtils.loadJson(json)) {
            let doc = JsonUtils.replaceValuesWithString(elem, "text", "game")

            @Expect(getStringCharKey(doc, "key01"), "This game is good Text")
            @Expect(getIntKey(doc, "key02"), 12)
            @Expect(getStringCharKey(doc, "key03"), "game")
        }
    }

    @TestCase
    func test_replaceValuesWithGameVar() {
        let json = ##"
        {
          "key01": "text",
          "key02": "game.size.x",
          "key03": "%game.size.x%",
          "key04": "!game.size.x!",
          "key05": "game size: [%game.size.x%, %game.size.y%]",
          "key06": "%game.keepAR%",
          "key07": "%game.size%",
          "key08": "%game.keepAR% ",
          "key09": "game size: [%%game.size.x%, %game.size.y%]",
          "key10": "game size: [%%game.size.x%, %game.size.y%%]",
          "key11": "game size: [%%game.size.x%%, %game.size.y%%]",
          "key12": "game size: [%%game.size.x%,% %game.size.y%%]"
        }"##

        try (game = Game(reset: true)) {
            // no change value type
            if (let Some(elem) <- JsonUtils.loadJson(json)) {
                var doc = JsonUtils.replaceValuesWithGameVar(elem, game, changeValueType: false)

                @Expect(getStringCharKey(doc, "key01"), "text")
                @Expect(getStringCharKey(doc, "key02"), "game.size.x")
                @Expect(getStringCharKey(doc, "key03"), "640")
                @Expect(getStringCharKey(doc, "key04"), "!game.size.x!")
                @Expect(getStringCharKey(doc, "key05"), "game size: [640, 480]")
                @Expect(getStringCharKey(doc, "key06"), "true")
                @Expect(getStringCharKey(doc, "key07"), "[640, 480]")
                @Expect(getStringCharKey(doc, "key08"), "true ")
                @Expect(getStringCharKey(doc, "key09"), "game size: [%640, 480]")
                @Expect(getStringCharKey(doc, "key10"), "game size: [%640, 480%]")
                @Expect(getStringCharKey(doc, "key11"), "game size: [%640%, 480%]")
                @Expect(getStringCharKey(doc, "key12"), "game size: [%640,% 480%]")
            }

            // change value type
            if (let Some(elem) <- JsonUtils.loadJson(json)) {
                let doc = JsonUtils.replaceValuesWithGameVar(elem, game, changeValueType: true)

                @Expect(getStringCharKey(doc, "key01"), "text")
                @Expect(getStringCharKey(doc, "key02"), "game.size.x")
                @Expect(getIntKey(doc, "key03"), 640)
                @Expect(getStringCharKey(doc, "key04"), "!game.size.x!")
                @Expect(getStringCharKey(doc, "key05"), "game size: [640, 480]")
                @Expect(getBoolKey(doc, "key06") == true)
                @Expect(getVector2iKey(doc, "key07") == Vector2i(640, 480))
                @Expect(getBoolKey(doc, "key08"), false)
            }

            // different token
            if (let Some(elem) <- JsonUtils.loadJson(json)) {
                let doc = JsonUtils.replaceValuesWithGameVar(elem, game, changeValueType: true, token: '!')

                @Expect(getStringCharKey(doc, "key03"), "%game.size.x%")
                @Expect(getIntKey(doc, "key04"), 640)
                @Expect(getStringCharKey(doc, "key05"), "game size: [%game.size.x%, %game.size.y%]")
            }
        }
    }

    @TestCase
    func test_toString() {
        let json = ##"
        {
          "key01": "text",
          "key02": -1,
          "key03": 5.89,
          "key04": true,
          "key05": false,
          "key06": null,
          "key07": ["value", "string"],
          "key08": { "name": "object", "range": [1, 10], "unique": true }
        }"##

        if (let Some(doc) <- JsonUtils.loadJson(json)) {
            @Expect(JsonUtils.toString(doc.asObject().get("key01").getOrThrow()), "text")
            @Expect(JsonUtils.toString(doc.asObject().get("key02").getOrThrow()), "-1")
            @Expect(JsonUtils.toString(doc.asObject().get("key03").getOrThrow()), "5.89")
            @Expect(JsonUtils.toString(doc.asObject().get("key04").getOrThrow()), "true")
            @Expect(JsonUtils.toString(doc.asObject().get("key05").getOrThrow()), "false")
            @Expect(JsonUtils.toString(doc.asObject().get("key06").getOrThrow()), "null")
            @Expect(JsonUtils.toString(doc.asObject().get("key07").getOrThrow()), #"["value","string"]"#)
            @Expect(JsonUtils.toString(doc.asObject().get("key08").getOrThrow()), #"{"name":"object","range":[1,10],"unique":true}"#)
        }
    }

    @TestCase
    func test_jsonToString() {
        let json = ##"
        {
          "key01": "text",
          "key02": -1,
          "key03": 5.89,
          "key04": true,
          "key05": false,
          "key06": null,
          "key07": ["value", "string"],
          "key08": { "name": "object", "range": [1, 10], "unique": true }
        }"##

        if (let Some(doc) <- JsonUtils.loadJson(json)) {
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key01").getOrThrow()), #""text""#)
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key02").getOrThrow()), "-1")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key03").getOrThrow()), "5.89")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key04").getOrThrow()), "true")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key05").getOrThrow()), "false")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key06").getOrThrow()), "null")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key07").getOrThrow()), #"["value","string"]"#)
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key08").getOrThrow()), #"{"name":"object","range":[1,10],"unique":true}"#)
        }
    }

    @TestCase
    func test_jsonToPrettyString() {
        let json = ##"
        {
          "key01": "text",
          "key02": -1,
          "key03": 5.89,
          "key04": true,
          "key05": false,
          "key06": null,
          "key07": ["value", "string"],
          "key08": { "name": "object", "range": [1, 10], "unique": true }
        }"##

        if (let Some(doc) <- JsonUtils.loadJson(json)) {
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key01").getOrThrow()), #""text""#)
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key02").getOrThrow()), "-1")
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key03").getOrThrow()).startsWith("5.89"))
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key04").getOrThrow()), "true")
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key05").getOrThrow()), "false")
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key06").getOrThrow()), "null")
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key07").getOrThrow()), #"["value", "string"]"#)
            @Expect(JsonUtils.jsonToPrettyString(doc.asObject().get("key08").getOrThrow()), "{\n  \"name\": \"object\",\n  \"range\": [1, 10],\n  \"unique\": true\n}")
        }
    }

    @TestCase
    func test_loadFile() {
        // valid
        let doc = JsonUtils.loadFile("json/jsonFile.json")
        @Expect(doc.isSome())
        if (let Some(doc) <- doc) {
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key01").getOrThrow()), #""text""#)
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key02").getOrThrow()), "-1")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key03").getOrThrow()), "5.89")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key04").getOrThrow()), "true")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key05").getOrThrow()), "false")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key06").getOrThrow()), "null")
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key07").getOrThrow()), #"["value","string"]"#)
            @Expect(JsonUtils.jsonToString(doc.asObject().get("key08").getOrThrow()), #"{"name":"object","range":[1,10],"unique":true}"#)
        }

        // invalid
        @Expect(JsonUtils.loadFile("resources/invalidFile.json").isNone())
    }

    @TestCase
    func test_loadJsonAndReplaceValues() {
        let json = ##"
        {
          "key01": "%game.size.x%",
          "key02": "!game.size.x!"
        }"##

        try (game = Game(reset: true)) {
            // no change value type
            if (let Some(doc) <- JsonUtils.loadJsonAndReplaceValues(json, game, changeValueType: false)) {
                @Expect(getStringCharKey(doc, "key01"), "640")
                @Expect(getStringCharKey(doc, "key02"), "!game.size.x!")
            }

            // change value type
            if (let Some(doc) <- JsonUtils.loadJsonAndReplaceValues(json, game, changeValueType: true)) {
                @Expect(getIntKey(doc, "key01"), 640)
                @Expect(getStringCharKey(doc, "key02"), "!game.size.x!")
            }

            // different token
            if (let Some(doc) <- JsonUtils.loadJsonAndReplaceValues(json, game, changeValueType: true, token: '!')) {
                @Expect(getStringCharKey(doc, "key01"), "%game.size.x%")
                @Expect(getIntKey(doc, "key02"), 640)
            }
        }
    }

    @TestCase
    func test_saveToFile() {
        let json = ##"
        {
          "variable": [
            { "key01": 1234 },
            { "key02": 5.678 },
            { "key03": "text!" },
            { "key04": true },
            { "key05": [-2, 3] },
            { "key06": [-2, 3, 1200] },
            { "key07": [-2, 3, 1200, -1298] },
            { "key08": [-2.1, 3.9] },
            { "key09": [-2.1, 3.9, 4.0] },
            { "key10": [-2.1, 3.9, 4.0, 1200.87] },
            { "key11": [-2.1, 10] },
            { "key12": [10, -2.1, -2.5] },
            { "key13": [10, -2.1, -2.5, 1] }
          ]
        }"##

        // initialize
        @Expect(FileUtils.setSaveDir("dir1"), true)
        @Expect(FileUtils.mount(FileUtils.saveDir, "", true), true)

        // json
        if (let Some(doc) <- JsonUtils.loadJson(json)) {
            JsonUtils.saveToFile("saveFile1.json", doc)
            if (let Some(doc2) <- JsonUtils.loadFile("saveFile1.json")) {
                let docA = doc.asObject()
                let docB = doc2.asObject()
                @Expect(getStringKey(docA["variable"], "key01"), getStringKey(docB["variable"], "key01"))
                @Expect(getStringKey(docA["variable"], "key02"), getStringKey(docB["variable"], "key02"))
                @Expect(getStringKey(docA["variable"], "key03"), getStringKey(docB["variable"], "key03"))
                @Expect(getStringKey(docA["variable"], "key04"), getStringKey(docB["variable"], "key04"))
                @Expect(getStringKey(docA["variable"], "key05"), getStringKey(docB["variable"], "key05"))
                @Expect(getStringKey(docA["variable"], "key06"), getStringKey(docB["variable"], "key06"))
                @Expect(getStringKey(docA["variable"], "key07"), getStringKey(docB["variable"], "key07"))
                @Expect(getStringKey(docA["variable"], "key08"), getStringKey(docB["variable"], "key08"))
                @Expect(getStringKey(docA["variable"], "key09"), getStringKey(docB["variable"], "key09"))
                @Expect(getStringKey(docA["variable"], "key10"), getStringKey(docB["variable"], "key10"))
                @Expect(getStringKey(docA["variable"], "key11"), getStringKey(docB["variable"], "key11"))
                @Expect(getStringKey(docA["variable"], "key12"), getStringKey(docB["variable"], "key12"))
                @Expect(getStringKey(docA["variable"], "key13"), getStringKey(docB["variable"], "key13"))
            }
        }

        // vector
        let variables: Array<(String, Variable)> = [
            ("key01", VaInteger(1234)),
            ("key02", VaDouble(5.678)),
            ("key03", VaString("text!")),
            ("key04", VaBoolean(true)),
            ("key05", VaTuple2i((-2, 3))),
            ("key06", VaTuple3i((-2, 3, 1200))),
            ("key07", VaTuple4i((-2, 3, 1200, -1298))),
            ("key08", VaTuple2f((-2.1, 3.9))),
            ("key09", VaTuple3f((-2.1, 3.9, 4.0))),
            ("key10", VaTuple4f((-2.1, 3.9, 4.0, 1200.87)))
        ]

        JsonUtils.saveToFile("saveFile2.json", "variable", variables.iterator())

        match (JsonUtils.loadFile("saveFile2.json")) {
            case Some(elem) =>
                let doc = elem.asObject()
                @Expect(variables[0][1], getVariableKey(doc["variable"], "key01"))
                @Expect(variables[1][1], getVariableKey(doc["variable"], "key02"))
                @Expect(variables[2][1], getVariableKey(doc["variable"], "key03"))
                @Expect(variables[3][1], getVariableKey(doc["variable"], "key04"))
                @Expect(variables[4][1], getVariableKey(doc["variable"], "key05"))
                @Expect(variables[5][1], getVariableKey(doc["variable"], "key06"))
                @Expect(variables[6][1], getVariableKey(doc["variable"], "key07"))
                @Expect(variables[7][1], getVariableKey(doc["variable"], "key08"))
                @Expect(variables[8][1], getVariableKey(doc["variable"], "key09"))
                @Expect(variables[9][1], getVariableKey(doc["variable"], "key10"))
            case None => @Fail("Expected successful load of saveFile2.json")
        }

        // unmount save dir
        @Expect(FileUtils.deleteFile("saveFile1.json"), true)
        @Expect(FileUtils.deleteFile("saveFile2.json"), true)
        @Expect(FileUtils.unmount(FileUtils.saveDir), true)
    }
}
