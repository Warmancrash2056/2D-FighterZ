extends Node2D

@onready var player = $".."

func _process(delta):
	player.connect("FacingLeft", scale_left)
	player.connect("facingRight", scale_right)
	
func scale_left():
	pass
	
func scale_right():
	pass
