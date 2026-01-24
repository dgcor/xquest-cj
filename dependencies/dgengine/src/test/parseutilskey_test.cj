package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import stdx.encoding.json.*
import std.collection.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.03 class names should be upper camel case
// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
func test_getAnchorKey() {
    let json = ##"
    {
      "key01": { "key01": "all" },
      "key02": "all",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getAnchorKey(doc.asObject().get("key01").getOrThrow(), "key01"), Anchor.All)
        @Expect(getAnchorKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Anchor.Left), Anchor.Left)
        @Expect(getAnchorKey(doc.asObject().get("key03").getOrThrow(), "key03"), (Anchor.Top | Anchor.Left))
    }
}

@Test
func test_getAnimationTypeKey() {
    let json = ##"
    {
      "key01": { "key01": "playOnce" },
      "key02": "playOnce",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getAnimationTypeKey(doc.asObject().get("key01").getOrThrow(), "key01"), AnimationType.PlayOnce)
        @Expect(getAnimationTypeKey(doc.asObject().get("key02").getOrThrow(), "key02", default: AnimationType.BackAndForth), AnimationType.BackAndForth)
        @Expect(getAnimationTypeKey(doc.asObject().get("key03").getOrThrow(), "key03"), AnimationType.Looped)
    }
}

@Test
func test_getBindingFlagsKey() {
    let json = ##"
    {
      "key01": { "key01": "always" },
      "key02": "always",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getBindingFlagsKey(doc.asObject().get("key01").getOrThrow(), "key01"), BindingFlags.Always)
        @Expect(getBindingFlagsKey(doc.asObject().get("key02").getOrThrow(), "key02", default: BindingFlags.Once), BindingFlags.Once)
        @Expect(getBindingFlagsKey(doc.asObject().get("key03").getOrThrow(), "key03"), BindingFlags.OnChange)
    }
}

@Test
func test_getBlendModeKey() {
    let json = ##"
    {
      "key01": { "key01": "add" },
      "key02": "add",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getBlendModeKey(doc.asObject().get("key01").getOrThrow(), "key01"), BlendAdd)
        @Expect(getBlendModeKey(doc.asObject().get("key02").getOrThrow(), "key02", default: BlendMax), BlendMax)
        @Expect(getBlendModeKey(doc.asObject().get("key03").getOrThrow(), "key03"), BlendAlpha)
    }
}

@Test
func test_getDirectionKey() {
    let json = ##"
    {
      "key01": { "key01": "left" },
      "key02": "left",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getDirectionKey(doc.asObject().get("key01").getOrThrow(), "key01"), Direction.Left)
        @Expect(getDirectionKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Direction.Right), Direction.Right)
        @Expect(getDirectionKey(doc.asObject().get("key03").getOrThrow(), "key03"), Direction.Up)
    }
}

@Test
func test_getBoolKey() {
    let json = ##"
    {
      "key01": { "key01": true },
      "key02": false,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getBoolKey(doc.asObject().get("key01").getOrThrow(), "key01"), true)
        @Expect(getBoolKey(doc.asObject().get("key02").getOrThrow(), "key02", default: true), true)
        @Expect(getBoolKey(doc.asObject().get("key03").getOrThrow(), "key03"), false)
    }
}

@Test
func test_getDoubleKey() {
    let json = ##"
    {
      "key01": { "key01": 1.0 },
      "key02": 0.0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getDoubleKey(doc.asObject().get("key01").getOrThrow(), "key01"), 1.0)
        @Expect(getDoubleKey(doc.asObject().get("key02").getOrThrow(), "key02", default: 1.0), 1.0)
        @Expect(getDoubleKey(doc.asObject().get("key03").getOrThrow(), "key03"), 0.0)
    }
}

