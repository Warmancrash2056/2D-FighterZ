extends Node

signal Player1Box

# Test to see if i can add the resource during instancing. #
@export var Controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")


func _ready():
	Player1Box.emit()
	
	
