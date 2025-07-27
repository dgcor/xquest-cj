package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import dgengine.*
import stdx.encoding.json.*
import std.collection.*
import std.math.*
import std.unittest.*

@Test
func test_getAnchorVal() {
    let json = ##"
    {
      "key01": "all",
      "key02": "invalid",
      "key03": "",
      "key04": true,
      "key05": ["all"],
      "key06": ["top", "right"],
      "key07": ["none", "all"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getAnchorVal(doc.asObject().get("key01").getOrThrow()), Anchor.All)
        @Expect(getAnchorVal(doc.asObject().get("key02").getOrThrow(), default: Anchor.All), Anchor.All)
        @Expect(getAnchorVal(doc.asObject().get("key03").getOrThrow()), (Anchor.Top | Anchor.Left))
        @Expect(getAnchorVal(doc.asObject().get("key04").getOrThrow()), (Anchor.Top | Anchor.Left))
        @Expect(getAnchorVal(doc.asObject().get("key05").getOrThrow()), Anchor.All)
        @Expect(getAnchorVal(doc.asObject().get("key06").getOrThrow()), (Anchor.Top | Anchor.Right))
        @Expect(getAnchorVal(doc.asObject().get("key07").getOrThrow()), Anchor.All)
    }
}

@Test
func test_getAnimationTypeVal() {
    let json = ##"
    {
      "key01": "playOnce",
      "key02": "invalid",
      "key03": "",
      "key04": true,
      "key05": ["playOnce"],
      "key06": ["playOnce", "looped"],
      "key07": ["none", "playOnce"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getAnimationTypeVal(doc.asObject().get("key01").getOrThrow()), AnimationType.PlayOnce)
        @Expect(getAnimationTypeVal(doc.asObject().get("key02").getOrThrow(), default: AnimationType.BackAndForth), AnimationType.BackAndForth)
        @Expect(getAnimationTypeVal(doc.asObject().get("key03").getOrThrow()), AnimationType.Looped)
        @Expect(getAnimationTypeVal(doc.asObject().get("key04").getOrThrow()), AnimationType.Looped)
        @Expect(getAnimationTypeVal(doc.asObject().get("key05").getOrThrow()), AnimationType.Looped)
        @Expect(getAnimationTypeVal(doc.asObject().get("key06").getOrThrow()), AnimationType.Looped)
        @Expect(getAnimationTypeVal(doc.asObject().get("key07").getOrThrow()), AnimationType.Looped)
    }
}

@Test
func test_getBindingFlagsVal() {
    let json = ##"
    {
      "key01": "always",
      "key02": "invalid",
      "key03": "",
      "key04": true,
      "key05": ["always"],
      "key06": ["always", "whenhidden"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getBindingFlagsVal(doc.asObject().get("key01").getOrThrow()), BindingFlags.Always)
        @Expect(getBindingFlagsVal(doc.asObject().get("key02").getOrThrow(), default: BindingFlags.Always), BindingFlags.Always)
        @Expect(getBindingFlagsVal(doc.asObject().get("key03").getOrThrow()), BindingFlags.OnChange)
        @Expect(getBindingFlagsVal(doc.asObject().get("key04").getOrThrow()), BindingFlags.OnChange)
        @Expect(getBindingFlagsVal(doc.asObject().get("key05").getOrThrow()), BindingFlags.Always)
        @Expect(getBindingFlagsVal(doc.asObject().get("key06").getOrThrow()), (BindingFlags.Always | BindingFlags.WhenHidden))
    }
}

@Test
func test_getBlendModeVal() {
    let json = ##"
    {
      "key01": "add",
      "key02": "invalid",
      "key03": "",
      "key04": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getBlendModeVal(doc.asObject().get("key01").getOrThrow()), BlendAdd)
        @Expect(getBlendModeVal(doc.asObject().get("key02").getOrThrow(), default: BlendNone), BlendNone)
        @Expect(getBlendModeVal(doc.asObject().get("key03").getOrThrow()), BlendAlpha)
        @Expect(getBlendModeVal(doc.asObject().get("key04").getOrThrow()), BlendAlpha)
    }
}

@Test
func test_getDirectionVal() {
    let json = ##"
    {
      "key01": "down",
      "key02": "invalid",
      "key03": "",
      "key04": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getDirectionVal(doc.asObject().get("key01").getOrThrow()), Direction.Down)
        @Expect(getDirectionVal(doc.asObject().get("key02").getOrThrow(), default: Direction.Down), Direction.Down)
        @Expect(getDirectionVal(doc.asObject().get("key03").getOrThrow()), Direction.Up)
        @Expect(getDirectionVal(doc.asObject().get("key04").getOrThrow()), Direction.Up)
    }
}

@Test
func test_getBoolVal() {
    let json = ##"
    {
      "key01": true,
      "key02": "invalid",
      "key03": "",
      "key04": 1
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getBoolVal(doc.asObject().get("key01").getOrThrow()), true)
        @Expect(getBoolVal(doc.asObject().get("key02").getOrThrow(), default: true), true)
        @Expect(getBoolVal(doc.asObject().get("key03").getOrThrow()), false)
        @Expect(getBoolVal(doc.asObject().get("key04").getOrThrow()), false)
    }
}

@Test
func test_getDoubleVal() {
    let json = ##"
    {
      "key01": 1.2,
      "key02": -1.2,
      "key03": 9000000000.5,
      "key04": "invalid",
      "key05": "1.2",
      "key06": 1,
      "key07": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getDoubleVal(doc.asObject().get("key01").getOrThrow()), 1.2)
        @Expect(getDoubleVal(doc.asObject().get("key02").getOrThrow()), -1.2)
        @Expect(getDoubleVal(doc.asObject().get("key03").getOrThrow()), 9000000000.5)
        @Expect(getDoubleVal(doc.asObject().get("key04").getOrThrow(), default: 1.2), 1.2)
        @Expect(getDoubleVal(doc.asObject().get("key05").getOrThrow()), 0.0)
        @Expect(getDoubleVal(doc.asObject().get("key06").getOrThrow()), 0.0)
        @Expect(getDoubleVal(doc.asObject().get("key07").getOrThrow()), 0.0)
    }
}

@Test
func test_getFloatVal() {
    let json = ##"
    {
      "key01": 1.2,
      "key02": -1.2,
      "key03": 9000000000.5,
      "key04": "invalid",
      "key05": "1.2",
      "key06": 1,
      "key07": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getFloatVal(doc.asObject().get("key01").getOrThrow()), 1.2)
        @Expect(getFloatVal(doc.asObject().get("key02").getOrThrow()), -1.2)
        @Expect(getFloatVal(doc.asObject().get("key03").getOrThrow()), 0.0)
        @Expect(getFloatVal(doc.asObject().get("key04").getOrThrow(), default: 1.2), 1.2)
        @Expect(getFloatVal(doc.asObject().get("key05").getOrThrow()), 0.0)
        @Expect(getFloatVal(doc.asObject().get("key06").getOrThrow()), 0.0)
        @Expect(getFloatVal(doc.asObject().get("key07").getOrThrow()), 0.0)
    }
}

@Test
func test_getIntVal() {
    let json = ##"
    {
      "key01": 10,
      "key02": -10,
      "key03": 9000000000,
      "key04": "invalid",
      "key05": "1",
      "key06": 1.2,
      "key07": true,
      "key08": 2147483647,
      "key09": 2147483648,
      "key10": -2147483648,
      "key11": -2147483649
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getIntVal(doc.asObject().get("key01").getOrThrow()), 10)
        @Expect(getIntVal(doc.asObject().get("key02").getOrThrow()), -10)
        @Expect(getIntVal(doc.asObject().get("key03").getOrThrow()), 0)
        @Expect(getIntVal(doc.asObject().get("key04").getOrThrow(), default: 10), 10)
        @Expect(getIntVal(doc.asObject().get("key05").getOrThrow()), 0)
        @Expect(getIntVal(doc.asObject().get("key06").getOrThrow()), 0)
        @Expect(getIntVal(doc.asObject().get("key07").getOrThrow()), 0)
        @Expect(getIntVal(doc.asObject().get("key08").getOrThrow()), Int32.Max)
        @Expect(getIntVal(doc.asObject().get("key09").getOrThrow()), 0)
        @Expect(getIntVal(doc.asObject().get("key10").getOrThrow()), Int32.Min)
        @Expect(getIntVal(doc.asObject().get("key11").getOrThrow()), 0)
    }
}