@Test
func test_getFloatKey() {
    let json = ##"
    {
      "key01": { "key01": 1.0 },
      "key02": 0.0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getFloatKey(doc.asObject().get("key01").getOrThrow(), "key01"), 1.0)
        @Expect(getFloatKey(doc.asObject().get("key02").getOrThrow(), "key02", default: 1.0), 1.0)
        @Expect(getFloatKey(doc.asObject().get("key03").getOrThrow(), "key03"), 0.0)
    }
}

@Test
func test_getIntKey() {
    let json = ##"
    {
      "key01": { "key01": -1 },
      "key02": 0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getIntKey(doc.asObject().get("key01").getOrThrow(), "key01"), -1)
        @Expect(getIntKey(doc.asObject().get("key02").getOrThrow(), "key02", default: 1), 1)
        @Expect(getIntKey(doc.asObject().get("key03").getOrThrow(), "key03"), 0)
    }
}

@Test
func test_getInt64Key() {
    let json = ##"
    {
      "key01": { "key01": -1 },
      "key02": 0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getInt64Key(doc.asObject().get("key01").getOrThrow(), "key01"), -1)
        @Expect(getInt64Key(doc.asObject().get("key02").getOrThrow(), "key02", default: 1), 1)
        @Expect(getInt64Key(doc.asObject().get("key03").getOrThrow(), "key03"), 0)
    }
}

@Test
func test_getStringCharKey() {
    let json = ##"
    {
      "key01": { "key01": "text", "key02": 120 },
      "key02": "invalid",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getStringCharKey(doc.asObject().get("key01").getOrThrow(), "key01"), "text")
        @Expect(getStringCharKey(doc.asObject().get("key01").getOrThrow(), "key02"), "")
        @Expect(getStringCharKey(doc.asObject().get("key02").getOrThrow(), "key02", default: "text"), "text")
        @Expect(getStringCharKey(doc.asObject().get("key03").getOrThrow(), "key03"), "")
    }
}

@Test
func test_getStringKey() {
    let json = ##"
    {
      "key01": { "key01": "text", "key02": 120 },
      "key02": "invalid",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getStringKey(doc.asObject().get("key01").getOrThrow(), "key01"), "text")
        @Expect(getStringKey(doc.asObject().get("key01").getOrThrow(), "key02"), "120")
        @Expect(getStringKey(doc.asObject().get("key02").getOrThrow(), "key02", default: "text"), "text")
        @Expect(getStringKey(doc.asObject().get("key03").getOrThrow(), "key03"), "")
    }
}

@Test
func test_getUIntKey() {
    let json = ##"
    {
      "key01": { "key01": 1 },
      "key02": 0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getUIntKey(doc.asObject().get("key01").getOrThrow(), "key01"), 1)
        @Expect(getUIntKey(doc.asObject().get("key02").getOrThrow(), "key02", default: 1), 1)
        @Expect(getUIntKey(doc.asObject().get("key03").getOrThrow(), "key03"), 0)
    }
}

@Test
func test_getUInt64Key() {
    let json = ##"
    {
      "key01": { "key01": 1 },
      "key02": 0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getUInt64Key(doc.asObject().get("key01").getOrThrow(), "key01"), 1)
        @Expect(getUInt64Key(doc.asObject().get("key02").getOrThrow(), "key02", default: 1), 1)
        @Expect(getUInt64Key(doc.asObject().get("key03").getOrThrow(), "key03"), 0)
    }
}

@Test
func test_getNumberKey() {
    let json = ##"
    {
      "key01": { "key01": 1, "key02": -1 },
      "key02": 0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getNumberKey(doc.asObject().get("key01").getOrThrow(), "key01", default: 0), 1)
        @Expect(getNumberKey(doc.asObject().get("key01").getOrThrow(), "key02", default: 0), -1)
        @Expect(getNumberKey(doc.asObject().get("key02").getOrThrow(), "key02", default: -1), -1)
        @Expect(getNumberKey(doc.asObject().get("key03").getOrThrow(), "key03", default: 0), 0)
    }
}

