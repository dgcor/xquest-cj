package cjsfml.system

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestVector3i {
    @TestCase
    func init_default() {
        let vector = Vector3i()
        @Expect(vector.x, 0)
        @Expect(vector.y, 0)
        @Expect(vector.z, 0)
    }

    @TestCase
    func init_coords() {
        let vector = Vector3i(1, 2, 3)
        @Expect(vector.x, 1)
        @Expect(vector.y, 2)
        @Expect(vector.z, 3)
    }

    @TestCase
    func init_tuple() {
        let vector = Vector3i((10, 20, 30))
        @Expect(vector.x, 10)
        @Expect(vector.y, 20)
        @Expect(vector.z, 30)
    }

    @TestCase
    func negation() {
        let vector = Vector3i(1, 2, 3)
        let negated = -vector
        @Expect(negated.x, -1)
        @Expect(negated.y, -2)
        @Expect(negated.z, -3)
    }

    @TestCase
    func addition() {
        var first = Vector3i(2, 5, 6)
        let second = Vector3i(8, 3, 7)

        first += second
        @Expect(first == Vector3i(10, 8, 13))

        let result = first + second
        @Expect(result == Vector3i(18, 11, 20))
    }

    @TestCase
    func subtraction() {
        var first = Vector3i(2, 5, 6)
        let second = Vector3i(8, 3, 7)

        first -= second
        @Expect(first == Vector3i(-6, 2, -1))

        let result = first - second
        @Expect(result == Vector3i(-14, -1, -8))
    }

    @TestCase
    func multiplication() {
        var vector = Vector3i(26, 12, 6)
        let scalar = 2i32

        let result = vector * scalar
        @Expect(result == Vector3i(52, 24, 12))

        vector *= scalar
        @Expect(vector == Vector3i(52, 24, 12))
    }

    @TestCase
    func division() {
        var vector = Vector3i(26, 12, 6)
        let scalar = 2i32

        let result = vector / scalar
        @Expect(result == Vector3i(13, 6, 3))

        vector /= scalar
        @Expect(vector == Vector3i(13, 6, 3))
    }

    @TestCase
    func equality() {
        let first = Vector3i(1, 5, 6)
        let second = Vector3i(1, 5, 6)
        let third = Vector3i(6, 9, 7)

        @Expect(first == second, true)
        @Expect(first != third, true)
        @Expect(first == third, false)
    }

    @TestCase
    func toTuple() {
        let vector = Vector3i(1, 2, 3)
        let (x, y, z) = vector.toTuple()

        @Expect(x, 1)
        @Expect(y, 2)
        @Expect(z, 3)
    }
}

@Test
class TestVector3f {
    @TestCase
    func init_default() {
        let vector = Vector3f()
        @Expect(vector.x, 0.0)
        @Expect(vector.y, 0.0)
        @Expect(vector.z, 0.0)
    }

    @TestCase
    func init_coords() {
        let vector = Vector3f(1.0, 2.0, 3.0)
        @Expect(vector.x, 1.0)
        @Expect(vector.y, 2.0)
        @Expect(vector.z, 3.0)
    }

    @TestCase
    func arithmetic() {
        let v1 = Vector3f(2.0, 5.0, 6.0)
        let v2 = Vector3f(8.0, 3.0, 7.0)

        @Expect(v1 + v2 == Vector3f(10.0, 8.0, 13.0))
        @Expect(v1 - v2 == Vector3f(-6.0, 2.0, -1.0))
        @Expect(v1 * 2.0 == Vector3f(4.0, 10.0, 12.0))
        @Expect(v1 / 2.0 == Vector3f(1.0, 2.5, 3.0))
        @Expect(-v1 == Vector3f(-2.0, -5.0, -6.0))
    }

    @TestCase
    func length() {
        let v = Vector3f(2.4, 3.0, 5.2)

        // lengthSquared
        let lenSq = v.lengthSquared()
        @Expect(lenSq, 41.79997, delta: 0.001)

        // length
        let len = v.length()
        @Expect(len, 6.46529, delta: 0.001)

        // normalized
        let norm = v.normalized()
        @Expect(norm.x, 0.37121, delta: 0.001)
        @Expect(norm.y, 0.46401, delta: 0.001)
        @Expect(norm.z, 0.80429, delta: 0.001)
    }

    @TestCase
    func products() {
        let v = Vector3f(2.4, 3.0, 5.2)
        let w = Vector3f(-0.7, -2.2, -4.8)

        // Dot
        let dot = v.dot(w)
        @Expect(dot, -33.24, delta: 0.001)

        // Commutative Dot
        let dot2 = w.dot(v)
        @Expect(dot2, -33.24, delta: 0.001)

        // Cross
        let crossVW = v.cross(w)
        @Expect(crossVW.x, -2.96, delta: 0.001)
        @Expect(crossVW.y, 7.88, delta: 0.001)
        @Expect(crossVW.z, -3.18, delta: 0.001)

        let crossWV = w.cross(v)
        @Expect(crossWV.x, 2.96, delta: 0.001)
        @Expect(crossWV.y, -7.88, delta: 0.001)
        @Expect(crossWV.z, 3.18, delta: 0.001)

        // Component-wise mul
        let mul = v.componentWiseMul(w)
        @Expect(mul.x, -1.68, delta: 0.001)
        @Expect(mul.y, -6.6, delta: 0.001)
        @Expect(mul.z, -24.96, delta: 0.001)

        // Commutative Mul
        let mul2 = w.componentWiseMul(v)
        @Expect(mul2.x, -1.68, delta: 0.001)
        @Expect(mul2.y, -6.6, delta: 0.001)
        @Expect(mul2.z, -24.96, delta: 0.001)

        // Component-wise div
        let div = v.componentWiseDiv(w)
        @Expect(div.x, -3.428571, delta: 0.001)
        @Expect(div.y, -1.363636, delta: 0.001)
        @Expect(div.z, -1.0833333, delta: 0.001)

        // Reverse Div (w / v)
        let div2 = w.componentWiseDiv(v)
        @Expect(div2.x, -0.291666, delta: 0.001)
        @Expect(div2.y, -0.733333, delta: 0.001)
        @Expect(div2.z, -0.9230769, delta: 0.001)
    }

    @TestCase
    func toTuple() {
        let vector = Vector3f(1.0, 2.0, 3.0)
        let (x, y, z) = vector.toTuple()

        @Expect(x, 1.0)
        @Expect(y, 2.0)
        @Expect(z, 3.0)
    }
}

// cjlint-ignore -end function names should be lower camel case