@Test
func test_getInt64Val() {
    let json = ##"
    {
      "key01": 10,
      "key02": -10,
      "key03": 9000000000,
      "key04": "invalid",
      "key05": "1",
      "key06": 1.2,
      "key07": true,
      "key08": 18446744073709551615,
      "key09": 18446744073709551616,
      "key10": -18446744073709551616,
      "key11": -18446744073709551617
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getInt64Val(doc.asObject().get("key01").getOrThrow()), 10)
        @Expect(getInt64Val(doc.asObject().get("key02").getOrThrow()), -10)
        @Expect(getInt64Val(doc.asObject().get("key03").getOrThrow()), 9000000000)
        @Expect(getInt64Val(doc.asObject().get("key04").getOrThrow(), default: 10), 10)
        @Expect(getInt64Val(doc.asObject().get("key05").getOrThrow()), 0)
        @Expect(getInt64Val(doc.asObject().get("key06").getOrThrow()), 0)
        @Expect(getInt64Val(doc.asObject().get("key07").getOrThrow()), 0)
        @Expect(getInt64Val(doc.asObject().get("key08").getOrThrow()), Int64.Max)
        @Expect(getInt64Val(doc.asObject().get("key09").getOrThrow()), 0)
        @Expect(getInt64Val(doc.asObject().get("key10").getOrThrow()), Int64.Min)
        @Expect(getInt64Val(doc.asObject().get("key11").getOrThrow()), 0)
    }
}

@Test
func test_getStringChar() {
    let json = ##"
    {
      "key01": "text",
      "key02": "",
      "key03": -10,
      "key04": 1.2,
      "key05": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getStringChar(doc.asObject().get("key01").getOrThrow()), "text")
        @Expect(getStringChar(doc.asObject().get("key02").getOrThrow(), default: "text"), "")
        @Expect(getStringChar(doc.asObject().get("key03").getOrThrow(), default: "text"), "text")
        @Expect(getStringChar(doc.asObject().get("key04").getOrThrow()), "")
        @Expect(getStringChar(doc.asObject().get("key05").getOrThrow()), "")
    }
}

@Test
func test_getStringVal() {
    let json = ##"
    {
      "key01": "text",
      "key02": "",
      "key03": -10,
      "key04": 1.2,
      "key05": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getStringVal(doc.asObject().get("key01").getOrThrow()), "text")
        @Expect(getStringVal(doc.asObject().get("key02").getOrThrow(), default: "text"), "")
        @Expect(getStringVal(doc.asObject().get("key03").getOrThrow()), "-10")
        @Expect(getStringVal(doc.asObject().get("key04").getOrThrow()), "1.2")
        @Expect(getStringVal(doc.asObject().get("key05").getOrThrow()), "")
    }
}

@Test
func test_getUIntVal() {
    let json = ##"
    {
      "key01": 10,
      "key02": -10,
      "key03": 9000000000,
      "key04": "invalid",
      "key05": "1",
      "key06": 1.2,
      "key07": true,
      "key08": 4294967295,
      "key09": 4294967296
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getUIntVal(doc.asObject().get("key01").getOrThrow()), 10)
        @Expect(getUIntVal(doc.asObject().get("key02").getOrThrow()), 0)
        @Expect(getUIntVal(doc.asObject().get("key03").getOrThrow()), 0)
        @Expect(getUIntVal(doc.asObject().get("key04").getOrThrow(), default: 10), 10)
        @Expect(getUIntVal(doc.asObject().get("key05").getOrThrow()), 0)
        @Expect(getUIntVal(doc.asObject().get("key06").getOrThrow()), 0)
        @Expect(getUIntVal(doc.asObject().get("key07").getOrThrow()), 0)
        @Expect(getUIntVal(doc.asObject().get("key08").getOrThrow()), UInt32.Max)
        @Expect(getUIntVal(doc.asObject().get("key09").getOrThrow()), 0)
    }
}

@Test
func test_getUInt64Val() {
    let json = ##"
    {
      "key01": 10,
      "key02": -10,
      "key03": 9000000000,
      "key04": "invalid",
      "key05": "1",
      "key06": 1.2,
      "key07": true,
      "key08": 18446744073709551615,
      "key09": 18446744073709551616
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getUInt64Val(doc.asObject().get("key01").getOrThrow()), 10)
        @Expect(getUInt64Val(doc.asObject().get("key02").getOrThrow()), 0)
        @Expect(getUInt64Val(doc.asObject().get("key03").getOrThrow()), 9000000000)
        @Expect(getUInt64Val(doc.asObject().get("key04").getOrThrow(), default: 10), 10)
        @Expect(getUInt64Val(doc.asObject().get("key05").getOrThrow()), 0)
        @Expect(getUInt64Val(doc.asObject().get("key06").getOrThrow()), 0)
        @Expect(getUInt64Val(doc.asObject().get("key07").getOrThrow()), 0)
        @Expect(getUInt64Val(doc.asObject().get("key08").getOrThrow()), UInt64.Max)
        @Expect(getUInt64Val(doc.asObject().get("key09").getOrThrow()), 0)
    }
}

@Test
class Test_getNumberVal {
    let json = ##"
    {
      "key01": 10,
      "key02": -10,
      "key03": 9000000000,
      "key04": 1.2,
      "key05": 9000000000.5,
      "key06": "invalid",
      "key07": "1",
      "key08": true,
      "key09": 0,
      "key10": 0.0
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Int32() {
        @Expect(getNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0i32), 10i32)
        @Expect(getNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0i32), -10i32)
        @Expect(getNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0i32), 0i32)
        @Expect(getNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0i32), 1i32)
        @Expect(getNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0i32), 0i32)
        @Expect(getNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0i32), 0i32)
        @Expect(getNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0i32), 0i32)
        @Expect(getNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0i32), 0i32)
        @Expect(getNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1i32), 0i32)
        @Expect(getNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1i32), 0i32)
    }

    @TestCase
    func test_Int64() {
        @Expect(getNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0i64), 10i64)
        @Expect(getNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0i64), -10i64)
        @Expect(getNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0i64), 9000000000i64)
        @Expect(getNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0i64), 1i64)
        @Expect(getNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0i64), 9000000000i64)
        @Expect(getNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0i64), 0i64)
        @Expect(getNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0i64), 0i64)
        @Expect(getNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0i64), 0i64)
        @Expect(getNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1i64), 0i64)
        @Expect(getNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1i64), 0i64)
    }

    @TestCase
    func test_UInt32() {
        @Expect(getNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0u32), 10u32)
        @Expect(getNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0u32), 0u32)
        @Expect(getNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0u32), 0u32)
        @Expect(getNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0u32), 1u32)
        @Expect(getNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0u32), 0u32)
        @Expect(getNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0u32), 0u32)
        @Expect(getNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0u32), 0u32)
        @Expect(getNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0u32), 0u32)
        @Expect(getNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1u32), 0u32)
        @Expect(getNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1u32), 0u32)
    }

    @TestCase
    func test_UInt64() {
        @Expect(getNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0u64), 10u64)
        @Expect(getNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0u64), 0u64)
        @Expect(getNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0u64), 9000000000u64)
        @Expect(getNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0u64), 1u64)
        @Expect(getNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0u64), 9000000000u64)
        @Expect(getNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0u64), 0u64)
        @Expect(getNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0u64), 0u64)
        @Expect(getNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0u64), 0u64)
        @Expect(getNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1u64), 0u64)
        @Expect(getNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1u64), 0u64)
    }

    @TestCase
    func test_Float32() {
        @Expect(getNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0.0f32), 10.0f32)
        @Expect(getNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0.0f32), -10.0f32)
        // @Expect(getNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0.0f32), 1.20f32)
        @Expect(getNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1.0f32), 0.0f32)
        @Expect(getNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1.0f32), 0.0f32)
    }

    @TestCase
    func test_Float64() {
        @Expect(getNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0.0f64), 10.0f64)
        @Expect(getNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0.0f64), -10.0f64)
        @Expect(getNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0.0f64), 9000000000.0f64)
        @Expect(getNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0.0f64), 1.2f64)
        @Expect(getNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0.0f64), 9000000000.5f64)
        @Expect(getNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0.0f64), 0.0f64)
        @Expect(getNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0.0f64), 0.0f64)
        @Expect(getNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0.0f64), 0.0f64)
        @Expect(getNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1.0f64), 0.0f64)
        @Expect(getNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1.0f64), 0.0f64)
    }
}

