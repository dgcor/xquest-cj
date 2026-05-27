package cjsfml.system

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestVector2i {
    @TestCase
    func init_default() {
        let vector = Vector2i()
        @Expect(vector.x, 0)
        @Expect(vector.y, 0)
    }

    @TestCase
    func init_coords() {
        let vector = Vector2i(1, 2)
        @Expect(vector.x, 1)
        @Expect(vector.y, 2)
    }

    @TestCase
    func init_tuple() {
        let vector = Vector2i((10, 20))
        @Expect(vector.x, 10)
        @Expect(vector.y, 20)
    }

    @TestCase
    func init_int64() {
        // Test creation from Int64 tuple
        let vector = Vector2i.create((100i64, -200i64))
        @Expect(vector.x, 100)
        @Expect(vector.y, -200)
    }

    @TestCase
    func negation() {
        let vector = Vector2i(1, 2)
        let negated = -vector
        @Expect(negated.x, -1)
        @Expect(negated.y, -2)
    }

    @TestCase
    func addition() {
        var first = Vector2i(2, 5)
        let second = Vector2i(8, 3)

        first += second
        @Expect(first == Vector2i(10, 8))

        let result = first + second
        @Expect(result == Vector2i(18, 11))
    }

    @TestCase
    func subtraction() {
        var first = Vector2i(2, 5)
        let second = Vector2i(8, 3)

        first -= second
        @Expect(first == Vector2i(-6, 2))

        let result = first - second
        @Expect(result == Vector2i(-14, -1))
    }

    @TestCase
    func multiplication() {
        var vector = Vector2i(26, 12)
        let scalar = 2i32

        let result = vector * scalar
        @Expect(result == Vector2i(52, 24))

        vector *= scalar
        @Expect(vector == Vector2i(52, 24))
    }

    @TestCase
    func division() {
        var vector = Vector2i(26, 12)
        let scalar = 2i32

        let result = vector / scalar
        @Expect(result == Vector2i(13, 6))

        vector /= scalar
        @Expect(vector == Vector2i(13, 6))
    }

    @TestCase
    func int_division_truncation() {
        // Verify truncation behavior for uneven division
        let vector = Vector2i(10, 11)
        let result = vector / 3i32
        // 10/3 = 3, 11/3 = 3
        @Expect(result == Vector2i(3, 3))
    }

    @TestCase
    func equality() {
        let first = Vector2i(1, 5)
        let second = Vector2i(1, 5)
        let third = Vector2i(6, 9)

        @Expect(first == second, true)
        @Expect(first != third, true)
        @Expect(first == third, false)
    }

    @TestCase
    func multiplication_assignment() {
        var vector = Vector2i(10, 20)
        vector *= 2i32
        @Expect(vector == Vector2i(20, 40))
    }

    @TestCase
    func division_assignment() {
        var vector = Vector2i(20, 40)
        vector /= 2i32
        @Expect(vector == Vector2i(10, 20))
    }

    @TestCase
    func toTuple() {
        let vector = Vector2i(1, 2)
        let (x, y) = vector.toTuple()

        @Expect(x, 1)
        @Expect(y, 2)
    }
}

@Test
class TestVector2f {
    @TestCase
    func init_default() {
        let vector = Vector2f()
        @Expect(vector.x, 0.0)
        @Expect(vector.y, 0.0)
    }

    @TestCase
    func init_coords() {
        let vector = Vector2f(1.0, 2.0)
        @Expect(vector.x, 1.0)
        @Expect(vector.y, 2.0)
    }

