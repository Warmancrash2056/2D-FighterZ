extends RayCast2D

@export var Character: CharacterBody2D
@export var Player_Stats: Node


func _on_animator_on_ground() -> void:
	Player_Stats.Jump_Count = 3
