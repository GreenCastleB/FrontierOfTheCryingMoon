extends Control

# The Control Node that holds the SubViewportContainer for the World.

func _ready() -> void:
	printt("WorldWindow ::", "_ready");

func inputFromParent(event: InputEvent) -> void:
	# input that has been passed down from the parent.
	# pass this into WorldView's first child (the worldNode) if it exists
	
	printt("WorldWindow ::", "inputFromParent");
	
	var WVKid = %WorldView.get_child(0);
	if WVKid != null:
		WVKid.inputFromParent(event);
