package cenum.test

import cenum.Enum

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Enum[SimpleEnum](
    Val1
    Val2
    Val3
    Val4
)

@Test
func test_SimpleEnum_value() {
    @Expect(SimpleEnum.Val1.value, 0)
    @Expect(SimpleEnum.Val2.value, 1)
    @Expect(SimpleEnum.Val3.value, 2)
    @Expect(SimpleEnum.Val4.value, 3)
}

@Enum[public CustomValueEnum](
    Val1 = 2
    Val2
    Val3
    Val4
)

@Test
func test_CustomValueEnum_value() {
    @Expect(CustomValueEnum.Val1.value, 2i32)
    @Expect(CustomValueEnum.Val2.value, 3i32)
    @Expect(CustomValueEnum.Val3.value, 4i32)
    @Expect(CustomValueEnum.Val4.value, 5i32)
}

@Enum[CustomValueEnum2 UInt32](
    Val1 = 2
    Val2
    Val3 = 8
    Val4
)

@Test
func test_CustomValueEnum2_value() {
    @Expect(CustomValueEnum2.Val1.value, 2u32)
    @Expect(CustomValueEnum2.Val2.value, 3u32)
    @Expect(CustomValueEnum2.Val3.value, 8u32)
    @Expect(CustomValueEnum2.Val4.value, 9u32)
}

@Enum[public CustomValueEnum3 Int64](
    Val1 = -2
    Val2
    Val3
    Val4
    Val5 = 8
    Val6
)

@Test
func test_CustomValueEnum3_value() {
    @Expect(CustomValueEnum3.Val1.value, -2i64)
    @Expect(CustomValueEnum3.Val2.value, -1i64)
    @Expect(CustomValueEnum3.Val3.value, 0i64)
    @Expect(CustomValueEnum3.Val4.value, 1i64)
    @Expect(CustomValueEnum3.Val5.value, 8i64)
    @Expect(CustomValueEnum3.Val6.value, 9i64)
}

// cjlint-ignore -end function names should be lower camel case