@Test
class Test_getUnsignedNumberVal {
    let json = ##"
    {
      "key01": 10,
      "key02": -10,
      "key03": 9000000000,
      "key04": 1.2,
      "key05": 9000000000.5,
      "key06": "invalid",
      "key07": "1",
      "key08": true,
      "key09": 0,
      "key10": 0.0
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Int32() {
        @Expect(getUnsignedNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0i32), 10i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0i32), 0i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0i32), 0i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0i32), 1i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0i32), 0i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0i32), 0i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0i32), 0i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0i32), 0i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1i32), 0i32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1i32), 0i32)
    }

    @TestCase
    func test_Int64() {
        @Expect(getUnsignedNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0i64), 10i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0i64), 0i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0i64), 9000000000i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0i64), 1i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0i64), 9000000000i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0i64), 0i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0i64), 0i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0i64), 0i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1i64), 0i64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1i64), 0i64)
    }

    @TestCase
    func test_UInt32() {
        @Expect(getUnsignedNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0u32), 10u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0u32), 0u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0u32), 0u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0u32), 1u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0u32), 0u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0u32), 0u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0u32), 0u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0u32), 0u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1u32), 0u32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1u32), 0u32)
    }

    @TestCase
    func test_UInt64() {
        @Expect(getUnsignedNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0u64), 10u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0u64), 0u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0u64), 9000000000u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0u64), 1u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0u64), 9000000000u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0u64), 0u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0u64), 0u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0u64), 0u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1u64), 0u64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1u64), 0u64)
    }

    @TestCase
    func test_Float32() {
        @Expect(getUnsignedNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0.0f32), 10.0f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0.0f32), 0.0f32)
        // @Expect(getUnsignedNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0.0f32), 1.20f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1.0f32), 0.0f32)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1.0f32), 0.0f32)
    }

    @TestCase
    func test_Float64() {
        @Expect(getUnsignedNumberVal(doc.asObject().get("key01").getOrThrow(), default: 0.0f64), 10.0f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key02").getOrThrow(), default: 0.0f64), 0.0f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key03").getOrThrow(), default: 0.0f64), 9000000000.0f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key04").getOrThrow(), default: 0.0f64), 1.2f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key05").getOrThrow(), default: 0.0f64), 9000000000.5f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key06").getOrThrow(), default: 0.0f64), 0.0f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key07").getOrThrow(), default: 0.0f64), 0.0f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key08").getOrThrow(), default: 0.0f64), 0.0f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key09").getOrThrow(), default: 1.0f64), 0.0f64)
        @Expect(getUnsignedNumberVal(doc.asObject().get("key10").getOrThrow(), default: 1.0f64), 0.0f64)
    }
}

