package cjsfml.graphics

import cjsfml.system.{InputStream, InputStreamData, ResourceHandle, SFMLNullHandleException, SFMLException}

foreign {
    func sfShader_createFromFile(vertexShaderFilename: CString, geometryShaderFilename: CString,
        fragmentShaderFilename: CString): CPointer<Unit>

    func sfShader_createFromMemory(vertexShader: CString, geometryShader: CString, fragmentShader: CString): CPointer<Unit>

    func sfShader_createFromStream(vertexShaderStream: CPointer<InputStreamData>,
        geometryShaderStream: CPointer<InputStreamData>, fragmentShaderStream: CPointer<InputStreamData>): CPointer<Unit>

    func sfShader_destroy(handle: CPointer<Unit>): Unit

    // Shader

    func sfShader_setFloatUniform(handle: CPointer<Unit>, name: CString, x: Float32): Unit

    func sfShader_setVec2Uniform(handle: CPointer<Unit>, name: CString, vector: GlslVec2): Unit

    func sfShader_setVec3Uniform(handle: CPointer<Unit>, name: CString, vector: GlslVec3): Unit

    func sfShader_setVec4Uniform(handle: CPointer<Unit>, name: CString, vector: GlslVec4): Unit

    func sfShader_setColorUniform(handle: CPointer<Unit>, name: CString, color: Color): Unit

    func sfShader_setIntUniform(handle: CPointer<Unit>, name: CString, x: Int32): Unit

    func sfShader_setIvec2Uniform(handle: CPointer<Unit>, name: CString, vector: GlslIvec2): Unit

    func sfShader_setIvec3Uniform(handle: CPointer<Unit>, name: CString, vector: GlslIvec3): Unit

    func sfShader_setIvec4Uniform(handle: CPointer<Unit>, name: CString, vector: GlslIvec4): Unit

    func sfShader_setIntColorUniform(handle: CPointer<Unit>, name: CString, color: Color): Unit

    func sfShader_setBoolUniform(handle: CPointer<Unit>, name: CString, x: Bool): Unit

    func sfShader_setBvec2Uniform(handle: CPointer<Unit>, name: CString, vector: GlslBvec2): Unit

    func sfShader_setBvec3Uniform(handle: CPointer<Unit>, name: CString, vector: GlslBvec3): Unit

    func sfShader_setBvec4Uniform(handle: CPointer<Unit>, name: CString, vector: GlslBvec4): Unit

    func sfShader_setMat3Uniform(handle: CPointer<Unit>, name: CString, matrix: GlslMat3): Unit

    func sfShader_setMat4Uniform(handle: CPointer<Unit>, name: CString, matrix: GlslMat4): Unit

    func sfShader_setTextureUniform(handle: CPointer<Unit>, name: CString, texture: CPointer<Unit>): Unit

    func sfShader_setCurrentTextureUniform(handle: CPointer<Unit>, name: CString): Unit

    func sfShader_setFloatUniformArray(handle: CPointer<Unit>, name: CString, scalarArray: CPointer<Float32>,
        length: UIntNative): Unit

    func sfShader_setVec2UniformArray(handle: CPointer<Unit>, name: CString, vectorArray: CPointer<GlslVec2>,
        length: UIntNative): Unit

    func sfShader_setVec3UniformArray(handle: CPointer<Unit>, name: CString, vectorArray: CPointer<GlslVec3>,
        length: UIntNative): Unit

    func sfShader_setVec4UniformArray(handle: CPointer<Unit>, name: CString, vectorArray: CPointer<GlslVec4>,
        length: UIntNative): Unit

    func sfShader_setMat3UniformArray(handle: CPointer<Unit>, name: CString, matrixArray: CPointer<GlslMat3>,
        length: UIntNative): Unit

    func sfShader_setMat4UniformArray(handle: CPointer<Unit>, name: CString, matrixArray: CPointer<GlslMat4>,
        length: UIntNative): Unit

    func sfShader_getNativeHandle(handle: CPointer<Unit>): UInt32

    func sfShader_bind(handle: CPointer<Unit>): Unit

    func sfShader_isAvailable(): Bool

    func sfShader_isGeometryAvailable(): Bool
}

