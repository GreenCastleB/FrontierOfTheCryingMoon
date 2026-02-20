extends Node2D

# The World Node.

const SPEED:int = 4;

var InputUpKey:bool = false;
var InputDownKey:bool = false;
var InputLeftKey:bool = false;
var InputRightKey:bool = false;

func _ready() -> void:
	printt("WorldNode ::", "_ready");
	printt("WorldNode ::", "spawning in room " + str(GLOBAL.spawnRoom), "loc " + str(GLOBAL.spawnLoc));
	
	# spawn room node
	var newRoomSCN:PackedScene = load("res://data/Rooms/Room" + str(GLOBAL.spawnRoom) + ".tscn");
	var newRoom = newRoomSCN.instantiate();
	%RoomLayer.add_child(newRoom);
	
	# set camera limits
	setCameraLimits();
	
	# set player position
	%Player.position = GLOBAL.spawnLoc;
	_on_player_just_moved();

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