@Test
func test_getUnsignedNumberKey() {
    let json = ##"
    {
      "key01": { "key01": 1, "key02": -1 },
      "key02": 0,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getUnsignedNumberKey(doc.asObject().get("key01").getOrThrow(), "key01", default: 0), 1)
        @Expect(getUnsignedNumberKey(doc.asObject().get("key01").getOrThrow(), "key02", default: 0), 0)
        @Expect(getUnsignedNumberKey(doc.asObject().get("key02").getOrThrow(), "key02", default: -1), -1)
        @Expect(getUnsignedNumberKey(doc.asObject().get("key03").getOrThrow(), "key03", default: 0), 0)
    }
}

@Test
class Test_getVector2NumberKey {
    let json = ##"
    {
      "key01": { "key01": [1, -2] },
      "key02": [1, 2],
      "key03": null
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Float32() {
        @Expect(getVector2fKey(doc.asObject().get("key01").getOrThrow(), "key01") == Vector2f(1.0, -2.0))
        @Expect(getVector2fKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Vector2f(-1.0, 2.0)) == Vector2f(-1.0, 2.0))
        @Expect(getVector2fKey(doc.asObject().get("key03").getOrThrow(), "key03") == Vector2f())
    }

    @TestCase
    func test_Int32() {
        @Expect(getVector2iKey(doc.asObject().get("key01").getOrThrow(), "key01") == Vector2i(1, -2))
        @Expect(getVector2iKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Vector2i(-1, 2)) == Vector2i(-1, 2))
        @Expect(getVector2iKey(doc.asObject().get("key03").getOrThrow(), "key03") == Vector2i())
    }

    @TestCase
    func test_UInt32() {
        @Expect(getVector2uKey(doc.asObject().get("key01").getOrThrow(), "key01") == Vector2u(1, 0))
        @Expect(getVector2uKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Vector2u(1, 2)) == Vector2u(1, 2))
        @Expect(getVector2uKey(doc.asObject().get("key03").getOrThrow(), "key03") == Vector2u())
    }
}

@Test
func test_getVector2UnsignedNumberKey() {
    let json = ##"
    {
      "key01": { "key01": [1, -2] },
      "key02": [1, 2],
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getVector2UnsignedNumberKey(doc.asObject().get("key01").getOrThrow(), "key01", default: Vector2i()) == Vector2i(1, 0))
        @Expect(getVector2UnsignedNumberKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Vector2i(-1, 2)) == Vector2i(-1, 2))
        @Expect(getVector2UnsignedNumberKey(doc.asObject().get("key03").getOrThrow(), "key03", default: Vector2i()) == Vector2i())
    }
}

@Test
class Test_getVector3NumberKey {
    let json = ##"
    {
      "key01": { "key01": [1, -2, 3.5] },
      "key02": [1, 2, 3],
      "key03": null
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Float32() {
        @Expect(getVector3fKey(doc.asObject().get("key01").getOrThrow(), "key01") == Vector3f(1.0, -2.0, 3.5))
        @Expect(getVector3fKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Vector3f(-1.0, 2.0, 0.0)) == Vector3f(-1.0, 2.0, 0.0))
        @Expect(getVector3fKey(doc.asObject().get("key03").getOrThrow(), "key03") == Vector3f())
    }

    @TestCase
    func test_Int32() {
        @Expect(getVector3iKey(doc.asObject().get("key01").getOrThrow(), "key01") == Vector3i(1, -2, 3))
        @Expect(getVector3iKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Vector3i(-1, 2, 0)) == Vector3i(-1, 2, 0))
        @Expect(getVector3iKey(doc.asObject().get("key03").getOrThrow(), "key03") == Vector3i())
    }
}

