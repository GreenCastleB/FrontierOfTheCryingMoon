extends CharacterBody2D

# The Player Node in WorldNode

@export var SPEED:float = 50.0;
@onready var mySprite = get_node("PlayerSprite");

var DIRECTION:Vector2 = Vector2.ZERO;

signal justMoved;
func _physics_process(_delta: float) -> void:
	if DIRECTION != Vector2.ZERO:
		velocity = DIRECTION * SPEED;
		justMoved.emit();
		mySprite.play("walk");
		if velocity.x > 0: mySprite.scale.x = 1;
		elif velocity.x < 0: mySprite.scale.x = -1;
	else:
		velocity = Vector2.ZERO;
		mySprite.play("idle");
	
	move_and_slide();
