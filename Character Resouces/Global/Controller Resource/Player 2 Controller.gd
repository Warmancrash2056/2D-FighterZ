extends Node

signal Player2Box

# Test to see if i can add the resource during instancing. #
@export var Controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_2.tres")


func _ready():
	Player2Box.emit()
	
	
