extends Node2D

func _on_movement_controller_facing_left() -> void:
	scale.x = -1


func _on_movement_controller_facing_right() -> void:
	scale.x = 1
