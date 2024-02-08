extends Area2D

@export var Character: CharacterBody2D
@export var Stat: Node

@export var Damage: int
@export var Recovery_Frames: int
@export var Knockback_X: int 
@export var Knockback_Y: int

var attack_reset = false
signal Attack_Connected
# Called when the node enters the scene tree for the first time.

func _ready():
	Character.connect("Player1Box", _player1_hitbox)
	Character.connect("Player2Box", _player2_hitbox)
	
func _player1_hitbox():
	set_collision_layer_value(11, true) 
	set_collision_mask_value(14, true)
	print_debug("Player 1 ",collision_layer," | ", collision_mask)
func _player2_hitbox():
	set_collision_layer_value(12, true)
	set_collision_mask_value(13, true)
	print_debug("Player 2 ",collision_layer," | ", collision_mask)


func _on_area_entered(area):
	emit_signal("Attack_Connected",)


func _on_attack_connected():
	Stat.Attack_Reset = true
