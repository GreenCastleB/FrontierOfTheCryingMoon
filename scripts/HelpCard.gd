extends Control

## State machine for Help Card.
enum STATE {INIT, READY, EXIT};
const STATESTR:Array = ['INIT', 'READY', 'EXIT'];
var currState:STATE = STATE.INIT:
	set(newState):
		var oldState:STATE = currState;
		currState = newState;
		var stateChange:String = STATESTR[oldState] + "->" + STATESTR[newState];
		printt("HelpCard ::", "stateChange", stateChange);
		
		if newState == STATE.EXIT:
			# outro animation
			%XferRect.show();
			var tween = get_tree().create_tween();
			tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 0.0, 1.25, 1.00);
			await tween.finished;
			RenderingServer.set_default_clear_color(Color.BLACK);
			get_tree().change_scene_to_file("res://scenes/TitleCard.tscn");

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("4789ce"));
	
	# intro animation
	%XferRect.material.set_shader_parameter("progress", 1.0);
	%XferRect.show();
	var tween = get_tree().create_tween();
	tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 1.0, 0.0, 0.75);
	await tween.finished;
	%XferRect.hide();
	
	currState = STATE.READY;

func _on_back_button_pressed() -> void:
	if currState in [STATE.READY]:
		printt("HelpCard ::", "BACK BUTTON PRESSED");
		currState = STATE.EXIT;
