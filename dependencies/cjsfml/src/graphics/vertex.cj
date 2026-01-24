package cjsfml.graphics

import cjsfml.system.Vector2f

@C
public struct Vertex {
    public const Vertex(
        public var position!: Vector2f = Vector2f(),
        public var color!: Color = Color.WHITE,
        public var texCoords!: Vector2f = Vector2f()
    ) {}
}
