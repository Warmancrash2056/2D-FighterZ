extends Area2D

@export var Knockback_X: int 
@export var Knockback_Y: int
# Called when the node enters the scene tree for the first time.

func _ready():
	owner.connect("Player1Box", _player1_layer)
	owner.connect("Player2Box", _player2_layer)
func _player1_layer():
	set_collision_layer_value(11, true)
	set_collision_mask_value(13, true)
	print_debug(collision_layer)
func _player2_layer():
	set_collision_layer_value(12, true)
	set_collision_mask_value(14, true)
	print_debug("player 2 goood")
