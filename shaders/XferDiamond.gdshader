shader_type canvas_item;
uniform float progress: hint_range(0, 1);

const float DIAMOND_SIZE = 8.0;

void fragment() {
	float xFraction = fract(FRAGCOORD.x / DIAMOND_SIZE);
	float yFraction = fract(FRAGCOORD.y / DIAMOND_SIZE);
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	if (xDistance + yDistance + UV.x + UV.y > progress * 4.0) {
		discard;
	}
}