@Test
class Test_getVector4NumberKey {
    let json = ##"
    {
      "key01": { "key01": [1, -2, 3.5, 0] },
      "key02": [1, 2, 3, 0],
      "key03": null
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Float32() {
        @Expect(getVector4fKey(doc.asObject().get("key01").getOrThrow(), "key01") == FloatRect(1.0, -2.0, 3.5, 0.0))
        @Expect(getVector4fKey(doc.asObject().get("key02").getOrThrow(), "key02", default: FloatRect(-1.0, 2.0, 0.0, 0.0)) == FloatRect(-1.0, 2.0, 0.0, 0.0))
        @Expect(getVector4fKey(doc.asObject().get("key03").getOrThrow(), "key03") == FloatRect())
    }

    @TestCase
    func test_Int32() {
        @Expect(getVector4iKey(doc.asObject().get("key01").getOrThrow(), "key01") == IntRect(1, -2, 3, 0))
        @Expect(getVector4iKey(doc.asObject().get("key02").getOrThrow(), "key02", default: IntRect(-1, 2, 0, 0)) == IntRect(-1, 2, 0, 0))
        @Expect(getVector4iKey(doc.asObject().get("key03").getOrThrow(), "key03") == IntRect())
    }
}

@Test
class Test_getRangeOrValueKey {
    let json = ##"
    {
      "key01": { "key01": [1, -2], "key02": 1 },
      "key02": [1, 2],
      "key03": null
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Int32() {
        @Expect(getRangeOrValueKey(doc.asObject().get("key01").getOrThrow(), "key01", default: (0i32, 0i32)) == (1i32, -2i32))
        @Expect(getRangeOrValueKey(doc.asObject().get("key01").getOrThrow(), "key02", default: (0i32, 0i32)) == (1i32, 1i32))
        @Expect(getRangeOrValueKey(doc.asObject().get("key02").getOrThrow(), "key02", default: (-1i32, 2)) == (-1i32, 2i32))
        @Expect(getRangeOrValueKey(doc.asObject().get("key03").getOrThrow(), "key03", default: (0i32, 0i32)) == (0i32, 0i32))
    }
}

@Test
class Test_getRangeNKey {
    let json = ##"
    {
      "key01": { "key01": [1, -2], "key02": 1 },
      "key02": [1, 2],
      "key03": null
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_getRange0Key() {
        @Expect(getRange0Key(doc.asObject().get("key01").getOrThrow(), "key01", default: (0i32, 0i32)) == (1i32, -2i32))
        @Expect(getRange0Key(doc.asObject().get("key01").getOrThrow(), "key02", default: (0i32, 0i32)) == (0i32, 1i32))
        @Expect(getRange0Key(doc.asObject().get("key02").getOrThrow(), "key02", default: (-1i32, 2i32)) == (-1i32, 2i32))
        @Expect(getRange0Key(doc.asObject().get("key03").getOrThrow(), "key03", default: (0i32, 0i32)) == (0i32, 0i32))
    }

    @TestCase
    func test_getRange1Key() {
        @Expect(getRange1Key(doc.asObject().get("key01").getOrThrow(), "key01", default: (0i32, 0i32)) == (1i32, -2i32))
        @Expect(getRange1Key(doc.asObject().get("key01").getOrThrow(), "key02", default: (0i32, 0i32)) == (1i32, 1i32))
        @Expect(getRange1Key(doc.asObject().get("key02").getOrThrow(), "key02", default: (-1i32, 2i32)) == (-1i32, 2i32))
        @Expect(getRange1Key(doc.asObject().get("key03").getOrThrow(), "key03", default: (0i32, 0i32)) == (0i32, 0i32))
    }

    @TestCase
    func test_getRangeNKey() {
        @Expect(getRangeNKey(doc.asObject().get("key01").getOrThrow(), "key01", minVal: 10, default: (0i32, 0i32)) == (1i32, -2i32))
        @Expect(getRangeNKey(doc.asObject().get("key01").getOrThrow(), "key02", minVal: 10, default: (0i32, 0i32)) == (10i32, 1i32))
        @Expect(getRangeNKey(doc.asObject().get("key02").getOrThrow(), "key02", minVal: 10, default: (-1i32, 2i32)) == (-1i32, 2i32))
        @Expect(getRangeNKey(doc.asObject().get("key03").getOrThrow(), "key03", minVal: 10, default: (0i32, 0i32)) == (0i32, 0i32))
    }
}

@Test
func test_getPositionKey() {
    let json = ##"
    {
      "key01": { "key01": [1, "center"] },
      "key02": [1, 2],
      "key03": null
    }"##
    let size = Vector2f(10.0, 10.0)
    let refSize = Vector2u(320, 240)

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getPositionKey(doc.asObject().get("key01").getOrThrow(), "key01", size, refSize) == Vector2f(1.0, 115.0))
        @Expect(getPositionKey(doc.asObject().get("key02").getOrThrow(), "key02", size, refSize) == Vector2f())
        @Expect(getPositionKey(doc.asObject().get("key03").getOrThrow(), "key03", size, refSize) == Vector2f())
    }
}

@Test
func test_getSizeKey() {
    let json = ##"
    {
      "key01": { "key01": [1, 2] },
      "key02": [1, 2],
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getSizeKey(doc.asObject().get("key01").getOrThrow(), "key01") == Vector2f(1.0, 2.0))
        @Expect(getSizeKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Vector2f(-1.0, 2.0)) == Vector2f(-1.0, 2.0))
        @Expect(getSizeKey(doc.asObject().get("key03").getOrThrow(), "key03") == Vector2f())
    }
}