@Test
class Test_getVector2NumberVal {
    let json = ##"
    {
      "key01": [10, -20],
      "key02": [400, 9000000000],
      "key03": [1.2, -2.9, 9.0, 9.0],
      "key04": [1.2, 9000000000.5],
      "key05": 1,
      "key06": "invalid",
      "key07": ["1", 2],
      "key08": [1]
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Vector2f() {
        @Expect(getVector2fVal(doc.asObject().get("key01").getOrThrow()) == Vector2f(10.0, -20.0))
        @Expect(getVector2fVal(doc.asObject().get("key02").getOrThrow()) == Vector2f(400.0, 9000000000.0))
        @Expect(getVector2fVal(doc.asObject().get("key03").getOrThrow()) == Vector2f(1.2, -2.9))
        @Expect(getVector2fVal(doc.asObject().get("key04").getOrThrow()) == Vector2f(1.2, 0.0))
        @Expect(getVector2fVal(doc.asObject().get("key05").getOrThrow()) == Vector2f())
        @Expect(getVector2fVal(doc.asObject().get("key06").getOrThrow(), default: Vector2f(1.0, 1.0)) == Vector2f(1.0, 1.0))
        @Expect(getVector2fVal(doc.asObject().get("key07").getOrThrow()) == Vector2f())
        @Expect(getVector2fVal(doc.asObject().get("key08").getOrThrow()) == Vector2f())
    }

    @TestCase
    func test_Vector2i() {
        @Expect(getVector2iVal(doc.asObject().get("key01").getOrThrow()) == Vector2i(10, -20))
        @Expect(getVector2iVal(doc.asObject().get("key02").getOrThrow()) == Vector2i(400, 0))
        @Expect(getVector2iVal(doc.asObject().get("key03").getOrThrow()) == Vector2i(1, -2))
        @Expect(getVector2iVal(doc.asObject().get("key04").getOrThrow()) == Vector2i(1, 0))
        @Expect(getVector2iVal(doc.asObject().get("key05").getOrThrow()) == Vector2i())
        @Expect(getVector2iVal(doc.asObject().get("key06").getOrThrow(), default: Vector2i(1, 1)) == Vector2i(1, 1))
        @Expect(getVector2iVal(doc.asObject().get("key07").getOrThrow()) == Vector2i())
        @Expect(getVector2iVal(doc.asObject().get("key08").getOrThrow()) == Vector2i())
    }

    @TestCase
    func test_Vector2u() {
        @Expect(getVector2uVal(doc.asObject().get("key01").getOrThrow()) == Vector2u(10, 0))
        @Expect(getVector2uVal(doc.asObject().get("key02").getOrThrow()) == Vector2u(400, 0))
        // @Expect(getVector2uVal(doc.asObject().get("key03").getOrThrow()) == Vector2u(1, 0))
        @Expect(getVector2uVal(doc.asObject().get("key04").getOrThrow()) == Vector2u(1, 0))
        @Expect(getVector2uVal(doc.asObject().get("key05").getOrThrow()) == Vector2u())
        @Expect(getVector2uVal(doc.asObject().get("key06").getOrThrow(), default: Vector2u(1, 1)) == Vector2u(1, 1))
        @Expect(getVector2uVal(doc.asObject().get("key07").getOrThrow()) == Vector2u())
        @Expect(getVector2uVal(doc.asObject().get("key08").getOrThrow()) == Vector2u())
    }
}

@Test
class Test_getVector2UnsignedNumberVal {
    let json = ##"
    {
      "key01": [10, -20],
      "key02": [400, 9000000000],
      "key03": [1.2, -2.9, 9.0, 9.0],
      "key04": [1.2, 9000000000.5],
      "key05": 1,
      "key06": "invalid",
      "key07": ["1", 2],
      "key08": [1]
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Vector2f() {
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key01").getOrThrow()) == Vector2f(10.0, 0.0))
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key02").getOrThrow()) == Vector2f(400.0, 9000000000.0))
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key03").getOrThrow()) == Vector2f(1.2, 0.0))
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key04").getOrThrow()) == Vector2f(1.2, 0.0))
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key05").getOrThrow()) == Vector2f())
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key06").getOrThrow(), default: Vector2f(1.0, 1.0)) == Vector2f(1.0, 1.0))
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key07").getOrThrow()) == Vector2f())
        @Expect(getUnsignedVector2fVal(doc.asObject().get("key08").getOrThrow()) == Vector2f())
    }

    @TestCase
    func test_Vector2i() {
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key01").getOrThrow()) == Vector2i(10, 0))
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key02").getOrThrow()) == Vector2i(400, 0))
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key03").getOrThrow()) == Vector2i(1, 0))
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key04").getOrThrow()) == Vector2i(1, 0))
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key05").getOrThrow()) == Vector2i())
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key06").getOrThrow(), default: Vector2i(1, 1)) == Vector2i(1, 1))
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key07").getOrThrow()) == Vector2i())
        @Expect(getUnsignedVector2iVal(doc.asObject().get("key08").getOrThrow()) == Vector2i())
    }

    @TestCase
    func test_Vector2u() {
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key01").getOrThrow()) == Vector2u(10, 0))
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key02").getOrThrow()) == Vector2u(400, 0))
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key03").getOrThrow()) == Vector2u(1, 0))
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key04").getOrThrow()) == Vector2u(1, 0))
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key05").getOrThrow()) == Vector2u())
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key06").getOrThrow(), default: Vector2u(1, 1)) == Vector2u(1, 1))
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key07").getOrThrow()) == Vector2u())
        @Expect(getUnsignedVector2uVal(doc.asObject().get("key08").getOrThrow()) == Vector2u())
    }
}

@Test
class Test_getVector3NumberVal {
    let json = ##"
    {
      "key01": [0, 10, -20],
      "key02": [0, 400, 9000000000],
      "key03": [0.0, 1.2, -2.9, 9.0, 9.0],
      "key04": [0.0, 1.2, 9000000000.5],
      "key05": 1,
      "key06": "invalid",
      "key07": ["1", 2, 0],
      "key08": [1]
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Vector3f() {
        @Expect(getVector3NumberVal(doc.asObject().get("key01").getOrThrow(), default: Vector3f()) == Vector3f(0.0, 10.0, -20.0))
        @Expect(getVector3NumberVal(doc.asObject().get("key02").getOrThrow(), default: Vector3f()) == Vector3f(0.0, 400.0, 9000000000.0))
        @Expect(getVector3NumberVal(doc.asObject().get("key03").getOrThrow(), default: Vector3f()) == Vector3f(0.0, 1.2, -2.9))
        @Expect(getVector3NumberVal(doc.asObject().get("key04").getOrThrow(), default: Vector3f()) == Vector3f(0.0, 1.2, 0.0))
        @Expect(getVector3NumberVal(doc.asObject().get("key05").getOrThrow(), default: Vector3f()) == Vector3f())
        @Expect(getVector3NumberVal(doc.asObject().get("key06").getOrThrow(), default: Vector3f(1.0, 1.0, 1.0)) == Vector3f(1.0, 1.0, 1.0))
        @Expect(getVector3NumberVal(doc.asObject().get("key07").getOrThrow(), default: Vector3f()) == Vector3f())
        @Expect(getVector3NumberVal(doc.asObject().get("key08").getOrThrow(), default: Vector3f()) == Vector3f())
    }

    @TestCase
    func test_Vector3i() {
        @Expect(getVector3NumberVal(doc.asObject().get("key01").getOrThrow(), default: Vector3i()) == Vector3i(0, 10, -20))
        @Expect(getVector3NumberVal(doc.asObject().get("key02").getOrThrow(), default: Vector3i()) == Vector3i(0, 400, 0))
        @Expect(getVector3NumberVal(doc.asObject().get("key03").getOrThrow(), default: Vector3i()) == Vector3i(0, 1, -2))
        @Expect(getVector3NumberVal(doc.asObject().get("key04").getOrThrow(), default: Vector3i()) == Vector3i(0, 1, 0))
        @Expect(getVector3NumberVal(doc.asObject().get("key05").getOrThrow(), default: Vector3i()) == Vector3i())
        @Expect(getVector3NumberVal(doc.asObject().get("key06").getOrThrow(), default: Vector3i(1, 1, 1)) == Vector3i(1, 1, 1))
        @Expect(getVector3NumberVal(doc.asObject().get("key07").getOrThrow(), default: Vector3i()) == Vector3i())
        @Expect(getVector3NumberVal(doc.asObject().get("key08").getOrThrow(), default: Vector3i()) == Vector3i())
    }
}

@Test
class Test_getVector4NumberVal {
    let json = ##"
    {
      "key01": [0, 0, 10, -20],
      "key02": [0, 0, 400, 9000000000],
      "key03": [0.0, 0.0, 1.2, -2.9, 9.0, 9.0],
      "key04": [0.0, 0.0, 1.2, 9000000000.5],
      "key05": 1,
      "key06": "invalid",
      "key07": ["1", 2, 0, 0],
      "key08": [1]
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_FloatRect() {
        @Expect(getVector4NumberVal(doc.asObject().get("key01").getOrThrow(), default: FloatRect()) == FloatRect(0.0, 0.0, 10.0, -20.0))
        @Expect(getVector4NumberVal(doc.asObject().get("key02").getOrThrow(), default: FloatRect()) == FloatRect(0.0, 0.0, 400.0, 9000000000.0))
        @Expect(getVector4NumberVal(doc.asObject().get("key03").getOrThrow(), default: FloatRect()) == FloatRect(0.0, 0.0, 1.2, -2.9))
        @Expect(getVector4NumberVal(doc.asObject().get("key04").getOrThrow(), default: FloatRect()) == FloatRect(0.0, 0.0, 1.2, 0.0))
        @Expect(getVector4NumberVal(doc.asObject().get("key05").getOrThrow(), default: FloatRect()) == FloatRect())
        @Expect(getVector4NumberVal(doc.asObject().get("key06").getOrThrow(), default: FloatRect(1.0, 1.0, 1.0, 1.0)) == FloatRect(1.0, 1.0, 1.0, 1.0))
        @Expect(getVector4NumberVal(doc.asObject().get("key07").getOrThrow(), default: FloatRect()) == FloatRect())
        @Expect(getVector4NumberVal(doc.asObject().get("key08").getOrThrow(), default: FloatRect()) == FloatRect())
    }

    @TestCase
    func test_IntRect() {
        @Expect(getVector4NumberVal(doc.asObject().get("key01").getOrThrow(), default: IntRect()) == IntRect(0, 0, 10, -20))
        @Expect(getVector4NumberVal(doc.asObject().get("key02").getOrThrow(), default: IntRect()) == IntRect(0, 0, 400, 0))
        @Expect(getVector4NumberVal(doc.asObject().get("key03").getOrThrow(), default: IntRect()) == IntRect(0, 0, 1, -2))
        @Expect(getVector4NumberVal(doc.asObject().get("key04").getOrThrow(), default: IntRect()) == IntRect(0, 0, 1, 0))
        @Expect(getVector4NumberVal(doc.asObject().get("key05").getOrThrow(), default: IntRect()) == IntRect())
        @Expect(getVector4NumberVal(doc.asObject().get("key06").getOrThrow(), default: IntRect(1, 1, 1, 1)) == IntRect(1, 1, 1, 1))
        @Expect(getVector4NumberVal(doc.asObject().get("key07").getOrThrow(), default: IntRect()) == IntRect())
        @Expect(getVector4NumberVal(doc.asObject().get("key08").getOrThrow(), default: IntRect()) == IntRect())
    }
}

@Test
class Test_getRangeOrValueVal {
    let json = ##"
    {
      "key01": [10, -20],
      "key02": [400, 9000000000],
      "key03": [1.2, -2.9, 9.0, 9.0],
      "key04": [1.2, 9000000000.5],
      "key05": 1,
      "key06": "invalid",
      "key07": ["1", 2],
      "key08": [1]
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Int32() {
        @Expect(getRangeOrValueVal(doc.asObject().get("key01").getOrThrow(), default: (0i32, 0i32)) == (10, -20))
        @Expect(getRangeOrValueVal(doc.asObject().get("key02").getOrThrow(), default: (0i32, 0i32)) == (400, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key03").getOrThrow(), default: (0i32, 0i32)) == (1, -2))
        @Expect(getRangeOrValueVal(doc.asObject().get("key04").getOrThrow(), default: (0i32, 0i32)) == (1, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key05").getOrThrow(), default: (0i32, 0i32)) == (1, 1))
        @Expect(getRangeOrValueVal(doc.asObject().get("key06").getOrThrow(), default: (1u32, 1u32)) == (1, 1))
        @Expect(getRangeOrValueVal(doc.asObject().get("key07").getOrThrow(), default: (0i32, 0i32)) == (0, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key08").getOrThrow(), default: (0i32, 0i32)) == (0, 0))
    }

    @TestCase
    func test_UInt32() {
        @Expect(getRangeOrValueVal(doc.asObject().get("key01").getOrThrow(), default: (0u32, 0u32)) == (10, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key02").getOrThrow(), default: (0u32, 0u32)) == (400, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key03").getOrThrow(), default: (0u32, 0u32)) == (1, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key04").getOrThrow(), default: (0u32, 0u32)) == (1, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key05").getOrThrow(), default: (0u32, 0u32)) == (1, 1))
        @Expect(getRangeOrValueVal(doc.asObject().get("key06").getOrThrow(), default: (1u32, 1u32)) == (1, 1))
        @Expect(getRangeOrValueVal(doc.asObject().get("key07").getOrThrow(), default: (0u32, 0u32)) == (0, 0))
        @Expect(getRangeOrValueVal(doc.asObject().get("key08").getOrThrow(), default: (0u32, 0u32)) == (0, 0))
    }
}

@Test
class Test_getRange0Val {
    let json = ##"
    {
      "key01": [10, -20],
      "key02": [400, 9000000000],
      "key03": [1.2, -2.9, 9.0, 9.0],
      "key04": [1.2, 9000000000.5],
      "key05": 1,
      "key06": "invalid",
      "key07": ["1", 2],
      "key08": [1]
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Int32() {
        @Expect(getRange0Val(doc.asObject().get("key01").getOrThrow(), default: (0i32, 0i32)) == (10, -20))
        @Expect(getRange0Val(doc.asObject().get("key02").getOrThrow(), default: (0i32, 0i32)) == (400, 0))
        @Expect(getRange0Val(doc.asObject().get("key03").getOrThrow(), default: (0i32, 0i32)) == (1, -2))
        @Expect(getRange0Val(doc.asObject().get("key04").getOrThrow(), default: (0i32, 0i32)) == (1, 0))
        @Expect(getRange0Val(doc.asObject().get("key05").getOrThrow(), default: (0i32, 0i32)) == (0, 1))
        @Expect(getRange0Val(doc.asObject().get("key06").getOrThrow(), default: (1u32, 1u32)) == (1, 1))
        @Expect(getRange0Val(doc.asObject().get("key07").getOrThrow(), default: (0i32, 0i32)) == (0, 0))
        @Expect(getRange0Val(doc.asObject().get("key08").getOrThrow(), default: (0i32, 0i32)) == (0, 0))
    }

    @TestCase
    func test_UInt32() {
        @Expect(getRange0Val(doc.asObject().get("key01").getOrThrow(), default: (0u32, 0u32)) == (10, 0))
        @Expect(getRange0Val(doc.asObject().get("key02").getOrThrow(), default: (0u32, 0u32)) == (400, 0))
        @Expect(getRange0Val(doc.asObject().get("key03").getOrThrow(), default: (0u32, 0u32)) == (1, 0))
        @Expect(getRange0Val(doc.asObject().get("key04").getOrThrow(), default: (0u32, 0u32)) == (1, 0))
        @Expect(getRange0Val(doc.asObject().get("key05").getOrThrow(), default: (0u32, 0u32)) == (0, 1))
        @Expect(getRange0Val(doc.asObject().get("key06").getOrThrow(), default: (1u32, 1u32)) == (1, 1))
        @Expect(getRange0Val(doc.asObject().get("key07").getOrThrow(), default: (0u32, 0u32)) == (0, 0))
        @Expect(getRange0Val(doc.asObject().get("key08").getOrThrow(), default: (0u32, 0u32)) == (0, 0))
    }
}

@Test
class Test_getRange1Val {
    let json = ##"
    {
      "key01": [10, -20],
      "key02": [400, 9000000000],
      "key03": [1.2, -2.9, 9.0, 9.0],
      "key04": [1.2, 9000000000.5],
      "key05": 2,
      "key06": "invalid",
      "key07": ["1", 2],
      "key08": [1]
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Int32() {
        @Expect(getRange1Val(doc.asObject().get("key01").getOrThrow(), default: (0i32, 0i32)) == (10, -20))
        @Expect(getRange1Val(doc.asObject().get("key02").getOrThrow(), default: (0i32, 0i32)) == (400, 0))
        @Expect(getRange1Val(doc.asObject().get("key03").getOrThrow(), default: (0i32, 0i32)) == (1, -2))
        @Expect(getRange1Val(doc.asObject().get("key04").getOrThrow(), default: (0i32, 0i32)) == (1, 0))
        @Expect(getRange1Val(doc.asObject().get("key05").getOrThrow(), default: (0i32, 0i32)) == (1, 2))
        @Expect(getRange1Val(doc.asObject().get("key06").getOrThrow(), default: (1i32, 1i32)) == (1, 1))
        @Expect(getRange1Val(doc.asObject().get("key07").getOrThrow(), default: (0i32, 0i32)) == (0, 0))
        @Expect(getRange1Val(doc.asObject().get("key08").getOrThrow(), default: (0i32, 0i32)) == (0, 0))
    }

    @TestCase
    func test_UInt32() {
        @Expect(getRange1Val(doc.asObject().get("key01").getOrThrow(), default: (0u32, 0u32)) == (10, 0))
        @Expect(getRange1Val(doc.asObject().get("key02").getOrThrow(), default: (0u32, 0u32)) == (400, 0))
        @Expect(getRange1Val(doc.asObject().get("key03").getOrThrow(), default: (0u32, 0u32)) == (1, 0))
        @Expect(getRange1Val(doc.asObject().get("key04").getOrThrow(), default: (0u32, 0u32)) == (1, 0))
        @Expect(getRange1Val(doc.asObject().get("key05").getOrThrow(), default: (0u32, 0u32)) == (1, 2))
        @Expect(getRange1Val(doc.asObject().get("key06").getOrThrow(), default: (1u32, 1u32)) == (1, 1))
        @Expect(getRange1Val(doc.asObject().get("key07").getOrThrow(), default: (0u32, 0u32)) == (0, 0))
        @Expect(getRange1Val(doc.asObject().get("key08").getOrThrow(), default: (0u32, 0u32)) == (0, 0))
    }
}

@Test
func test_getPositionVal() {
    let json = ##"
    {
      "key01": [0, 0],
      "key02": [10, -100],
      "key03": [320, 240],
      "key04": ["left", "bottom"],
      "key05": ["center", "center"],
      "key06": ["right", "top"],
      "key07": ["invalid", "text"],
      "key08": [10.4, -10.51]
    }"##
    let size = Vector2f(10.0, 10.0)
    let refSize = Vector2u(320, 240)

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getPositionVal(doc.asObject().get("key01").getOrThrow(), size, refSize) == Vector2f(0.0, 0.0))
        @Expect(getPositionVal(doc.asObject().get("key02").getOrThrow(), size, refSize) == Vector2f(10.0, -100.0))
        @Expect(getPositionVal(doc.asObject().get("key03").getOrThrow(), size, refSize) == Vector2f(320.0, 240.0))
        @Expect(getPositionVal(doc.asObject().get("key04").getOrThrow(), size, refSize) == Vector2f(0.0, 230.0))
        @Expect(getPositionVal(doc.asObject().get("key05").getOrThrow(), size, refSize) == Vector2f(155.0, 115.0))
        @Expect(getPositionVal(doc.asObject().get("key06").getOrThrow(), size, refSize) == Vector2f(310.0, 0.0))
        @Expect(getPositionVal(doc.asObject().get("key07").getOrThrow(), size, refSize) == Vector2f(0.0, 0.0))
        @Expect(getPositionVal(doc.asObject().get("key08").getOrThrow(), size, refSize) == Vector2f(10.0, -11.0))
    }
}

@Test
func test_getSizeVal() {
    let json = ##"
    {
      "key01": [0, 0],
      "key02": [10, -100],
      "key03": [320, 240],
      "key04": ["left", "bottom"],
      "key05": ["center", "center"],
      "key06": ["right", "top"],
      "key07": ["invalid", "text"],
      "key08": [10.4, -10.51]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getSizeVal(doc.asObject().get("key01").getOrThrow()) == Vector2f(0.0, 0.0))
        @Expect(getSizeVal(doc.asObject().get("key02").getOrThrow()) == Vector2f(10.0, -100.0))
        @Expect(getSizeVal(doc.asObject().get("key03").getOrThrow()) == Vector2f(320.0, 240.0))
        @Expect(getSizeVal(doc.asObject().get("key04").getOrThrow()) == Vector2f())
        @Expect(getSizeVal(doc.asObject().get("key05").getOrThrow()) == Vector2f())
        @Expect(getSizeVal(doc.asObject().get("key06").getOrThrow()) == Vector2f())
        @Expect(getSizeVal(doc.asObject().get("key07").getOrThrow()) == Vector2f())
        @Expect(getSizeVal(doc.asObject().get("key08").getOrThrow()) == Vector2f(10.0, -11.0))
    }
}

@Test
func test_getFloatRectVal() {
    let json = ##"
    {
      "key01": [0, 0, 10, -20],
      "key02": [0, 0, 400, 9000000000],
      "key03": [0.0, 0.0, 1.2, -2.9, 9.0, 9.0],
      "key04": [0.0, 0.0, 1.2, 9000000000.5],
      "key05": [10, 20],
      "key06": [10.5, 20.5],
      "key07": 1,
      "key08": "invalid",
      "key09": ["1", 2],
      "key10": [1]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getFloatRectVal(doc.asObject().get("key01").getOrThrow()) == FloatRect(0.0, 0.0, 10.0, -20.0))
        @Expect(getFloatRectVal(doc.asObject().get("key02").getOrThrow()) == FloatRect(0.0, 0.0, 400.0, 9000000000.0))
        @Expect(getFloatRectVal(doc.asObject().get("key03").getOrThrow()) == FloatRect(0.0, 0.0, 1.2, -2.9))
        @Expect(getFloatRectVal(doc.asObject().get("key04").getOrThrow()) == FloatRect(0.0, 0.0, 1.2, 0.0))
        @Expect(getFloatRectVal(doc.asObject().get("key05").getOrThrow()) == FloatRect(0.0, 0.0, 10.0, 20.0))
        @Expect(getFloatRectVal(doc.asObject().get("key06").getOrThrow()) == FloatRect(0.0, 0.0, 10.5, 20.5))
        @Expect(getFloatRectVal(doc.asObject().get("key07").getOrThrow()) == FloatRect())
        @Expect(getFloatRectVal(doc.asObject().get("key08").getOrThrow(), default: FloatRect(1.0, 1.0, 1.0, 1.0)) == FloatRect(1.0, 1.0, 1.0, 1.0))
        @Expect(getFloatRectVal(doc.asObject().get("key09").getOrThrow()) == FloatRect(0.0, 0.0, 0.0, 2.0))
        @Expect(getFloatRectVal(doc.asObject().get("key10").getOrThrow()) == FloatRect())
    }
}

@Test
func test_getIntRectVal() {
    let json = ##"
    {
      "key01": [0, 0, 10, -20],
      "key02": [0, 0, 400, 9000000000],
      "key03": [0.0, 0.0, 1.2, -2.9, 9.0, 9.0],
      "key04": [0.0, 0.0, 1.2, 9000000000.5],
      "key05": [10, 20],
      "key06": [10.5, 20.5],
      "key07": 1,
      "key08": "invalid",
      "key09": ["1", 2],
      "key10": [1]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getIntRectVal(doc.asObject().get("key01").getOrThrow()) == IntRect(0, 0, 10, -20))
        @Expect(getIntRectVal(doc.asObject().get("key02").getOrThrow()) == IntRect(0, 0, 400, 0))
        @Expect(getIntRectVal(doc.asObject().get("key03").getOrThrow()) == IntRect(0, 0, 1, -2))
        @Expect(getIntRectVal(doc.asObject().get("key04").getOrThrow()) == IntRect(0, 0, 1, 0))
        @Expect(getIntRectVal(doc.asObject().get("key05").getOrThrow()) == IntRect(0, 0, 10, 20))
        @Expect(getIntRectVal(doc.asObject().get("key06").getOrThrow()) == IntRect(0, 0, 10, 20))
        @Expect(getIntRectVal(doc.asObject().get("key07").getOrThrow()) == IntRect())
        @Expect(getIntRectVal(doc.asObject().get("key08").getOrThrow(), default: IntRect(1, 1, 1, 1)) == IntRect(1, 1, 1, 1))
        @Expect(getIntRectVal(doc.asObject().get("key09").getOrThrow()) == IntRect(0, 0, 0, 2))
        @Expect(getIntRectVal(doc.asObject().get("key10").getOrThrow()) == IntRect())
    }
}

@Test
func test_getColorVal() {
    let json = ##"
    {
      "key01": "0xAABB22",
      "key02": "0xAABB2299",
      "key03": 2863311615,
      "key04": [255, 0, 128],
      "key05": [255, 0, 128, 200, 120],
      "key06": [255, 0],
      "key07": "invalid",
      "key08": "",
      "key09": true,
      "key10": ["10", "20", "30"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getColorVal(doc.asObject().get("key01").getOrThrow()) == Color(0xAA, 0xBB, 0x22))
        @Expect(getColorVal(doc.asObject().get("key02").getOrThrow()) == Color(0xAA, 0xBB, 0x22, 0x99))
        @Expect(getColorVal(doc.asObject().get("key03").getOrThrow()) == Color(0xAA, 0xAA, 0xAA))
        @Expect(getColorVal(doc.asObject().get("key04").getOrThrow()) == Color(255, 0, 128))
        @Expect(getColorVal(doc.asObject().get("key05").getOrThrow()) == Color(255, 0, 128, 200))
        @Expect(getColorVal(doc.asObject().get("key06").getOrThrow(), default: Color.blue) == Color.blue)
        @Expect(getColorVal(doc.asObject().get("key07").getOrThrow()) == Color())
        @Expect(getColorVal(doc.asObject().get("key08").getOrThrow()) == Color())
        @Expect(getColorVal(doc.asObject().get("key09").getOrThrow()) == Color())
        @Expect(getColorVal(doc.asObject().get("key10").getOrThrow()) == Color())
    }
}

@Test
func test_getKeyCodeVal() {
    let json = ##"
    {
      "key01": 0,
      "key02": 1,
      "key03": 9,
      "key04": "1",
      "key05": "escape",
      "key06": "ENTER",
      "key07": 10,
      "key08": 1.0,
      "key09": "invalid",
      "key10": "",
      "key11": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getKeyCodeVal(doc.asObject().get("key01").getOrThrow()) == KeyCode.Num0)
        @Expect(getKeyCodeVal(doc.asObject().get("key02").getOrThrow()) == KeyCode.Num1)
        @Expect(getKeyCodeVal(doc.asObject().get("key03").getOrThrow()) == KeyCode.Num9)
        @Expect(getKeyCodeVal(doc.asObject().get("key04").getOrThrow()) == KeyCode.Num1)
        @Expect(getKeyCodeVal(doc.asObject().get("key05").getOrThrow()) == KeyCode.Escape)
        @Expect(getKeyCodeVal(doc.asObject().get("key06").getOrThrow()) == KeyCode.Enter)
        @Expect(getKeyCodeVal(doc.asObject().get("key07").getOrThrow(), default: KeyCode.Num5) == KeyCode.Num5)
        @Expect(getKeyCodeVal(doc.asObject().get("key08").getOrThrow()) == KeyCode.Unknown)
        @Expect(getKeyCodeVal(doc.asObject().get("key09").getOrThrow()) == KeyCode.Unknown)
        @Expect(getKeyCodeVal(doc.asObject().get("key10").getOrThrow()) == KeyCode.Unknown)
        @Expect(getKeyCodeVal(doc.asObject().get("key11").getOrThrow()) == KeyCode.Unknown)
    }
}

@Test
func test_getScanCodeVal() {
    let json = ##"
    {
      "key01": 0,
      "key02": 1,
      "key03": 9,
      "key04": "1",
      "key05": "escape",
      "key06": "ENTER",
      "key07": 10,
      "key08": 1.0,
      "key09": "invalid",
      "key10": "",
      "key11": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getScanCodeVal(doc.asObject().get("key01").getOrThrow()) == Scancode.Num0)
        @Expect(getScanCodeVal(doc.asObject().get("key02").getOrThrow()) == Scancode.Num1)
        @Expect(getScanCodeVal(doc.asObject().get("key03").getOrThrow()) == Scancode.Num9)
        @Expect(getScanCodeVal(doc.asObject().get("key04").getOrThrow()) == Scancode.Num1)
        @Expect(getScanCodeVal(doc.asObject().get("key05").getOrThrow()) == Scancode.Escape)
        @Expect(getScanCodeVal(doc.asObject().get("key06").getOrThrow()) == Scancode.Enter)
        @Expect(getScanCodeVal(doc.asObject().get("key07").getOrThrow(), default: Scancode.Num5) == Scancode.Num5)
        @Expect(getScanCodeVal(doc.asObject().get("key08").getOrThrow()) == Scancode.Unknown)
        @Expect(getScanCodeVal(doc.asObject().get("key09").getOrThrow()) == Scancode.Unknown)
        @Expect(getScanCodeVal(doc.asObject().get("key10").getOrThrow()) == Scancode.Unknown)
        @Expect(getScanCodeVal(doc.asObject().get("key11").getOrThrow()) == Scancode.Unknown)
    }
}

@Test
func test_getTimeVal() {
    let json = ##"
    {
      "key01": 10,
      "key02": 1.2,
      "key03": "1",
      "key04": "10",
      "key05": "10.6",
      "key06": "10:20",
      "key07": "10:20.6",
      "key08": "1:30:05",
      "key09": "1:30:05.6",
      "key10": "-10",
      "key11": "-10.6",
      "key12": "-10:20",
      "key13": "-10:20.6",
      "key14": "-1:30:05",
      "key15": "-1:30:05.6",
      "key16": -1,
      "key17": -1.2,
      "key18": "invalid",
      "key19": "",
      "key20": true,
      "key21": "-1:-30:-05.-6"
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getTimeVal(doc.asObject().get("key01").getOrThrow()) == Time(milliseconds: 10))
        @Expect(getTimeVal(doc.asObject().get("key02").getOrThrow()).seconds, 1.2)
        @Expect(getTimeVal(doc.asObject().get("key03").getOrThrow()).seconds, 1.0)
        @Expect(getTimeVal(doc.asObject().get("key04").getOrThrow()).seconds, 10.0)
        @Expect(getTimeVal(doc.asObject().get("key05").getOrThrow()).seconds, 10.6)
        @Expect(getTimeVal(doc.asObject().get("key06").getOrThrow()).seconds, 620.0)
        @Expect(getTimeVal(doc.asObject().get("key07").getOrThrow()).seconds, 620.6)
        @Expect(getTimeVal(doc.asObject().get("key08").getOrThrow()).seconds, 5405.0)
        @Expect(getTimeVal(doc.asObject().get("key09").getOrThrow()).seconds, 5405.6)
        @Expect(getTimeVal(doc.asObject().get("key10").getOrThrow()).seconds, -10.0)
        @Expect(getTimeVal(doc.asObject().get("key11").getOrThrow()).seconds, -10.6)
        @Expect(getTimeVal(doc.asObject().get("key12").getOrThrow()).seconds, -620.0)
        @Expect(getTimeVal(doc.asObject().get("key13").getOrThrow()).seconds, -620.6)
        @Expect(getTimeVal(doc.asObject().get("key14").getOrThrow()).seconds, -5405.0)
        @Expect(getTimeVal(doc.asObject().get("key15").getOrThrow()).seconds, -5405.6)
        @Expect(getTimeVal(doc.asObject().get("key16").getOrThrow()) == Time(milliseconds: -1))
        @Expect(getTimeVal(doc.asObject().get("key17").getOrThrow()).seconds, -1.2)
        @Expect(getTimeVal(doc.asObject().get("key18").getOrThrow(), default: Time(seconds: 1.0)) == Time(seconds: 1.0))
        @Expect(getTimeVal(doc.asObject().get("key19").getOrThrow()) == Time.zero)
        @Expect(getTimeVal(doc.asObject().get("key20").getOrThrow()) == Time.zero)
        @Expect(getTimeVal(doc.asObject().get("key21").getOrThrow()).seconds, -5405.6)
    }
}

@Test
func test_getTimeUVal() {
    let json = ##"
    {
      "key01": 10,
      "key02": 1.2,
      "key03": "1",
      "key04": "10",
      "key05": "10.6",
      "key06": "10:20",
      "key07": "10:20.6",
      "key08": "1:30:05",
      "key09": "1:30:05.6",
      "key10": "-10",
      "key11": "-10.6",
      "key12": "-10:20",
      "key13": "-10:20.6",
      "key14": "-1:30:05",
      "key15": "-1:30:05.6",
      "key16": -1,
      "key17": -1.2,
      "key18": "invalid",
      "key19": "",
      "key20": true,
      "key21": "-1:-30:-05.-6"
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getTimeUVal(doc.asObject().get("key01").getOrThrow()) == Time(milliseconds: 10))
        @Expect(getTimeUVal(doc.asObject().get("key02").getOrThrow()).seconds, 1.2)
        @Expect(getTimeUVal(doc.asObject().get("key03").getOrThrow()).seconds, 1.0)
        @Expect(getTimeUVal(doc.asObject().get("key04").getOrThrow()).seconds, 10.0)
        @Expect(getTimeUVal(doc.asObject().get("key05").getOrThrow()).seconds, 10.6)
        @Expect(getTimeUVal(doc.asObject().get("key06").getOrThrow()).seconds, 620.0)
        @Expect(getTimeUVal(doc.asObject().get("key07").getOrThrow()).seconds, 620.6)
        @Expect(getTimeUVal(doc.asObject().get("key08").getOrThrow()).seconds, 5405.0)
        @Expect(getTimeUVal(doc.asObject().get("key09").getOrThrow()).seconds, 5405.6)
        @Expect(getTimeUVal(doc.asObject().get("key10").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key11").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key12").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key13").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key14").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key15").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key16").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key17").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key18").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key19").getOrThrow(), default: Time(seconds: -1.0)) == Time(seconds: -1.0))
        @Expect(getTimeUVal(doc.asObject().get("key20").getOrThrow()) == Time.zero)
        @Expect(getTimeUVal(doc.asObject().get("key21").getOrThrow()) == Time.zero)
    }
}

