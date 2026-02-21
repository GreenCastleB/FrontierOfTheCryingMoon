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
			"WALKING->ENTER_DIALOG":
				%DialogUI.show();
				%Anim.play("ShowDialog");
				%WorldWindow.stopFromParent();
			"ENTER_DIALOG->DIALOG":
				pass;
			"DIALOG->EXIT_DIALOG":
				%InventoryUI.show();
				%Anim.play("HideDialog");
			"EXIT_DIALOG->WALKING":
				pass;

func _ready() -> void:
	printt("MainNode ::", "_ready");
	MUSIC.playDayTheme();

func _input(event: InputEvent) -> void:
	if currState in [STATE.WALKING]:
		# pass input into WorldWindow who will pass it to WorldNode
		%WorldWindow.inputFromParent(event);

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


func _on_world_window_world_approaching_npc(whom: String) -> void:
	printt("MainNode ::", "_on_world_window_world_approaching_npc", whom);
	match whom:
		"bartender":
			GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.BARTENDER, 0);
		"worker0":
			GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.WORKER, 0);
		"worker1":
			GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.WORKER, 1);
		"worker2":
			GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.WORKER, 2);
		"worker3":
			GLOBAL.inventoryState["interactable"] = Interactable.new(Interactable.TYPE.WORKER, 3);
	%InventoryUI.updateFromInvState();

func _on_world_window_world_departing_npc(whom: String) -> void:
	printt("MainNode ::", "_on_world_window_world_departing_npc", whom);
	GLOBAL.inventoryState["interactable"] = null;
	%InventoryUI.updateFromInvState();

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
	%WorldWindow.killInteractableFromParent();

func _on_inventory_ui_talk_to_button_pressed() -> void:
	pass # Replace with function body.
