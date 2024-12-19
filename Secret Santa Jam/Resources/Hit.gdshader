shader_type canvas_item;

uniform vec4 color_override: source_color;
uniform float blend_delta: hint_range(0., 1.0, 0.02) = 0.;

vec4 override_blend_alpha(vec4 base, vec4 blend)
{
	blend.a = base.a;
	return blend;
}

void fragment()
{
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 blend_override = override_blend_alpha(texture_color, color_override);
	vec4 target_color = mix(texture_color, blend_override, blend_delta);
	COLOR = target_color;
}