@Test
func test_getStringVectorVal() {
    let json = ##"
    {
      "key01": [],
      "key02": ["this", "is", 1, true, "string", 9.9],
      "key03": ["text", [1, 2, 3], [1, 2, 3, 4, 5], null],
      "key04": "text",
      "key05": "",
      "key06": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        var vec = ArrayList<String>()

        @Expect(getStringVectorVal(doc.asObject().get("key01").getOrThrow()), vec)

        vec = ArrayList<String>(["this", "is", "1", "true", "string", "9.9"])

        @Expect(getStringVectorVal(doc.asObject().get("key02").getOrThrow()), vec)

        vec = ArrayList<String>(["text", "[1,2,3]", "[1,2,3,4,5]", "null"])

        @Expect(getStringVectorVal(doc.asObject().get("key03").getOrThrow()), vec)

        vec = ArrayList<String>(["text"])

        @Expect(getStringVectorVal(doc.asObject().get("key04").getOrThrow()), vec)

        vec = ArrayList<String>([""])

        @Expect(getStringVectorVal(doc.asObject().get("key05").getOrThrow()), vec)

        vec = ArrayList<String>()

        @Expect(getStringVectorVal(doc.asObject().get("key06").getOrThrow()), vec)
    }
}

@Test
func test_getValidStringVectorVal() {
    let json = ##"
    {
      "key01": [],
      "key02": ["this", "is", 1, true, "string", 9.9],
      "key03": ["text", [1, 2, 3], [1, 2, 3, 4, 5], null],
      "key04": "text",
      "key05": "",
      "key06": null
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        var vec = ArrayList<String>()

        @Expect(getValidStringVectorVal(doc.asObject().get("key01").getOrThrow()), vec)

        vec = ArrayList<String>(["this", "is", "string"])

        @Expect(getValidStringVectorVal(doc.asObject().get("key02").getOrThrow()), vec)

        vec = ArrayList<String>(["text"])

        @Expect(getValidStringVectorVal(doc.asObject().get("key03").getOrThrow()), vec)

        vec = ArrayList<String>(["text"])

        @Expect(getValidStringVectorVal(doc.asObject().get("key04").getOrThrow()), vec)

        vec = ArrayList<String>()

        @Expect(getValidStringVectorVal(doc.asObject().get("key05").getOrThrow()), vec)

        vec = ArrayList<String>()

        @Expect(getValidStringVectorVal(doc.asObject().get("key06").getOrThrow()), vec)
    }
}

