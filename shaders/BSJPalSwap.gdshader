shader_type canvas_item;
uniform float progress: hint_range(0, 1);

const vec4 COLOR_BLUE = vec4(.14, .32, .48, 1);
const vec4 COLOR_GREEN = vec4(.12, .63, .47, 1);
const vec4 COLOR_CYAN = vec4(.00, .98, .95, 1);
const vec4 COLOR_RED = vec4(.84, .14, .21, 1);
const vec4 COLOR_ORANGE = vec4(.95, .37, .21, 1);
const vec4 COLOR_YELLOW = vec4(1.00, .82, .24, 1);
const vec4 COLOR_BLACK = vec4(.00, .00, .00, 1);

const float precision = 0.25;

vec4 swap_color(vec4 color){
	if(progress < .25) return color;
	if(progress > .90) return vec4(.0, .0, .0, color.a);
	vec4 original_colors[3];
	vec4 replace_colors[3];

	if(progress < .5){
		// stage 1
		original_colors = vec4[3] (COLOR_BLUE, COLOR_GREEN, COLOR_CYAN);
		replace_colors = vec4[3] (COLOR_RED, COLOR_ORANGE, COLOR_YELLOW);
	}else if(progress < .75){
		// stage 2
		original_colors = vec4[3] (COLOR_BLUE, COLOR_GREEN, COLOR_CYAN);
		replace_colors = vec4[3] (COLOR_BLACK, COLOR_RED, COLOR_ORANGE);
	}else{
		// stage 3
		original_colors = vec4[3] (COLOR_BLUE, COLOR_GREEN, COLOR_CYAN);
		replace_colors = vec4[3] (COLOR_BLACK, COLOR_BLACK, COLOR_RED);
	}

	for (int i = 0; i < 3; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}

void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV));
}