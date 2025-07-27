package cjsfml.graphics

import cjsfml.macros.*
import cjsfml.system.*

// 2D vectors

public type GlslVec2 = Vector2f

public type GlslIvec2 = Vector2i

@CVector2[public GlslBvec2 Bool]()

// 3D vectors

public type GlslVec3 = Vector3f

public type GlslIvec3 = Vector3i

@CVector3[public GlslBvec3 Bool]()

// 4D vectors

@CVector4[public GlslVec4 Float32]()

@CVector4[public GlslIvec4 Int32]()

@CVector4[public GlslBvec4 Bool]()

// matrices

@C
public struct GlslMat3 {
    public var array: VArray<Float32, $9> = VArray<Float32, $9>(repeat: 0.0)
}

@C
public struct GlslMat4 {
    public var array: VArray<Float32, $16> = VArray<Float32, $16>(repeat: 0.0)
}
