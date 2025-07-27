package dgengine.test

import dgengine.*
import std.unittest.*

@Test
func test_getIdFromFile() {
    @Expect(getIdFromFile(""), None)
    @Expect(getIdFromFile("file"), Some("file"))
    @Expect(getIdFromFile("file.txt"), Some("file"))
    @Expect(getIdFromFile("path 1/file.txt"), Some("file"))
    @Expect(getIdFromFile("path 1/file/...fi.le.txt"), Some("file"))
    @Expect(getIdFromFile("path 1//file."),Some("file"))
    @Expect(getIdFromFile("path 1//file.."), Some("file"))
    @Expect(getIdFromFile("path 1//.txt"), Some("txt"))
    @Expect(getIdFromFile("path 1//file/"), Some("file"))
    @Expect(getIdFromFile("path 1//file/."), None)
    @Expect(getIdFromFile("path 1//file/.."), None)
    @Expect(getIdFromFile("path 1//file/..."), None)
}

@Test
func test_getValidArray() {
    let json = ##"
    {
      "key01": "text",
      "key02": null,
      "key03": 1,
      "key04": true,
      "key05": [],
      "key06": ["text"],
      "key07": ["text", 1],
      "key08": [1.2, null],
      "key09": [[10, 20], [true, false]]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getValidArray(doc, "key01").isNone())
        @Expect(getValidArray(doc, "key02").isNone())
        @Expect(getValidArray(doc, "key03").isNone())
        @Expect(getValidArray(doc, "key04").isNone())
        @Expect(getValidArray(doc, "key05").isNone())
        @Expect(getValidArray(doc, "key06").isSome())
        @Expect(getValidArray(doc, "key07").isSome())
        @Expect(getValidArray(doc, "key08").isSome())
        @Expect(getValidArray(doc, "key09").isSome())
        @Expect(getValidArray(doc, "invalid").isNone())
        @Expect(getValidArray(doc.asObject().get("key01").getOrThrow(), "invalid").isNone())

        @Expect(getValidArray(doc.asObject().get("key01").getOrThrow()).isNone())
        @Expect(getValidArray(doc.asObject().get("key05").getOrThrow()).isNone())
        @Expect(getValidArray(doc.asObject().get("key06").getOrThrow()).isSome())
    }
}

@Test
func test_isValidArray() {
    let json = ##"
    {
      "key01": "text",
      "key02": null,
      "key03": 1,
      "key04": true,
      "key05": [],
      "key06": ["text"],
      "key07": ["text", 1],
      "key08": [1.2, null],
      "key09": [[10, 20], [true, false]]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(isValidArray(doc, "key01"), false)
        @Expect(isValidArray(doc, "key02"), false)
        @Expect(isValidArray(doc, "key03"), false)
        @Expect(isValidArray(doc, "key04"), false)
        @Expect(isValidArray(doc, "key05"), false)
        @Expect(isValidArray(doc, "key06"), true)
        @Expect(isValidArray(doc, "key07"), true)
        @Expect(isValidArray(doc, "key08"), true)
        @Expect(isValidArray(doc, "key09"), true)
        @Expect(isValidArray(doc, "invalid"), false)
        @Expect(isValidArray(doc.asObject().get("key01").getOrThrow(), "invalid"), false)

        @Expect(isValidArray(doc.asObject().get("key01").getOrThrow()), false)
        @Expect(isValidArray(doc.asObject().get("key05").getOrThrow()), false)
        @Expect(isValidArray(doc.asObject().get("key06").getOrThrow()), true)
    }
}

