extends Area2D


@export var Recovery_Time: float
@export var Damage: int
@export var Knockback_X: int
@export var Knockback_Y: int

# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: int


func _on_hurtbox_player_1_setting() -> void:
	pass # Replace with function body.
