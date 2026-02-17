extends MarginContainer

# The Main Node

## State machine for Main Node.
enum STATE {INIT, WALKING, ENTER_DIALOG, DIALOG, EXIT_DIALOG};
const STATESTR:Array = ['INIT', 'WALKING', 'ENTER_DIALOG', 'DIALOG', 'EXIT_DIALOG'];
var currState:STATE = STATE.INIT:
	set(newState):
		var oldState:STATE = currState;
		currState = newState;
		var stateChange:String = STATESTR[oldState] + "->" + STATESTR[newState];
		printt("MainNode ::", "stateChange", stateChange);
		match stateChange:
			"WALKING->ENTER_DIALOG":
				%DialogUI.show();
				%Anim.play("ShowDialog");
			"ENTER_DIALOG->DIALOG":
				pass;
			"DIALOG->EXIT_DIALOG":
				%InventoryUI.show();
				%Anim.play("HideDialog");
			"EXIT_DIALOG->WALKING":
				pass;

func _ready() -> void:
	printt("MainNode ::", "_ready");
	currState = STATE.WALKING;

func _input(event: InputEvent) -> void:
	if currState in [STATE.WALKING]:
		if (event.is_action_pressed("ui_right")):
			printt("MainNode ::", "Walking Input", "ui_right");
			currState = STATE.ENTER_DIALOG;
	elif currState in [STATE.DIALOG]:
		if (event.is_action_pressed("ui_left")):
			printt("MainNode ::", "Dialog Input", "ui_left");
			currState = STATE.EXIT_DIALOG;

func _on_anim_finished(anim_name: StringName) -> void:
	var animFin:String = STATESTR[currState] + ":" + anim_name;
	printt("MainNode ::", "animFin", animFin);
	match animFin:
		"ENTER_DIALOG:ShowDialog":
			%InventoryUI.hide();
			currState = STATE.DIALOG;
		"EXIT_DIALOG:HideDialog":
			%DialogUI.hide();
			currState = STATE.WALKING;
