extends Node2D

@onready var player_stats = $'../Player Stats'
@onready var character = $'..'
@export var Animator: AnimationPlayer
@onready var Floor_1 = $'Floor 1'
@onready var Floor_2 = $'Floor 2'
@onready var Floor_3 = $'Floor 3'
@onready var Floor_4 = $'Floor 4'
@onready var Floor_5 = $'Floor 5'
@onready var Floor_6 = $'Floor 6'
@onready var Floor_7 = $'Floor 7'

@onready var Wall_1 = $'Wall 1'
@onready var Wall_2 = $'Wall 2'
@onready var Wall_3 = $'Wall 3'
@onready var Wall_4 = $'Wall 4'
@onready var Wall_5 = $'Wall 5'
@onready var Wall_6 = $'Wall 6'
@onready var Wall_7 = $'Wall 7'

enum {
	Idle,
	Forward_Step,
	Backward_Step,
	Moving_Left,
	Turning_Left,
	Moving_Right,
	Turning_Right,
	Running,
	Dash,
	Wall,
	Air,
	Ground_Block_Start_Tap,
	Ground_Block_Held,
	Ground_Block_To_Idle,
	Block_Slide,
	Air_Block_Start_Tap,
	Air_Block_Held,
	Neutral_Light,
	Neutral_Heavy,
	Neutral_Air,
	Neutral_Recovery,
	Side_Light_Start_Tap,
	Side_Light_Held_Release,
	Side_Light_Held,
	Side_Heavy_Start_Tap,
	Side_Heavy_Held_Release,
	Side_Heavy_Held,
	Side_Air_Start_Tap,
	Side_Air_Held_Release,
	Side_Air_Held,
	Down_Light_Start_Tap,
	Down_Light_Held_Release,
	Down_Light_Held,
	Down_Heavy_Start_Tap,
	Down_Heavy_Held_Release,
	Down_Heavy_Held,
	Down_Air_Start_Tap,
	Down_Air_Held_Release,
	Down_Air_Held,
	Dowm_Recovery_Start_Tap,
	Dowm_Recovery_Held_Release,
	Dowm_Recovery_Held,
	Ground_Throw_Start_Tap,
	Ground_Throw_Held_Release,
	Ground_Throw_Held,
	Air_Throw_Start_Tap,
	Air_Throw_Held_Release,
	Air_Throw_Held,
	Hurt,
	Recover,
	Respawn
}

var onground = false
var onwall = false
var completely_on_the_wall = false
var completely_on_the_floor = false

func _completely_is_on_floor():
	var detectors = [Floor_1, Floor_2, Floor_3, Floor_4, Floor_5, Floor_6, Floor_7]
	for detect in detectors:
		if not detect.is_colliding():
			return false

	return true


func _floor_detectors() -> bool:
	var detectors = [Floor_1, Floor_2, Floor_3, Floor_4, Floor_5, Floor_6, Floor_7]
	for detect in detectors:
		if detect.is_colliding() == true:
			return true

	return false

func _completeley_is_on_the_wall():
	var detectors= [Wall_1,
	 Wall_2, Wall_3,
	 Wall_4, Wall_5,
	 Wall_6, Wall_7]
	for detect in detectors:
		if not detect.is_colliding():
			return false

	return true
func _wall_detectors() -> bool:
	var detectors= [Wall_1,
	 Wall_2, Wall_3,
	 Wall_4, Wall_5,
	 Wall_6, Wall_7]
	for detect in detectors:
		if detect.is_colliding() == true:
			return true

	return false



func _process(delta: float) -> void:
	onground = _floor_detectors()
	completely_on_the_floor = _completely_is_on_floor()
	onwall = _wall_detectors()
	completely_on_the_wall = _completeley_is_on_the_wall()

	if Animator.state in [Hurt]:
		Wall_1.enabled = false
		Wall_2.enabled = false
		Wall_3.enabled = false
		Wall_4.enabled = false
		Wall_5.enabled = false
		Wall_6.enabled = false
		Wall_7.enabled = false


func _on_controller_facing_left() -> void:
	scale.x = -1

func _on_controller_facing_right() -> void:
	scale.x = 1


func _on_animator_on_ground() -> void:
	if character.previouslyjumped == true and onground == true:
		player_stats.Jump_Count = 3
		character.previouslyjumped = false


func _on_animator_on_wall() -> void:
	if onwall == true:
		player_stats.Jump_Count = 3
