extends Resource
class_name Interactable

enum TYPE {BARTENDER, WORKER, STUFFITEM};
var myType:TYPE;
var myIdx:int; # meaningless for bartender

var name:StringName:
	get():
		match myType:
			TYPE.BARTENDER:
				return "Bartender";
			TYPE.WORKER:
				return GLOBAL.workerData[myIdx]["name"];
			TYPE.STUFFITEM:
				return GLOBAL.stuffData[myIdx]["name"];
			_:
				return "Unreachable";

var flavorText:String:
	get():
		match myType:
			TYPE.BARTENDER:
				return "What can I do ya for?";
			TYPE.WORKER:
				return GLOBAL.workerData[myIdx]["flavor"];
			TYPE.STUFFITEM:
				return "An object.";
			_:
				return "Unreachable";

## only applicable for workers
var acceptedStuff:Array:
	get():
		match myType:
			TYPE.WORKER:
				return GLOBAL.workerData[myIdx]["accepts"];
			_:
				return [];

## represents interactable thing you can approach
func _init(whichType:TYPE, whichIdx:int) -> void:
	printt("Interactable ::", "init", str(whichType), str(whichIdx));
	myType = whichType;
	myIdx = whichIdx;
