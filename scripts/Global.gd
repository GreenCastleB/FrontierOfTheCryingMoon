extends Node

# Global Code.  Everybody needs to access this.

var spawnRoom:String = "FirstRoom";
var spawnLoc:Vector2i = Vector2i.ONE;

func _ready() -> void:
	printt("GLOBAL ::", "_ready");
