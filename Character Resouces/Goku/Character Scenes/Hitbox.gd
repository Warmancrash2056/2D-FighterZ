extends Area2D


@export var Recovery_Time: float
@export var Damage: int
@export var Knockback_X: int
@export var Knockback_Y: int

# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: int


func _on_hurtbox_player_1_setting() -> void:
	set_collision_layer_value(6, true)
	set_collision_mask_value(9, true)


func _on_hurtbox_player_2_setting() -> void:
	set_collision_layer_value(10, true)
	set_collision_mask_value(5, true)

