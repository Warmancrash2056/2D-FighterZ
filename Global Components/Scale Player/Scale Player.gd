extends Node2D

@export var Controller: Node
@export var Sprite: Sprite2D

func _on_controller_facing_left():
	scale.x = -1
	Sprite.flip_h = true


func _on_controller_facing_right():
	scale.x = 1
	Sprite.flip_h = false
