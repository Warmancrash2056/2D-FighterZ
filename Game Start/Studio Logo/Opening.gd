extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Open")

func change_scene():
	get_tree().change_scene_to_file("res://Game Start/Main Menu.tscn")
