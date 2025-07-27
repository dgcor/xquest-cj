package dgengine.test

import dgengine.*
import std.unittest.*

@Test
func test_ReplaceVars_get() {
    @Expect(ReplaceVars.get("none"), ReplaceNone)
    @Expect(ReplaceVars.get("string"), ReplaceString)
    @Expect(ReplaceVars.get("value"), ReplaceValue)
    @Expect(ReplaceVars.get("VALUE"), ReplaceValue)
    @Expect(ReplaceVars.get("value "), ReplaceNone)
    @Expect(ReplaceVars.get("invalid", default: ReplaceValue), ReplaceValue)
    @Expect(ReplaceVars.get(""), ReplaceNone)
}
