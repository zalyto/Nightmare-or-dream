shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform float wind_strength : hint_range(0.0, 2.0) = 0.25;
uniform float wind_speed : hint_range(0.0, 5.0) = 1.0;
uniform vec3 wind_direction = vec3(1.0, 0.0, 1.0);
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.3;

uniform vec3 color : source_color;
uniform vec3 color2 : source_color;
uniform sampler2D noise;
uniform float noiseScale = 20.0;
varying vec3 worldPos;
void vertex() {
	float h = VERTEX.y;
	float influence = clamp((h - 0.2) / 1.5, 0.0, 1.0);
	float t = TIME * wind_speed;
	float wave1 = sin((VERTEX.x * 2.0 + VERTEX.z * 1.0) + t);
	float wave2 = sin((VERTEX.x * 1.5 - VERTEX.z * 0.8) + t * 1.3);
	float wave = (wave1 * 0.6 + wave2 * 0.4);
	VERTEX += wind_direction * wave * wind_strength * influence;
	
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	ALPHA_SCISSOR_THRESHOLD = alpha_cutoff;
	if (ALPHA < alpha_cutoff) {
		discard;
		}
	vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
	ALBEDO = mix(color, color2, 1.0- UV.y) * mix(color, color2, noiseLevel.r);
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
	}