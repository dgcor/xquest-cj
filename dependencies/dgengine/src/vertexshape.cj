package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class VertexShape <: Resource & Drawable & Transformable {
    let m_vertices: VertexArray
    var m_transform: TransformableImpl
    var m_bounds: FloatRect = FloatRect()

    public init(primitiveType: PrimitiveType) {
        m_vertices = VertexArray(primitiveType)
        m_transform = TransformableImpl()
    }

    // Resource

    public func isClosed(): Bool {
        m_vertices.isClosed()
    }

    public func close(): Unit {
        m_vertices.close()
        m_transform.close()
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            m_transform.position
        }
        set(value) {
            m_transform.position = value
        }
    }

    public mut prop rotation: Float32 {
        get() {
            m_transform.rotation
        }
        set(value) {
            m_transform.rotation = value
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            m_transform.scaleVal
        }
        set(value) {
            m_transform.scaleVal = value
        }
    }

    public mut prop origin: Vector2f {
        get() {
            m_transform.origin
        }
        set(value) {
            m_transform.origin = value
        }
    }

    public func move(offset: Vector2f): Unit {
        m_transform.move(offset)
    }

    public func rotate(angle: Float32): Unit {
        m_transform.rotate(angle)
    }

    public func scale(factors: Vector2f): Unit {
        m_transform.scale(factors)
    }

    public prop transform: Transform {
        get() {
            m_transform.transform
        }
    }

    public prop inverseTransform: Transform {
        get() {
            m_transform.inverseTransform
        }
    }

    // VertexShape

    public func update(): Unit {
        m_bounds = m_vertices.bounds
    }

    public func addVertex(vertex: Vertex): Unit {
        m_vertices.append(vertex)
        update()
    }

    public prop localBounds: FloatRect {
        get() {
            m_bounds
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            m_transform.transform.transform(m_bounds)
        }
    }

    public func draw(target: RenderTarget, states: RenderStates): Unit {
        var states2 = states
        states2.transform = m_transform.transform
        target.draw(m_vertices, states2)
    }

    public prop pointCount: UInt32 {
        get() {
            m_vertices.vertexCount
        }
    }
}
