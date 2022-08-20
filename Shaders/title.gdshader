shader_type canvas_item;

uniform float rotation_amount = 50.0;

void vertex() {
  VERTEX += vec2(cos(TIME) * rotation_amount, sin(TIME) * rotation_amount / 2.0);
}