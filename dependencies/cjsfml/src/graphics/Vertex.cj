package cjsfml.graphics

import cjsfml.system.*

@C
public struct Vertex {
    public const Vertex(
        public var position!: Vector2f = Vector2f(),
        public var color!: Color = Color.white,
        public var texCoords!: Vector2f = Vector2f()
    ) {}
}
