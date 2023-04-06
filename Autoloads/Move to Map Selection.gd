extends Node
var Player1Ready = false
var Player2Ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	print(Player1Ready, Player2Ready)
	if Player1Ready and Player2Ready == true:
		get_tree().change_scene_to_file("res://Game Maps/Galvin.tscn")
