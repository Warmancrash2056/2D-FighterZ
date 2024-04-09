extends AnimationPlayer

@export var Character: CharacterBody2D
@export var Sprite: Sprite2D

func _on_controller_attack_movement_x(Vector: Vector2) -> void:
	if Sprite.flip_h == true:
		Character.velocity.x = -Vector.x

	else:
		Character.velocity.x  = Vector.x


func _on_controller_attack_movement_y(Vector: Vector2) -> void:
	Character.velocity.y = Vector.y
