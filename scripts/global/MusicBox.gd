extends Node

# MUSIC singleton

const MIN_DB = -80.0;
var MUSIC_DB = -20.0;

class MusicBox extends Node:
	var player;
	func _init(stream):
		player = AudioStreamPlayer.new();
		add_child(player);
		player.stream = stream;
		player.volume_db = MIN_DB;
	func set_volume_db(volume_db):
		player.volume_db = volume_db;
	func play():
		player.volume_db = MUSIC.MUSIC_DB;
		player.play();

var TITLE_THEME = preload("res://assets/music/title.ogg");
var XFER_THEME = preload("res://assets/music/transition.ogg");
var GAMEOVER_THEME = preload("res://assets/music/game_over.ogg");
var NIGHT_THEME = preload("res://assets/music/hell's_good_company.ogg");
var DAY_THEME = preload("res://assets/music/blisterin'_sun.ogg");

var Jukebox:Dictionary;

const track_TITLE_THEME = "TITLE_THEME";
const track_XFER_THEME = "XFER_THEME";
const track_GAMEOVER_THEME = "GAMEOVER_THEME";
const track_NIGHT_THEME = "NIGHT_THEME";
const track_DAY_THEME = "DAY_THEME";
var currTrack = null;
var transitionTimer:Timer = Timer.new();

func _ready():
	_load_music();
	_load_timer();

func _load_timer():
	transitionTimer.one_shot = true;
	transitionTimer.autostart = false;
	transitionTimer.wait_time = 1.0;
	add_child(transitionTimer);

func _load_music():
	Jukebox["TITLE_THEME"] = MusicBox.new(TITLE_THEME);
	Jukebox["XFER_THEME"] = MusicBox.new(XFER_THEME);
	Jukebox["GAMEOVER_THEME"] = MusicBox.new(GAMEOVER_THEME);
	Jukebox["NIGHT_THEME"] = MusicBox.new(NIGHT_THEME);
	Jukebox["DAY_THEME"] = MusicBox.new(DAY_THEME);
	add_child(Jukebox["TITLE_THEME"]);
	add_child(Jukebox["XFER_THEME"]);
	add_child(Jukebox["GAMEOVER_THEME"]);
	add_child(Jukebox["NIGHT_THEME"]);
	add_child(Jukebox["DAY_THEME"]);
	Jukebox["TITLE_THEME"].player.finished.connect(_onFinishedTitleTheme);

func playTitleTheme():
	if currTrack == track_XFER_THEME:
		printt("MUSIC ::", "did not play title theme", "xfer is playing");
	elif currTrack != track_TITLE_THEME:
		printt("MUSIC ::", "will play", "Title Theme");
		if currTrack != null: Jukebox[currTrack].player.stop();
		Jukebox["TITLE_THEME"].play();
		currTrack = track_TITLE_THEME;
func _onFinishedTitleTheme():
	printt("MUSIC ::", "Title Theme finished");
	playXferTheme();
func playXferTheme():
	if currTrack != track_XFER_THEME:
		printt("MUSIC ::", "will play", "Xfer Theme");
		if currTrack != null: Jukebox[currTrack].player.stop();
		transitionTimer.start();
		await transitionTimer.timeout;
		Jukebox["XFER_THEME"].play();
		currTrack = track_XFER_THEME;
func playGameOverTheme():
	if currTrack != track_GAMEOVER_THEME:
		printt("MUSIC ::", "will play", "Gameover Theme");
		if currTrack != null: Jukebox[currTrack].player.stop();
		Jukebox["GAMEOVER_THEME"].play();
		currTrack = track_GAMEOVER_THEME;
func playNightTheme():
	if currTrack != track_NIGHT_THEME:
		printt("MUSIC ::", "will play", "Night Theme");
		if currTrack != null: Jukebox[currTrack].player.stop();
		transitionTimer.start();
		await transitionTimer.timeout;
		Jukebox["NIGHT_THEME"].play();
		currTrack = track_NIGHT_THEME;
func playDayTheme():
	if currTrack != track_DAY_THEME:
		printt("MUSIC ::", "will play", "Day Theme");
		if currTrack != null: Jukebox[currTrack].player.stop();
		transitionTimer.start();
		await transitionTimer.timeout;
		Jukebox["DAY_THEME"].play();
		currTrack = track_DAY_THEME;

func stop():
	if currTrack != null:
		printt("MUSIC ::", "stopping");
		Jukebox[currTrack].player.stop();
		currTrack = null;

func adjustVolume(level):
	MUSIC_DB = level;
	Jukebox["TITLE_THEME"].set_volume_db(level);
func getVolume() -> float:
	return MUSIC_DB;
