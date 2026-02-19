extends Control

## State machine for Message Card.
enum STATE {INIT, READY, EXIT};
const STATESTR:Array = ['INIT', 'READY', 'EXIT'];
var currState:STATE = STATE.INIT:
	set(newState):
		var oldState:STATE = currState;
		currState = newState;
		var stateChange:String = STATESTR[oldState] + "->" + STATESTR[newState];
		printt("MessageCard ::", "stateChange", stateChange);
		
		if newState == STATE.READY:
			MUSIC.playDayTheme();
			%SkipBtnTimer.start();
			
			# MessageTxtLabel slow reveal
			MessageTxtTween = get_tree().create_tween();
			MessageTxtTween.tween_property(%MessageTxtLabel, "visible_ratio", 1.5, MessageTxtTime);
			await MessageTxtTween.finished;
			
			printt("MessageCard ::", "MessageTxtTween.finished");
			set_deferred("currState", STATE.EXIT);
			
		elif newState == STATE.EXIT:
			MessageTxtTween.kill();
			%SkipButton.hide();
			
			# outro animation
			%XferRect.show();
			var tween = get_tree().create_tween();
			tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 0.0, 1.0, 2.00);
			await tween.finished;
			RenderingServer.set_default_clear_color(Color.BLACK);
			get_tree().change_scene_to_file("res://scenes/Main.tscn");

var MessageTxtTween:Tween;
var MessageTxtTime:float;

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("933215ff"));
	
	%MessageTxtLabel.visible_ratio = 0.0;
	%MessageTxtLabel.text = GLOBAL.messageCardTxt;
	MessageTxtTime = %MessageTxtLabel.text.length() / 10.0;
	MessageTxtTime += 3.0;
	%SkipButton.hide();
	
	# intro animation
	%XferRect.material.set_shader_parameter("progress", 1.0);
	%XferRect.show();
	var tween = get_tree().create_tween();
	tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 1.0, 0.0, 2.00);
	await tween.finished;
	%XferRect.hide();
	
	currState = STATE.READY;

func _on_skip_button_pressed() -> void:
	if currState in [STATE.READY]:
		printt("SettingsCard ::", "SKIP BUTTON PRESSED");
		currState = STATE.EXIT;

func _on_skip_btn_timer_timeout() -> void:
	if currState in [STATE.READY]:
		printt("SettingsCard ::", "skipbtnTimer expired");
		%SkipButton.show();
