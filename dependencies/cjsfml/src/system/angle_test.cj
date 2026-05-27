package cjsfml.system

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestAngle {
    @TestCase
    func construction() {
        let angle = Angle()
        @Expect(angle.asDegrees(), 0.0)
        @Expect(angle.asRadians(), 0.0)
    }

    @TestCase
    func wrapSigned() {
        @Expect(Angle.ZERO.wrapSigned() == Angle.ZERO)

        @Expect(Angle.degrees(0.0).wrapSigned().value, Angle.degrees(0.0).value, delta: 0.001)
        @Expect(Angle.degrees(1.0).wrapSigned().value, Angle.degrees(1.0).value, delta: 0.001)
        @Expect(Angle.degrees(-1.0).wrapSigned().value, Angle.degrees(-1.0).value, delta: 0.001)
        @Expect(Angle.degrees(90.0).wrapSigned().value, Angle.degrees(90.0).value, delta: 0.001)
        @Expect(Angle.degrees(-90.0).wrapSigned().value, Angle.degrees(-90.0).value, delta: 0.001)

        // 180 wraps to -180
        @Expect(Angle.degrees(180.0).wrapSigned().value, Angle.degrees(-180.0).value, delta: 0.001)
        @Expect(Angle.degrees(-180.0).wrapSigned().value, Angle.degrees(-180.0).value, delta: 0.001)

        // Use approx for wrapped values due to float precision
        @Expect(Angle.degrees(360.0).wrapSigned().asDegrees(), 0.0, delta: 0.001)
        @Expect(Angle.degrees(-360.0).wrapSigned().asDegrees(), 0.0, delta: 0.001)
        @Expect(Angle.degrees(720.0).wrapSigned().asDegrees(), 0.0, delta: 0.001)
        @Expect(Angle.degrees(-720.0).wrapSigned().asDegrees(), 0.0, delta: 0.001)
    }

    @TestCase
    func wrapUnsigned() {
        @Expect(Angle.ZERO.wrapUnsigned() == Angle.ZERO)

        @Expect(Angle.degrees(0.0).wrapUnsigned().value, Angle.degrees(0.0).value, delta: 0.001)
        @Expect(Angle.degrees(1.0).wrapUnsigned().value, Angle.degrees(1.0).value, delta: 0.001)
        @Expect(Angle.degrees(-1.0).wrapUnsigned().value, Angle.degrees(359.0).value, delta: 0.001)
        @Expect(Angle.degrees(90.0).wrapUnsigned().value, Angle.degrees(90.0).value, delta: 0.001)
        @Expect(Angle.degrees(-90.0).wrapUnsigned().value, Angle.degrees(270.0).value, delta: 0.001)
        @Expect(Angle.degrees(180.0).wrapUnsigned().value, Angle.degrees(180.0).value, delta: 0.001)
        @Expect(Angle.degrees(-180.0).wrapUnsigned().value, Angle.degrees(180.0).value, delta: 0.001)

        // Use approx for wrapped values
        @Expect(Angle.degrees(360.0).wrapUnsigned().asDegrees(), 0.0, delta: 0.001)
        @Expect(Angle.degrees(-360.0).wrapUnsigned().asDegrees(), 0.0, delta: 0.001)
        @Expect(Angle.degrees(720.0).wrapUnsigned().asDegrees(), 0.0, delta: 0.001)
        @Expect(Angle.degrees(-720.0).wrapUnsigned().asDegrees(), 0.0, delta: 0.001)
    }

    @TestCase
    func degrees() {
        let angle = Angle.degrees(15.0)
        @Expect(angle == Angle.degrees(15.0))
        @Expect(angle.asRadians(), 0.26179939, delta: 0.001)

        let bigAngle = Angle.degrees(1000.0)
        @Expect(bigAngle == Angle.degrees(1000.0))
        @Expect(bigAngle.asRadians(), 17.453293, delta: 0.001)

        let bigNegativeAngle = Angle.degrees(-4321.0)
        @Expect(bigNegativeAngle == Angle.degrees(-4321.0))
        @Expect(bigNegativeAngle.asRadians(), -75.415677, delta: 0.001)
    }

    @TestCase
    func radians() {
        let angle = Angle.radians(1.0)
        @Expect(angle.asDegrees(), 57.2957795, delta: 0.001)
        @Expect(angle.asRadians() == 1.0)

        let bigAngle = Angle.radians(72.0)
        @Expect(bigAngle.asDegrees(), 4125.29612, delta: 0.001)
        @Expect(bigAngle.asRadians() == 72.0)

        let bigNegativeAngle = Angle.radians(-200.0)
        @Expect(bigNegativeAngle.asDegrees(), -11459.1559, delta: 0.001)
        @Expect(bigNegativeAngle.asRadians() == -200.0)
    }

    @TestCase
    func constants() {
        @Expect(Angle.ZERO.asDegrees(), 0.0)
        @Expect(Angle.ZERO.asRadians(), 0.0)
    }

    @TestCase
    func operator_equality() {
        @Expect(Angle() == Angle())
        @Expect(Angle() == Angle.ZERO)
        @Expect(Angle() == Angle.degrees(0.0))
        @Expect(Angle() == Angle.radians(0.0))
        @Expect(Angle.degrees(0.0) == Angle.radians(0.0))
        @Expect(Angle.degrees(15.0) == Angle.degrees(15.0))
        @Expect(Angle.radians(1.0) == Angle.radians(1.0))
        @Expect(Angle.degrees(360.0) == Angle.degrees(360.0))
        @Expect(Angle.degrees(720.0) == Angle.degrees(720.0))
    }

    @TestCase
    func operator_inequality() {
        @Expect(Angle() != Angle.radians(2.0))
        @Expect(Angle.degrees(1.0) != Angle.radians(1.0))
        @Expect(Angle.radians(0.0) != Angle.radians(0.1))
    }

    @TestCase
    func operator_lessThan() {
        @Expect(Angle.radians(0.0) < Angle.degrees(0.1))
        @Expect(Angle.degrees(0.0) < Angle.radians(0.1))
        @Expect(Angle.radians(-0.1) < Angle.radians(0.0))
        @Expect(Angle.degrees(-0.1) < Angle.degrees(0.0))
    }

    @TestCase
    func operator_greaterThan() {
        @Expect(Angle.radians(0.1) > Angle.degrees(0.0))
        @Expect(Angle.degrees(0.1) > Angle.radians(0.0))
        @Expect(Angle.radians(0.0) > Angle.radians(-0.1))
        @Expect(Angle.degrees(0.0) > Angle.degrees(-0.1))
    }

    @TestCase
    func operator_lessThanOrEqual() {
        @Expect(Angle.radians(0.0) <= Angle.degrees(0.1))
        @Expect(Angle.degrees(0.0) <= Angle.radians(0.1))
        @Expect(Angle.radians(-0.1) <= Angle.radians(0.0))
        @Expect(Angle.degrees(-0.1) <= Angle.degrees(0.0))

        @Expect(Angle() <= Angle())
        @Expect(Angle() <= Angle.ZERO)
        @Expect(Angle() <= Angle.degrees(0.0))
        @Expect(Angle() <= Angle.radians(0.0))
        @Expect(Angle.degrees(0.0) <= Angle.radians(0.0))
        @Expect(Angle.degrees(15.0) <= Angle.degrees(15.0))
        @Expect(Angle.radians(1.0) <= Angle.radians(1.0))
        @Expect(Angle.degrees(360.0) <= Angle.degrees(360.0))
        @Expect(Angle.degrees(720.0) <= Angle.degrees(720.0))
    }

    @TestCase
    func operator_greaterThanOrEqual() {
        @Expect(Angle.radians(0.1) >= Angle.degrees(0.0))
        @Expect(Angle.degrees(0.1) >= Angle.radians(0.0))
        @Expect(Angle.radians(0.0) >= Angle.radians(-0.1))
        @Expect(Angle.degrees(0.0) >= Angle.degrees(-0.1))

        @Expect(Angle() >= Angle())
        @Expect(Angle() >= Angle.ZERO)
        @Expect(Angle() >= Angle.degrees(0.0))
        @Expect(Angle() >= Angle.radians(0.0))
        @Expect(Angle.degrees(0.0) >= Angle.radians(0.0))
        @Expect(Angle.degrees(15.0) >= Angle.degrees(15.0))
        @Expect(Angle.radians(1.0) >= Angle.radians(1.0))
        @Expect(Angle.degrees(360.0) >= Angle.degrees(360.0))
        @Expect(Angle.degrees(720.0) >= Angle.degrees(720.0))
    }

    @TestCase
    func operator_unaryNegation() {
        @Expect(-Angle() == Angle())
        @Expect(-Angle.radians(-1.0) == Angle.radians(1.0))
        @Expect(-Angle.degrees(15.0) == Angle.degrees(-15.0))
        @Expect(-Angle.radians(1.0) == Angle.radians(-1.0))
    }

    @TestCase
    func operator_addition() {
        @Expect(Angle() + Angle() == Angle())
        @Expect(Angle.ZERO + Angle.radians(0.5) == Angle.radians(0.5))
        @Expect(Angle.radians(6.0) + Angle.radians(0.5) == Angle.radians(6.5))
        @Expect(Angle.radians(10.0) + Angle.radians(0.5) == Angle.radians(10.5))
        @Expect(Angle.degrees(360.0) + Angle.degrees(360.0) == Angle.degrees(720.0))
    }

    @TestCase
    func operator_additionAssignment() {
        var angle = Angle.degrees(-15.0)
        angle += Angle.degrees(15.0)
        @Expect(angle == Angle.degrees(0.0))

        angle += Angle.radians(10.0)
        @Expect(angle == Angle.radians(10.0))
    }

    @TestCase
    func operator_subtraction() {
        @Expect(Angle() - Angle() == Angle())
        @Expect(Angle.radians(1.0) - Angle.radians(0.5) == Angle.radians(0.5))
        @Expect(Angle.ZERO - Angle.radians(0.5) == Angle.radians(-0.5))
        @Expect(Angle.degrees(900.0) - Angle.degrees(1.0) == Angle.degrees(899.0))
    }

    @TestCase
    func operator_subtractionAssignment() {
        var angle = Angle.degrees(15.0)
        angle -= Angle.degrees(15.0)
        @Expect(angle == Angle.degrees(0.0))

        angle -= Angle.radians(10.0)
        @Expect(angle == Angle.radians(-10.0))
    }

    @TestCase
    func operator_multiplication() {
        @Expect(Angle.radians(0.0) * 10.0 == Angle.ZERO)

        // Use approx for float math results
        let res1 = Angle.degrees(10.0) * 2.5
        @Expect(res1.asDegrees(), 25.0, delta: 0.001)

        let res2 = Angle.degrees(100.0) * 10.0
        @Expect(res2.asDegrees(), 1000.0, delta: 0.001)
    }

    @TestCase
    func operator_multiplicationAssignment() {
        var angle = Angle.degrees(1.0)
        angle *= 10.0
        @Expect(angle == Angle.degrees(10.0))
    }

    @TestCase
    func operator_division() {
        @Expect(Angle.ZERO / 10.0 == Angle.ZERO)
        @Expect(Angle.radians(12.0) / 3.0 == Angle.radians(4.0))
        @Expect(Angle.degrees(10.0) / 2.5 == Angle.degrees(4.0))

        // Angle / Angle
        @Expect(Angle.ZERO / Angle.degrees(1.0), 0.0)
        @Expect(Angle.degrees(10.0) / Angle.degrees(10.0), 1.0)
        @Expect(Angle.radians(10.0) / Angle.radians(2.0), 5.0)
    }

    @TestCase
    func operator_divisionAssignment() {
        var angle = Angle.degrees(60.0)
        angle /= 5.0
        @Expect(angle == Angle.degrees(12.0))
    }

    @TestCase
    func operator_modulo() {
        @Expect(Angle.ZERO % Angle.radians(0.5) == Angle.ZERO)
        @Expect(Angle.radians(10.0) % Angle.radians(1.0) == Angle.radians(0.0))
        @Expect(Angle.degrees(90.0) % Angle.degrees(30.0) == Angle.degrees(0.0))

        // Use approx for modulo results
        let res1 = Angle.degrees(90.0) % Angle.degrees(40.0)
        @Expect(res1.asDegrees(), 10.0, delta: 0.001)

        @Expect(Angle.degrees(-90.0) % Angle.degrees(30.0) == Angle.degrees(0.0))

        let res2 = Angle.degrees(-90.0) % Angle.degrees(40.0)
        @Expect(res2.asDegrees(), 30.0, delta: 0.001)
    }

    @TestCase
    func operator_moduloAssignment() {
        var angle = Angle.degrees(59.0)
        angle %= Angle.degrees(10.0)
        @Expect(angle.value, Angle.degrees(9.0).value, delta: 0.001)
    }
}

// cjlint-ignore -end function names should be lower camel case