/**
 * Shader class (vertex, geometry and fragment).
 *
 * Shaders are programs written using a specific language,
 * executed directly by the graphics card and allowing
 * to apply real-time operations to the rendered entities.
 *
 * There are three kinds of shaders:
 * - Vertex shaders, that process vertices
 * - Geometry shaders, that process primitives
 * - Fragment (pixel) shaders, that process pixels
 *
 * A `Shader` can be composed of either a vertex shader
 * alone, a geometry shader alone, a fragment shader alone,
 * or any combination of them. (see the variants of the
 * load functions).
 *
 * Shaders are written in GLSL, which is a C-like
 * language dedicated to OpenGL shaders. You'll probably
 * need to learn its basics before writing your own shaders
 * for SFML.
 *
 * Like any C/C++ program, a GLSL shader has its own variables
 * called _uniforms_ that you can set from your C++ application.
 * `Shader` handles different types of uniforms:
 * - scalars: float, int, bool
 * - vectors (2, 3 or 4 components)
 * - matrices (3x3 or 4x4)
 * - samplers (textures)
 *
 * Some SFML-specific types can be converted:
 * - `Color` as a 4D vector (vec4)
 * - `Transform` as matrices (mat3 or mat4)
 *
 * Every uniform variable in a shader can be set through one of the
 * `setUniform()` or `setUniformArray()` overloads. For example, if you
 * have a shader with the following uniforms:
 * ```
 * uniform float offset;
 * uniform vec3 point;
 * uniform vec4 color;
 * uniform mat4 matrix;
 * uniform sampler2D overlay;
 * uniform sampler2D current;
 * ```
 * You can set their values from Cangjie code as follows, using the types
 * defined in the `Glsl` namespace:
 * ```
 * shader.setUniform("offset", 2.0);
 * shader.setUniform("point", GlslVec3(0.5, 0.8, 0.3));
 * shader.setUniform("color", GlslVec4(color));          // color is a Color
 * shader.setUniform("matrix", GlslMat4(transform));     // transform is a Transform
 * shader.setUniform("overlay", texture);                // texture is a Texture
 * shader.setCurrentTextureUniform("current");
 * ```
 *
 * The special `CurrentTextureType` argument maps the
 * given sampler2D uniform to the current texture of the
 * object being drawn (which cannot be known in advance).
 *
 * To apply a shader to a drawable, you must pass it as an
 * additional parameter to the `RenderWindow.draw` function:
 * ```
 * window.draw(sprite, RenderStates(shader: shader));
 * ```
 *
 * Shaders can be used on any drawable, but some combinations are
 * not interesting. For example, using a vertex shader on a `Sprite`
 * is limited because there are only 4 vertices, the sprite would
 * have to be subdivided in order to apply wave effects.
 * Another bad example is a fragment shader with `Text`: the texture
 * of the text is not the actual text that you see on screen, it is
 * a big texture containing all the characters of the font in an
 * arbitrary order; thus, texture lookups on pixels other than the
 * current one may not give you the expected result.
 *
 * Shaders can also be used to apply global post-effects to the
 * current contents of the target.
 * This can be done in two different ways:
 * - draw everything to a `RenderTexture`, then draw it to
 *   the main target using the shader
 * - draw everything directly to the main target, then use
 *   `Texture.update(Window)` to copy its contents to a texture
 *   and draw it to the main target using the shader
 *
 * The first technique is more optimized because it doesn't involve
 * retrieving the target's pixels to system memory, but the
 * second one doesn't impact the rendering process and can be
 * easily inserted anywhere without impacting all the code.
 *
 * Like `Texture` that can be used as a raw OpenGL texture,
 * `Shader` can also be used directly as a raw shader for
 * custom OpenGL geometry.
 * ```
 * Shader.bind(shader);
 * ... render OpenGL geometry ...
 * Shader.bind(CPointer<Unit>());
 * ```
 *
 * @see `Glsl`
 */
public class Shader <: ResourceHandle & Equatable<Shader> {
    private var m_handle: CPointer<Unit> = CPointer()
    private var m_isOwner: Bool = true

    public init() {}

