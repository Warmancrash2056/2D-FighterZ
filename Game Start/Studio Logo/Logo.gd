extends Node2D

@onready var Animate = $AnimationPlayer

func _ready():
	Animate.play("Start")

func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Game Start/Main Menu.tscn")
