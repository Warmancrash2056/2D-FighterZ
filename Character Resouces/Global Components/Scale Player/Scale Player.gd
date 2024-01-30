extends Node2D

@export var Character: CharacterBody2D

func _process(delta):
	Character.connect("FacingLeft", scale_left)
	Character.connect("facingRight", scale_right)
	
func scale_left():
	pass
	
func scale_right():
	pass
