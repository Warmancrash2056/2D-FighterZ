extends Node2D

var player_1_spawn = preload("res://Game Maps/Player Spawn Scripts/player_1_spawn.tscn")
var player_2_spawn = preload("res://Game Maps/Player Spawn Scripts/player_2_spawn.tscn")

@onready var player_1_position = $"Player 1 Position"
@onready var player_2_position = $"Player 2 Position"
func _ready():
	Audio._galvin_map_play()
	
	if CharacterList.check_player_1_is_called == true:
		_spawn_player_1()
		
	if CharacterList.check_player_2_is_called == true:
		_spawn_player_2()

func _spawn_player_1():
	var player_1_instance = player_1_spawn.instantiate()
	call_deferred("add_child", player_1_instance)
	player_1_instance.global_position = player_1_position.global_position
func _spawn_player_2():
	var player_2_instance = player_2_spawn.instantiate()
	call_deferred("add_child", player_2_instance)
	player_2_instance.global_position = player_2_position.global_position
