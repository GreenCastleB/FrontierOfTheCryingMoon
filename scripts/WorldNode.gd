extends Node2D

# The World Node.

func _ready() -> void:
	printt("WorldNode ::", "_ready");
	printt("WorldNode ::", "spawning at", GLOBAL.spawnRoom, str(GLOBAL.spawnLoc));

func inputFromParent(event: InputEvent) -> void:
	# process input that has been passed down from the parent
	
	var didPlayerMove:bool = false;
	
	if event.is_action_pressed("ui_up"):
		%Player.position.y -= 4;
		didPlayerMove = true;
	elif event.is_action_pressed("ui_down"):
		%Player.position.y += 4;
		didPlayerMove = true;
	elif event.is_action_pressed("ui_left"):
		%Player.position.x -= 4;
		didPlayerMove = true;
	elif event.is_action_pressed("ui_right"):
		%Player.position.x += 4;
		didPlayerMove = true;
	
	if didPlayerMove:
		%WorldCam.position = %Player.position;
