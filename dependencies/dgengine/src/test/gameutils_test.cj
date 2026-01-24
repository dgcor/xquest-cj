package dgengine.test

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import dgengine.*
import std.unittest.*

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestGameUtils {
    @TestCase
    func test_fpsToTime() {
        @Expect(GameUtils.fpsToTime(-1) == Time(milliseconds: 1000))
        @Expect(GameUtils.fpsToTime(0) == Time(milliseconds: 1000))
        @Expect(GameUtils.fpsToTime(1) == Time(milliseconds: 1000))
        @Expect(GameUtils.fpsToTime(1000) == Time(milliseconds: 1))
        @Expect(GameUtils.fpsToTime(5000) == Time(milliseconds: 1))
    }

    @TestCase
    func test_getAnimationType() {
        @Expect(AnimationType.get("looped", default: AnimationType.PlayOnce), AnimationType.Looped)
        @Expect(AnimationType.get("playOnce", default: AnimationType.Looped), AnimationType.PlayOnce)
        @Expect(AnimationType.get("backAndForth", default: AnimationType.Looped), AnimationType.BackAndForth)
        @Expect(AnimationType.get("LOOPED", default: AnimationType.PlayOnce), AnimationType.Looped)
        @Expect(AnimationType.get("looped ", default: AnimationType.PlayOnce), AnimationType.PlayOnce)
        @Expect(AnimationType.get("invalid ", default: AnimationType.PlayOnce), AnimationType.PlayOnce)
        @Expect(AnimationType.get("", default: AnimationType.PlayOnce), AnimationType.PlayOnce)
    }

    @TestCase
    func test_getAlignmentPosition() {
        var size = Vector2f(10.0, 10.0)

        @Expect(GameUtils.getAlignmentPosition(Vector2f(20.0, 20.0), size, AlignLeft, AlignTop) == Vector2f(20.0, 10.0))
        @Expect(GameUtils.getAlignmentPosition(Vector2f(20.0, 20.0), size, AlignCenter, AlignCenter) == Vector2f(15.0, 15.0))
        @Expect(GameUtils.getAlignmentPosition(Vector2f(20.0, 20.0), size, AlignRight, AlignBottom) == Vector2f(10.0, 20.0))

        size = Vector2f(10.0, 10.0)

        @Expect(GameUtils.getAlignmentPosition(Vector2f(3.0, 0.0), size, AlignRight, AlignCenter) == Vector2f(-7.0, -5.0))
        @Expect(GameUtils.getAlignmentPosition(Vector2f(3.0, 0.0), size, AlignLeft, AlignTop) == Vector2f(3.0, -10.0))
        @Expect(GameUtils.getAlignmentPosition(Vector2f(3.0, 0.0), size, AlignCenter, AlignBottom) == Vector2f(-2.0, 0.0))
    }

    @TestCase
    func test_getAnchorPosition() {
        var position = Vector2f(20.0, 20.0)
        var size = Vector2f(10.0, 10.0)
        var anchorToSize = Vector2f(55.0, 55.0)

        // valid
        @Expect((Anchor.Bottom | Anchor.Left).getPosition(	size, position, anchorToSize) == Vector2f(10.0, 75.0))
        @Expect((Anchor.Bottom).getPosition(				size, position, anchorToSize) == Vector2f(42.0, 75.0))
        @Expect((Anchor.Bottom | Anchor.Right).getPosition(	size, position, anchorToSize) == Vector2f(75.0, 75.0))
        @Expect((Anchor.Left).getPosition(					size, position, anchorToSize) == Vector2f(10.0, 42.0))
        @Expect((Anchor.None).getPosition(					size, position, anchorToSize) == Vector2f(42.0, 42.0))
        @Expect((Anchor.Right).getPosition(					size, position, anchorToSize) == Vector2f(75.0, 42.0))
        @Expect((Anchor.Top | Anchor.Left).getPosition(		size, position, anchorToSize) == Vector2f(10.0, 10.0))
        @Expect((Anchor.Top).getPosition(					size, position, anchorToSize) == Vector2f(42.0, 10.0))
        @Expect((Anchor.Top | Anchor.Right).getPosition(	size, position, anchorToSize) == Vector2f(75.0, 10.0))

        // invalid
        @Expect((Anchor.All).getPosition(					size, position, anchorToSize) == position)
        @Expect((Anchor.Left | Anchor.Right).getPosition(	size, position, anchorToSize) == position)
        @Expect((Anchor.Top | Anchor.Bottom).getPosition(	size, position, anchorToSize) == position)
    }

    @TestCase
    func test_getPosSize() {
        var oldWSize = Vector2u(320, 240)
        var newWSize = Vector2u(640, 480)

        // none
        var anchor = Anchor.None
        var pos = Box(Vector2f(20.0, 20.0))
        var size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(180.0, 140.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // top
        anchor = Anchor.Top
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(180.0, 20.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // bottom
        anchor = Anchor.Bottom
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(180.0, 260.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // left
        anchor = Anchor.Left
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(20.0, 140.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // right
        anchor = Anchor.Right
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(340.0, 140.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // topLeft
        anchor = Anchor.Top | Anchor.Left
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(20.0, 20.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // topRight
        anchor = Anchor.Top | Anchor.Right
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(340.0, 20.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // topLeftRight
        anchor = Anchor.Top | Anchor.Left | Anchor.Right
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(20.0, 20.0))
        @Expect(size.value == Vector2f(330.0, 10.0))

        // bottomLeft
        anchor = Anchor.Bottom | Anchor.Left
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(20.0, 260.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // bottomRight
        anchor = Anchor.Bottom | Anchor.Right
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(340.0, 260.0))
        @Expect(size.value == Vector2f(10.0, 10.0))

        // bottomLeftRight
        anchor = Anchor.Bottom | Anchor.Left | Anchor.Right
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(20.0, 260.0))
        @Expect(size.value == Vector2f(330.0, 10.0))

        // all
        anchor = Anchor.All
        pos = Box(Vector2f(20.0, 20.0))
        size = Box(Vector2f(10.0, 10.0))

        anchor.getPosSize(pos, size, oldWSize, newWSize)
        @Expect(pos.value == Vector2f(20.0, 20.0))
        @Expect(size.value == Vector2f(330.0, 250.0))
    }

    @TestCase
    func test_getAnchor() {
        @Expect(Anchor.get("none", default: Anchor.All), Anchor.None)
        @Expect(Anchor.get("top", default: Anchor.All), Anchor.Top)
        @Expect(Anchor.get("topleft", default: Anchor.All), (Anchor.Top | Anchor.Left))
        @Expect(Anchor.get("topright", default: Anchor.All), (Anchor.Top | Anchor.Right))
        @Expect(Anchor.get("bottom", default: Anchor.All), Anchor.Bottom)
        @Expect(Anchor.get("bottomleft", default: Anchor.All), (Anchor.Bottom | Anchor.Left))
        @Expect(Anchor.get("bottomright", default: Anchor.All), (Anchor.Bottom | Anchor.Right))
        @Expect(Anchor.get("left", default: Anchor.All), Anchor.Left)
        @Expect(Anchor.get("right", default: Anchor.All), Anchor.Right)
        @Expect(Anchor.get("all", default: Anchor.None), Anchor.All)
        @Expect(Anchor.get("NONE", default: Anchor.All), Anchor.None)
        @Expect(Anchor.get("none ", default: Anchor.All), Anchor.All)
        @Expect(Anchor.get("invalid ", default: Anchor.All), Anchor.All)
        @Expect(Anchor.get("", default: Anchor.All), Anchor.All)
    }

    @TestCase
    func test_getBindingFlags() {
        @Expect(BindingFlags.get("onchange", default: BindingFlags.WhenHidden), BindingFlags.OnChange)
        @Expect(BindingFlags.get("once", default: BindingFlags.OnChange), BindingFlags.Once)
        @Expect(BindingFlags.get("always", default: BindingFlags.OnChange), BindingFlags.Always)
        @Expect(BindingFlags.get("whenhidden", default: BindingFlags.OnChange), BindingFlags.WhenHidden)
        @Expect(BindingFlags.get("ONCHANGE", default: BindingFlags.WhenHidden), BindingFlags.OnChange)
        @Expect(BindingFlags.get("onchange ", default: BindingFlags.WhenHidden), BindingFlags.WhenHidden)
        @Expect(BindingFlags.get("invalid ", default: BindingFlags.WhenHidden), BindingFlags.WhenHidden)
        @Expect(BindingFlags.get("", default: BindingFlags.WhenHidden), BindingFlags.WhenHidden)
    }

    @TestCase
    func test_getBlendMode() {
        @Expect(BlendModeType.get("alpha", default: BlendNone), BlendAlpha)
        @Expect(BlendModeType.get("add", default: BlendAlpha), BlendAdd)
        @Expect(BlendModeType.get("multiply", default: BlendAlpha), BlendMultiply)
        @Expect(BlendModeType.get("min", default: BlendAlpha), BlendMin)
        @Expect(BlendModeType.get("max", default: BlendAlpha), BlendMax)
        @Expect(BlendModeType.get("none", default: BlendAlpha), BlendNone)
        @Expect(BlendModeType.get("ALPHA", default: BlendNone), BlendAlpha)
        @Expect(BlendModeType.get("alpha ", default: BlendNone), BlendNone)
        @Expect(BlendModeType.get("invalid ", default: BlendNone), BlendNone)
        @Expect(BlendModeType.get("", default: BlendNone), BlendNone)
    }

    @TestCase
    func test_getColorFormat() {
        @Expect(ColorFormat.get("rgb"), ColorFormat.RGB)
        @Expect(ColorFormat.get("bgr"), ColorFormat.BGR)
        @Expect(ColorFormat.get("rgba"), ColorFormat.RGBA)
        @Expect(ColorFormat.get("bgra"), ColorFormat.BGRA)
        @Expect(ColorFormat.get("argb"), ColorFormat.ARGB)
        @Expect(ColorFormat.get("abgr"), ColorFormat.ABGR)
        @Expect(ColorFormat.get("BGR"), ColorFormat.BGR)
        @Expect(ColorFormat.get("bgr "), ColorFormat.RGB)
        @Expect(ColorFormat.get("invalid "), ColorFormat.RGB)
        @Expect(ColorFormat.get(""), ColorFormat.RGB)
    }

    @TestCase
    func test_getDirection() {
        @Expect(Direction.get("up", default: Direction.Right), Direction.Up)
        @Expect(Direction.get("down", default: Direction.Up), Direction.Down)
        @Expect(Direction.get("left", default: Direction.Up), Direction.Left)
        @Expect(Direction.get("right", default: Direction.Up), Direction.Right)
        @Expect(Direction.get("UP", default: Direction.Right), Direction.Up)
        @Expect(Direction.get("up ", default: Direction.Right), Direction.Right)
        @Expect(Direction.get("invalid ", default: Direction.Right), Direction.Right)
        @Expect(Direction.get("", default: Direction.Right), Direction.Right)
    }

    @TestCase
    func test_getHorizontalAlign() {
        @Expect(HorizontalAlign.get("left", default: HorizontalAlign.AlignRight), HorizontalAlign.AlignLeft)
        @Expect(HorizontalAlign.get("center", default: HorizontalAlign.AlignLeft), HorizontalAlign.AlignCenter)
        @Expect(HorizontalAlign.get("right", default: HorizontalAlign.AlignLeft), HorizontalAlign.AlignRight)
        @Expect(HorizontalAlign.get("LEFT", default: HorizontalAlign.AlignRight), HorizontalAlign.AlignLeft)
        @Expect(HorizontalAlign.get("left ", default: HorizontalAlign.AlignRight), HorizontalAlign.AlignRight)
        @Expect(HorizontalAlign.get("invalid ", default: HorizontalAlign.AlignRight), HorizontalAlign.AlignRight)
        @Expect(HorizontalAlign.get("", default: HorizontalAlign.AlignRight), HorizontalAlign.AlignRight)
    }

    @TestCase
    func test_getVerticalAlign() {
        @Expect(VerticalAlign.get("top", default: VerticalAlign.AlignBottom), VerticalAlign.AlignTop)
        @Expect(VerticalAlign.get("center", default: VerticalAlign.AlignTop), VerticalAlign.AlignCenter)
        @Expect(VerticalAlign.get("bottom", default: VerticalAlign.AlignTop), VerticalAlign.AlignBottom)
        @Expect(VerticalAlign.get("TOP", default: VerticalAlign.AlignBottom), VerticalAlign.AlignTop)
        @Expect(VerticalAlign.get("top ", default: VerticalAlign.AlignBottom), VerticalAlign.AlignBottom)
        @Expect(VerticalAlign.get("invalid ", default: VerticalAlign.AlignBottom), VerticalAlign.AlignBottom)
        @Expect(VerticalAlign.get("", default: VerticalAlign.AlignBottom), VerticalAlign.AlignBottom)
    }

    @TestCase
    func test_getIgnoreResource() {
        @Expect(IgnoreResource.get("none", default: IgnoreResource.All), IgnoreResource.None)
        @Expect(IgnoreResource.get("alldraws", default: IgnoreResource.None), (IgnoreResource.Draw | IgnoreResource.All))
        @Expect(IgnoreResource.get("alldrawsandupdates", default: IgnoreResource.None), (IgnoreResource.Draw | IgnoreResource.Update | IgnoreResource.All))
        @Expect(IgnoreResource.get("allupdates", default: IgnoreResource.None), (IgnoreResource.Update | IgnoreResource.All))
        @Expect(IgnoreResource.get("draw", default: IgnoreResource.None), IgnoreResource.Draw)
        @Expect(IgnoreResource.get("drawandupdate", default: IgnoreResource.None), (IgnoreResource.Draw | IgnoreResource.Update))
        @Expect(IgnoreResource.get("update", default: IgnoreResource.None), IgnoreResource.Update)
        @Expect(IgnoreResource.get("NONE", default: IgnoreResource.All), IgnoreResource.None)
        @Expect(IgnoreResource.get("none ", default: IgnoreResource.All), IgnoreResource.All)
        @Expect(IgnoreResource.get("invalid ", default: IgnoreResource.All), IgnoreResource.All)
        @Expect(IgnoreResource.get("", default: IgnoreResource.All), IgnoreResource.All)
    }

    @TestCase
    func test_getInputEventType() {
        @Expect(InputEventType.get("none", default: InputEventType.All), InputEventType.None)
        @Expect(InputEventType.get("leftclick", default: InputEventType.None), InputEventType.LeftClick)
        @Expect(InputEventType.get("middleclick", default: InputEventType.None), InputEventType.MiddleClick)
        @Expect(InputEventType.get("rightclick", default: InputEventType.None), InputEventType.RightClick)
        @Expect(InputEventType.get("mousepress", default: InputEventType.None), InputEventType.MousePress)
        @Expect(InputEventType.get("mousemove", default: InputEventType.None), InputEventType.MouseMove)
        @Expect(InputEventType.get("mouserelease", default: InputEventType.None), InputEventType.MouseRelease)
        @Expect(InputEventType.get("mousescroll", default: InputEventType.None), InputEventType.MouseScroll)
        @Expect(InputEventType.get("keypress", default: InputEventType.None), InputEventType.KeyPress)
        @Expect(InputEventType.get("textenter", default: InputEventType.None), InputEventType.TextEnter)
        @Expect(InputEventType.get("touchbegin", default: InputEventType.None), InputEventType.TouchBegin)
        @Expect(InputEventType.get("touchmove", default: InputEventType.None), InputEventType.TouchMove)
        @Expect(InputEventType.get("touchend", default: InputEventType.None), InputEventType.TouchEnd)

        @Expect(InputEventType.get("allleftclick", default: InputEventType.None), (InputEventType.All ^ (InputEventType.MiddleClick | InputEventType.RightClick)))
        @Expect(InputEventType.get("allmiddleclick", default: InputEventType.None), (InputEventType.All ^ (InputEventType.LeftClick | InputEventType.RightClick)))
        @Expect(InputEventType.get("allrightclick", default: InputEventType.None), (InputEventType.All ^ (InputEventType.LeftClick | InputEventType.MiddleClick)))
        @Expect(InputEventType.get("all", default: InputEventType.None), InputEventType.All)

        @Expect(InputEventType.get("NONE", default: InputEventType.All), InputEventType.None)
        @Expect(InputEventType.get("none ", default: InputEventType.All), InputEventType.All)
        @Expect(InputEventType.get("invalid ", default: InputEventType.All), InputEventType.All)
        @Expect(InputEventType.get("", default: InputEventType.All), InputEventType.All)
    }

    @TestCase
    func test_getPrimitiveType() {
        @Expect(GameUtils.getPrimitiveType("points", default: PrimitiveType.Lines) == PrimitiveType.Points)
        @Expect(GameUtils.getPrimitiveType("lines", default: PrimitiveType.Points) == PrimitiveType.Lines)
        @Expect(GameUtils.getPrimitiveType("linestrip", default: PrimitiveType.Points) == PrimitiveType.LineStrip)
        @Expect(GameUtils.getPrimitiveType("triangles", default: PrimitiveType.Points) == PrimitiveType.Triangles)
        @Expect(GameUtils.getPrimitiveType("trianglestrip", default: PrimitiveType.Points) == PrimitiveType.TriangleStrip)
        @Expect(GameUtils.getPrimitiveType("trianglefan", default: PrimitiveType.Points) == PrimitiveType.TriangleFan)
        @Expect(GameUtils.getPrimitiveType("POINTS", default: PrimitiveType.Lines) == PrimitiveType.Points)
        @Expect(GameUtils.getPrimitiveType("points ", default: PrimitiveType.Lines) == PrimitiveType.Lines)
        @Expect(GameUtils.getPrimitiveType("invalid ", default: PrimitiveType.Lines) == PrimitiveType.Lines)
        @Expect(GameUtils.getPrimitiveType("", default: PrimitiveType.Lines) == PrimitiveType.Lines)
    }

    @TestCase
    func test_getKeyCode() {
        // int
        @Expect(GameUtils.getKeyCode(0) == KeyCode.Num0)
        @Expect(GameUtils.getKeyCode(1) == KeyCode.Num1)
        @Expect(GameUtils.getKeyCode(2) == KeyCode.Num2)
        @Expect(GameUtils.getKeyCode(3) == KeyCode.Num3)
        @Expect(GameUtils.getKeyCode(4) == KeyCode.Num4)
        @Expect(GameUtils.getKeyCode(5) == KeyCode.Num5)
        @Expect(GameUtils.getKeyCode(6) == KeyCode.Num6)
        @Expect(GameUtils.getKeyCode(7) == KeyCode.Num7)
        @Expect(GameUtils.getKeyCode(8) == KeyCode.Num8)
        @Expect(GameUtils.getKeyCode(9) == KeyCode.Num9)
        @Expect(GameUtils.getKeyCode(10, default: KeyCode.A) == KeyCode.A)

        // string
        @Expect(GameUtils.getKeyCode("A") == KeyCode.A)
        @Expect(GameUtils.getKeyCode("B") == KeyCode.B)
        @Expect(GameUtils.getKeyCode("C") == KeyCode.C)
        @Expect(GameUtils.getKeyCode("D") == KeyCode.D)
        @Expect(GameUtils.getKeyCode("E") == KeyCode.E)
        @Expect(GameUtils.getKeyCode("F") == KeyCode.F)
        @Expect(GameUtils.getKeyCode("G") == KeyCode.G)
        @Expect(GameUtils.getKeyCode("H") == KeyCode.H)
        @Expect(GameUtils.getKeyCode("I") == KeyCode.I)
        @Expect(GameUtils.getKeyCode("J") == KeyCode.J)
        @Expect(GameUtils.getKeyCode("K") == KeyCode.K)
        @Expect(GameUtils.getKeyCode("L") == KeyCode.L)
        @Expect(GameUtils.getKeyCode("M") == KeyCode.M)
        @Expect(GameUtils.getKeyCode("N") == KeyCode.N)
        @Expect(GameUtils.getKeyCode("O") == KeyCode.O)
        @Expect(GameUtils.getKeyCode("P") == KeyCode.P)
        @Expect(GameUtils.getKeyCode("Q") == KeyCode.Q)
        @Expect(GameUtils.getKeyCode("R") == KeyCode.R)
        @Expect(GameUtils.getKeyCode("S") == KeyCode.S)
        @Expect(GameUtils.getKeyCode("T") == KeyCode.T)
        @Expect(GameUtils.getKeyCode("U") == KeyCode.U)
        @Expect(GameUtils.getKeyCode("V") == KeyCode.V)
        @Expect(GameUtils.getKeyCode("W") == KeyCode.W)
        @Expect(GameUtils.getKeyCode("X") == KeyCode.X)
        @Expect(GameUtils.getKeyCode("Y") == KeyCode.Y)
        @Expect(GameUtils.getKeyCode("Z") == KeyCode.Z)

        @Expect(GameUtils.getKeyCode("a") == KeyCode.A)
        @Expect(GameUtils.getKeyCode("b") == KeyCode.B)
        @Expect(GameUtils.getKeyCode("c") == KeyCode.C)
        @Expect(GameUtils.getKeyCode("d") == KeyCode.D)
        @Expect(GameUtils.getKeyCode("e") == KeyCode.E)
        @Expect(GameUtils.getKeyCode("f") == KeyCode.F)
        @Expect(GameUtils.getKeyCode("g") == KeyCode.G)
        @Expect(GameUtils.getKeyCode("h") == KeyCode.H)
        @Expect(GameUtils.getKeyCode("i") == KeyCode.I)
        @Expect(GameUtils.getKeyCode("j") == KeyCode.J)
        @Expect(GameUtils.getKeyCode("k") == KeyCode.K)
        @Expect(GameUtils.getKeyCode("l") == KeyCode.L)
        @Expect(GameUtils.getKeyCode("m") == KeyCode.M)
        @Expect(GameUtils.getKeyCode("n") == KeyCode.N)
        @Expect(GameUtils.getKeyCode("o") == KeyCode.O)
        @Expect(GameUtils.getKeyCode("p") == KeyCode.P)
        @Expect(GameUtils.getKeyCode("q") == KeyCode.Q)
        @Expect(GameUtils.getKeyCode("r") == KeyCode.R)
        @Expect(GameUtils.getKeyCode("s") == KeyCode.S)
        @Expect(GameUtils.getKeyCode("t") == KeyCode.T)
        @Expect(GameUtils.getKeyCode("u") == KeyCode.U)
        @Expect(GameUtils.getKeyCode("v") == KeyCode.V)
        @Expect(GameUtils.getKeyCode("w") == KeyCode.W)
        @Expect(GameUtils.getKeyCode("x") == KeyCode.X)
        @Expect(GameUtils.getKeyCode("y") == KeyCode.Y)
        @Expect(GameUtils.getKeyCode("z") == KeyCode.Z)

        @Expect(GameUtils.getKeyCode("0") == KeyCode.Num0)
        @Expect(GameUtils.getKeyCode("1") == KeyCode.Num1)
        @Expect(GameUtils.getKeyCode("2") == KeyCode.Num2)
        @Expect(GameUtils.getKeyCode("3") == KeyCode.Num3)
        @Expect(GameUtils.getKeyCode("4") == KeyCode.Num4)
        @Expect(GameUtils.getKeyCode("5") == KeyCode.Num5)
        @Expect(GameUtils.getKeyCode("6") == KeyCode.Num6)
        @Expect(GameUtils.getKeyCode("7") == KeyCode.Num7)
        @Expect(GameUtils.getKeyCode("8") == KeyCode.Num8)
        @Expect(GameUtils.getKeyCode("9") == KeyCode.Num9)

        @Expect(GameUtils.getKeyCode("[") == KeyCode.LBracket)
        @Expect(GameUtils.getKeyCode("]") == KeyCode.RBracket)
        @Expect(GameUtils.getKeyCode(";") == KeyCode.Semicolon)
        @Expect(GameUtils.getKeyCode(",") == KeyCode.Comma)
        @Expect(GameUtils.getKeyCode(".") == KeyCode.Period)
        @Expect(GameUtils.getKeyCode("\'") == KeyCode.Apostrophe)
        @Expect(GameUtils.getKeyCode("\\") == KeyCode.Backslash)
        @Expect(GameUtils.getKeyCode("~") == KeyCode.Grave)
        @Expect(GameUtils.getKeyCode("=") == KeyCode.Equal)
        @Expect(GameUtils.getKeyCode(" ") == KeyCode.Space)
        @Expect(GameUtils.getKeyCode("+") == KeyCode.Add)
        @Expect(GameUtils.getKeyCode("-") == KeyCode.Subtract)
        @Expect(GameUtils.getKeyCode("*") == KeyCode.Multiply)
        @Expect(GameUtils.getKeyCode("/") == KeyCode.Divide)

        @Expect(GameUtils.getKeyCode("all") == KeyCode.Count)
        @Expect(GameUtils.getKeyCode("any") == KeyCode.Count)
        @Expect(GameUtils.getKeyCode("esc") == KeyCode.Escape)
        @Expect(GameUtils.getKeyCode("escape") == KeyCode.Escape)
        @Expect(GameUtils.getKeyCode("lcontrol") == KeyCode.LControl)
        @Expect(GameUtils.getKeyCode("lshift") == KeyCode.LShift)
        @Expect(GameUtils.getKeyCode("lalt") == KeyCode.LAlt)
        @Expect(GameUtils.getKeyCode("lsystem") == KeyCode.LSystem)
        @Expect(GameUtils.getKeyCode("rcontrol") == KeyCode.RControl)
        @Expect(GameUtils.getKeyCode("rshift") == KeyCode.RShift)
        @Expect(GameUtils.getKeyCode("ralt") == KeyCode.RAlt)
        @Expect(GameUtils.getKeyCode("rsystem") == KeyCode.RSystem)
        @Expect(GameUtils.getKeyCode("menu") == KeyCode.Menu)
        @Expect(GameUtils.getKeyCode("leftbracket") == KeyCode.LBracket)
        @Expect(GameUtils.getKeyCode("rightbracket") == KeyCode.RBracket)
        @Expect(GameUtils.getKeyCode("semicolon") == KeyCode.Semicolon)
        @Expect(GameUtils.getKeyCode("comma") == KeyCode.Comma)
        @Expect(GameUtils.getKeyCode("period") == KeyCode.Period)
        @Expect(GameUtils.getKeyCode("apostrophe") == KeyCode.Apostrophe)
        @Expect(GameUtils.getKeyCode("quote") == KeyCode.Apostrophe)
        @Expect(GameUtils.getKeyCode("slash") == KeyCode.Slash)
        @Expect(GameUtils.getKeyCode("backslash") == KeyCode.Backslash)
        @Expect(GameUtils.getKeyCode("grave") == KeyCode.Grave)
        @Expect(GameUtils.getKeyCode("tilde") == KeyCode.Grave)
        @Expect(GameUtils.getKeyCode("equal") == KeyCode.Equal)
        @Expect(GameUtils.getKeyCode("dash") == KeyCode.Hyphen)
        @Expect(GameUtils.getKeyCode("hyphen") == KeyCode.Hyphen)
        @Expect(GameUtils.getKeyCode("space") == KeyCode.Space)
        @Expect(GameUtils.getKeyCode("enter") == KeyCode.Enter)
        @Expect(GameUtils.getKeyCode("return") == KeyCode.Enter)
        @Expect(GameUtils.getKeyCode("backspace") == KeyCode.Backspace)
        @Expect(GameUtils.getKeyCode("tab") == KeyCode.Tab)
        @Expect(GameUtils.getKeyCode("pageup") == KeyCode.PageUp)
        @Expect(GameUtils.getKeyCode("pagedown") == KeyCode.PageDown)
        @Expect(GameUtils.getKeyCode("end") == KeyCode.End)
        @Expect(GameUtils.getKeyCode("home") == KeyCode.Home)
        @Expect(GameUtils.getKeyCode("insert") == KeyCode.Insert)
        @Expect(GameUtils.getKeyCode("delete") == KeyCode.Delete)
        @Expect(GameUtils.getKeyCode("add") == KeyCode.Add)
        @Expect(GameUtils.getKeyCode("subtract") == KeyCode.Subtract)
        @Expect(GameUtils.getKeyCode("multiply") == KeyCode.Multiply)
        @Expect(GameUtils.getKeyCode("divide") == KeyCode.Divide)
        @Expect(GameUtils.getKeyCode("left") == KeyCode.Left)
        @Expect(GameUtils.getKeyCode("right") == KeyCode.Right)
        @Expect(GameUtils.getKeyCode("up") == KeyCode.Up)
        @Expect(GameUtils.getKeyCode("down") == KeyCode.Down)
        @Expect(GameUtils.getKeyCode("numpad0") == KeyCode.Numpad0)
        @Expect(GameUtils.getKeyCode("numpad1") == KeyCode.Numpad1)
        @Expect(GameUtils.getKeyCode("numpad2") == KeyCode.Numpad2)
        @Expect(GameUtils.getKeyCode("numpad3") == KeyCode.Numpad3)
        @Expect(GameUtils.getKeyCode("numpad4") == KeyCode.Numpad4)
        @Expect(GameUtils.getKeyCode("numpad5") == KeyCode.Numpad5)
        @Expect(GameUtils.getKeyCode("numpad6") == KeyCode.Numpad6)
        @Expect(GameUtils.getKeyCode("numpad7") == KeyCode.Numpad7)
        @Expect(GameUtils.getKeyCode("numpad8") == KeyCode.Numpad8)
        @Expect(GameUtils.getKeyCode("numpad9") == KeyCode.Numpad9)
        @Expect(GameUtils.getKeyCode("f1") == KeyCode.F1)
        @Expect(GameUtils.getKeyCode("f2") == KeyCode.F2)
        @Expect(GameUtils.getKeyCode("f3") == KeyCode.F3)
        @Expect(GameUtils.getKeyCode("f4") == KeyCode.F4)
        @Expect(GameUtils.getKeyCode("f5") == KeyCode.F5)
        @Expect(GameUtils.getKeyCode("f6") == KeyCode.F6)
        @Expect(GameUtils.getKeyCode("f7") == KeyCode.F7)
        @Expect(GameUtils.getKeyCode("f8") == KeyCode.F8)
        @Expect(GameUtils.getKeyCode("f9") == KeyCode.F9)
        @Expect(GameUtils.getKeyCode("f10") == KeyCode.F10)
        @Expect(GameUtils.getKeyCode("f11") == KeyCode.F11)
        @Expect(GameUtils.getKeyCode("f12") == KeyCode.F12)
        @Expect(GameUtils.getKeyCode("f13") == KeyCode.F13)
        @Expect(GameUtils.getKeyCode("f14") == KeyCode.F14)
        @Expect(GameUtils.getKeyCode("f15") == KeyCode.F15)
        @Expect(GameUtils.getKeyCode("pause") == KeyCode.Pause)

        // invalid
        @Expect(GameUtils.getKeyCode("invalid") == KeyCode.Unknown)
        @Expect(GameUtils.getKeyCode("invalid", default: KeyCode.A) == KeyCode.A)
    }

    @TestCase
    func test_getScanCode() {
        // int
        @Expect(GameUtils.getScanCode(0) == Scancode.Num0)
        @Expect(GameUtils.getScanCode(1) == Scancode.Num1)
        @Expect(GameUtils.getScanCode(2) == Scancode.Num2)
        @Expect(GameUtils.getScanCode(3) == Scancode.Num3)
        @Expect(GameUtils.getScanCode(4) == Scancode.Num4)
        @Expect(GameUtils.getScanCode(5) == Scancode.Num5)
        @Expect(GameUtils.getScanCode(6) == Scancode.Num6)
        @Expect(GameUtils.getScanCode(7) == Scancode.Num7)
        @Expect(GameUtils.getScanCode(8) == Scancode.Num8)
        @Expect(GameUtils.getScanCode(9) == Scancode.Num9)
        @Expect(GameUtils.getScanCode(10, default: Scancode.A) == Scancode.A)

        // string
        @Expect(GameUtils.getScanCode("A") == Scancode.A)
        @Expect(GameUtils.getScanCode("B") == Scancode.B)
        @Expect(GameUtils.getScanCode("C") == Scancode.C)
        @Expect(GameUtils.getScanCode("D") == Scancode.D)
        @Expect(GameUtils.getScanCode("E") == Scancode.E)
        @Expect(GameUtils.getScanCode("F") == Scancode.F)
        @Expect(GameUtils.getScanCode("G") == Scancode.G)
        @Expect(GameUtils.getScanCode("H") == Scancode.H)
        @Expect(GameUtils.getScanCode("I") == Scancode.I)
        @Expect(GameUtils.getScanCode("J") == Scancode.J)
        @Expect(GameUtils.getScanCode("K") == Scancode.K)
        @Expect(GameUtils.getScanCode("L") == Scancode.L)
        @Expect(GameUtils.getScanCode("M") == Scancode.M)
        @Expect(GameUtils.getScanCode("N") == Scancode.N)
        @Expect(GameUtils.getScanCode("O") == Scancode.O)
        @Expect(GameUtils.getScanCode("P") == Scancode.P)
        @Expect(GameUtils.getScanCode("Q") == Scancode.Q)
        @Expect(GameUtils.getScanCode("R") == Scancode.R)
        @Expect(GameUtils.getScanCode("S") == Scancode.S)
        @Expect(GameUtils.getScanCode("T") == Scancode.T)
        @Expect(GameUtils.getScanCode("U") == Scancode.U)
        @Expect(GameUtils.getScanCode("V") == Scancode.V)
        @Expect(GameUtils.getScanCode("W") == Scancode.W)
        @Expect(GameUtils.getScanCode("X") == Scancode.X)
        @Expect(GameUtils.getScanCode("Y") == Scancode.Y)
        @Expect(GameUtils.getScanCode("Z") == Scancode.Z)

        @Expect(GameUtils.getScanCode("a") == Scancode.A)
        @Expect(GameUtils.getScanCode("b") == Scancode.B)
        @Expect(GameUtils.getScanCode("c") == Scancode.C)
        @Expect(GameUtils.getScanCode("d") == Scancode.D)
        @Expect(GameUtils.getScanCode("e") == Scancode.E)
        @Expect(GameUtils.getScanCode("f") == Scancode.F)
        @Expect(GameUtils.getScanCode("g") == Scancode.G)
        @Expect(GameUtils.getScanCode("h") == Scancode.H)
        @Expect(GameUtils.getScanCode("i") == Scancode.I)
        @Expect(GameUtils.getScanCode("j") == Scancode.J)
        @Expect(GameUtils.getScanCode("k") == Scancode.K)
        @Expect(GameUtils.getScanCode("l") == Scancode.L)
        @Expect(GameUtils.getScanCode("m") == Scancode.M)
        @Expect(GameUtils.getScanCode("n") == Scancode.N)
        @Expect(GameUtils.getScanCode("o") == Scancode.O)
        @Expect(GameUtils.getScanCode("p") == Scancode.P)
        @Expect(GameUtils.getScanCode("q") == Scancode.Q)
        @Expect(GameUtils.getScanCode("r") == Scancode.R)
        @Expect(GameUtils.getScanCode("s") == Scancode.S)
        @Expect(GameUtils.getScanCode("t") == Scancode.T)
        @Expect(GameUtils.getScanCode("u") == Scancode.U)
        @Expect(GameUtils.getScanCode("v") == Scancode.V)
        @Expect(GameUtils.getScanCode("w") == Scancode.W)
        @Expect(GameUtils.getScanCode("x") == Scancode.X)
        @Expect(GameUtils.getScanCode("y") == Scancode.Y)
        @Expect(GameUtils.getScanCode("z") == Scancode.Z)

        @Expect(GameUtils.getScanCode("0") == Scancode.Num0)
        @Expect(GameUtils.getScanCode("1") == Scancode.Num1)
        @Expect(GameUtils.getScanCode("2") == Scancode.Num2)
        @Expect(GameUtils.getScanCode("3") == Scancode.Num3)
        @Expect(GameUtils.getScanCode("4") == Scancode.Num4)
        @Expect(GameUtils.getScanCode("5") == Scancode.Num5)
        @Expect(GameUtils.getScanCode("6") == Scancode.Num6)
        @Expect(GameUtils.getScanCode("7") == Scancode.Num7)
        @Expect(GameUtils.getScanCode("8") == Scancode.Num8)
        @Expect(GameUtils.getScanCode("9") == Scancode.Num9)

        @Expect(GameUtils.getScanCode("[") == Scancode.LBracket)
        @Expect(GameUtils.getScanCode("]") == Scancode.RBracket)
        @Expect(GameUtils.getScanCode(";") == Scancode.Semicolon)
        @Expect(GameUtils.getScanCode(",") == Scancode.Comma)
        @Expect(GameUtils.getScanCode(".") == Scancode.Period)
        @Expect(GameUtils.getScanCode("\'") == Scancode.Apostrophe)
        @Expect(GameUtils.getScanCode("\\") == Scancode.Backslash)
        @Expect(GameUtils.getScanCode("`") == Scancode.Grave)
        @Expect(GameUtils.getScanCode("~") == Scancode.Grave)
        @Expect(GameUtils.getScanCode("=") == Scancode.Equal)
        @Expect(GameUtils.getScanCode(" ") == Scancode.Space)
        @Expect(GameUtils.getScanCode("+") == Scancode.Equal)
        @Expect(GameUtils.getScanCode("-") == Scancode.Hyphen)
        @Expect(GameUtils.getScanCode("/") == Scancode.Slash)

        @Expect(GameUtils.getScanCode("all") == Scancode.Count)
        @Expect(GameUtils.getScanCode("any") == Scancode.Count)
        @Expect(GameUtils.getScanCode("esc") == Scancode.Escape)
        @Expect(GameUtils.getScanCode("escape") == Scancode.Escape)
        @Expect(GameUtils.getScanCode("lcontrol") == Scancode.LControl)
        @Expect(GameUtils.getScanCode("lshift") == Scancode.LShift)
        @Expect(GameUtils.getScanCode("lalt") == Scancode.LAlt)
        @Expect(GameUtils.getScanCode("lsystem") == Scancode.LSystem)
        @Expect(GameUtils.getScanCode("rcontrol") == Scancode.RControl)
        @Expect(GameUtils.getScanCode("rshift") == Scancode.RShift)
        @Expect(GameUtils.getScanCode("ralt") == Scancode.RAlt)
        @Expect(GameUtils.getScanCode("rsystem") == Scancode.RSystem)
        @Expect(GameUtils.getScanCode("menu") == Scancode.Menu)
        @Expect(GameUtils.getScanCode("leftbracket") == Scancode.LBracket)
        @Expect(GameUtils.getScanCode("rightbracket") == Scancode.RBracket)
        @Expect(GameUtils.getScanCode("semicolon") == Scancode.Semicolon)
        @Expect(GameUtils.getScanCode("comma") == Scancode.Comma)
        @Expect(GameUtils.getScanCode("period") == Scancode.Period)
        @Expect(GameUtils.getScanCode("apostrophe") == Scancode.Apostrophe)
        @Expect(GameUtils.getScanCode("quote") == Scancode.Apostrophe)
        @Expect(GameUtils.getScanCode("slash") == Scancode.Slash)
        @Expect(GameUtils.getScanCode("backslash") == Scancode.Backslash)
        @Expect(GameUtils.getScanCode("tilde") == Scancode.Grave)
        @Expect(GameUtils.getScanCode("equal") == Scancode.Equal)
        @Expect(GameUtils.getScanCode("hyphen") == Scancode.Hyphen)
        @Expect(GameUtils.getScanCode("space") == Scancode.Space)
        @Expect(GameUtils.getScanCode("enter") == Scancode.Enter)
        @Expect(GameUtils.getScanCode("return") == Scancode.Enter)
        @Expect(GameUtils.getScanCode("backspace") == Scancode.Backspace)
        @Expect(GameUtils.getScanCode("tab") == Scancode.Tab)
        @Expect(GameUtils.getScanCode("pageup") == Scancode.PageUp)
        @Expect(GameUtils.getScanCode("pagedown") == Scancode.PageDown)
        @Expect(GameUtils.getScanCode("end") == Scancode.End)
        @Expect(GameUtils.getScanCode("home") == Scancode.Home)
        @Expect(GameUtils.getScanCode("insert") == Scancode.Insert)
        @Expect(GameUtils.getScanCode("delete") == Scancode.Delete)
        @Expect(GameUtils.getScanCode("add") == Scancode.Equal)
        @Expect(GameUtils.getScanCode("subtract") == Scancode.Hyphen)
        @Expect(GameUtils.getScanCode("divide") == Scancode.Slash)
        @Expect(GameUtils.getScanCode("left") == Scancode.Left)
        @Expect(GameUtils.getScanCode("right") == Scancode.Right)
        @Expect(GameUtils.getScanCode("up") == Scancode.Up)
        @Expect(GameUtils.getScanCode("down") == Scancode.Down)
        @Expect(GameUtils.getScanCode("numpad0") == Scancode.Numpad0)
        @Expect(GameUtils.getScanCode("numpad1") == Scancode.Numpad1)
        @Expect(GameUtils.getScanCode("numpad2") == Scancode.Numpad2)
        @Expect(GameUtils.getScanCode("numpad3") == Scancode.Numpad3)
        @Expect(GameUtils.getScanCode("numpad4") == Scancode.Numpad4)
        @Expect(GameUtils.getScanCode("numpad5") == Scancode.Numpad5)
        @Expect(GameUtils.getScanCode("numpad6") == Scancode.Numpad6)
        @Expect(GameUtils.getScanCode("numpad7") == Scancode.Numpad7)
        @Expect(GameUtils.getScanCode("numpad8") == Scancode.Numpad8)
        @Expect(GameUtils.getScanCode("numpad9") == Scancode.Numpad9)
        @Expect(GameUtils.getScanCode("f1") == Scancode.F1)
        @Expect(GameUtils.getScanCode("f2") == Scancode.F2)
        @Expect(GameUtils.getScanCode("f3") == Scancode.F3)
        @Expect(GameUtils.getScanCode("f4") == Scancode.F4)
        @Expect(GameUtils.getScanCode("f5") == Scancode.F5)
        @Expect(GameUtils.getScanCode("f6") == Scancode.F6)
        @Expect(GameUtils.getScanCode("f7") == Scancode.F7)
        @Expect(GameUtils.getScanCode("f8") == Scancode.F8)
        @Expect(GameUtils.getScanCode("f9") == Scancode.F9)
        @Expect(GameUtils.getScanCode("f10") == Scancode.F10)
        @Expect(GameUtils.getScanCode("f11") == Scancode.F11)
        @Expect(GameUtils.getScanCode("f12") == Scancode.F12)
        @Expect(GameUtils.getScanCode("f13") == Scancode.F13)
        @Expect(GameUtils.getScanCode("f14") == Scancode.F14)
        @Expect(GameUtils.getScanCode("f15") == Scancode.F15)
        @Expect(GameUtils.getScanCode("pause") == Scancode.Pause)

        // invalid
        @Expect(GameUtils.getScanCode("invalid") == Scancode.Unknown)
        @Expect(GameUtils.getScanCode("invalid", default: Scancode.A) == Scancode.A)
    }

    @TestCase
    func test_getTime_ms() {
        let fmt = "ms"
        @Expect(GameUtils.getTime(Time(seconds: 0.1), fmt).toInt64(), 100)
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toInt64(), 1000)
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toInt64(), 1100)
        @Expect(GameUtils.getTime(Time(seconds: 1.5), fmt).toInt64(), 1500)
        @Expect(GameUtils.getTime(Time(seconds: 1.9), fmt).toInt64(), 1900)
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toInt64(), 1100)
        @Expect(GameUtils.getTime(Time(seconds: 1.5), fmt, roundUp: true).toInt64(), 1500)
        @Expect(GameUtils.getTime(Time(seconds: 1.9), fmt, roundUp: true).toInt64(), 1900)
        @Expect(GameUtils.getTime(Time(seconds: 10.0), fmt).toInt64(), 10000)
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toInt64(), 10000000)
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toInt64(), -1100)
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt, roundUp: true).toInt64(), -1100)
    }

    @TestCase
    func test_getTime_empty_fmt() {
        let fmt = ""
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.5), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.9), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toInt64(), 2)
        @Expect(GameUtils.getTime(Time(seconds: 1.5), fmt, roundUp: true).toInt64(), 2)
        @Expect(GameUtils.getTime(Time(seconds: 1.9), fmt, roundUp: true).toInt64(), 2)
        @Expect(GameUtils.getTime(Time(seconds: 10.0), fmt).toInt64(), 10)
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toInt64(), 10000)
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toInt64(), -2)
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt, roundUp: true).toInt64(), -1)
    }

    @TestCase
    func test_getTime_s() {
        let fmt = "s"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.5), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.9), fmt).toInt64(), 1)
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toInt64(), 2)
        @Expect(GameUtils.getTime(Time(seconds: 1.5), fmt, roundUp: true).toInt64(), 2)
        @Expect(GameUtils.getTime(Time(seconds: 1.9), fmt, roundUp: true).toInt64(), 2)
        @Expect(GameUtils.getTime(Time(seconds: 10.0), fmt).toInt64(), 10)
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toInt64(), 10000)
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toInt64(), -2)
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt, roundUp: true).toInt64(), -1)
    }

    @TestCase
    func test_getTime_S() {
        let fmt = "S"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "2")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-2")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt, roundUp: true).toString(), "-1")
    }

    @TestCase
    func test_getTime_Sf() {
        let fmt = "Sf"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "1.0")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "1.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "1.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "1.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "1.5")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59.0")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000.0")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-1.1")
    }

    @TestCase
    func test_getTime_Sff() {
        let fmt = "Sff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "1.00")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "1.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "1.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "1.12")
        @Expect(GameUtils.getTime(Time(seconds: 1.506), fmt).toString(), "1.51")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59.00")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000.00")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-1.10")
    }

    @TestCase
    func test_getTime_Sfff() {
        let fmt = "Sfff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "1.000")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "1.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "1.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "1.123")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "1.505")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59.000")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000.000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-1.100")
    }

    @TestCase
    func test_getTime_SS() {
        let fmt = "SS"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "02")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-02")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt, roundUp: true).toString(), "-01")
    }

    @TestCase
    func test_getTime_SSf() {
        let fmt = "SSf"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "01.0")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "01.5")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59.0")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000.0")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-01.1")
    }

    @TestCase
    func test_getTime_SSff() {
        let fmt = "SSff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "01.00")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "01.12")
        @Expect(GameUtils.getTime(Time(seconds: 1.506), fmt).toString(), "01.51")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59.00")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000.00")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-01.10")
    }

    @TestCase
    func test_getTime_SSfff() {
        let fmt = "SSfff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "01.000")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "01.123")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "01.505")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "59.000")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "10000.000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-01.100")
    }

    @TestCase
    func test_getTime_MSS() {
        let fmt = "MSS"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:02")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:59")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "1:00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "1:01")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:02")
    }

    @TestCase
    func test_getTime_MSSf() {
        let fmt = "MSSf"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "0:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "0:01.5")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "1:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "1:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40.0")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:01.1")
    }

    @TestCase
    func test_getTime_MSSff() {
        let fmt = "MSSff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "0:01.12")
        @Expect(GameUtils.getTime(Time(seconds: 1.506), fmt).toString(), "0:01.51")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "1:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "1:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40.00")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:01.10")
    }

    @TestCase
    func test_getTime_MSSfff() {
        let fmt = "MSSfff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "0:01.123")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "0:01.505")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "1:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "1:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40.000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:01.100")
    }

    @TestCase
    func test_getTime_MMSS() {
        let fmt = "MMSS"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:02")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:59")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "01:00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "01:01")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:02")
    }

    @TestCase
    func test_getTime_MMSSf() {
        let fmt = "MMSSf"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "00:01.5")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "01:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "01:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40.0")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:01.1")
    }

    @TestCase
    func test_getTime_MMSSff() {
        let fmt = "MMSSff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "00:01.12")
        @Expect(GameUtils.getTime(Time(seconds: 1.506), fmt).toString(), "00:01.51")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "01:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "01:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40.00")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:01.10")
    }

    @TestCase
    func test_getTime_MMSSfff() {
        let fmt = "MMSSfff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "00:01.123")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "00:01.505")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "01:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "01:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "59:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "60:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "60:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "166:40.000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:01.100")
    }

    @TestCase
    func test_getTime_HMMSS() {
        let fmt = "HMMSS"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:00:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:00:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:00:02")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:00:59")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "0:01:00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "0:01:01")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "0:59:59")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "1:00:00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "1:00:01")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "2:46:40")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:00:02")
    }

    @TestCase
    func test_getTime_HMMSSf() {
        let fmt = "HMMSSf"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:00:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "0:00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "0:00:01.5")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:00:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "0:01:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "0:01:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "0:59:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "1:00:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "1:00:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "2:46:40.0")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01.0")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:00:01.1")
    }

    @TestCase
    func test_getTime_HMMSSff() {
        let fmt = "HMMSSff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:00:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:00:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:00:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "0:00:01.12")
        @Expect(GameUtils.getTime(Time(seconds: 1.506), fmt).toString(), "0:00:01.51")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:00:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "0:01:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "0:01:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "0:59:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "1:00:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "1:00:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "2:46:40.00")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01.00")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:00:01.10")
    }

    @TestCase
    func test_getTime_HMMSSfff() {
        let fmt = "HMMSSfff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "0:00:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "0:00:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "0:00:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "0:00:01.123")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "0:00:01.505")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "0:00:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "0:01:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "0:01:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "0:59:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "1:00:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "1:00:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "2:46:40.000")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01.000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-0:00:01.100")
    }

    @TestCase
    func test_getTime_HHMMSS() {
        let fmt = "HHMMSS"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:00:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:00:01")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:00:02")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:00:59")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "00:01:00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "00:01:01")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "00:59:59")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "01:00:00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "01:00:01")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "02:46:40")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01")
        @Expect(GameUtils.getTime(Time(seconds: 1000000.0), fmt).toString(), "277:46:40")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:00:02")
    }

    @TestCase
    func test_getTime_HHMMSSf() {
        let fmt = "HHMMSSf"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:00:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "00:00:01.1")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "00:00:01.5")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:00:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "00:01:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "00:01:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "00:59:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "01:00:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "01:00:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "02:46:40.0")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59.0")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00.0")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01.0")
        @Expect(GameUtils.getTime(Time(seconds: 1000000.0), fmt).toString(), "277:46:40.0")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:00:01.1")
    }

    @TestCase
    func test_getTime_HHMMSSff() {
        let fmt = "HHMMSSff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:00:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:00:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:00:01.10")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "00:00:01.12")
        @Expect(GameUtils.getTime(Time(seconds: 1.506), fmt).toString(), "00:00:01.51")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:00:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "00:01:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "00:01:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "00:59:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "01:00:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "01:00:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "02:46:40.00")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59.00")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00.00")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01.00")
        @Expect(GameUtils.getTime(Time(seconds: 1000000.0), fmt).toString(), "277:46:40.00")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:00:01.10")
    }

    @TestCase
    func test_getTime_HHMMSSfff() {
        let fmt = "HHMMSSfff"
        @Expect(GameUtils.getTime(Time(seconds: 1.0), fmt).toString(), "00:00:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt).toString(), "00:00:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1), fmt, roundUp: true).toString(), "00:00:01.100")
        @Expect(GameUtils.getTime(Time(seconds: 1.1235), fmt).toString(), "00:00:01.123")
        @Expect(GameUtils.getTime(Time(seconds: 1.505), fmt).toString(), "00:00:01.505")
        @Expect(GameUtils.getTime(Time(seconds: 59.0), fmt).toString(), "00:00:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 60.0), fmt).toString(), "00:01:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 61.0), fmt).toString(), "00:01:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 3599.0), fmt).toString(), "00:59:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 3600.0), fmt).toString(), "01:00:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 3601.0), fmt).toString(), "01:00:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 10000.0), fmt).toString(), "02:46:40.000")
        @Expect(GameUtils.getTime(Time(seconds: 215999.0), fmt).toString(), "59:59:59.000")
        @Expect(GameUtils.getTime(Time(seconds: 216000.0), fmt).toString(), "60:00:00.000")
        @Expect(GameUtils.getTime(Time(seconds: 216001.0), fmt).toString(), "60:00:01.000")
        @Expect(GameUtils.getTime(Time(seconds: 1000000.0), fmt).toString(), "277:46:40.000")
        @Expect(GameUtils.getTime(Time(seconds: -1.1), fmt).toString(), "-00:00:01.100")
    }

    @TestCase
    func test_replaceStringWithQueryable() {
        try (obj = Circle(2.0, pointCount: 30)) {
            @Expect(GameUtils.replaceStringWithQueryable("", obj), "")
            @Expect(GameUtils.replaceStringWithQueryable("text", obj), "text")
            @Expect(GameUtils.replaceStringWithQueryable("%text%", obj), "%text%")
            @Expect(GameUtils.replaceStringWithQueryable("%radius%", obj), "2")
            @Expect(GameUtils.replaceStringWithQueryable("%points%", obj), "30")
            @Expect(GameUtils.replaceStringWithQueryable("%size.x%", obj), "4")
            @Expect(GameUtils.replaceStringWithQueryable("%size.y%", obj), "4")
            @Expect(GameUtils.replaceStringWithQueryable("!size.y!", obj, token: '!'), "4")
            @Expect(GameUtils.replaceStringWithQueryable("The size is: [%size.x%, %size.y%]", obj), "The size is: [4, 4]")
            @Expect(GameUtils.replaceStringWithQueryable("The size is: [%%size.x%, %size.y%]", obj), "The size is: [%4, 4]")
            @Expect(GameUtils.replaceStringWithQueryable("The size is: [%%size.x%, %size.y%%]", obj), "The size is: [%4, 4%]")
            @Expect(GameUtils.replaceStringWithQueryable("The size is: [%%size.x%%, %size.y%%]", obj), "The size is: [%4%, 4%]")
            @Expect(GameUtils.replaceStringWithQueryable("The size is: [%%size.x%,% %size.y%%]", obj), "The size is: [%4,% 4%]")
        }
    }

    @TestCase
    func test_replaceStringWithVarOrProp() {
        try (game = Game(reset: true)) {
            try (obj = Circle(2.0, pointCount: 30)) {
                game.resources.addDrawable("obj", obj, manageObjDrawing: true)
                @Expect(GameUtils.replaceStringWithVarOrProp("", game), "")
                @Expect(GameUtils.replaceStringWithVarOrProp("text", game), "text")
                @Expect(GameUtils.replaceStringWithVarOrProp("%text%", game), "%text%")
                @Expect(GameUtils.replaceStringWithVarOrProp("%game.gamma%", game), "0")
                @Expect(GameUtils.replaceStringWithVarOrProp("%game.keepAR%", game), "true")
                @Expect(GameUtils.replaceStringWithVarOrProp("%game.size.x%", game), "640")
                @Expect(GameUtils.replaceStringWithVarOrProp("%game.size.y%", game), "480")
                @Expect(GameUtils.replaceStringWithVarOrProp("!game.size.y!", game, token: '!'), "480")
                @Expect(GameUtils.replaceStringWithVarOrProp("The size is: [%game.size.x%, %game.size.y%]", game), "The size is: [640, 480]")
                @Expect(GameUtils.replaceStringWithVarOrProp("The size is: [%%game.size.x%, %game.size.y%]", game), "The size is: [%640, 480]")
                @Expect(GameUtils.replaceStringWithVarOrProp("The size is: [%%game.size.x%, %game.size.y%%]", game), "The size is: [%640, 480%]")
                @Expect(GameUtils.replaceStringWithVarOrProp("The size is: [%%game.size.x%%, %game.size.y%%]", game), "The size is: [%640%, 480%]")
                @Expect(GameUtils.replaceStringWithVarOrProp("The size is: [%%game.size.x%,% %game.size.y%%]", game), "The size is: [%640,% 480%]")
                @Expect(GameUtils.replaceStringWithVarOrProp("keepAR: %game.keepAR%, radius: %obj.radius.y%", game), "keepAR: true, radius: 2")
            }
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