@Test
func test_isValidId() {
    @Expect(isValidId(""), false)
    @Expect(isValidId("_"), true)
    @Expect(isValidId("abcdefghijklmnopqrstuvwxyz"), true)
    @Expect(isValidId("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), true)
    @Expect(isValidId("0123456789_"), true)
    @Expect(isValidId("àéîöu"), false)
    @Expect(isValidId("ab cd"), false)
    @Expect(isValidId("12 24"), false)
    @Expect(isValidId("ab "), false)
    @Expect(isValidId(" ab"), false)
    @Expect(isValidId("ab.cd"), false)
    @Expect(isValidId("12.24"), false)
    @Expect(isValidId("ab."), false)
    @Expect(isValidId(".ab"), false)
}

@Test
func test_getValidObject() {
    let json = ##"
    {
      "key01": "text",
      "key02": null,
      "key03": 1,
      "key04": true,
      "key05": {},
      "key06": { "key": 1 },
      "key07": { "key": 1, "key2": "text" }
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getValidObject(doc, "key01").isNone())
        @Expect(getValidObject(doc, "key02").isNone())
        @Expect(getValidObject(doc, "key03").isNone())
        @Expect(getValidObject(doc, "key04").isNone())
        @Expect(getValidObject(doc, "key05").isNone())
        @Expect(getValidObject(doc, "key06").isSome())
        @Expect(getValidObject(doc, "key07").isSome())
        @Expect(getValidObject(doc, "invalid").isNone())
        @Expect(getValidObject(doc.asObject().get("key01").getOrThrow(), "invalid").isNone())

        @Expect(getValidObject(doc.asObject().get("key01").getOrThrow()).isNone())
        @Expect(getValidObject(doc.asObject().get("key05").getOrThrow()).isNone())
        @Expect(getValidObject(doc.asObject().get("key06").getOrThrow()).isSome())
    }
}

@Test
func test_isValidObject() {
    let json = ##"
    {
      "key01": "text",
      "key02": null,
      "key03": 1,
      "key04": true,
      "key05": {},
      "key06": { "key": 1 },
      "key07": { "key": 1, "key2": "text" }
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(isValidObject(doc, "key01"), false)
        @Expect(isValidObject(doc, "key02"), false)
        @Expect(isValidObject(doc, "key03"), false)
        @Expect(isValidObject(doc, "key04"), false)
        @Expect(isValidObject(doc, "key05"), false)
        @Expect(isValidObject(doc, "key06"), true)
        @Expect(isValidObject(doc, "key07"), true)
        @Expect(isValidObject(doc, "invalid"), false)
        @Expect(isValidObject(doc.asObject().get("key01").getOrThrow(), "invalid"), false)

        @Expect(isValidObject(doc.asObject().get("key01").getOrThrow()), false)
        @Expect(isValidObject(doc.asObject().get("key05").getOrThrow()), false)
        @Expect(isValidObject(doc.asObject().get("key06").getOrThrow()), true)
    }
}

@Test
func test_getValidString() {
    let json = ##"
    {
      "key01": "text",
      "key02": "",
      "key03": null,
      "key04": 1,
      "key05": true,
      "key06": ["text"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getValidString(doc, "key01"), Some("text"))
        @Expect(getValidString(doc, "key02"), None)
        @Expect(getValidString(doc, "key03"), None)
        @Expect(getValidString(doc, "key04"), None)
        @Expect(getValidString(doc, "key05"), None)
        @Expect(getValidString(doc, "key06"), None)
        @Expect(getValidString(doc, "invalid"), None)
        @Expect(getValidString(doc.asObject().get("key01").getOrThrow(), "invalid"), None)
    }
}

@Test
func test_isValidString() {
    let json = ##"
    {
      "key01": "text",
      "key02": "",
      "key03": null,
      "key04": 1,
      "key05": true,
      "key06": ["text"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(isValidString(doc.asObject().get("key01").getOrThrow()), true)
        @Expect(isValidString(doc.asObject().get("key02").getOrThrow()), false)

        @Expect(isValidString(doc, "key01"), true)
        @Expect(isValidString(doc, "key02"), false)
        @Expect(isValidString(doc, "key03"), false)
        @Expect(isValidString(doc, "key04"), false)
        @Expect(isValidString(doc, "key05"), false)
        @Expect(isValidString(doc, "key06"), false)
        @Expect(isValidString(doc, "invalid"), false)
        @Expect(isValidString(doc.asObject().get("key01").getOrThrow(), "invalid"), false)
    }
}