@Test
func test_getFloatRectKey() {
    let json = ##"
    {
      "key01": { "key01": [1, 2, 3, 4] },
      "key02": [1, 2, 3, 4],
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getFloatRectKey(doc.asObject().get("key01").getOrThrow(), "key01") == FloatRect(1.0, 2.0, 3.0, 4.0))
        @Expect(getFloatRectKey(doc.asObject().get("key02").getOrThrow(), "key02", default: FloatRect(-1.0, 2.0, 3.0, 4.0)) == FloatRect(-1.0, 2.0, 3.0, 4.0))
        @Expect(getFloatRectKey(doc.asObject().get("key03").getOrThrow(), "key03") == FloatRect())
    }
}

@Test
func test_getIntRectKey() {
    let json = ##"
    {
      "key01": { "key01": [1, 2, 3, 4] },
      "key02": [1, 2, 3, 4],
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getIntRectKey(doc.asObject().get("key01").getOrThrow(), "key01") == IntRect(1, 2, 3, 4))
        @Expect(getIntRectKey(doc.asObject().get("key02").getOrThrow(), "key02", default: IntRect(-1, 2, 3, 4)) == IntRect(-1, 2, 3, 4))
        @Expect(getIntRectKey(doc.asObject().get("key03").getOrThrow(), "key03") == IntRect())
    }
}

@Test
func test_getColorKey() {
    let json = ##"
    {
      "key01": { "key01": "0x0000FF" },
      "key02": "0x0000FF",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getColorKey(doc.asObject().get("key01").getOrThrow(), "key01") == Color.BLUE)
        @Expect(getColorKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Color.RED) == Color.RED)
        @Expect(getColorKey(doc.asObject().get("key03").getOrThrow(), "key03") == Color.BLACK)
    }
}

@Test
func test_getTimeKey() {
    let json = ##"
    {
      "key01": { "key01": 1200, "key02": -1200 },
      "key02": 1200,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getTimeKey(doc.asObject().get("key01").getOrThrow(), "key01") == Time(milliseconds: 1200))
        @Expect(getTimeKey(doc.asObject().get("key01").getOrThrow(), "key02") == Time(milliseconds: -1200))
        @Expect(getTimeKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Time(seconds: 1.0)) == Time(seconds: 1.0))
        @Expect(getTimeKey(doc.asObject().get("key03").getOrThrow(), "key03") == Time.ZERO)
    }
}

