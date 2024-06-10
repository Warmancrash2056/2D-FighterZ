extends RayCast2D
signal WallCloud

@export var Character: CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
func _process(delta: float) -> void:
	if Character.is_on_wall() and is_colliding():
		Player_Stats.Jump_Count = 3

		if target_position.x == -11:
			Sprite.flip_h = false

		else:
			Sprite.flip_h = true



func _on_movement_controller_facing_left() -> void:
	target_position.x = -11


func _on_movement_controller_facing_right() -> void:
	target_position.x = 11
