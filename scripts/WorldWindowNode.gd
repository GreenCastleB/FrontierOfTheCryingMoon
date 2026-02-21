extends Control

# The Control Node that holds the SubViewportContainer for the World.

var newWorldSCN:PackedScene = preload("res://scenes/WorldNode.tscn");

## State machine for WorldWindow.
enum STATE {INIT, LOADINGWORLD, READY, LEAVINGROOM};
const STATESTR:Array = ['INIT', 'LOADINGWORLD', 'READY', 'LEAVINGROOM'];
var currState:STATE = STATE.INIT:
	set(newState):
		var oldState:STATE = currState;
		currState = newState;
		var stateChange:String = STATESTR[oldState] + "->" + STATESTR[newState];
		printt("WorldWindow ::", "stateChange", stateChange);
		
		if newState == STATE.LOADINGWORLD:
			call_deferred("doIntroAnim");
		if newState == STATE.LEAVINGROOM:
			call_deferred("doOutroAnim");

func doIntroAnim() -> void:
	%XferRect.material.set_shader_parameter("progress", 1.0);
	%XferRect.show();
	var tween = get_tree().create_tween();
	tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 1.0, 0.0, 1.00);
	await tween.finished;
	%XferRect.hide();
	
	currState = STATE.READY;
	roomLoaded.emit();

func _ready() -> void:
	printt("WorldWindow ::", "_ready");
	%WorldView.get_children()[0].reloadMePlease.connect(reloadWorld);
	%WorldView.get_children()[0].doneLoading.connect(worldIsLoaded);
	%WorldView.get_children()[0].approachedNPC.connect(playerApproachingNPC);
	%WorldView.get_children()[0].departedNPC.connect(playerDepartingNPC);
	%WorldView.get_children()[0].approachedGroundStuff.connect(playerApproachingGroundStuff);
	%WorldView.get_children()[0].departedGroundStuff.connect(playerDepartingGroundStuff);
	
	currState = STATE.LOADINGWORLD;

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

signal roomReloading();
func reloadWorld() -> void:
	printt("WorldWindow ::", "reloadWorld");
	roomReloading.emit();
	
	currState = STATE.LEAVINGROOM;
func doOutroAnim() -> void:
	%XferRect.material.set_shader_parameter("progress", 0.0);
	%XferRect.show();
	var tween = get_tree().create_tween();
	tween.tween_method(func(value): %XferRect.material.set_shader_parameter("progress", value), 0.0, 1.0, 1.00);
	await tween.finished;
	%XferRect.hide();
	
	call_deferred("emptyWorldView");
func emptyWorldView() -> void:
	var kidArray = %WorldView.get_children();
	for thisKid in kidArray:
		
		thisKid.reloadMePlease.disconnect(reloadWorld);
		thisKid.doneLoading.disconnect(worldIsLoaded);
		thisKid.approachedNPC.disconnect(playerApproachingNPC);
		thisKid.departedNPC.disconnect(playerDepartingNPC);
		thisKid.approachedNPC.disconnect(playerApproachingGroundStuff);
		thisKid.departedNPC.disconnect(playerDepartingGroundStuff);
		
		%WorldView.remove_child(thisKid);
	call_deferred("insertNewWorld");
func insertNewWorld() -> void:
	var newWorldNode = newWorldSCN.instantiate();
	%WorldView.add_child(newWorldNode);
	
	newWorldNode.reloadMePlease.connect(reloadWorld);
	newWorldNode.doneLoading.connect(worldIsLoaded);
	newWorldNode.approachedNPC.connect(playerApproachingNPC);
	newWorldNode.departedNPC.connect(playerDepartingNPC);
	newWorldNode.approachedNPC.connect(playerApproachingGroundStuff);
	newWorldNode.departedNPC.connect(playerDepartingGroundStuff);
	
	currState = STATE.LOADINGWORLD;

signal roomLoaded();
signal worldApproachingNPC(whom:String);
signal worldDepartingNPC(whom:String);
signal worldApproachingGroundStuff(what:String);
signal worldDepartingGroundStuff(what:String);
func worldIsLoaded() -> void:
	printt("WorldWindow ::", "worldIsLoaded");
func playerApproachingNPC(whom) -> void:
	printt("WorldWindow ::", "playerApproachingNPC");
	worldApproachingNPC.emit(whom);
func playerDepartingNPC(whom) -> void:
	printt("WorldWindow ::", "playerDepartingNPC");
	worldDepartingNPC.emit(whom);
func playerApproachingGroundStuff(what) -> void:
	printt("WorldWindow ::", "playerApproachingGroundStuff");
	worldApproachingGroundStuff.emit(what);
func playerDepartingGroundStuff(what) -> void:
	printt("WorldWindow ::", "playerDepartingGroundStuff");
	worldDepartingGroundStuff.emit(what);
