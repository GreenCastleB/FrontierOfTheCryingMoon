extends Control

# The Inventory UI Node

const FULL_SIZE:int = 102;

## 0.0 is hidden, 1.0 is shown.
@export_range(0.0,1.0) var progress:float = 1.0:
	set(newVal):
		progress = newVal;
		var custMinSize:int = roundi(FULL_SIZE * progress);
		%Background.set_deferred("custom_minimum_size", Vector2(custMinSize, 0));
		self.set_deferred("custom_minimum_size", Vector2(custMinSize, 0));

func _ready() -> void:
	printt("InventoryUI ::", "_ready");
	updateFromInvState();

## reads GLOBAL.inventoryState and updates visual status
func updateFromInvState() -> void:
	printt("InventoryUI ::", "updateFromInvState", str(GLOBAL.inventoryState["workers"].size()), str(GLOBAL.inventoryState["stuff"].size()));
	
	for i in range(1, 5):
		if GLOBAL.inventoryState["workers"].size() < i:
			%WorkersHBox.get_node("WorkerNode"+str(i)).hide();
		else:
			var updatingNode:Control = %WorkersHBox.get_node("WorkerNode"+str(i));
			
			var iconTexture:AtlasTexture = updatingNode.get_node("Icon").texture;
			iconTexture.region.position.x = 0;
			updatingNode.get_node("Progress").value = 25.0;
			
			%WorkersHBox.get_node("WorkerNode"+str(i)).show();
	
	for i in range(1, 9):
		if GLOBAL.inventoryState["stuff"].size() < i:
			%StuffGrid.get_node("StuffNode"+str(i)).hide();
		else:
			var updatingNode:Control = %StuffGrid.get_node("StuffNode"+str(i));
			
			var iconTexture:AtlasTexture = updatingNode.get_node("Icon").texture;
			iconTexture.region.position.x = 0;
			
			%StuffGrid.get_node("StuffNode"+str(i)).show();
	
	var thisInteractable:Interactable = GLOBAL.inventoryState["interactable"];
	if thisInteractable == null:
		%TalkToLabel.text = "";
		%TalkToIcon.hide();
		%TalkButton.hide();
		%TalkToVerb.text = "";
	else:
		match thisInteractable.myType:
			Interactable.TYPE.BARTENDER:
				%TalkToLabel.text = "Bartender";
				var iconTexture:AtlasTexture = %TalkToIcon.texture;
				iconTexture.region.position.x = 20 * 10;
				%TalkToIcon.show();
				%TalkButton.show();
				%TalkToVerb.text = "Check";
			Interactable.TYPE.WORKER:
				%TalkToLabel.text = GLOBAL.workerData[thisInteractable.myIdx]["name"];
				var iconTexture:AtlasTexture = %TalkToIcon.texture;
				iconTexture.region.position.x = 20 * thisInteractable.myIdx;
				%TalkToIcon.show();
				%TalkButton.show();
				%TalkToVerb.text = "Talk";
			Interactable.TYPE.STUFFITEM:
				%TalkToLabel.text = GLOBAL.stuffData[thisInteractable.myIdx]["name"];
				var iconTexture:AtlasTexture = %TalkToIcon.texture;
				iconTexture.region.position.x = 20 * (thisInteractable.myIdx + 4);
				%TalkToIcon.show();
				%TalkButton.show();
				%TalkToVerb.text = "Get";

signal pickedUpGroundStuff();
signal talkToButtonPressed();
func _on_TalkTo_button_pressed() -> void:
	var thisInteractable:Interactable = GLOBAL.inventoryState["interactable"];
	if thisInteractable == null: return;
	match thisInteractable.myType:
		Interactable.TYPE.BARTENDER:
			talkToButtonPressed.emit();
		Interactable.TYPE.WORKER:
			talkToButtonPressed.emit();
		Interactable.TYPE.STUFFITEM:
			# pick up item immediately
			GLOBAL.inventoryState["stuff"].append(thisInteractable.myIdx);
			GLOBAL.inventoryState["interactable"] = null;
			updateFromInvState();
			pickedUpGroundStuff.emit();
