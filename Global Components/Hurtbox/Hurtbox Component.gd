extends Area2D

@export var Character: CharacterBody2D
@export var Stat: Node

func _ready():
	Character.connect("Player1Box", _player1_layer)
	Character.connect("Player2Box", _player2_layer)
	
func _player1_layer():
	set_collision_layer_value(13, true)
	set_collision_mask_value(12, true)
	
func _player2_layer():
	set_collision_layer_value(14, true)
	set_collision_mask_value(11, true)
	
	
func _on_area_entered(area):
	var damage = area.Damage
	var knockback_x = area.Knockback_X
	var knockback_y = area.Knockback_Y
	print(knockback_x, knockback_y, damage)

	Character.velocity = Vector2(knockback_x, knockback_y)
