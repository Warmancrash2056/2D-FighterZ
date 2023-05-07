extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Audio._main_menu_play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Game Start/Main Menu.tscn")
