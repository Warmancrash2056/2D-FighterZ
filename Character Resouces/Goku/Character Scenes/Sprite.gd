extends Sprite2D

func _on_controller_facing_left() -> void:
	flip_h = true


func _on_controller_facing_right() -> void:
	flip_h = false
