extends Node2D


# Play audio before the main menu to prevent stopping the player when entering.
# Scene and replaying audio again.
func _ready():
	Audio._main_menu_play()
	get_tree().change_scene_to_file("res://Game Start/Main Menu.tscn")

