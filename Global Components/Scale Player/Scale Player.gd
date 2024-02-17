extends Node2D

@export var Controller: Node
@export var Sprite: Sprite2D

var direction = 1

func _on_controller_facing_left():
	scale.x = -1
	Sprite.flip_h = true
	direction = -1


func _on_controller_facing_right():
	scale.x = 1
	Sprite.flip_h = false
	direction = 1


func _on_character_attack_moving():
	pass # Replace with function body.
