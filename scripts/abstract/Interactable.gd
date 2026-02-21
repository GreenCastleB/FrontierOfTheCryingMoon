extends Resource
class_name Interactable

enum TYPE {BARTENDER, WORKER, STUFFITEM};
var myType:TYPE;
var myIdx:int; # meaningless for bartender

## represents interactable thing you can approach
func _init(whichType:TYPE, whichIdx:int) -> void:
	printt("Interactable ::", "init", str(whichType), str(whichIdx));
	myType = whichType;
	myIdx = whichIdx;
