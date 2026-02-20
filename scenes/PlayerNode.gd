extends CharacterBody2D

# The Player Node in WorldNode

@export var SPEED:float = 8.0;

var DIRECTION:Vector2 = Vector2.ZERO;

signal justMoved;
func _physics_process(_delta: float) -> void:
	if DIRECTION != Vector2.ZERO:
		velocity = DIRECTION * SPEED;
		justMoved.emit();
	else:
		velocity = Vector2.ZERO;
	
	move_and_slide();