@Test
func test_getTimeUKey() {
    let json = ##"
    {
      "key01": { "key01": 1200, "key02": -1200 },
      "key02": 1200,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getTimeUKey(doc.asObject().get("key01").getOrThrow(), "key01") == Time(milliseconds: 1200))
        @Expect(getTimeUKey(doc.asObject().get("key01").getOrThrow(), "key02") == Time.ZERO)
        @Expect(getTimeUKey(doc.asObject().get("key02").getOrThrow(), "key02", default: Time(seconds: 1.0)) == Time(seconds: 1.0))
        @Expect(getTimeUKey(doc.asObject().get("key03").getOrThrow(), "key03") == Time.ZERO)
    }
}

@Test
func test_getStringVectorKey() {
    let json = ##"
    {
      "key01": ["this", "is", 1, true, "string", 9.9]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        var vec = ArrayList(["this", "is", "1", "true", "string", "9.9"])

        @Expect(getStringVectorKey(doc, "key01"), vec)

        vec.clear()

        @Expect(getStringVectorKey(doc, "key02"), vec)
    }
}

@Test
func test_getValidStringVectorKey() {
    let json = ##"
    {
      "key01": ["this", "is", 1, true, "string", 9.9]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        var vec = ArrayList(["this", "is", "string"])

        @Expect(getValidStringVectorKey(doc, "key01"), vec)

        vec.clear()

        @Expect(getValidStringVectorKey(doc, "key02"), vec)
    }
}

@Test
func test_getIgnoreResourceKey() {
    let json = ##"
    {
      "key01": { "key01": "draw", "key02": ["draw", "update"] },
      "key02": "draw",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getIgnoreResourceKey(doc.asObject().get("key01").getOrThrow(), "key01"), IgnoreResource.Draw)
        @Expect(getIgnoreResourceKey(doc.asObject().get("key01").getOrThrow(), "key02"), (IgnoreResource.Draw | IgnoreResource.Update))
        @Expect(getIgnoreResourceKey(doc.asObject().get("key02").getOrThrow(), "key02", default: IgnoreResource.Update), IgnoreResource.Update)
        @Expect(getIgnoreResourceKey(doc.asObject().get("key03").getOrThrow(), "key03"), IgnoreResource.None)
    }
}

@Test
func test_getInputEventTypeKey() {
    let json = ##"
    {
      "key01": { "key01": "mousePress", "key02": ["mousePress", "mouseRelease"] },
      "key02": "draw",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getInputEventTypeKey(doc.asObject().get("key01").getOrThrow(), "key01"), InputEventType.MousePress)
        @Expect(getInputEventTypeKey(doc.asObject().get("key01").getOrThrow(), "key02"), (InputEventType.MousePress | InputEventType.MouseRelease))
        @Expect(getInputEventTypeKey(doc.asObject().get("key02").getOrThrow(), "key02", default: InputEventType.LeftClick), InputEventType.LeftClick)
        @Expect(getInputEventTypeKey(doc.asObject().get("key03").getOrThrow(), "key03"), InputEventType.None)
    }
}

@Test
func test_getMinMaxIntKey() {
    let json = ##"
    {
      "key01": { "key01": "max", "key02": 1 },
      "key02": 1,
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getMinMaxIntKey(doc.asObject().get("key01").getOrThrow(), "key01", default: 0i32), Int32.Max)
        @Expect(getMinMaxIntKey(doc.asObject().get("key01").getOrThrow(), "key02", default: 0i32), 1i32)
        @Expect(getMinMaxIntKey(doc.asObject().get("key02").getOrThrow(), "key02", default: 2i32), 2i32)
        @Expect(getMinMaxIntKey(doc.asObject().get("key03").getOrThrow(), "key03", default: 0i32), 0i32)
    }
}

