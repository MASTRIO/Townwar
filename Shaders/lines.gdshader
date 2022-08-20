shader_type canvas_item;

uniform float multiplication_amount = 3.5;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(cos(TIME) * multiplication_amount))) * cos(TIME) * multiplication_amount);
}

void fragment()
{
	if (random(UV) >= 0.9) {
		COLOR = vec4(0, 0, 0, 1);
	}
}