extends Node

# Centralized SFX management.

const MIN_DB = -80.0;
var SFX_DB = -9.0;

const SAMPLES = {
	"gun_armed": preload("res://assets/sounds/gun_armed.ogg"),
	"gun_shot_high": preload("res://assets/sounds/gun_shot_high.ogg"),
	"gun_shot_mid": preload("res://assets/sounds/gun_shot_mid.ogg"),
	"gun_shot_low": preload("res://assets/sounds/gun_shot_low.ogg"),
	"npc_affirmative": preload("res://assets/sounds/npc_affirmative.ogg"),
	"npc_death": preload("res://assets/sounds/npc_death.ogg"),
	"npc_interact": preload("res://assets/sounds/npc_interact.ogg"),
	"player_death": preload("res://assets/sounds/player_death.ogg"),
	"trap_built": preload("res://assets/sounds/trap_built.ogg"),
	"ui_select_1": preload("res://assets/sounds/ui_select_1.ogg"),
	"ui_select_2": preload("res://assets/sounds/ui_select_2.ogg"),
	"ui_select_3": preload("res://assets/sounds/ui_select_3.ogg"),
	"werewolf_attack": preload("res://assets/sounds/werewolf_attack.ogg"),
	"werewolf_death": preload("res://assets/sounds/werewolf_death.ogg"),
	"werewolf_howl": preload("res://assets/sounds/werewolf_howl.ogg")
}

const POOL_SIZE = 6;
var pool = [];
# Index of the current audio player in the pool.
var next_player = 0;

func _ready():
	_init_stream_players();

func _init_stream_players():
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new();
		add_child(player);
		pool.append(player);

func _get_next_player_idx():
	var next = next_player;
	next_player = (next_player + 1) % POOL_SIZE;
	return next;

func play(sample):
	assert(sample in SAMPLES);
	var stream = SAMPLES[sample];
	var idx = _get_next_player_idx();
	printt("SOUND ::", "playing " + sample);

	var player = pool[idx];
	player.stream = stream;
	player.volume_db = SFX_DB;
	player.play();

func adjustVolume(level):
	SFX_DB = level;
	play("confirm");
func getVolume() -> float:
	return SFX_DB;
