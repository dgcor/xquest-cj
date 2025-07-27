package ctemplate.test

import ctemplate.*
import std.math.*
import std.unittest.*

@Template[T: Int32, Int64, Float32](
func getNum(n: T): T {
    var ret = unsafe { zeroValue<T>() }
    ret += n
    return ret
})

@Test
func test_template_single_param() {
    @Expect(getNum(10i32), 10)
    @Expect(getNum(10i64), 10)
    @Expect(getNum(10.0f32), 10.0)
}

@Template[T, U: Float32, Int32 ; Float64, Int64](
func round(num: T, digits: U): T {
    let fac = pow(10.0, digits)
    return round(num * fac) / fac
})

@Test
func test_template_multi_params() {
    @Expect(round(1234.5234f32, 2), 1234.52f32)
    @Expect(round(9842.124534f64, 4), 9842.1245f64)
}

@Template[T U: Float32 Int32 Float64 Int64](
func round2(num: T, digits: U): T {
    let fac = pow(10.0, digits)
    return round(num * fac) / fac
})

@Test
func test_template_no_commas() {
    @Expect(round2(1234.5234f32, 2), 1234.52f32)
    @Expect(round2(9842.124534f64, 4), 9842.1245f64)
}
