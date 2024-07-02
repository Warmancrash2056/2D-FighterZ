extends RayCast2D

@export var Character: CharacterBody2D
@export var Player_Stats: Node


func _on_animator_on_ground() -> void:
	print("On Ground")
	if Character.is_on_floor() and Character.is_on_floor():
		Player_Stats.Jump_Count = 3
		print("On Ground")
