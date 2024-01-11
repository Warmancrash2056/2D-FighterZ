extends Node

var galvin_player_respawn = Vector2(0,-328)
var get_player_1 = null
var get_player_2 = null
var get_main_player = null

var goku_neutral_heavy_positioner = Vector2()
var player_1_health: int
var player_2_health: int
var player_3_health: int
var lives = 2

var goku_selected = false
var general_selected = false
var hunter_selected = false
var nomad_selected = false 
var sakura_selected = false
var atlantis_selected = false
var blacksmith = false

var goku_neutral_heavy_grab_position = Vector2()

var player_1_position: Vector2
var player_2_position: Vector2
# Display Icon 
var icon 
var check_player_1_is_called = false
var check_player_2_is_called = false
var check_main_is_called = false

var player_1_facing_left = false
var player_2_facing_left= false
var main_player_facing_left = false

var goku_side_start_transition = false
var disable_mini_platform = false

# Reminder that if script is not erroing and cannot register script. 
# Usually means that script has an error.
var get_player_1_script = preload("res://Character Resouces/Global/Player 1 Script.gd")
var get_player_2_script = preload("res://Character Resouces/Global/Player 2 Script.gd")

# Get character resouces to be called in character selection menu
var SelectCharacters = {
	"General Archfield" : preload("res://Character Resouces/General Archfield/Character Scenes/General Archfield.tscn"),
	"Hunter" : preload("res://Character Resouces/Hunter/Character Scene/Hunter.tscn"),
	"Atlantis" : preload("res://Character Resouces/Atlantis/Character Scenes/Atlantis.tscn"),
	"Nomad" : preload("res://Character Resouces/Nomad/Character Scenes/Nomad.tscn"),
	"Goku" : preload("res://Character Resouces/Goku/Character Scenes/Goku.tscn"),
	"Sakura" : preload("res://Character Resouces/Sakura/Character Scene/Sakura.tscn")
}
