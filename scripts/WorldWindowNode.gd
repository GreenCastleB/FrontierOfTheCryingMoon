extends Control

# The Control Node that holds the SubViewportContainer for the World.

var newWorldSCN:PackedScene = preload("res://scenes/WorldNode.tscn");

func _ready() -> void:
	printt("WorldWindow ::", "_ready");
	%WorldView.get_children()[0].reloadMePlease.connect(reloadWorld);

## parent has told us that input has stopped
func stopFromParent() -> void:
	printt("WorldWindow ::", "stopFromParent");
	var WVKid = %WorldView.get_child(0);
	if WVKid != null:
		WVKid.stopFromParent();

## input that has been passed down from the parent.
## pass this into WorldView's first child (the worldNode) if it exists
func inputFromParent(event: InputEvent) -> void:
	var WVKid = %WorldView.get_child(0);
	if WVKid != null:
		WVKid.inputFromParent(event);

func reloadWorld() -> void:
	printt("WorldWindow ::", "reloadWorld");
	var kidArray = %WorldView.get_children();
	for thisKid in kidArray:
		thisKid.reloadMePlease.disconnect(reloadWorld);
		%WorldView.remove_child(thisKid);
	
	var newWorldNode = newWorldSCN.instantiate();
	%WorldView.add_child(newWorldNode);
	newWorldNode.reloadMePlease.connect(reloadWorld);
