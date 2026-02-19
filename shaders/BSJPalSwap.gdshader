shader_type canvas_item;
uniform float progress: hint_range(0, 1);

const vec4 COLOR_LIGHT1 = vec4(.88, .65, .41, 1);
const vec4 COLOR_LIGHT2 = vec4(1.00, .89, .48, 1);
const vec4 COLOR_LIGHT3 = vec4(.87, .87, .67, 1);

const vec4 COLOR_PINK = vec4(.83, .39, .49, 1);

const vec4 COLOR_BLACK = vec4(.00, .00, .00, 1);
const vec4 COLOR_DARK3 = vec4(.16, .11, .25, 1);
const vec4 COLOR_DARK2 = vec4(.34, .22, .43, 1);
const vec4 COLOR_DARK1 = vec4(.83, .39, .49, 1);

const float precision = 0.25;

vec4 swap_color(vec4 color){
	if(progress < .25) return color;
	if(progress > .90) return vec4(.0, .0, .0, color.a);
	vec4 original_colors[4];
	vec4 replace_colors[4];

	if(progress < .5){
		// stage 1
		original_colors = vec4[4] (COLOR_LIGHT1, COLOR_LIGHT2, COLOR_PINK, COLOR_LIGHT3);
		replace_colors = vec4[4] (COLOR_DARK3, COLOR_DARK2, COLOR_DARK2, COLOR_DARK1);
	}else if(progress < .75){
		// stage 2
		original_colors = vec4[4] (COLOR_LIGHT1, COLOR_LIGHT2, COLOR_PINK, COLOR_LIGHT3);
		replace_colors = vec4[4] (COLOR_BLACK, COLOR_DARK3, COLOR_DARK3, COLOR_DARK2);
	}else{
		// stage 3
		original_colors = vec4[4] (COLOR_LIGHT1, COLOR_LIGHT2, COLOR_PINK, COLOR_LIGHT3);
		replace_colors = vec4[4] (COLOR_BLACK, COLOR_BLACK, COLOR_BLACK, COLOR_DARK3);
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