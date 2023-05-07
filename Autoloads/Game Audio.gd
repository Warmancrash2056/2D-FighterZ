extends AudioStreamPlayer

var Main_Menu_Audio = load("res://Game Music/Main Menu Music.wav")
var Galvin_Map_Audio = load("res://Game Music/Galvin.wav")
var Artic_Map_Audio = load("res://Game Music/The Artic.wav")
var Studio_Logo_Audio = load("res://Game Music/Logo Sound.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _main_menu_play():
	stream = Main_Menu_Audio
	play()
	
func _galvin_map_play():
	stream = Galvin_Map_Audio
	play()
	
func _artic_map_audio():
	stream = Artic_Map_Audio
	play()
	
func _logo_play_audio():
	stream = Studio_Logo_Audio
	play()


func _on_finished():
	play()
