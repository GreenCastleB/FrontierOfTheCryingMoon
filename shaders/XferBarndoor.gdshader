shader_type canvas_item;
uniform float progress: hint_range(0, 1);

void fragment() {
	float prog = round(progress / .05) * .05;
	if(1.0 - UV.y > prog / 2.0){
		if(UV.y > prog / 2.0){
			discard;
		}
	}
}
