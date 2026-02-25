extends Node2D

# The World Node.

var InputUpKey:bool = false;
var InputDownKey:bool = false;
var InputLeftKey:bool = false;
var InputRightKey:bool = false;

## State machine for WorldNode.
enum STATE {INIT, READY, EXIT};
const STATESTR:Array = ['INIT', 'READY', 'EXIT'];
var currState:STATE = STATE.INIT:
	set(newState):
		var oldState:STATE = currState;
		currState = newState;
		var stateChange:String = STATESTR[oldState] + "->" + STATESTR[newState];
		printt("WorldNode ::", "stateChange", stateChange);
		
		if newState == STATE.READY:
			doneLoading.emit();
		if newState == STATE.EXIT:
			loadNewRoom();

signal doneLoading();
func _ready() -> void:
	printt("WorldNode ::", "_ready");
	printt("WorldNode ::", "spawning in room " + str(GLOBAL.spawnRoom), "loc " + str(GLOBAL.spawnLoc));
	
	# spawn room node
	var newRoomSCN:PackedScene = load("res://data/Rooms/Room" + str(GLOBAL.spawnRoom) + ".tscn");
	var newRoom = newRoomSCN.instantiate();
	%RoomLayer.add_child(newRoom);
	
	setupDoorways();
	setupNPCs();
	setupGroundStuffs();
	
	setCameraLimits();
	
	# set player position
	%Player.position = GLOBAL.spawnLoc;
	_on_player_just_moved();
	
	currState = STATE.READY;

## Make sure to call this after instantiating the room.
func setCameraLimits() -> void:
	assert(%RoomLayer.get_children().size() > 0);
	var terrainNode = %RoomLayer.get_children()[0].get_node("Terrain");
	var usedRect:Rect2 = terrainNode.get_used_rect();
	var cellSize:Vector2i = terrainNode.tile_set.tile_size;
	%WorldCam.limit_left = usedRect.position.x * cellSize.x;
	%WorldCam.limit_top = usedRect.position.y * cellSize.y;
	%WorldCam.limit_right = usedRect.end.x * cellSize.x;
	%WorldCam.limit_bottom = usedRect.end.y * cellSize.y;

## Make sure to call this after instantiating the room.
func setupDoorways() -> void:
	assert(%RoomLayer.get_children().size() > 0);
	var doorwaysNode = %RoomLayer.get_children()[0].get_node("Doorways");
	var doorwaysArray = doorwaysNode.get_children();
	for thisDoorNode:Area2D in doorwaysArray:
		printt("WorldNode ::", "setupDoorways", "found door", thisDoorNode.editor_description);
		thisDoorNode.body_entered.connect(doorwayEntered.bind(thisDoorNode.editor_description));

## Make sure to call this after instantiating the room.
func setupNPCs() -> void:
	assert(%RoomLayer.get_children().size() > 0);
	var NPCsNode = %RoomLayer.get_children()[0].get_node("NPCs");
	var NPCsArray = NPCsNode.get_children();
	for thisNPCNode:CharacterBody2D in NPCsArray:
		printt("WorldNode ::", "setupNPCs", "found npc", thisNPCNode.editor_description);
		if GLOBAL.isNPCWorking(thisNPCNode.editor_description):
			# this shouldn't be here
			thisNPCNode.queue_free();
		else:
			# ok to init NPC
			thisNPCNode.get_node("Sprite").play(thisNPCNode.editor_description);
			thisNPCNode.get_node("TalkArea").body_entered.connect(NPCEntered.bind(thisNPCNode.editor_description, thisNPCNode));
			thisNPCNode.get_node("TalkArea").body_exited.connect(NPCExited.bind(thisNPCNode.editor_description));

## Make sure to call this after instantiating the room.
func setupGroundStuffs() -> void:
	assert(%RoomLayer.get_children().size() > 0);
	var GroundStuffsNode = %RoomLayer.get_children()[0].get_node("GroundStuffs");
	var GroundStuffsArray = GroundStuffsNode.get_children();
	for thisGroundStuffNode:CharacterBody2D in GroundStuffsArray:
		printt("WorldNode ::", "setupGroundStuffs", "found stuff", thisGroundStuffNode.editor_description);
		if GLOBAL.wasObjSpent(thisGroundStuffNode.name):
			# this shouldn't be here
			thisGroundStuffNode.queue_free();
		else:
			# ok to init groundstuff
			thisGroundStuffNode.get_node("Sprite").frame = int(thisGroundStuffNode.editor_description);
			thisGroundStuffNode.get_node("TalkArea").body_entered.connect(GroundStuffEntered.bind(thisGroundStuffNode.editor_description, thisGroundStuffNode));
			thisGroundStuffNode.get_node("TalkArea").body_exited.connect(GroundStuffExited.bind(thisGroundStuffNode.editor_description));