@Test
func test_getIgnoreResourceVal() {
    let json = ##"
    {
      "key01": "draw",
      "key02": "invalid",
      "key03": "",
      "key04": true,
      "key05": false,
      "key06": ["draw"],
      "key07": ["draw", "update"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getIgnoreResourceVal(doc.asObject().get("key01").getOrThrow()), IgnoreResource.Draw)
        @Expect(getIgnoreResourceVal(doc.asObject().get("key02").getOrThrow(), default: IgnoreResource.All), IgnoreResource.All)
        @Expect(getIgnoreResourceVal(doc.asObject().get("key03").getOrThrow()), IgnoreResource.None)
        @Expect(getIgnoreResourceVal(doc.asObject().get("key04").getOrThrow()), (IgnoreResource.Draw | IgnoreResource.Update))
        @Expect(getIgnoreResourceVal(doc.asObject().get("key05").getOrThrow()), IgnoreResource.None)
        @Expect(getIgnoreResourceVal(doc.asObject().get("key06").getOrThrow()), IgnoreResource.Draw)
        @Expect(getIgnoreResourceVal(doc.asObject().get("key07").getOrThrow()), (IgnoreResource.Draw | IgnoreResource.Update))
    }
}

@Test
func test_getInputEventTypeVal() {
    let json = ##"
    {
      "key01": "leftClick",
      "key02": "invalid",
      "key03": "",
      "key04": true,
      "key05": false,
      "key06": ["leftClick"],
      "key07": ["leftClick", "rightClick"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getInputEventTypeVal(doc.asObject().get("key01").getOrThrow()), InputEventType.LeftClick)
        @Expect(getInputEventTypeVal(doc.asObject().get("key02").getOrThrow(), default: InputEventType.All), InputEventType.All)
        @Expect(getInputEventTypeVal(doc.asObject().get("key03").getOrThrow()), InputEventType.None)
        @Expect(getInputEventTypeVal(doc.asObject().get("key04").getOrThrow()), InputEventType.All)
        @Expect(getInputEventTypeVal(doc.asObject().get("key05").getOrThrow()), InputEventType.None)
        @Expect(getInputEventTypeVal(doc.asObject().get("key06").getOrThrow()), InputEventType.LeftClick)
        @Expect(getInputEventTypeVal(doc.asObject().get("key07").getOrThrow()), (InputEventType.LeftClick | InputEventType.RightClick))
    }
}

