extends AudioStreamPlayer2D

# Load audio sound.
var Main_Menu_Audio = load("res://Game Music/Ludum Dare 38 - Track 2.wav")
var Galvin_Map_Audio = load("res://Game Music/Galvin.wav")
var Artic_Map_Audio = load("res://Game Music/The Artic.wav")
var Character_Selection_Audio = load("res://Game Music/Ludum Dare 38 - Track 3.wav")

# Play audio when selecred by scene script on _ready(). 
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

# Repeat Audio after finish.
func _on_finished():
	play()
