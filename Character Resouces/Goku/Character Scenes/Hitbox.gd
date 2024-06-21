class_name Hitbox extends Area2D

@export var Sprite: Sprite2D
@export var Stun_Time: float ## Send the amount of time player is stunned to hitbox
@export var Damage: int
@export var Variable_Force: Vector2 ## Force added onto current player velocity
@export var Constant_Force: Vector2 ## Constant Force applied to player velocity
# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: int

func _process(delta: float) -> void:
	direction = Sprite.flip_h