@Test
class Test_getMinMaxIntVal {
    let json = ##"
    {
      "key01": -10,
      "key02": 20.2,
      "key03": 30,
      "key04": "min",
      "key05": "max",
      "key06": "invalid",
      "key07": "",
      "key08": true,
      "key09": false,
      "key10": "MAX",
      "key11": "1",
      "key12": 9000000000
    }"##
    let doc = JsonUtils.loadJson(json) ?? JsonNull()

    @TestCase
    func test_Int32() {
        @Expect(getMinMaxIntVal(doc.asObject().get("key01").getOrThrow(), default: 0i32), -10i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key02").getOrThrow(), default: 0i32), 20i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key03").getOrThrow(), default: 0i32), 30i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key04").getOrThrow(), default: 0i32), Int32.Min)
        @Expect(getMinMaxIntVal(doc.asObject().get("key05").getOrThrow(), default: 0i32), Int32.Max)
        @Expect(getMinMaxIntVal(doc.asObject().get("key06").getOrThrow(), default: 1i32), 1i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key07").getOrThrow(), default: 0i32), 0i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key08").getOrThrow(), default: 0i32), 1i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key09").getOrThrow(), default: 0i32), 0i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key10").getOrThrow(), default: 0i32), 0i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key11").getOrThrow(), default: 0i32), 0i32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key12").getOrThrow(), default: 0i32), 0i32)
    }

    @TestCase
    func test_Int64() {
        @Expect(getMinMaxIntVal(doc.asObject().get("key01").getOrThrow(), default: 0i64), -10i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key02").getOrThrow(), default: 0i64), 20i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key03").getOrThrow(), default: 0i64), 30i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key04").getOrThrow(), default: 0i64), Int64.Min)
        @Expect(getMinMaxIntVal(doc.asObject().get("key05").getOrThrow(), default: 0i64), Int64.Max)
        @Expect(getMinMaxIntVal(doc.asObject().get("key06").getOrThrow(), default: 1i64), 1i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key07").getOrThrow(), default: 0i64), 0i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key08").getOrThrow(), default: 0i64), 1i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key09").getOrThrow(), default: 0i64), 0i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key10").getOrThrow(), default: 0i64), 0i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key11").getOrThrow(), default: 0i64), 0i64)
        @Expect(getMinMaxIntVal(doc.asObject().get("key12").getOrThrow(), default: 0i64), 9000000000i64)
    }

    @TestCase
    func test_UInt32() {
        @Expect(getMinMaxIntVal(doc.asObject().get("key01").getOrThrow(), default: 0u32), 0u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key02").getOrThrow(), default: 0u32), 20u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key03").getOrThrow(), default: 0u32), 30u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key04").getOrThrow(), default: 0u32), UInt32.Min)
        @Expect(getMinMaxIntVal(doc.asObject().get("key05").getOrThrow(), default: 0u32), UInt32.Max)
        @Expect(getMinMaxIntVal(doc.asObject().get("key06").getOrThrow(), default: 1u32), 1u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key07").getOrThrow(), default: 0u32), 0u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key08").getOrThrow(), default: 0u32), 1u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key09").getOrThrow(), default: 0u32), 0u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key10").getOrThrow(), default: 0u32), 0u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key11").getOrThrow(), default: 0u32), 0u32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key12").getOrThrow(), default: 0u32), 0u32)
    }

    @TestCase
    func test_Float32() {
        @Expect(getMinMaxIntVal(doc.asObject().get("key01").getOrThrow(), default: 0.0f32), -10.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key02").getOrThrow(), default: 0.0f32), 20.2f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key03").getOrThrow(), default: 0.0f32), 30.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key04").getOrThrow(), default: 0.0f32), Float32.Min)
        @Expect(getMinMaxIntVal(doc.asObject().get("key05").getOrThrow(), default: 0.0f32), Float32.Max)
        @Expect(getMinMaxIntVal(doc.asObject().get("key06").getOrThrow(), default: 1.0f32), 1.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key07").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key08").getOrThrow(), default: 0.0f32), 1.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key09").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key10").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key11").getOrThrow(), default: 0.0f32), 0.0f32)
        @Expect(getMinMaxIntVal(doc.asObject().get("key12").getOrThrow(), default: 0.0f32), 9000000000.0f32)
    }

    @TestCase
    func test_getMinMaxNumber32Val() {
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key01").getOrThrow()).getInt64(), -10)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key02").getOrThrow()).getFloat(), 20.2)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key03").getOrThrow()).getUInt32(), 30u32)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key04").getOrThrow()).getInt64(), Int64(Int32.Min))
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key05").getOrThrow()).getInt64(), Int64(Int32.Max))
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key06").getOrThrow()).getInt64(), 0)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key07").getOrThrow()).getInt64(), 0)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key08").getOrThrow()).getInt64(), 1)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key09").getOrThrow()).getInt64(), 0)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key10").getOrThrow()).getInt64(), 0)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key11").getOrThrow()).getInt64(), 0)
        @Expect(getMinMaxNumber32Val(doc.asObject().get("key12").getOrThrow()).getInt64(), 0)
    }
}

