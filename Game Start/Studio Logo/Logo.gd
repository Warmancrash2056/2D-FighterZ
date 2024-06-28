extends Node2D

@onready var Animate = $AnimationPlayer

func _ready():
	Animate.play("Start")
	GameAuido._galvin_map_play()

func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Game Start/Main Menu/Main Menu.tscn")
	GameAuido._main_menu_play()
