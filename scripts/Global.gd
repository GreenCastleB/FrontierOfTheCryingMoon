extends Node

# Global Code.  Everybody needs to access this.

var spawnRoom:int = 1;
var spawnLoc:Vector2 = Vector2.ZERO;
var messageCardTxt:String = "stuff";

var inventoryState:Dictionary = {};

const workerData:Array[Dictionary] =\
	[{"name" = "Gregg", "spriteIdx" = 0},
	{"name" = "Padre", "spriteIdx" = 1},
	{"name" = "Herbert", "spriteIdx" = 2},
	{"name" = "Betsy", "spriteIdx" = 3}];

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
