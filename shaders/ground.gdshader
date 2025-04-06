shader_type canvas_item;

varying vec2 world_position;

uniform float digg_alpha;
uniform vec2[2] digg_rect;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

void fragment() {
		vec2 top_left = digg_rect[0];
		vec2 bottom_right = digg_rect[1];
		bool x_in_rect = world_position.x > top_left.x
			&& world_position.x < bottom_right.x;
		bool y_in_rect = world_position.y > top_left.y
			&& world_position.y < bottom_right.y;
		float alpha_diff = float(x_in_rect && y_in_rect) * (1.0 - digg_alpha);
		COLOR.a = 1.0 - alpha_diff;
}