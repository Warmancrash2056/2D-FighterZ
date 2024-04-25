extends RayCast2D

@export var Character: CharacterBody2D
@export var Player_Stats: Node

func _process(delta: float) -> void:
	if Character.is_on_floor() and is_colliding():
		pass

