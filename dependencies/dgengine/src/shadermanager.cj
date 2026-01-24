package dgengine

import std.collection.*

public class ShaderManager <: Resource {
    private var m_shaders: HashMap<String, GameShader> = HashMap<String, GameShader>()
    private var m_closed = false

    public static const DEFAULT_GAME_SHADER: String = """
#version 110
uniform sampler2D texture;
uniform vec4 fade;
uniform float gamma;

vec3 Gamma(vec3 value, float param)
{
	return vec3(pow(abs(value.r), param), pow(abs(value.g), param), pow(abs(value.b), param));
}

void main()
{
	vec4 pixel = texture2D(texture, gl_TexCoord[0].xy) - fade;
	float gamma2 = 1.0 - (0.007 * gamma);
	gl_FragColor = vec4(Gamma(pixel.rgb, gamma2), pixel.a);
}
"""

    public static const DEFAULT_LEVEL_SHADER: String = """
#version 110
uniform sampler2D texture;

void main()
{
	gl_FragColor = texture2D(texture, gl_TexCoord[0].xy);
}
"""

    public static const DEFAULT_SPRITE_SHADER: String = """
#version 110
uniform sampler2D palette;
uniform sampler2D texture;
uniform vec2 pixelSize;
uniform vec4 outline;
uniform vec4 ignore;
uniform bool hasPalette;

void main()
{
	vec4 pixel = texture2D(texture, gl_TexCoord[0].xy);

	if (hasPalette == true && pixel.a == 1.0)
	{
		pixel = texture2D(palette, vec2(pixel.r, 0.0));
	}

	if (outline.a > 0.0 && pixel.a == 0.0)
	{
		vec4 vu = texture2D(texture, vec2(gl_TexCoord[0].x , gl_TexCoord[0].y - pixelSize.y));
		vec4 vd = texture2D(texture, vec2(gl_TexCoord[0].x , gl_TexCoord[0].y + pixelSize.y));
		vec4 vl = texture2D(texture, vec2(gl_TexCoord[0].x - pixelSize.x, gl_TexCoord[0].y));
		vec4 vr = texture2D(texture, vec2(gl_TexCoord[0].x + pixelSize.x, gl_TexCoord[0].y));

		if (vu.a == 1.0 || vd.a == 1.0 || vl.a == 1.0 || vr.a == 1.0)
		{
			if (ignore.a == 0.0)
			{
				pixel = outline;
			}
			else
			{
				if (vu != ignore &&
					vd != ignore &&
					vl != ignore &&
					vr != ignore)
				{
					pixel = outline;
				}
			}
		}
	}
	gl_FragColor = pixel;
}
"""

    public static func initShaderManager(shaderManager: ShaderManager): Unit {
        if (let Some(shader) <- GameShader.create(fragmentShader: DEFAULT_GAME_SHADER, uniforms: ["fade", "gamma"])) {
            shaderManager.add("game", shader)
        }
        if (let Some(shader) <- GameShader.create(fragmentShader: DEFAULT_LEVEL_SHADER)) {
            shaderManager.add("level", shader)
        }
        if (let Some(shader) <- GameShader.create(
            fragmentShader: DEFAULT_SPRITE_SHADER,
            uniforms: ["palette", "pixelSize", "outline"]
        )) {
            shaderManager.add("sprite", shader)
        }
    }

    public func initGameShaders(gameShaders: GameShaders): Unit {
        gameShaders.game = get("game")
        gameShaders.level = get("level")
        gameShaders.sprite = get("sprite")
    }

    // Resource

    public func isClosed(): Bool {
        m_closed
    }

    public func close(): Unit {
        if (m_closed == false) {
            for (shader in m_shaders.values()) {
                shader.shader.close()
            }
            m_shaders.clear()
            m_closed = true
        }
    }

    // ShaderManager

    public func add(id: String, shader: GameShader): Unit {
        if (let Some(oldShader) <- m_shaders.add(id, shader)) {
            oldShader.close()
        }
    }

    public func get(id: String): ?GameShader {
        m_shaders.get(id)
    }

    public func has(id: String): Bool {
        m_shaders.contains(id)
    }
}
