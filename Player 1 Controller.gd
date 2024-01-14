extends Node2D

@export var Player_Controller: Resource

var num = 1
func _process(delta):
	if num == 1:
		num += 1
		print(2)
