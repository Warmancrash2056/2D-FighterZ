extends Node2D

@export var Character: CharacterBody2D
@export var Sprite: Sprite2D
func _process(delta):
	Character.connect("FacingLeft", scale_left)
	Character.connect("FacingRight", scale_right)
	
func scale_left():
	scale.x = -1
	Sprite.flip_h = true
func scale_right():
	scale.x = 1
	Sprite.flip_h = false