@Test
func test_getPrimitiveTypeVal() {
    let json = ##"
    {
      "key01": "points",
      "key02": "invalid",
      "key03": "",
      "key04": true
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getPrimitiveTypeVal(doc.asObject().get("key01").getOrThrow()) == PrimitiveType.Points)
        @Expect(getPrimitiveTypeVal(doc.asObject().get("key02").getOrThrow(), default: PrimitiveType.Points) == PrimitiveType.Points)
        @Expect(getPrimitiveTypeVal(doc.asObject().get("key03").getOrThrow()) == PrimitiveType.TriangleStrip)
        @Expect(getPrimitiveTypeVal(doc.asObject().get("key04").getOrThrow()) == PrimitiveType.TriangleStrip)
    }
}

@Test
func test_getReplaceVarsVal() {
    let json = ##"
    {
      "key01": "value",
      "key02": "invalid",
      "key03": "",
      "key04": true,
      "key05": false,
      "key06": ["value"],
      "key07": ["value", "string"]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getReplaceVarsVal(doc.asObject().get("key01").getOrThrow()), ReplaceValue)
        @Expect(getReplaceVarsVal(doc.asObject().get("key02").getOrThrow(), default: ReplaceValue), ReplaceValue)
        @Expect(getReplaceVarsVal(doc.asObject().get("key03").getOrThrow()), ReplaceNone)
        @Expect(getReplaceVarsVal(doc.asObject().get("key04").getOrThrow()), ReplaceString)
        @Expect(getReplaceVarsVal(doc.asObject().get("key05").getOrThrow(), default: ReplaceValue), ReplaceNone)
        @Expect(getReplaceVarsVal(doc.asObject().get("key06").getOrThrow()), ReplaceNone)
        @Expect(getReplaceVarsVal(doc.asObject().get("key07").getOrThrow()), ReplaceNone)
    }
}

@Test
func test_getVariableVal() {
    let json = ##"
    {
      "int":          1234,
      "double":       5.678,
      "string":       "text!",
      "bool":         true,
      "Int64Tuple2":  [-2, 3],
      "Int64Tuple3":  [-2, 3, 1200],
      "Int64Tuple4":  [-2, 3, 1200, -1298],
      "DoubleTuple2": [-2.1, 3.9],
      "DoubleTuple3": [-2.1, 3.9, 4.0],
      "DoubleTuple4": [-2.1, 3.9, 4.0, 1200.87],
      "MixedTuple2":  [-2.1, 10],
      "MixedTuple3":  [10, -2.1, -2.5],
      "MixedTuple4":  [10, -2.1, -2.5, 1]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        @Expect(getVariableVal(doc.asObject().get("int").getOrThrow()).getOrThrow(), VaInteger(1234))
        @Expect(getVariableVal(doc.asObject().get("double").getOrThrow()).getOrThrow(), VaDouble(5.678))
        @Expect(getVariableVal(doc.asObject().get("string").getOrThrow()).getOrThrow(), VaString("text!"))
        @Expect(getVariableVal(doc.asObject().get("bool").getOrThrow()).getOrThrow(), VaBoolean(true))
        @Expect(getVariableVal(doc.asObject().get("Int64Tuple2").getOrThrow()).getOrThrow(), VaTuple2i((-2, 3)))
        @Expect(getVariableVal(doc.asObject().get("Int64Tuple3").getOrThrow()).getOrThrow(), VaTuple3i((-2, 3, 1200)))
        @Expect(getVariableVal(doc.asObject().get("Int64Tuple4").getOrThrow()).getOrThrow(), VaTuple4i((-2, 3, 1200, -1298)))
        @Expect(getVariableVal(doc.asObject().get("DoubleTuple2").getOrThrow()).getOrThrow(), VaTuple2f((-2.1, 3.9)))
        @Expect(getVariableVal(doc.asObject().get("DoubleTuple3").getOrThrow()).getOrThrow(), VaTuple3f((-2.1, 3.9, 4.0)))
        @Expect(getVariableVal(doc.asObject().get("DoubleTuple4").getOrThrow()).getOrThrow(), VaTuple4f((-2.1, 3.9, 4.0, 1200.87)))
        @Expect(getVariableVal(doc.asObject().get("MixedTuple2").getOrThrow()).isNone())
        @Expect(getVariableVal(doc.asObject().get("MixedTuple3").getOrThrow()).isNone())
        @Expect(getVariableVal(doc.asObject().get("MixedTuple4").getOrThrow()).isNone())
    }
}

@Test
func test_getVariables() {
    let json = ##"
    {
      "int":          1234,
      "invalid":      [-2.1, 10],
      "DoubleTuple4": [-2.1, 3.9, 4.0, 1200.87]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        // valid
        let vars = getVariables(doc)
        @Expect(vars.size, 2)

        @Expect(vars[0][0], "int")
        @Expect(vars[0][1], VaInteger(1234))

        @Expect(vars[1][0], "DoubleTuple4")
        @Expect(vars[1][1], VaTuple4f((-2.1, 3.9, 4.0, 1200.87)))

        // invalid
        @Expect(getVariables(doc.asObject().get("int").getOrThrow()).isEmpty(), true)
        @Expect(getVariables(doc.asObject().get("DoubleTuple4").getOrThrow()).isEmpty(), true)
    }
}

@Test
func test_getVariablesMap() {
    let json = ##"
    {
      "int":          1234,
      "invalid":      [-2.1, 10],
      "DoubleTuple4": [-2.1, 3.9, 4.0, 1200.87]
    }"##

    if (let Some(doc) <- JsonUtils.loadJson(json)) {
        // valid
        let vars = getVariablesMap(doc)
        @Expect(vars.size, 2)

        @Expect(vars["int"], VaInteger(1234))
        @Expect(vars["DoubleTuple4"], VaTuple4f((-2.1, 3.9, 4.0, 1200.87)))

        // invalid
        @Expect(getVariablesMap(doc.asObject().get("int").getOrThrow()).isEmpty(), true)
        @Expect(getVariablesMap(doc.asObject().get("DoubleTuple4").getOrThrow()).isEmpty(), true)
    }
}

@Test
func test_getVarOrPredicateVal() {
    let json = ##"
    {
      "key01": 1234,
      "key02": { "name": "file.exists", "file": "text.txt" },
      "key03": [-2.1, 10]
    }"##

    try (game = Game()) {
        if (let Some(doc) <- JsonUtils.loadJson(json)) {
            var value = getVarOrPredicateVal(game, doc.asObject().get("key01").getOrThrow())

            match (value) {
                case VaVariable(value) => @Expect(value, VaInteger(1234))
                case _ => @Fail("Expected Variable")
            }

            value = getVarOrPredicateVal(game, doc.asObject().get("key02").getOrThrow())

            match (value) {
                case VaPredicate(value) => @Expect(value.isSome())
                case _ => @Fail("Expected Predicate")
            }

            value = getVarOrPredicateVal(game, doc.asObject().get("key03").getOrThrow())

            match (value) {
                case VaVariable(value) => @Expect(value, VaString(""))
                case _ => @Fail("Expected Variable")
            }
        }
    }
}