signal approachedNPC(whom:String);
signal departedNPC(whom:String);
func NPCEntered(body:Node2D, notes:String, linkback) -> void:
	printt("WorldNode ::", "NPCEntered", body.name, notes);
	if body.name != "Player": return;
	currInteractableBody = linkback;
	approachedNPC.emit(notes);
func NPCExited(body:Node2D, notes:String) -> void:
	printt("WorldNode ::", "NPCExited", body.name, notes);
	if body.name != "Player": return;
	currInteractableBody = null;
	departedNPC.emit(notes);

signal approachedGroundStuff(whom:String);
signal departedGroundStuff(whom:String);
func GroundStuffEntered(body:Node2D, notes:String, linkback) -> void:
	printt("WorldNode ::", "GroundStuffEntered", body.name, notes);
	if body.name != "Player": return;
	currInteractableBody = linkback;
	approachedGroundStuff.emit(notes);
func GroundStuffExited(body:Node2D, notes:String) -> void:
	printt("WorldNode ::", "GroundStuffExited", body.name, notes);
	if body.name != "Player": return;
	currInteractableBody = null;
	departedGroundStuff.emit(notes);

var currInteractableBody = null;
## parent is telling us that we need to eliminate the body we just interacted with
## because, for instance, it's an item that's been picked up
func killInteractableFromParent(poof:bool = false) -> void:
	printt("WorldNode ::", "killInteractableFromParent", "poof=" + str(poof));
	if currInteractableBody == null: return;
	GLOBAL.registerAsSpent(currInteractableBody.name);
	currInteractableBody.queue_free();

func doorwayEntered(_body:Node2D, notes:String) -> void:
	printt("WorldNode ::", "doorwayEntered", notes);
	var notesExp = notes.split("|");
	
	GLOBAL.goToRoom(int(notesExp[0]), Vector2i(int(notesExp[1]), int(notesExp[2])));
	stopFromParent();
	currState = STATE.EXIT;

signal reloadMePlease;
func loadNewRoom() -> void:
	printt("WorldNode ::", "loadNewRoom", "reloadMePlease");
	reloadMePlease.emit();

## parent has told us that input has stopped
func stopFromParent() -> void:
	printt("WorldNode ::", "stopFromParent");
	
	InputUpKey = false;
	InputDownKey = false;
	InputLeftKey = false;
	InputRightKey = false;
	%Player.DIRECTION = Vector2.ZERO;

## process input that has been passed down from the parent
func inputFromParent(event: InputEvent) -> void:
	if currState != STATE.READY: return;
	
	if event.is_action_pressed("ui_up"):
		InputUpKey = true;
		%Player.DIRECTION.y = -1;
	elif event.is_action_pressed("ui_down"):
		InputDownKey = true;
		%Player.DIRECTION.y = 1;
	elif event.is_action_pressed("ui_left"):
		InputLeftKey = true;
		%Player.DIRECTION.x = -1;
	elif event.is_action_pressed("ui_right"):
		InputRightKey = true;
		%Player.DIRECTION.x = 1;
	
	if event.is_action_released("ui_up"):
		InputUpKey = false;
		%Player.DIRECTION.y = 1 if InputDownKey else 0;
	if event.is_action_released("ui_down"):
		InputDownKey = false;
		%Player.DIRECTION.y = -1 if InputUpKey else 0;
	if event.is_action_released("ui_left"):
		InputLeftKey = false;
		%Player.DIRECTION.x = 1 if InputRightKey else 0;
	if event.is_action_released("ui_right"):
		InputRightKey = false;
		%Player.DIRECTION.x = -1 if InputLeftKey else 0;

func _on_player_just_moved() -> void:
	%WorldCam.position = %Player.position;
