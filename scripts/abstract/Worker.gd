extends Resource
class_name Worker

static var SPRITE_SIZE:int = 20;

var spriteIdx:int;
var name:StringName;
var progress:int; # percentage complete with task
var taskItemIdx:int; # stuff they are working on

## represents a Worker (NPC that can help you)
func _init(whichWorker:int) -> void:
	self.spriteIdx = GLOBAL.workerData[whichWorker].spriteIdx;
	self.name = GLOBAL.workerData[whichWorker].name;
	progress = 0;
	taskItemIdx = -1;

## assigns a task to this worker
func assign(whichStuff:int) -> void:
	printt("Worker ::", name, "assigned " + GLOBAL.stuffData[whichStuff].name);
	GLOBAL.inventoryState["workers"].push_front(self.spriteIdx);
	taskItemIdx = whichStuff;
	progress = 0;
