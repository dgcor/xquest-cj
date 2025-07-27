package XQuest

import cjsfml.graphics.*
import cjsfml.system.*
import dgengine.*
import std.collection.*
import std.math.*

private struct Star {
    Star(
        var x!: Float32,
        var y!: Float32,
        var z!: Float32,
        var pz!: Float32,
        var starColor!: Color
    ) {}

    mut func updateColor() {
        starColor.a = UInt8(clamp(Int64(255.0 - (255.0 * z)), 0, 255))
    }
}

class Starfield <: UIObject {
    private static const MaxTimeout = 0.25f32

    private let m_stars = ArrayList<Star>()
    private var m_elapsedTime = ElapsedTimef(timeout: MaxTimeout)
    private let m_surface = Surface()
    private var m_updateSurface = false
    private let m_drawableStar = RectangleShape(Vector2f(1.0, 1.0))

    public init(game: Game, size: Vector2f, stars: Int16) {
        for (_ in 0..stars) {
            let z = Random.getf(1.0f32)
            var star = Star(
                x: -0.5 + Random.getf(1.0),
                y: -0.5 + Random.getf(1.0),
                z: z,
                pz: z,
                starColor: Color.white
            )
            star.updateColor()
            m_stars.add(star)
        }
        m_surface.size = size
        m_surface.setCenter()
        m_surface.initialize(game)
        m_surface.updateView(game)
    }

    // Resource

    public func isClosed(): Bool {
        m_drawableStar.isClosed()
    }

    public func close(): Unit {
        m_drawableStar.close()
    }

    // UIObject

    public mut prop anchor: Anchor {
        get() {
            m_surface.anchor
        }
        set(value) {
            m_surface.anchor = value
        }
    }

    public func updateSize(game: Game): Unit {
        m_surface.updateSize(game)
        m_surface.setCenter()
    }

    public prop drawPosition: Vector2f {
        get() {
            m_surface.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_surface.position
        }
        set(value) {
            m_surface.position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            m_surface.size
        }
        set(value) {
            m_surface.size = value
            m_surface.setCenter()
            m_updateSurface = true
        }
    }

    public mut prop visible: Bool {
        get() {
            m_surface.visible
        }
        set(value) {
            m_surface.visible = value
        }
    }

    private static func scale(q: Float32, a: Float32, b: Float32, c: Float32, d: Float32): Float32 {
        let temp = (b - (q / (b - a) * b)) / b
        return (d - temp * (d - c))
    }

    public func draw(_: Game, target: RenderTarget): Unit {
        if (m_surface.visible) {
            try (origView = target.view.clone()) {
                m_surface.clear(Color.black)

                let size = m_surface.size

                for (star in m_stars) {
                    let sx = scale((star.x * size.x) / (star.z * size.x), 0.0, 1.0, 0.0, size.x)
                    let sy = scale((star.y * size.y) / (star.z * size.x), 0.0, 1.0, 0.0, size.x)

                    m_drawableStar.position = Vector2f(round(sx + size.x / 2.0), round(sy + size.y / 2.0))
                    m_drawableStar.fillColor = star.starColor

                    m_surface.draw(m_drawableStar)
                }

                m_surface.draw(target)
                target.view = origView
            }
        }
    }

    public override func update(game: Game): Unit {
        if (m_updateSurface == true) {
            m_surface.updateView(game)
        }
        if (m_elapsedTime.timeout == 0.0) {
            return
        }
        m_elapsedTime.update(
            game.elapsedTime.seconds,
            {
                => for (index in 0..m_stars.size) {
                    var star = m_stars[index]
                    star.z -= 0.005

                    if (star.z < 0.000001) {
                        star.z = 0.9 + Random.getf(0.1)
                        star.x = -0.5 + Random.getf(1.0)
                        star.y = -0.5 + Random.getf(1.0)
                        star.pz = star.z
                    }
                    star.updateColor()
                    m_stars[index] = star
                }
            }
        )
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        getProperty(props[0], props[1])
    }

    // Starfield
    public func setSpeed(speed: Float32): Unit {
        m_elapsedTime.timeout = clamp(speed, 0.0, MaxTimeout)
    }
}
