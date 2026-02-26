extends Control

# The Dialog UI Node

const FULL_SIZE:int = 102;

## 0.0 is hidden, 1.0 is shown.
@export_range(0.0,1.0) var progress:float = 1.0:
	set(newVal):
		progress = newVal;
		var custMinSize:int = roundi(FULL_SIZE * progress);
		%Background.set_deferred("custom_minimum_size", Vector2(custMinSize, 0));
		self.set_deferred("custom_minimum_size", Vector2(custMinSize, 0));

func _ready() -> void:
	printt("DialogUI ::", "_ready");
	var ACkids:Array = %ActionsContainer.get_children();
	ACkids[0].get_node("Icon").get_node("Button").pressed.connect(actionButtonClick.bind(0));
	ACkids[1].get_node("Icon").get_node("Button").pressed.connect(actionButtonClick.bind(1));
	ACkids[2].get_node("Icon").get_node("Button").pressed.connect(actionButtonClick.bind(2));

## shows or hides touchscreen button at bottom
func setTSBtnsVisible(newState:bool) -> void:
	%ActionsContainer.visible = newState;
	%TSBackBtn.visible = newState and DisplayServer.is_touchscreen_available();

func prepareForInteraction() -> void:
	var target:Interactable = GLOBAL.inventoryState["interactable"];
	assert(target != null);
	printt("DialogUI ::", "prepareForInteraction with", target.name);
	%NPCName.text = target.name;
	%NPCDialog.text = target.flavorText;
	populateActionsContainer(target);

func populateActionsContainer(thisNPC:Interactable) -> void:
	printt("DialogUI ::", "populateActionsContainer for", thisNPC.name);
	for i in range(1, 4):
		if thisNPC.acceptedStuff.size() < i:
			%ActionsContainer.get_node("StuffNode"+str(i)).hide();
		else:
			var updatingNode:Control = %ActionsContainer.get_node("StuffNode"+str(i));
			
			var iconTexture:AtlasTexture = updatingNode.get_node("Icon").get_node("Icon").texture;
			iconTexture.region.position.x = GLOBAL.UI_ICON_SIZE * thisNPC.acceptedStuff[i-1];
			
			# does the player actually have at least one of this thing?
			if thisNPC.acceptedStuff[i-1] in GLOBAL.inventoryState["stuff"]:
				%ActionsContainer.get_node("StuffNode"+str(i)).show();
			else: %ActionsContainer.get_node("StuffNode"+str(i)).hide();

signal workerWasAssignedTask;

## assigns a worker this stuffItem to work on and removes that item from inventory
## assumes this is a WORKER, as this is currently the only interactable type using buttons
func actionButtonClick(which:int) -> void: # which is 0..2
	printt("DialogUI ::", "actionButtonClick", str(which));
	var thisInteractable:Interactable = GLOBAL.inventoryState["interactable"];
	assert(thisInteractable != null);
	assert(thisInteractable.myType == Interactable.TYPE.WORKER);
	
	GLOBAL.workersState[thisInteractable.myIdx].assign(thisInteractable.acceptedStuff[which]);
	GLOBAL.inventoryState["stuff"].erase(thisInteractable.acceptedStuff[which]);
	
	workerWasAssignedTask.emit();
