package cenum.test

import cenum.{FlagEnum, FlagEnum0, FlagEnum1}

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@FlagEnum[SimpleFlagEnum](
    Val1
    Val2
    Val3
    Val4
)

@Test
func test_SimpleFlagEnum_value() {
    @Expect(SimpleFlagEnum.Val1.value, 0)
    @Expect(SimpleFlagEnum.Val2.value, 1)
    @Expect(SimpleFlagEnum.Val3.value, 2)
    @Expect(SimpleFlagEnum.Val4.value, 4)
}

@FlagEnum0[SimpleFlagEnum0](
    Val1
    Val2
    Val3
    Val4
)

@Test
func test_SimpleFlagEnum0_value() {
    @Expect(SimpleFlagEnum0.Val1.value, 0)
    @Expect(SimpleFlagEnum0.Val2.value, 1)
    @Expect(SimpleFlagEnum0.Val3.value, 2)
    @Expect(SimpleFlagEnum0.Val4.value, 4)
}

@FlagEnum1[SimpleFlagEnum1](
    Val1
    Val2
    Val3
    Val4
)

@Test
func test_SimpleFlagEnum1_value() {
    @Expect(SimpleFlagEnum1.Val1.value, 1)
    @Expect(SimpleFlagEnum1.Val2.value, 2)
    @Expect(SimpleFlagEnum1.Val3.value, 4)
    @Expect(SimpleFlagEnum1.Val4.value, 8)
}

@FlagEnum[SimpleFlagEnum2](
    None
    Val1
    Val2
    Val3
)

@Test
func test_SimpleFlagEnum2_equals() {
    let flags = SimpleFlagEnum2.Val3
    @Expect(flags != SimpleFlagEnum2.None)
    @Expect(flags != SimpleFlagEnum2.Val1)
    @Expect(flags != SimpleFlagEnum2.Val2)
    @Expect(flags == SimpleFlagEnum2.Val3)
}

@Test
func test_SimpleFlagEnum2_set() {
    var flags = SimpleFlagEnum2.None.set(SimpleFlagEnum2.Val3)
    @Expect(flags != SimpleFlagEnum2.None)
    @Expect(flags != SimpleFlagEnum2.Val1)
    @Expect(flags != SimpleFlagEnum2.Val2)
    @Expect(flags == SimpleFlagEnum2.Val3)

    flags = flags.set(SimpleFlagEnum2.Val2)
    @Expect(flags != SimpleFlagEnum2.None)
    @Expect(flags != SimpleFlagEnum2.Val1)
    @Expect(flags != SimpleFlagEnum2.Val2)
    @Expect(flags != SimpleFlagEnum2.Val3)
}

@Test
func test_SimpleFlagEnum2_isSet() {
    var flags = SimpleFlagEnum2.None.set(SimpleFlagEnum2.Val3)
    @Expect(flags.isSet(SimpleFlagEnum2.None) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val3) == true)

    flags = flags.set(SimpleFlagEnum2.Val2)
    @Expect(flags.isSet(SimpleFlagEnum2.None) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val2) == true)
    @Expect(flags.isSet(SimpleFlagEnum2.Val3) == true)
}

@Test
func test_SimpleFlagEnum2_clear() {
    var flags = SimpleFlagEnum2.None
    @Expect(flags.isSet(SimpleFlagEnum2.None) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val3) == false)

    flags = flags.set(SimpleFlagEnum2.Val1)
    flags = flags.set(SimpleFlagEnum2.Val2)
    flags = flags.set(SimpleFlagEnum2.Val3)
    @Expect(flags.isSet(SimpleFlagEnum2.None) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val1) == true)
    @Expect(flags.isSet(SimpleFlagEnum2.Val2) == true)
    @Expect(flags.isSet(SimpleFlagEnum2.Val3) == true)

    flags = flags.clear(SimpleFlagEnum2.Val2)
    @Expect(flags.isSet(SimpleFlagEnum2.None) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val1) == true)
    @Expect(flags.isSet(SimpleFlagEnum2.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val3) == true)

    flags = flags.clear(SimpleFlagEnum2.Val1)
    @Expect(flags.isSet(SimpleFlagEnum2.None) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val3) == true)

    flags = flags.clear(SimpleFlagEnum2.Val3)
    @Expect(flags.isSet(SimpleFlagEnum2.None) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum2.Val3) == false)
}

@FlagEnum1[SimpleFlagEnum3](
    Val1
    Val2
    Val3
    Val4
)

@Test
func test_SimpleFlagEnum3_equals() {
    let flags = SimpleFlagEnum3.Val3
    @Expect(flags != SimpleFlagEnum3.Val1)
    @Expect(flags != SimpleFlagEnum3.Val2)
    @Expect(flags == SimpleFlagEnum3.Val3)
    @Expect(flags != SimpleFlagEnum3.Val4)
}

@Test
func test_SimpleFlagEnum3_set() {
    var flags = SimpleFlagEnum3.Val3
    @Expect(flags != SimpleFlagEnum3.Val1)
    @Expect(flags != SimpleFlagEnum3.Val2)
    @Expect(flags == SimpleFlagEnum3.Val3)
    @Expect(flags != SimpleFlagEnum3.Val4)

    flags = flags.set(SimpleFlagEnum3.Val2)
    @Expect(flags != SimpleFlagEnum3.Val1)
    @Expect(flags != SimpleFlagEnum3.Val2)
    @Expect(flags != SimpleFlagEnum3.Val3)
    @Expect(flags != SimpleFlagEnum3.Val4)
}

@Test
func test_SimpleFlagEnum3_isSet() {
    var flags = SimpleFlagEnum3.Val3
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == false)

    flags = flags.set(SimpleFlagEnum3.Val2)
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == false)
}

@Test
func test_SimpleFlagEnum3_clear() {
    var flags = SimpleFlagEnum3.Val1
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == false)

    flags = flags.set(SimpleFlagEnum3.Val1)
    flags = flags.set(SimpleFlagEnum3.Val2)
    flags = flags.set(SimpleFlagEnum3.Val3)
    flags = flags.set(SimpleFlagEnum3.Val4)
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == true)

    flags = flags.clear(SimpleFlagEnum3.Val2)
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == true)

    flags = flags.clear(SimpleFlagEnum3.Val1)
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == true)

    flags = flags.clear(SimpleFlagEnum3.Val4)
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == true)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == false)

    flags = flags.clear(SimpleFlagEnum3.Val3)
    @Expect(flags.isSet(SimpleFlagEnum3.Val1) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val2) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val3) == false)
    @Expect(flags.isSet(SimpleFlagEnum3.Val4) == false)
}

// cjlint-ignore -end function names should be lower camel case
