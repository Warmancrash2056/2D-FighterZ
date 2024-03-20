extends Node2D

@export var Controller: Node
@export var Sprite: Sprite2D

var direction = 1

func _on_character_facing_left():
	scale.x = -1
	direction = -1


func _on_character_facing_right():
	scale.x = 1
	direction = 1


func _on_character_attack_friction():
	pass # Replace with function body.


func _on_controller_facing_left():
	scale.x = -1
	direction = -1


func _on_controller_facing_right():
	scale.x = 1
	direction = 1
