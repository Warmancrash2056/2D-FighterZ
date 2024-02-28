extends Node2D

@export var Character: CharacterBody2D
@export var Animator: AnimationPlayer

@export var Controller = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")
var dir: Vector2
var jump: bool = false
var light: bool = false
var heavy: bool = false
var dash: bool = false
var can_action: bool = false
var can_move: bool = false

func _process(delta):
	pass

func _movement():
	if can_move == true:
		pass