    @TestCase
    func init_length_angle() {
        // Zero length
        @Expect(Vector2f(0.0, Angle.degrees(0.0)) == Vector2f(0.0, 0.0))
        @Expect(Vector2f(0.0, Angle.degrees(45.0)) == Vector2f(0.0, 0.0))
        @Expect(Vector2f(0.0, Angle.degrees(90.0)) == Vector2f(0.0, 0.0))

        // Unit length
        @Expect(Vector2f(1.0, Angle.degrees(0.0)) == Vector2f(1.0, 0.0))
        let v45 = Vector2f(1.0, Angle.degrees(45.0))
        @Expect(v45.x, 0.707106, delta: 0.001) // sqrt(2)/2
        @Expect(v45.y, 0.707106, delta: 0.001)

        @Expect(Vector2f(1.0, Angle.degrees(90.0)).x, 0.0, delta: 0.001)
        @Expect(Vector2f(1.0, Angle.degrees(90.0)).y, 1.0, delta: 0.001)

        @Expect(Vector2f(1.0, Angle.degrees(135.0)).x, -0.707106, delta: 0.001)
        @Expect(Vector2f(1.0, Angle.degrees(135.0)).y, 0.707106, delta: 0.001)

        @Expect(Vector2f(1.0, Angle.degrees(180.0)).x, -1.0, delta: 0.001)
        @Expect(Vector2f(1.0, Angle.degrees(180.0)).y, 0.0, delta: 0.001)

        @Expect(Vector2f(1.0, Angle.degrees(270.0)).x, 0.0, delta: 0.001)
        @Expect(Vector2f(1.0, Angle.degrees(270.0)).y, -1.0, delta: 0.001)

        @Expect(Vector2f(1.0, Angle.degrees(360.0)).x, 1.0, delta: 0.001)
        @Expect(Vector2f(1.0, Angle.degrees(360.0)).y, 0.0, delta: 0.001)

        // Negative length
        @Expect(Vector2f(-1.0, Angle.degrees(0.0)) == Vector2f(-1.0, 0.0))
        let vNeg45 = Vector2f(-1.0, Angle.degrees(45.0))
        @Expect(vNeg45.x, -0.707106, delta: 0.001)
        @Expect(vNeg45.y, -0.707106, delta: 0.001)

        // Specific length 4.2
        @Expect(Vector2f(4.2, Angle.degrees(0.0)) == Vector2f(4.2, 0.0))
        let v4290 = Vector2f(4.2, Angle.degrees(90.0))
        @Expect(v4290.x, 0.0, delta: 0.001)
        @Expect(v4290.y, 4.2, delta: 0.001)
    }

    @TestCase
    func arithmetic() {
        let v1 = Vector2f(2.0, 5.0)
        let v2 = Vector2f(8.0, 3.0)

        @Expect(v1 + v2 == Vector2f(10.0, 8.0))
        @Expect(v1 - v2 == Vector2f(-6.0, 2.0))
        @Expect(v1 * 2.0 == Vector2f(4.0, 10.0))
        @Expect(v1 / 2.0 == Vector2f(1.0, 2.5))
        @Expect(-v1 == Vector2f(-2.0, -5.0))
    }

    @TestCase
    func length() {
        let v = Vector2f(2.4, 3.0)

        // lengthSquared
        let lenSq = v.lengthSquared()
        @Expect(lenSq, 14.7599650969, delta: 0.001)

        // length
        let len = v.length()
        @Expect(len, 3.84187, delta: 0.001)

        // normalized
        let norm = v.normalized()
        @Expect(norm.x, 0.624695, delta: 0.001)
        @Expect(norm.y, 0.780869, delta: 0.001)

        // Second vector w
        let w = Vector2f(-0.7, -2.2)
        @Expect(w.length(), 2.30868, delta: 0.001)
        @Expect(w.lengthSquared(), 5.3300033, delta: 0.001)

        let normW = w.normalized()
        @Expect(normW.x, -0.303204, delta: 0.001)
        @Expect(normW.y, -0.952926, delta: 0.001)
    }

    @TestCase
    func perpendicular() {
        let v = Vector2f(2.4, 3.0)
        let p = v.perpendicular()

        @Expect(p == Vector2f(-3.0, 2.4))
        @Expect(p.perpendicular().perpendicular().perpendicular().perpendicular() == p)
    }

