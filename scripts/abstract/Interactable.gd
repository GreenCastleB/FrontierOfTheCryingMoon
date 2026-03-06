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
				var totalTraps:int = GLOBAL.totalAccomplishments();
				var totalHours:int = GLOBAL.timeUnitsPassed / 4;
				if totalTraps == 0 and totalHours == 0:
					return "Howdy, stranger.\n\nWhat can I do ya for?";
				
				var flavor:String = "";
				
				if totalHours == 1:
					flavor += "Welp, that's one hour gone.  ";
				elif totalHours > 1:
					flavor += "You've passed " + str(totalHours) + " hours.  ";
				
				if totalTraps == 1:
					flavor += "You've set up one trap.  Think that'll be enough?";
				elif totalTraps > 1:
					flavor += "Now we got " + str(totalTraps) + " traps.";
				
				return flavor;
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
