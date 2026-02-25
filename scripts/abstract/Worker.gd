extends Resource
class_name Worker

static var SPRITE_SIZE:int = 20;

var spriteIdx:int;
var name:StringName;
var progress:int; # percentage complete with task
var taskItemIdx:int; # stuff they are working on
var accomplished:Array[int]; # indices of stuffItems this worker has finished
var myData:Dictionary:
	get():
		return GLOBAL.workerData[spriteIdx];

## represents a Worker (NPC that can help you)
func _init(whichWorker:int) -> void:
	self.spriteIdx = GLOBAL.workerData[whichWorker].spriteIdx;
	self.name = GLOBAL.workerData[whichWorker].name;
	progress = 0;
	taskItemIdx = -1;
	accomplished.clear();

## assigns a task to this worker
func assign(whichStuff:int) -> void:
	printt("Worker ::", name, "assigned " + GLOBAL.stuffData[whichStuff].name);
	GLOBAL.inventoryState["workers"].push_front(self.spriteIdx);
	taskItemIdx = whichStuff;
	progress = 0;

## Global has told all the currently working workers that a time unit has passed.
## Return true if, after this time passed, the worker completed the task.
func timeUnitPassed() -> bool:
	printt("Worker ::", name, "timeUnitPassed");
	assert(taskItemIdx > -1); # shouldn't be called on Workers not working on anything
	
	if taskItemIdx == myData["accepts"][0]:
		progress += GLOBAL.WORK_SPEED_FAVORITE;
	else: progress += GLOBAL.WORK_SPEED_NORMAL;
	printt("Worker ::", name, "progress = " + str(progress));
	
	if progress >= 100:
		accomplished.append(taskItemIdx);
		printt("Worker ::", name, "accomplished " + str(accomplished));
		taskItemIdx = -1;
		progress = 0;
		return true;
	else: return false;