    /**
     * Construct the shader from an existing handle.
     *
     * @param handle  The handle to use.
     * @param isOwner Whether this instance owns the handle.
     *
     * @throws SFMLNullHandleException
     */
    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    /**
     * Load the vertex, geometry or fragment shader from a file.
     *
     * This function loads a single shader, vertex, geometry or
     * fragment, identified by the second argument.
     * The source must be a text file containing a valid
     * shader in GLSL language. GLSL is a C-like language
     * dedicated to OpenGL shaders; you'll probably need to
     * read a good documentation for it before writing your
     * own shaders.
     *
     * @param vertexShaderFilename   Path of the vertex shader file to load
     * @param geometryShaderFilename Path of the geometry shader file to load
     * @param fragmentShaderFilename Path of the fragment shader file to load
     *
     * @throws SFMLNullHandleException
     */
    public func createFromFile(vertexShader!: ?String = None, geometryShader!: ?String = None,
        fragmentShader!: ?String = None): Unit {
        ifInitThrow()
        unsafe {
            let vertexShaderStr = match (vertexShader) {
                case Some(value) => LibC.mallocCString(value)
                case None => CString(CPointer<UInt8>())
            }
            let geometryShaderStr = match (geometryShader) {
                case Some(value) => LibC.mallocCString(value)
                case None => CString(CPointer<UInt8>())
            }
            let fragmentShaderStr = match (fragmentShader) {
                case Some(value) => LibC.mallocCString(value)
                case None => CString(CPointer<UInt8>())
            }
            m_handle = sfShader_createFromFile(vertexShaderStr, geometryShaderStr, fragmentShaderStr)
            LibC.free(fragmentShaderStr)
            LibC.free(geometryShaderStr)
            LibC.free(vertexShaderStr)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Load the vertex, geometry or fragment shader from a source code in memory.
     *
     * This function loads a single shader, vertex, geometry
     * or fragment, identified by the second argument.
     * The source code must be a valid shader in GLSL language.
     * GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for
     * it before writing your own shaders.
     *
     * @param vertexShader   String containing the source code of the vertex shader
     * @param geometryShader String containing the source code of the geometry shader
     * @param fragmentShader String containing the source code of the fragment shader
     *
     * @throws SFMLNullHandleException
     */
    public func createFromMemory(vertexShader!: ?String = None, geometryShader!: ?String = None,
        fragmentShader!: ?String = None): Unit {
        ifInitThrow()
        unsafe {
            let vertexShaderStr = match (vertexShader) {
                case Some(value) => LibC.mallocCString(value)
                case None => CString(CPointer<UInt8>())
            }
            let geometryShaderStr = match (geometryShader) {
                case Some(value) => LibC.mallocCString(value)
                case None => CString(CPointer<UInt8>())
            }
            let fragmentShaderStr = match (fragmentShader) {
                case Some(value) => LibC.mallocCString(value)
                case None => CString(CPointer<UInt8>())
            }
            m_handle = sfShader_createFromMemory(vertexShaderStr, geometryShaderStr, fragmentShaderStr)
            LibC.free(fragmentShaderStr)
            LibC.free(geometryShaderStr)
            LibC.free(vertexShaderStr)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Load the vertex, geometry or fragment shader from a custom stream.
     *
     * This function loads a single shader, vertex, geometry
     * or fragment, identified by the second argument.
     * The source code must be a valid shader in GLSL language.
     * GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for it
     * before writing your own shaders.
     *
     * @param vertexShaderStream   Source stream to read the vertex shader from
     * @param geometryShaderStream Source stream to read the geometry shader from
     * @param fragmentShaderStream Source stream to read the fragment shader from
     *
     * @throws SFMLNullHandleException
     */
    public func createFromStream(vertexShader!: ?InputStream = None, geometryShader!: ?InputStream = None,
        fragmentShader!: ?InputStream = None): Unit {
        ifInitThrow()
        unsafe {
            let vertexShaderStr = match (vertexShader) {
                case Some(value) =>
                    let stream = LibC.malloc<InputStreamData>()
                    stream.write(value.stream)
                    stream
                case None => CPointer<InputStreamData>()
            }
            let geometryShaderStr = match (geometryShader) {
                case Some(value) =>
                    let stream = LibC.malloc<InputStreamData>()
                    stream.write(value.stream)
                    stream
                case None => CPointer<InputStreamData>()
            }
            let fragmentShaderStr = match (fragmentShader) {
                case Some(value) =>
                    let stream = LibC.malloc<InputStreamData>()
                    stream.write(value.stream)
                    stream
                case None => CPointer<InputStreamData>()
            }
            m_handle = sfShader_createFromStream(vertexShaderStr, geometryShaderStr, fragmentShaderStr)
            LibC.free(fragmentShaderStr)
            LibC.free(geometryShaderStr)
            LibC.free(vertexShaderStr)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * @throws SFMLException
     */
    public func ifInitThrow(): Unit {
        if (!isClosed()) {
            throw SFMLException("Shader is already initialized")
        }
    }

    ~init() {
        if (m_handle.isNotNull() && m_isOwner) {
            unsafe { sfShader_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || !m_isOwner) {
            return
        }
        unsafe { sfShader_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    public override prop isOwner: Bool {
        get() {
            m_isOwner
        }
    }

    // Equatable

    public override operator func ==(right: Shader): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Shader): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Shader

    // cjlint-ignore -start !G.DCL.01 function name already exists

    /**
     * Specify value for `float` uniform.
     *
     * @param name Name of the uniform variable in GLSL
     * @param x    Value of the float scalar
     */
    public func setUniform(name: String, x: Float32): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setFloatUniform(m_handle, nameRes.value, x)
            }
        }
    }

    /**
     * Specify value for `vec2` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the vec2 vector
     */
    public func setUniform(name: String, vector: GlslVec2): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec2Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    /**
     * Specify value for `vec3` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the vec3 vector
     */
    public func setUniform(name: String, vector: GlslVec3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec3Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    /**
     * Specify value for `vec4` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the vec4 vector
     */
    public func setUniform(name: String, vector: GlslVec4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec4Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    /**
     * Specify value for `vec4` uniform from a color.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param color Color to convert
     */
    public func setUniform(name: String, color: Color): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setColorUniform(m_handle, nameRes.value, color)
            }
        }
    }

    /**
     * Specify value for `int` uniform.
     *
     * @param name Name of the uniform variable in GLSL
     * @param x    Value of the int scalar
     */
    public func setUniform(name: String, x: Int32): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIntUniform(m_handle, nameRes.value, x)
            }
        }
    }

    /**
     * Specify value for `ivec2` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the ivec2 vector
     */
    public func setUniform(name: String, vector: GlslIvec2): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIvec2Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    /**
     * Specify value for `ivec3` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the ivec3 vector
     */
    public func setUniform(name: String, vector: GlslIvec3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIvec3Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    /**
     * Specify value for `ivec4` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the ivec4 vector
     */
    public func setUniform(name: String, vector: GlslIvec4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIvec4Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    /**
     * Specify value for `ivec4` uniform from a color.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param color Color to convert
     */
    public func setIntUniform(name: String, color: Color): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIntColorUniform(m_handle, nameRes.value, color)
            }
        }
    }

