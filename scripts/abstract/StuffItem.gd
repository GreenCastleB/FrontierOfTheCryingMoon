extends Resource
class_name StuffItem

static var SPRITE_SIZE:int = 20;

var spriteIdx:int;
var name:StringName;

## represents a StuffItem (thing you can carry)
func _init(whichStuff:int) -> void:
	self.spriteIdx = GLOBAL.stuffData[whichStuff].spriteIdx;
	self.name = GLOBAL.stuffData[whichStuff].name;
