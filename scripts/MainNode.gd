extends MarginContainer

# The Main Node

## State machine for Main Node.
enum STATE {INIT, WALKING, ENTER_DIALOG, DIALOG, EXIT_DIALOG, ROOM_XFER};
const STATESTR:Array = ['INIT', 'WALKING', 'ENTER_DIALOG', 'DIALOG', 'EXIT_DIALOG', 'ROOM_XFER'];
var currState:STATE = STATE.INIT:
	set(newState):
		var oldState:STATE = currState;
		currState = newState;
		var stateChange:String = STATESTR[oldState] + "->" + STATESTR[newState];
		printt("MainNode ::", "stateChange", stateChange);
		match stateChange:
			"INIT->WALKING":
				%CoolTimer.start();
			"WALKING->ENTER_DIALOG":
				%MainTimer.paused = true;
				SOUND.play("npc_interact");
				%DialogUI.show();
				%Anim.play("ShowDialog");
				%WorldWindow.stopFromParent();
			"ENTER_DIALOG->DIALOG":
				pass;
			"DIALOG->EXIT_DIALOG":
				%InventoryUI.show();
				%Anim.play("HideDialog");
			"EXIT_DIALOG->WALKING":
				%MainTimer.paused = false;
			"WALKING->ROOM_XFER":
				%CoolTimer.stop();
				%MainTimer.stop();
			"ROOM_XFER->WALKING":
				%CoolTimer.start();
		
		%InventoryUI.setTSBtnsVisible(newState == STATE.WALKING);
		%DialogUI.setTSBtnsVisible(newState == STATE.DIALOG);

# States & Transitions

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
func _on_world_window_room_loaded() -> void:
	printt("MainNode ::", "_on_world_window_room_loaded");
	currState = STATE.WALKING;
func _on_world_window_room_reloading() -> void:
	printt("MainNode ::", "_on_world_window_room_reloading");
	currState = STATE.ROOM_XFER;

func _ready() -> void:
	printt("MainNode ::", "_ready");
	MUSIC.playDayTheme();

# Input

func _input(event: InputEvent) -> void:
	if currState in [STATE.WALKING]:
		# pass input into WorldWindow who will pass it to WorldNode
		%WorldWindow.inputFromParent(event);
	if currState in [STATE.DIALOG]:
		# if dialog is open, cancel or left should get out of it
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_left"):
			SOUND.play("ui_select_2");
			currState = STATE.EXIT_DIALOG;

# NPC interaction

func _on_world_window_world_approaching_npc(whom: String) -> void:
	printt("MainNode ::", "_on_world_window_world_approaching_npc", whom);
	if whom == "bartender":
		GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.BARTENDER, 0);
	elif whom.begins_with("worker"): # e.g. "worker2"
		GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.WORKER, whom.to_int());
	%InventoryUI.updateFromInvState();
func _on_world_window_world_departing_npc(whom: String) -> void:
	printt("MainNode ::", "_on_world_window_world_departing_npc", whom);
	GLOBAL.inventoryState["interactable"] = null;
	%InventoryUI.updateFromInvState();
func _on_inventory_ui_talk_to_button_pressed() -> void:
	printt("MainNode ::", "_on_inventory_ui_talk_to_button_pressed");
	if currState in [STATE.WALKING]:
		%DialogUI.prepareForInteraction();
		%InventoryUI.clearInteractable();
		currState = STATE.ENTER_DIALOG;

# Ground Stuff interaction

func _on_world_window_world_approaching_ground_stuff(what: String) -> void:
	printt("MainNode ::", "_on_world_window_world_approaching_ground_stuff", what);
	GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.STUFFITEM, int(what));
	%InventoryUI.updateFromInvState();
func _on_world_window_world_departing_ground_stuff(what: String) -> void:
	printt("MainNode ::", "_on_world_window_world_departing_ground_stuff", what);
	GLOBAL.inventoryState["interactable"] = null;
	%InventoryUI.updateFromInvState();
func _on_inventory_ui_picked_up_ground_stuff() -> void:
	printt("MainNode ::", "_on_inventory_ui_picked_up_ground_stuff");
	%WorldWindow.killInteractableFromParent(false);

func _on_dialog_ui_WorkerAssignedTask() -> void:
	printt("MainNode ::", "_on_dialog_ui_WorkerAssignedTask");
	%InventoryUI.updateFromInvState();
	%WorldWindow.killInteractableFromParent(true);
	SOUND.play("npc_affirmative");
	currState = STATE.EXIT_DIALOG;

## The CoolTimer is run for the first 2 seconds when the player gets control.
func _on_cool_timer_timeout() -> void:
	if currState in [STATE.WALKING]:
		printt("MainNode ::", "CoolTimer expired", "MainTimer starting");
		%MainTimer.start();

## After 2 seconds, any time the player uses will come out of the Main Timer.
func _on_main_timer_timeout() -> void:
	if currState in [STATE.WALKING]:
		printt("MainNode ::", "MainTimer expired");
		GLOBAL.timeUnitPass();
