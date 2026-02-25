extends Node

# Global Code.  Everybody needs to access this.

var spawnRoom:int = 1;
var _prevRoom:int = 0;
var spawnLoc:Vector2 = Vector2.ZERO;
var messageCardTxt:String = "stuff";
var _timeUnitsPassed:int = 0;

var inventoryState:Dictionary = {};
var _spentObjects:Array[String] = [];
var workersState:Array[Worker] = [];

const WORK_SPEED_FAVORITE:int = 20;
const WORK_SPEED_NORMAL:int = 16;

const UI_ICON_SIZE:int = 20;

const NUM_WORKERS:int = 4;
const workerData:Array[Dictionary] =\
	[{"name" = "Gregg", "spriteIdx" = 0,\
		"flavor" = "Ain't no job too dirty for ol' Gregg.",\
		"accepts" = [1,2,3]},
	{"name" = "Padre", "spriteIdx" = 1,\
		"flavor" = "Me llamo Padre.",\
		"accepts" = [2,3]},
	{"name" = "Herbert", "spriteIdx" = 2,\
		"flavor" = "Où est mon canard?",\
		"accepts" = [2,5]},
	{"name" = "Betsy", "spriteIdx" = 3,\
		"flavor" = "I dunno what you need but I cook a mean omelet",\
		"accepts" = [4,5]}];

const NUM_STUFF:int = 6;
const stuffData:Array[Dictionary] =\
	[{"name" = "Silver bullet", "spriteIdx" = 0},
	{"name" = "Horse poop", "spriteIdx" = 1},
	{"name" = "Dynamite", "spriteIdx" = 2},
	{"name" = "Bear trap", "spriteIdx" = 3},
	{"name" = "Frying pan", "spriteIdx" = 4},
	{"name" = "Rubber ducky", "spriteIdx" = 5}];

func _ready() -> void:
	printt("GLOBAL ::", "_ready");

func setUpGame() -> void:
	printt("GLOBAL ::", "setUpGame");
	messageCardTxt = "Let me tell you the tale of a man who rode into town one day.";
	messageCardTxt += "\nThere was something, let's just say, different, about this man.";
	messageCardTxt += "\n                    ";
	messageCardTxt += "\nHe knew somethin' bad was gonna happen the next full moon.";
	messageCardTxt += "\nHe had to get the townsfolk ready.  They needed traps.";
	messageCardTxt += "\nAnd he had 'til sundown to see what they could muster.";
	
	inventoryState.clear();
	inventoryState["workers"] = [];
	inventoryState["stuff"] = [];
	inventoryState["interactable"] = null;
	
	workersState.clear();
	for i in range(workerData.size()):
		workersState.append(Worker.new(i));
	
	_timeUnitsPassed = 0;
	_spentObjects = [];
	
	# initial location of player
	spawnRoom = 1;
	_prevRoom = 0;
	spawnLoc = Vector2.ZERO;

## World has indicated the player is moving to a new room.
func goToRoom(newSpawnRoom:int, newSpawnLoc:Vector2i) -> void:
	var backAndForth:bool = newSpawnRoom == GLOBAL._prevRoom;
	printt("GLOBAL ::", "goToRoom", str(newSpawnRoom), "backAndForth=" + str(backAndForth));
	
	GLOBAL._prevRoom = GLOBAL.spawnRoom;
	GLOBAL.spawnRoom = newSpawnRoom;
	GLOBAL.spawnLoc = newSpawnLoc;
	
	#if !backAndForth: timeUnitPass();
	timeUnitPass(); # TODO: ease of testing

## A unit of gametime has passed
func timeUnitPass() -> void:
	printt("GLOBAL ::", "timeUnitPass");
	
	for thisInvWorkerIdx in inventoryState["workers"]:
		var thisInvWorker = workersState[thisInvWorkerIdx];
		if thisInvWorker.timeUnitPassed():
			# remove this worker from currents - they finished the task
			inventoryState["workers"].erase(thisInvWorkerIdx);
	
	_timeUnitsPassed += 1;
	timeUnitPassed.emit();
signal timeUnitPassed;

## an object with this name was spent; should not respawn
func registerAsSpent(objName:StringName) -> void:
	_spentObjects.append(str(spawnRoom) + ":" + objName);
	printt("GLOBAL ::", "registerAsSpent", objName);
	printt("GLOBAL ::", "_spentObjects", str(_spentObjects));
func wasObjSpent(objName:StringName) -> bool:
	return str(spawnRoom) + ":" + objName in _spentObjects;

## if frameName is a worker#, is that worker currently working?
func isNPCWorking(frameName:String) -> bool:
	for thisWorker:int in inventoryState["workers"]:
		if "worker" + str(thisWorker) == frameName: return true;
	return false;
