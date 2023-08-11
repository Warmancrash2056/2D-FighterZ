extends Node

# Get the player 
var get_player_1
var get_player_2
var get_main_player

# If player is called set true to move to map selction.
var check_player_1_is_called = false
var check_player_2_is_called = false
var check_main_is_called = false

# Check if player is facing left for each player script. 
var player_1_facing_left = false
var player_2_facing_left= false
var main_player_facing_left = false

# Disable all small platforms. 
# Hunter has the ability to root a platform to prevent the opponent from climbing this does not effect the user. 
var disable_mini_platform = false

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
