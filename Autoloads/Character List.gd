extends Node

var get_player_1
var get_player_2

var check_player_1_is_called = false
var check_player_2_is_called = false


# Reminder that if script is not erroing and cannot register script. 
# Usually means that script has an error.
var get_player_1_script = preload("res://Character Resouces/Global/Player 1 Script.gd")
var get_player_2_script = preload("res://Character Resouces/Global/Player 2 Script.gd")
var get_main_player_script = preload("res://Character Resouces/Global/main_player.gd")

# Get character resouces to be called in character selection menu
var SelectCharacters = {
	"General Archfield" : preload("res://Character Resouces/General Archfield/Character Scenes/General Archfield.tscn"),
	"Hunter" : preload("res://Character Resouces/Hunter/Character Scene/Hunter.tscn"),
	"Atlantis" : preload("res://Character Resouces/Atlantis/Character Scenes/Atlantis.tscn"),
	"Nomad" : preload("res://Character Resouces/Nomad/Character Scenes/Nomad.tscn"),
	"Goku" : preload("res://Character Resouces/Goku/Character Scenes/Goku.tscn"),
	"Sakura" : preload("res://Character Resouces/Sakura/Character Scene/Sakura.tscn")
}
