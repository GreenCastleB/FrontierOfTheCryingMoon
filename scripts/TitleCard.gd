extends Control

## State machine for Title Card.
enum STATE {INIT, READY, EXIT};
const STATESTR:Array = ['INIT', 'READY', 'EXIT'];
var currState:STATE = STATE.INIT:
	set(newState):
		var oldState:STATE = currState;
		currState = newState;
		var stateChange:String = STATESTR[oldState] + "->" + STATESTR[newState];
		printt("TitleCard ::", "stateChange", stateChange);
		
		if newState == STATE.EXIT:
			# outro animation
			%XferRect.show();
			var tween = get_tree().create_tween();
			tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 0.0, 1.25, 1.00);
			await tween.finished;
			RenderingServer.set_default_clear_color(Color.BLACK);
			get_tree().change_scene_to_file(nextScene);

var nextScene:String = "res://scenes/TitleCard.tscn";

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("ba542fff"));
	%VersionLabel.text = "version " + ProjectSettings.get_setting("application/config/version");
	MUSIC.playTitleTheme();
	
	# intro animation
	%XferRect.material.set_shader_parameter("progress", 1.0);
	%XferRect.show();
	var tween = get_tree().create_tween();
	tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 1.0, 0.0, 0.75);
	await tween.finished;
	%XferRect.hide();
	
	currState = STATE.READY;

func _on_play_button_pressed() -> void:
	if currState in [STATE.READY]:
		printt("TitleCard ::", "PLAY BUTTON PRESSED");
		GLOBAL.setUpGame();
		nextScene = "res://scenes/MessageCard.tscn";
		currState = STATE.EXIT;

func _on_help_button_pressed() -> void:
	if currState in [STATE.READY]:
		printt("TitleCard ::", "HELP BUTTON PRESSED");
		nextScene = "res://scenes/HelpCard.tscn";
		currState = STATE.EXIT;

func _on_credits_button_pressed() -> void:
	if currState in [STATE.READY]:
		printt("TitleCard ::", "CREDITS BUTTON PRESSED");
		nextScene = "res://scenes/CreditsCard.tscn";
		currState = STATE.EXIT;

func _on_settings_button_pressed() -> void:
	if currState in [STATE.READY]:
		printt("TitleCard ::", "SETTINGS BUTTON PRESSED");
		nextScene = "res://scenes/SettingsCard.tscn";
		currState = STATE.EXIT;
