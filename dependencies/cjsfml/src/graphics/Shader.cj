package cjsfml.graphics

import cjsfml.system.*

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

    func sfShader_setBoolUniform(handle: CPointer<Unit>, name: CString, x: SfBool): Unit

    func sfShader_setBvec2Uniform(handle: CPointer<Unit>, name: CString, vector: GlslIvec2): Unit

    func sfShader_setBvec3Uniform(handle: CPointer<Unit>, name: CString, vector: GlslIvec3): Unit

    func sfShader_setBvec4Uniform(handle: CPointer<Unit>, name: CString, vector: GlslIvec4): Unit

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

    func sfShader_isAvailable(): SfBool

    func sfShader_isGeometryAvailable(): SfBool
}

public class Shader <: ResourceHandle & Equatable<Shader> {
    private var m_handle: CPointer<Unit> = CPointer()
    private var m_isOwner: Bool = true

    public init() {}

    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    public func createFromFile(vertexShader!: ?String = None, geometryShader!: ?String = None,
        fragmentShader!: ?String = None) {
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

    public func createFromMemory(vertexShader!: ?String = None, geometryShader!: ?String = None,
        fragmentShader!: ?String = None) {
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

    public func createFromStream(vertexShader!: ?InputStream = None, geometryShader!: ?InputStream = None,
        fragmentShader!: ?InputStream = None) {
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
        if (m_handle.isNull() || m_isOwner == false) {
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

    public operator override func ==(right: Shader): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Shader): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Shader

    public func setUniform(name: String, x: Float32): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setFloatUniform(m_handle, nameRes.value, x)
            }
        }
    }

    public func setUniform(name: String, vector: GlslVec2): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec2Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    public func setUniform(name: String, vector: GlslVec3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec3Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    public func setUniform(name: String, vector: GlslVec4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setVec4Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    public func setUniform(name: String, color: Color): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setColorUniform(m_handle, nameRes.value, color)
            }
        }
    }

    public func setUniform(name: String, x: Int32): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIntUniform(m_handle, nameRes.value, x)
            }
        }
    }

    public func setUniform(name: String, vector: GlslIvec2): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIvec2Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    public func setUniform(name: String, vector: GlslIvec3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIvec3Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    public func setUniform(name: String, vector: GlslIvec4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIvec4Uniform(m_handle, nameRes.value, vector)
            }
        }
    }

    public func setIntUniform(name: String, color: Color): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setIntColorUniform(m_handle, nameRes.value, color)
            }
        }
    }

    public func setUniform(name: String, x: Bool): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBoolUniform(m_handle, nameRes.value, SfBool.fromBool(x))
            }
        }
    }

    public func setUniform(name: String, vector: GlslBvec2): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBvec2Uniform(
                    m_handle,
                    nameRes.value,
                    GlslIvec2(
                        SfBool.fromBool(vector.x),
                        SfBool.fromBool(vector.y)
                    )
                )
            }
        }
    }

    public func setUniform(name: String, vector: GlslBvec3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBvec3Uniform(
                    m_handle,
                    nameRes.value,
                    GlslIvec3(
                        SfBool.fromBool(vector.x),
                        SfBool.fromBool(vector.y),
                        SfBool.fromBool(vector.z)
                    )
                )
            }
        }
    }

    public func setUniform(name: String, vector: GlslBvec4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setBvec4Uniform(
                    m_handle,
                    nameRes.value,
                    GlslIvec4(
                        SfBool.fromBool(vector.x),
                        SfBool.fromBool(vector.y),
                        SfBool.fromBool(vector.z),
                        SfBool.fromBool(vector.w)
                    )
                )
            }
        }
    }

    public func setUniform(name: String, matrix: GlslMat3): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat3Uniform(m_handle, nameRes.value, matrix)
            }
        }
    }

    public func setUniform(name: String, matrix: GlslMat4): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat4Uniform(m_handle, nameRes.value, matrix)
            }
        }
    }

    public func setUniform(name: String, texture: Texture): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setTextureUniform(m_handle, nameRes.value, texture.handle)
            }
        }
    }

    public func setCurrentTextureUniform(name: String): Unit {
        unsafe {
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setCurrentTextureUniform(m_handle, nameRes.value)
            }
        }
    }

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

    public func setUniform(name: String, array: Array<GlslMat3>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array)
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat3UniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    public func setUniform(name: String, array: Array<GlslMat4>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(array)
            try (nameRes = LibC.mallocCString(name).asResource()) {
                sfShader_setMat4UniformArray(m_handle, nameRes.value, rawData.pointer, UIntNative(array.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    public prop nativeHandle: UInt32 {
        get() {
            unsafe { sfShader_getNativeHandle(m_handle) }
        }
    }

    public static func bind(shader: Shader): Unit {
        unsafe { sfShader_bind(shader.m_handle) }
    }

    public static prop isAvailable: Bool {
        get() {
            unsafe { sfShader_isAvailable().toBool() }
        }
    }

    public static prop isGeometryAvailable: Bool {
        get() {
            unsafe { sfShader_isGeometryAvailable().toBool() }
        }
    }
}
