extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Bing")

func _change_scene():
	get_tree().change_scene_to_file("res://Opening.tscn")