@Test
func test_getPrimitiveTypeKey() {
    let json = ##"
    {
      "key01": { "key01": "points" },
      "key02": "points",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getPrimitiveTypeKey(doc.asObject().get("key01").getOrThrow(), "key01") == PrimitiveType.Points)
        @Expect(getPrimitiveTypeKey(doc.asObject().get("key02").getOrThrow(), "key02", default: PrimitiveType.Triangles) == PrimitiveType.Triangles)
        @Expect(getPrimitiveTypeKey(doc.asObject().get("key03").getOrThrow(), "key03") == PrimitiveType.TriangleStrip)
    }
}

@Test
func test_getReplaceVarsKey() {
    let json = ##"
    {
      "key01": { "key01": "string" },
      "key02": "string",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getReplaceVarsKey(doc.asObject().get("key01").getOrThrow(), "key01"), ReplaceString)
        @Expect(getReplaceVarsKey(doc.asObject().get("key02").getOrThrow(), "key02", default: ReplaceValue), ReplaceValue)
        @Expect(getReplaceVarsKey(doc.asObject().get("key03").getOrThrow(), "key03"), ReplaceNone)
    }
}

@Test
func test_getVariableKey() {
    let json = ##"
    {
      "key01": { "key01": "string" },
      "key02": "string",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getVariableKey(doc.asObject().get("key01").getOrThrow(), "key01"), VaString("string"))
        @Expect(getVariableKey(doc.asObject().get("key02").getOrThrow(), "key02").isNone())
        @Expect(getVariableKey(doc.asObject().get("key03").getOrThrow(), "key03").isNone())
    }
}

@Test
func test_getVariablesKey() {
    let json = ##"
    {
      "key01": { "id": "id1", "value": 10 },
      "key02": "string",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        let vars = getVariablesKey(doc, "key01")
        @Expect(vars.size, 2)

        @Expect(vars[0][0], "id")
        @Expect(vars[0][1], VaString("id1"))

        @Expect(vars[1][0], "value")
        @Expect(vars[1][1], VaInteger(10))

        @Expect(getVariablesKey(doc, "key02").size, 0)
        @Expect(getVariablesKey(doc, "key03").size, 0)
        @Expect(getVariablesKey(doc, "key04").size, 0)
    }
}

@Test
func test_getVariablesMapKey() {
    let json = ##"
    {
      "key01": { "id": "id1", "value": 10 },
      "key02": "string",
      "key03": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        let vars = getVariablesMapKey(doc, "key01")
        @Expect(vars.size, 2)

        @Expect(vars["id"], VaString("id1"))
        @Expect(vars["value"], VaInteger(10))

        @Expect(getVariablesKey(doc, "key02").size, 0)
        @Expect(getVariablesKey(doc, "key03").size, 0)
        @Expect(getVariablesKey(doc, "key04").size, 0)
    }
}

@Test
func test_getVarOrPredicateKey() {
    let json = ##"
    {
      "key01": { "key01": "string", "key02": { "name": "file.exists", "file": "text.txt" } },
      "key02": "string",
      "key03": null
    }"##

    try (game = Game()) {
        if (let Some(doc) <- JsonUtils.loadJson(json)) {
            var value = getVarOrPredicateKey(game, doc.asObject().get("key01").getOrThrow(), "key01")

            match (value) {
                case VaVariable(value) => @Expect(value, VaString("string"))
                case _ => @Fail("Expected Variable")
            }

            value = getVarOrPredicateKey(game, doc.asObject().get("key01").getOrThrow(), "key02")

            match (value) {
                case VaPredicate(value) => @Expect(value.isSome())
                case _ => @Fail("Expected Predicate")
            }

            value = getVarOrPredicateKey(game, doc.asObject().get("key02").getOrThrow(), "key02")

            match (value) {
                case VaVariable(value) => @Expect(value, VaString(""))
                case _ => @Fail("Expected Variable")
            }

            value = getVarOrPredicateKey(game, doc.asObject().get("key03").getOrThrow(), "key03")

            match (value) {
                case VaVariable(value) => @Expect(value, VaString(""))
                case _ => @Fail("Expected Variable")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
// cjlint-ignore -end class names should be upper camel case
