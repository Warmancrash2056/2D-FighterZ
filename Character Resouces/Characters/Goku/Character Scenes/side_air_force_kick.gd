extends Area2D

@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D
@onready var Player_Stats = $'../../Player Stats'

## Send the amount of time player is stunned to hitbox.
## Attack by default are 15 - 30 frames and Heavy are 30 - 60 frames
@export_range(1, 1000, 1) var Recovery_Frames: int
@export_range(1, 1000, 1) var Damage: float
@export var Variable_Force: Vector2 ## Force added onto current player velocity
@export var Constant_Force: Vector2 ## Constant Force applied to player velocity

func _on_area_entered(area:Area2D) -> void:
	pass # Replace with function body.