    /**
     * Specify value for `bool` uniform.
     *
     * @param name Name of the uniform variable in GLSL
     * @param x    Value of the bool scalar
     */
    public func setUniform(name: String, x: Bool): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBoolUniform(m_handle, nameRes.value, x)
            }
        }
    }

    /**
     * Specify value for `bvec2` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the bvec2 vector
     */
    public func setUniform(name: String, vector: GlslBvec2): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBvec2Uniform(
                    m_handle,
                    nameRes.value,
                    GlslBvec2(
                        vector.x,
                        vector.y
                    )
                )
            }
        }
    }

    /**
     * Specify value for `bvec3` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the bvec3 vector
     */
    public func setUniform(name: String, vector: GlslBvec3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBvec3Uniform(
                    m_handle,
                    nameRes.value,
                    GlslBvec3(
                        vector.x,
                        vector.y,
                        vector.z
                    )
                )
            }
        }
    }

    /**
     * Specify value for `bvec4` uniform.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param vector Value of the bvec4 vector
     */
    public func setUniform(name: String, vector: GlslBvec4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBvec4Uniform(
                    m_handle,
                    nameRes.value,
                    GlslBvec4(
                        vector.x,
                        vector.y,
                        vector.z,
                        vector.w
                    )
                )
            }
        }
    }

    /**
     * Specify value for `mat3` matrix.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param matrix Value of the mat3 matrix
     */
    public func setUniform(name: String, matrix: GlslMat3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat3Uniform(m_handle, nameRes.value, matrix)
            }
        }
    }

    /**
     * Specify value for `mat4` matrix.
     *
     * @param name   Name of the uniform variable in GLSL
     * @param matrix Value of the mat4 matrix
     */
    public func setUniform(name: String, matrix: GlslMat4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat4Uniform(m_handle, nameRes.value, matrix)
            }
        }
    }

    /**
     * Specify a texture as `sampler2D` uniform.
     *
     * @param name    Name of the texture in the shader
     * @param texture Texture to assign
     */
    public func setUniform(name: String, texture: Texture): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setTextureUniform(m_handle, nameRes.value, texture.handle)
            }
        }
    }

    /**
     * Specify current texture as `sampler2D` uniform.
     *
     * This overload maps a shader texture variable to the
     * texture of the object being drawn, which cannot be
     * known in advance.
     *
     * @param name Name of the texture in the shader
     */
    public func setCurrentTextureUniform(name: String): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setCurrentTextureUniform(m_handle, nameRes.value)
            }
        }
    }

    /**
     * Specify values for `float[]` array uniform.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param array Array of float values
     */
    public func setUniform(name: String, array: Array<Float32>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array)
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setFloatUniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Specify values for `vec2[]` array uniform.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param array Array of vec2 values
     */
    public func setUniform(name: String, array: Array<GlslVec2>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array)
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec2UniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Specify values for `vec3[]` array uniform.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param array Array of vec3 values
     */
    public func setUniform(name: String, array: Array<GlslVec3>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array)
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec3UniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Specify values for `vec4[]` array uniform.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param array Array of vec4 values
     */
    public func setUniform(name: String, array: Array<GlslVec4>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array)
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec4UniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Specify values for `mat3[]` array uniform.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param array Array of mat3 values
     */
    public func setUniform(name: String, array: Array<GlslMat3>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array) // cjlint-ignore !G.VAR.02 minimize scope
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat3UniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Specify values for `mat4[]` array uniform.
     *
     * @param name  Name of the uniform variable in GLSL
     * @param array Array of mat4 values
     */
    public func setUniform(name: String, array: Array<GlslMat4>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array) // cjlint-ignore !G.VAR.02 minimize scope
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat4UniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    // cjlint-ignore -end function name already exists

    /**
     * Get the underlying OpenGL handle of the shader.
     *
     * You shouldn't need to use this function, unless you have
     * very specific stuff to implement that SFML doesn't support,
     * or implement a temporary workaround until a bug is fixed.
     *
     * @return OpenGL handle of the shader or 0 if not yet loaded
     */
    public prop nativeHandle: UInt32 {
        get() {
            unsafe { sfShader_getNativeHandle(m_handle) }
        }
    }

    /**
     * Bind a shader for rendering.
     *
     * This function is not part of the graphics API, it mustn't be
     * used when drawing SFML entities. It must be used only if you
     * mix `Shader` with OpenGL code.
     *
     * @param shader Shader to bind, can be null to use no shader
     */
    public static func bind(shader: Shader): Unit {
        unsafe { sfShader_bind(shader.m_handle) }
    }

    // cjlint-ignore -start !G.NAM.05 use all capital letters for static variable

    /**
     * Tell whether or not the system supports shaders.
     *
     * This function should always be called before using
     * the shader features. If it returns `false`, then
     * any attempt to use `Shader` will fail.
     *
     * @return `true` if shaders are supported, `false` otherwise
     */
    public static prop isAvailable: Bool {
        get() {
            unsafe { sfShader_isAvailable() }
        }
    }

    /**
     * Tell whether or not the system supports geometry shaders.
     *
     * This function should always be called before using
     * the geometry shader features. If it returns `false`, then
     * any attempt to use `Shader` geometry shader features will fail.
     *
     * This function can only return `true` if isAvailable() would also
     * return `true`, since shaders in general have to be supported in
     * order for geometry shaders to be supported as well.
     *
     * Note: The first call to this function, whether by your
     * code or SFML will result in a context switch.
     *
     * @return `true` if geometry shaders are supported, `false` otherwise
     */
    public static prop isGeometryAvailable: Bool {
        get() {
            unsafe { sfShader_isGeometryAvailable() }
        }
    }

    // cjlint-ignore -end use all capital letters for static variable
}
