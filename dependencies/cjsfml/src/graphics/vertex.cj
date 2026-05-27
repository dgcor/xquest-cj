package cjsfml.graphics

import cjsfml.system.Vector2f

/**
 * Point with color and texture coordinates.
 *
 * A vertex is an improved point. It has a position and other
 * extra attributes that will be used for drawing: in SFML,
 * vertices also have a color and a pair of texture coordinates.
 *
 * The vertex is the building block of drawing. Everything which
 * is visible on screen is made of vertices. They are grouped
 * as 2D primitives (lines, triangles, ...), and these primitives
 * are grouped to create even more complex 2D entities such as
 * sprites, texts, etc.
 *
 * If you use the graphical entities of SFML (sprite, text, shape)
 * you won't have to deal with vertices directly. But if you want
 * to define your own 2D entities, such as tiled maps or particle
 * systems, using vertices will allow you to get maximum performances.
 *
 * Example:
 * ```
 * // define a 100x100 square, red, with a 10x10 texture mapped on it
 * let vertices = Array<Vertex>(6, { i =>
 *     match (i) {
 *         case 0 => Vertex(Vector2f(0.0, 0.0), Color.RED, Vector2f(0.0, 0.0))
 *         case 1 => Vertex(Vector2f(0.0, 100.0), Color.RED, Vector2f(0.0, 10.0))
 *         case 2 => Vertex(Vector2f(100.0, 100.0), Color.RED, Vector2f(10.0, 10.0))
 *         case 3 => Vertex(Vector2f(0.0, 0.0), Color.RED, Vector2f(0.0, 0.0))
 *         case 4 => Vertex(Vector2f(100.0, 100.0), Color.RED, Vector2f(10.0, 10.0))
 *         case 5 => Vertex(Vector2f(100.0, 0.0), Color.RED, Vector2f(10.0, 0.0))
 *     }
 * });
 *
 * // draw it
 * window.draw(vertices, PrimitiveType.Triangles);
 * ```
 *
 * Note: Although texture coordinates are supposed to be an integer
 * amount of pixels, their type is float because of some buggy graphics
 * drivers that are not able to process integer coordinates correctly.
 *
 * @see `VertexArray`
 */
@C
public struct Vertex {
    /**
     * Construct a vertex from its position, color and texture coordinates.
     *
     * By default, the vertex color is white and texture coordinates are (0, 0).
     *
     * @param position  2D position of the vertex
     * @param color     Color of the vertex
     * @param texCoords Coordinates of the texture's pixel to map to the vertex
     */
    public const Vertex(
        public var position!: Vector2f = Vector2f(), // 2D position of the vertex.
        public var color!: Color = Color.WHITE, // Color of the vertex.
        public var texCoords!: Vector2f = Vector2f() // Coordinates of the texture's pixel to map to the vertex.
    ) {}
}
