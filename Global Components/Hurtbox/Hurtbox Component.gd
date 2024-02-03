extends Area2D

@export var Character: CharacterBody2D


func _ready():
	Character.connect("Player1Box", _player1_layer)
	Character.connect("Player2Box", _player2_layer)
	
func _player1_layer():
	set_collision_layer_value(13, true)
	set_collision_mask_value(12, true)
	print_debug(collision_layer)
	
func _player2_layer():
	set_collision_layer_value(14, true)
	set_collision_mask_value(11, true)
	print(collision_layer)
