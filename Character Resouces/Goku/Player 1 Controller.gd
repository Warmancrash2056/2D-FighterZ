extends Node

@export var Controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")
@export var Scale_Player: Node2D

signal FacingLeft
signal FacingRight
var direction: Vector2
var left: bool = false
var right: bool = false
var down: bool = false
var jump: bool = false
var throw: bool = false
var light: bool = false
var heavy: bool = false
var dash: bool = false

var can_input: bool = false
var start_move: bool = false
var can_action: bool = false
signal Player1Box

func _process(delta):
	start_movmeent()
	change_dir()
	direction.normalized()
func start_movmeent():
	if start_move == true:
		direction = Vector2(Input.get_action_strength(Controls.right) - Input.get_action_strength(Controls.left), Input.get_action_strength(Controls.down))
		
	if can_action == true:
		if Input.is_action_just_pressed(Controls.jump):
			jump = true
			
		if Input.is_action_just_pressed(Controls.throw):
			throw = true
			
		if Input.is_action_just_pressed(Controls.dash):
			dash = true
			
		if Input.is_action_just_pressed(Controls.light):
			light = true
			
		if Input.is_action_just_pressed(Controls.heavy):
			heavy = true
func change_dir():
	print(start_move)
	if Input.is_action_pressed(Controls.left):
		emit_signal("FacingLeft")
		if Engine.get_process_frames() % 30 == 0:
			start_move = true
			
	else:
		if Input.is_action_just_released(Controls.left):
			start_move = false
			
	if Input.is_action_pressed(Controls.right):
		emit_signal("FacingRight")
		if Engine.get_process_frames() % 30 == 0:
			start_move = true
		
	else:
		if Input.is_action_just_released(Controls.right):
			start_move = false
		
	
