extends Node

# Global Code.  Everybody needs to access this.

var spawnRoom:String = "FirstRoom";
var spawnLoc:Vector2i = Vector2i.ONE;
var messageCardTxt:String = "stuff";

func _ready() -> void:
	printt("GLOBAL ::", "_ready");

func setUpGame() -> void:
	printt("GLOBAL ::", "setUpGame");
	messageCardTxt = "Let me tell you the tale of a man who rode into town one day.";
	messageCardTxt += "\nThere was something, let's just say, different, about this man.";
