shader_type spatial;

// --- TEXTURES ---
uniform sampler2D grass_tex : source_color;
uniform sampler2D path_tex  : source_color;
uniform sampler2D mask_tex  : source_color;

// --- RÉGLAGES ---
uniform float triplanar_sharpness : hint_range(1.0, 32.0) = 8.0;
uniform float uv_scale = 1.0;

// Varying pour passer la position monde depuis vertex() vers fragment()
varying vec3 v_world_pos;
varying vec3 v_normal_world;

// --- TRIPLANAR ---
vec4 triplanar_texture(sampler2D tex, vec3 pos, vec3 normal) {
	vec3 blending = abs(normal);
	blending = pow(blending, vec3(triplanar_sharpness));
	blending /= (blending.x + blending.y + blending.z);

	vec2 x_uv = pos.yz * uv_scale;
	vec2 y_uv = pos.xz * uv_scale;
	vec2 z_uv = pos.xy * uv_scale;

	vec4 x_tex = texture(tex, x_uv);
	vec4 y_tex = texture(tex, y_uv);
	vec4 z_tex = texture(tex, z_uv);
	return x_tex * blending.x + y_tex * blending.y + z_tex * blending.z;
}

// --- VERTEX : calcule la position monde et la normale monde ---
void vertex() {
    // Correction de l'erreur des uniformes (si vous les aviez dans ce fichier)
    // MODEL_MATRIX transforme les coordonnées locales -> monde
	v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	v_normal_world = normalize(MODEL_NORMAL_MATRIX * NORMAL);

    // Important : laisser Godot faire la transform habituelle du vertex
}

// --- FRAGMENT : utilise les varyings ---
void fragment() {
	vec3 world_pos = v_world_pos;
	vec3 n = normalize(v_normal_world);

    // Triplanar pour les textures (herbe et chemin)
	vec4 grass = triplanar_texture(grass_tex, world_pos, n);
	vec4 path  = triplanar_texture(path_tex,  world_pos, n);
    
	float blend = texture(mask_tex, UV).r; 

	ALBEDO = mix(grass.rgb, path.rgb, blend);
}