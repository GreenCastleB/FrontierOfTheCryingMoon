extends Control

# The Control Node that holds the SubViewportContainer for the World.

func _ready() -> void:
	printt("WorldWindow ::", "_ready");

## parent has told us that input has stopped
func stopFromParent() -> void:
	printt("WorldNode ::", "stopFromParent");
	var WVKid = %WorldView.get_child(0);
	if WVKid != null:
		WVKid.stopFromParent();

## input that has been passed down from the parent.
## pass this into WorldView's first child (the worldNode) if it exists
func inputFromParent(event: InputEvent) -> void:
	var WVKid = %WorldView.get_child(0);
	if WVKid != null:
		WVKid.inputFromParent(event);
