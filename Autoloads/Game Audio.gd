extends AudioStreamPlayer2D

var Main_Menu_Audio = load("res://Game Music/Ludum Dare 38 - Track 2.wav")
var Galvin_Map_Audio = load("res://Game Music/Galvin.wav")
var Artic_Map_Audio = load("res://Game Music/The Artic.wav")
var Character_Selection_Audio = load("res://Game Music/Ludum Dare 38 - Track 3.wav")
var intro_studio = load("res://wind/Wind.ogg")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _main_menu_play():
	stream = Main_Menu_Audio
	play()

func _galvin_map_play():
	stream = Galvin_Map_Audio
	play()

func _artic_map_play():
	stream = Artic_Map_Audio
	play()

func _character_select_play():
	stream = Character_Selection_Audio
	play()

func _studio_play():
	stream = intro_studio
	play()
func _on_finished():
	play()
