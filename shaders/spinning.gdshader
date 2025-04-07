shader_type canvas_item;
uniform float velocity;

void fragment() {
	float c = sin(VERTEX.x * 0.15 + TIME * velocity) - 0.8;
	COLOR = texture(TEXTURE, UV);
	COLOR.r += clamp(c, 0.0, 1.0);
	COLOR.g += clamp(c, 0.0, 1.0);
	COLOR.b += clamp(c, 0.0, 1.0);
}
