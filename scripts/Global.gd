extends Node

# Global Code.  Everybody needs to access this.

var spawnRoom:String = "FirstRoom";
var spawnLoc:Vector2i = Vector2i.ONE;
var messageCardTxt:String = "stuff";

var inventoryState:Dictionary = {};

const workerData:Array[Dictionary] =\
	[{"name" = "Bartender", "spriteIdx" = 0},
	{"name" = "Tim", "spriteIdx" = 1}];

const stuffData:Array[Dictionary] =\
	[{"name" = "Silver bullet", "spriteIdx" = 0},
	{"name" = "Horse poop", "spriteIdx" = 1},
	{"name" = "Dynamite", "spriteIdx" = 2},
	{"name" = "Bear trap", "spriteIdx" = 3}];

func _ready() -> void:
	printt("GLOBAL ::", "_ready");

func setUpGame() -> void:
	printt("GLOBAL ::", "setUpGame");
	messageCardTxt = "Let me tell you the tale of a man who rode into town one day.";
	messageCardTxt += "\nThere was something, let's just say, different, about this man.";
	
	inventoryState.clear();
	inventoryState["workers"] = [];
	inventoryState["stuff"] = [];
	inventoryState["interactable"] = null;
