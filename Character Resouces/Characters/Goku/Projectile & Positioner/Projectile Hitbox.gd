class_name ProjectileHitbox extends Area2D


var transition_attack: bool = false

@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D

## Send the amount of time player is stunned to hitbox.
## Attack by default are 15 - 30 frames and Heavy are 30 - 60 frames
@export_range(1, 300, 1) var Recovery_Frames: int
@export_range(1, 100, 1) var Damage: float
@export var Variable_Force: Vector2 ## Force added onto current player velocity
@export var Constant_Force: Vector2 ## Constant Force applied to player velocity
# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: int

func _process(delta: float) -> void:
	direction = Sprite.flip_h

