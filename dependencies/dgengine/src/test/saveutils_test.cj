package dgengine.test

import cjsfml.system.*
import dgengine.*
import stdx.encoding.json.stream.*
import std.collection.*
import std.io.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestSaveUtils {
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
    func test_hasProperty() {
        let map = HashMap<String, Variable>([("key01", VaInteger(1234))])

        @Expect(SaveUtils.hasProperty(map, "key01"), true)
        @Expect(SaveUtils.hasProperty(map, "key02"), false)
    }

    @TestCase
    func test_getProperty() {
        let map = HashMap<String, Variable>(
            [
                ("key01", VaInteger(0)),
                ("key02", VaInteger(1234)),
                ("key03", VaDouble(0.0)),
                ("key04", VaDouble(5.678)),
                ("key05", VaString("")),
                ("key06", VaString("text!")),
                ("key07", VaBoolean(false)),
                ("key08", VaBoolean(true)),
                ("key09", VaTuple2i((-2, 3))),
                ("key10", VaTuple3i((-2, 3, 1200))),
                ("key11", VaTuple4i((-2, 3, 1200, -1298))),
                ("key12", VaTuple2f((-2.1, 3.9))),
                ("key13", VaTuple3f((-2.1, 3.9, 4.0))),
                ("key14", VaTuple4f((-2.1, 3.9, 4.0, 1200.87)))
            ]
        )

        // getBoolProperty
        @Expect(SaveUtils.getBoolProperty(map, "key01"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key02"), true)
        @Expect(SaveUtils.getBoolProperty(map, "key03"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key04"), true)
        @Expect(SaveUtils.getBoolProperty(map, "key05"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key06"), true)
        @Expect(SaveUtils.getBoolProperty(map, "key07"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key08"), true)
        @Expect(SaveUtils.getBoolProperty(map, "key09"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key10"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key11"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key12"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key13"), false)
        @Expect(SaveUtils.getBoolProperty(map, "key14"), false)

        // getInt64Property
        @Expect(SaveUtils.getInt64Property(map, "key01"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key02"), 1234)
        @Expect(SaveUtils.getInt64Property(map, "key03"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key04"), 5)
        @Expect(SaveUtils.getInt64Property(map, "key05"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key06"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key07"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key08"), 1)
        @Expect(SaveUtils.getInt64Property(map, "key09"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key10"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key11"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key12"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key13"), 0)
        @Expect(SaveUtils.getInt64Property(map, "key14"), 0)

        // getDoubleProperty
        @Expect(SaveUtils.getDoubleProperty(map, "key01"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key02"), 1234.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key03"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key04"), 5.678)
        @Expect(SaveUtils.getDoubleProperty(map, "key05"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key06"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key07"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key08"), 1.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key09"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key10"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key11"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key12"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key13"), 0.0)
        @Expect(SaveUtils.getDoubleProperty(map, "key14"), 0.0)

        // getStringProperty
        @Expect(SaveUtils.getStringProperty(map, "key01"), "0")
        @Expect(SaveUtils.getStringProperty(map, "key02"), "1234")
        @Expect(SaveUtils.getStringProperty(map, "key03"), "0.0")
        @Expect(SaveUtils.getStringProperty(map, "key04"), "5.678")
        @Expect(SaveUtils.getStringProperty(map, "key05"), "")
        @Expect(SaveUtils.getStringProperty(map, "key06"), "text!")
        @Expect(SaveUtils.getStringProperty(map, "key07"), "false")
        @Expect(SaveUtils.getStringProperty(map, "key08"), "true")
        @Expect(SaveUtils.getStringProperty(map, "key09"), "[-2, 3]")
        @Expect(SaveUtils.getStringProperty(map, "key10"), "[-2, 3, 1200]")
        @Expect(SaveUtils.getStringProperty(map, "key11"), "[-2, 3, 1200, -1298]")
        @Expect(SaveUtils.getStringProperty(map, "key12"), "[-2.1, 3.9]")
        @Expect(SaveUtils.getStringProperty(map, "key13"), "[-2.1, 3.9, 4.0]")
        @Expect(SaveUtils.getStringProperty(map, "key14"), "[-2.1, 3.9, 4.0, 1200.87]")
    }

    @TestCase
    func test_write() {
        let stream = ByteBuffer()
        let writer = JsonWriter(stream)
        writer.writeConfig = WriteConfig.pretty
        writer.writeConfig.indent = "  "

        // root
        writer.startObject()

        SaveUtils.writeValue(writer, "key01", true)
        SaveUtils.writeValue(writer, "key02", -1200)
        SaveUtils.writeValue(writer, "key03", -90000000000)
        SaveUtils.writeValue(writer, "key04", 1200)
        SaveUtils.writeValue(writer, "key05", 90000000000)
        SaveUtils.writeValue(writer, "key06", 2.5)
        SaveUtils.writeValue(writer, "key07", NumberFloat(1.5))
        SaveUtils.writeValue(writer, "key08", NumberInt(-2))
        SaveUtils.writeValue(writer, "key09", NumberUInt(2))
        SaveUtils.writeValue(writer, "key10", Vector2i(-2, 5))
        SaveUtils.writeValue(writer, "key11", Vector2f(-2.0, 5.0))
        SaveUtils.writeValue(writer, "key12", Vector2f(-2.5, 5.5))
        SaveUtils.writeValuefi(writer, "key13", Vector2f(-2.0, 5.0))
        SaveUtils.writeValuefi(writer, "key14", Vector2f(-2.5, 5.5))
        SaveUtils.writeValue(writer, "key15", "text")
        SaveUtils.writeValue(writer, "key16", "text")
        SaveUtils.writeValue(writer, "key17", VaInteger(0))
        SaveUtils.writeValue(writer, "key18", VaInteger(1234))
        SaveUtils.writeValue(writer, "key19", VaDouble(0.0))
        SaveUtils.writeValue(writer, "key20", VaDouble(5.678))
        SaveUtils.writeValue(writer, "key21", VaString(""))
        SaveUtils.writeValue(writer, "key22", VaString("text!"))
        SaveUtils.writeValue(writer, "key23", VaBoolean(true))
        SaveUtils.writeValue(writer, "key24", VaTuple2i((-2, 3)))
        SaveUtils.writeValue(writer, "key25", VaTuple3i((-2, 3, 1200)))
        SaveUtils.writeValue(writer, "key26", VaTuple4i((-2, 3, 1200, -1298)))
        SaveUtils.writeValue(writer, "key27", VaTuple2f((-2.1, 3.9)))
        SaveUtils.writeValue(writer, "key28", VaTuple3f((-2.1, 3.9, 4.0)))
        SaveUtils.writeValue(writer, "key29", VaTuple4f((-2.1, 3.9, 4.0, 1200.87)))

        // root
        writer.endObject()
        writer.flush()

        let json = String.fromUtf8(stream.bytes())
        @Expect(FileUtils.readText("json/saveFile.json"), json)

        if (let Some(doc) <- JsonUtils.loadJson(json)) {
            @Expect(getBoolKey(doc,       "key01"), true)
            @Expect(getIntKey(doc,        "key02"), -1200)
            @Expect(getInt64Key(doc,      "key03"), -90000000000)
            @Expect(getUIntKey(doc,       "key04"), 1200)
            @Expect(getUInt64Key(doc,     "key05"), 90000000000)
            @Expect(getDoubleKey(doc,     "key06"), 2.5)
            @Expect(getDoubleKey(doc,     "key07"), 1.5)
            @Expect(getIntKey(doc,        "key08"), -2)
            @Expect(getUIntKey(doc,       "key09"), 2)
            @Expect(getVector2iKey(doc,   "key10") == Vector2i(-2, 5))
            @Expect(getVector2fKey(doc,   "key11") == Vector2f(-2.0, 5.0))
            @Expect(getVector2fKey(doc,   "key12") == Vector2f(-2.5, 5.5))
            @Expect(getVector2fKey(doc,   "key13") == Vector2f(-2.0, 5.0))
            @Expect(getVector2fKey(doc,   "key14") == Vector2f(-2.5, 5.5))
            @Expect(getStringCharKey(doc, "key15"), "text")
            @Expect(getStringCharKey(doc, "key16"), "text")
            @Expect(getVariableKey(doc,   "key17"), VaInteger(0))
            @Expect(getVariableKey(doc,   "key18"), VaInteger(1234))
            @Expect(getVariableKey(doc,   "key19"), VaDouble(0.0))
            @Expect(getVariableKey(doc,   "key20"), VaDouble(5.678))
            @Expect(getVariableKey(doc,   "key21"), VaString(""))
            @Expect(getVariableKey(doc,   "key22"), VaString("text!"))
            @Expect(getVariableKey(doc,   "key23"), VaBoolean(true))
            @Expect(getVariableKey(doc,   "key24"), VaTuple2i((-2, 3)))
            @Expect(getVariableKey(doc,   "key25"), VaTuple3i((-2, 3, 1200)))
            @Expect(getVariableKey(doc,   "key26"), VaTuple4i((-2, 3, 1200, -1298)))
            @Expect(getVariableKey(doc,   "key27"), VaTuple2f((-2.1, 3.9)))
            @Expect(getVariableKey(doc,   "key28"), VaTuple3f((-2.1, 3.9, 4.0)))
            @Expect(getVariableKey(doc,   "key29"), VaTuple4f((-2.1, 3.9, 4.0, 1200.87)))
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
