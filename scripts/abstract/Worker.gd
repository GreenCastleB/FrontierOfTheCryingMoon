extends Resource
class_name Worker

static var SPRITE_SIZE:int = 20;

var spriteIdx:int;
var name:StringName;
var progress:int; # percentage complete with task

## represents a Worker (NPC that can help you)
func _init(whichWorker:int) -> void:
	self.spriteIdx = GLOBAL.workerData[whichWorker].spriteIdx;
	self.name = GLOBAL.workerData[whichWorker].name;
	
	progress = 0;
