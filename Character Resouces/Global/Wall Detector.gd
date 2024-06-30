extends RayCast2D
signal WallCloud

@export var Character: CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
func _process(delta: float) -> void:
	if Character.is_on_wall() and is_colliding():
		Player_Stats.Jump_Count = 3


func _on_movement_controller_facing_left() -> void:
	target_position.x = -8.3


func _on_movement_controller_facing_right() -> void:
	target_position.x = 8.3
