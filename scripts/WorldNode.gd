extends Node2D

# The World Node.

const SPEED:int = 4;

func _ready() -> void:
	printt("WorldNode ::", "_ready");
	printt("WorldNode ::", "spawning in room " + str(GLOBAL.spawnRoom), "loc " + str(GLOBAL.spawnLoc));
	
	%Player.position = GLOBAL.spawnLoc;
	_on_player_just_moved();

## parent has told us that input has stopped
func stopFromParent() -> void:
	printt("WorldNode ::", "stopFromParent");
	%Player.DIRECTION = Vector2.ZERO;

## process input that has been passed down from the parent
func inputFromParent(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		%Player.DIRECTION = Vector2.UP;
	elif event.is_action_pressed("ui_down"):
		%Player.DIRECTION = Vector2.DOWN;
	elif event.is_action_pressed("ui_left"):
		%Player.DIRECTION = Vector2.LEFT;
	elif event.is_action_pressed("ui_right"):
		%Player.DIRECTION = Vector2.RIGHT;
	
	if event.is_action_released("ui_up") and %Player.DIRECTION == Vector2.UP:
		%Player.DIRECTION = Vector2.ZERO;
	if event.is_action_released("ui_down") and %Player.DIRECTION == Vector2.DOWN:
		%Player.DIRECTION = Vector2.ZERO;
	if event.is_action_released("ui_left") and %Player.DIRECTION == Vector2.LEFT:
		%Player.DIRECTION = Vector2.ZERO;
	if event.is_action_released("ui_right") and %Player.DIRECTION == Vector2.RIGHT:
		%Player.DIRECTION = Vector2.ZERO;

func _on_player_just_moved() -> void:
	%WorldCam.position = %Player.position;