    @TestCase
    func products() {
        let v = Vector2f(2.4, 3.0)
        let w = Vector2f(-0.7, -2.2)

        // Dot
        let dot = v.dot(w)
        @Expect(dot, -8.28, delta: 0.001)

        // Commutative Dot
        let dot2 = w.dot(v)
        @Expect(dot2, -8.28, delta: 0.001)

        // Cross
        let cross = v.cross(w)
        @Expect(cross, -3.18, delta: 0.001)

        // Reverse Cross
        let cross2 = w.cross(v)
        @Expect(cross2, 3.18, delta: 0.001)

        // Component-wise mul
        let mul = v.componentWiseMul(w)
        @Expect(mul.x, -1.68, delta: 0.001)
        @Expect(mul.y, -6.6, delta: 0.001)

        // Commutative Mul
        let mul2 = w.componentWiseMul(v)
        @Expect(mul2.x, -1.68, delta: 0.001)
        @Expect(mul2.y, -6.6, delta: 0.001)

        // Component-wise div
        let div = v.componentWiseDiv(w)
        @Expect(div.x, -3.428571, delta: 0.001)
        @Expect(div.y, -1.363636, delta: 0.001)

        // Reverse Div (w / v)
        let div2 = w.componentWiseDiv(v)
        @Expect(div2.x, -0.291666, delta: 0.001)
        @Expect(div2.y, -0.733333, delta: 0.001)
    }

    @TestCase
    func angle_operations() {
        let v = Vector2f(2.4, 3.0)
        let w = Vector2f(-0.7, -2.2)

        // angle()
        @Expect(v.angle().value, 51.3402, delta: 0.001)
        @Expect(w.angle().value, -107.65, delta: 0.001)

        // angleTo
        // Angle from X axis to v
        @Expect(Vector2f(1.0, 0.0).angleTo(v).asDegrees(), 51.3402, delta: 0.001)
        // Angle from Y axis to v
        @Expect(Vector2f(0.0, 1.0).angleTo(v).asDegrees(), -38.6598, delta: 0.001)

        // Angle between v and w
        @Expect(v.angleTo(w).asDegrees(), -158.9902, delta: 0.001)
        @Expect(w.angleTo(v).asDegrees(), 158.9902, delta: 0.001)
    }

    @TestCase
    func angle_and_rotation() {
        let v = Vector2f(2.4, 3.0)

        // Angle
        let angle = v.angle()
        @Expect(angle.value, 51.3402, delta: 0.001)

        // RotatedBy 90
        let rotated = v.rotatedBy(Angle.degrees(90.0))
        @Expect(rotated.x, -3.0, delta: 0.001)
        @Expect(rotated.y, 2.4, delta: 0.001)

        // RotatedBy 27.14
        let rotated2 = v.rotatedBy(Angle.degrees(27.14))
        @Expect(rotated2.x, 0.767248, delta: 0.001)
        @Expect(rotated2.y, 3.76448, delta: 0.001)

        // RotatedBy -36.11
        let rotated3 = v.rotatedBy(Angle.degrees(-36.11))
        @Expect(rotated3.x, 3.70694, delta: 0.001)
        @Expect(rotated3.y, 1.00925, delta: 0.001)
    }

    @TestCase
    func projection() {
        let v = Vector2f(2.4, 3.0)
        let w = Vector2f(-0.7, -2.2)

        let proj = v.projectedOnto(w)
        @Expect(proj.x, 1.087430, delta: 0.001)
        @Expect(proj.y, 3.417636, delta: 0.001)

        // Reverse projection
        let proj2 = w.projectedOnto(v)
        @Expect(proj2.x, -1.346342, delta: 0.001)
        @Expect(proj2.y, -1.682927, delta: 0.001)

        // Projection onto axes
        let projX = v.projectedOnto(Vector2f(1.0, 0.0))
        @Expect(projX.x, 2.4, delta: 0.001)
        @Expect(projX.y, 0.0, delta: 0.001)

        let projY = v.projectedOnto(Vector2f(0.0, 1.0))
        @Expect(projY.x, 0.0, delta: 0.001)
        @Expect(projY.y, 3.0, delta: 0.001)
    }

    @TestCase
    func multiplication_assignment() {
        var vector = Vector2f(10.0, 20.0)
        vector *= 2.0
        @Expect(vector == Vector2f(20.0, 40.0))
    }

    @TestCase
    func division_assignment() {
        var vector = Vector2f(20.0, 40.0)
        vector /= 2.0
        @Expect(vector == Vector2f(10.0, 20.0))
    }

    @TestCase
    func toTuple() {
        let vector = Vector2f(1.0, 2.0)
        let (x, y) = vector.toTuple()

        @Expect(x, 1.0)
        @Expect(y, 2.0)
    }
}

// cjlint-ignore -end function names should be lower camel case
