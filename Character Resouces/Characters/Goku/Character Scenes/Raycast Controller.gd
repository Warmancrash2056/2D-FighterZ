extends Node2D

@export var Player_Stats: Node
@export var Character: RigidBody2D
@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D
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
@onready var Wall_8 = $'Wall 8'
@onready var Wall_9 = $'Wall 9'
@onready var Wall_10 = $'Wall 10'
@onready var Wall_11 = $'Wall 11'
@onready var Wall_12 = $'Wall 12'
@onready var Wall_13 = $'Wall 13'
@onready var Wall_14 = $'Wall 14'
@onready var Wall_15 = $'Wall 15'
@onready var Wall_16 = $'Wall 16'

enum {SurfaceGround, SurfaceWall, SurfaceAir}

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
	 Wall_6, Wall_7,
	Wall_8,Wall_9,
	Wall_10,Wall_11
	,Wall_12,Wall_13,Wall_14,Wall_15,Wall_16]
	for detect in detectors:
		if not detect.is_colliding():
			return false

	return true
func _wall_detectors() -> bool:
	var detectors= [Wall_1,
	 Wall_2, Wall_3,
	 Wall_4, Wall_5,
	 Wall_6, Wall_7,
	Wall_8,Wall_9,
	Wall_10,Wall_11
	,Wall_12,Wall_13,Wall_14,Wall_15,Wall_16]
	for detect in detectors:
		if detect.is_colliding() == true:
			return true

	return false



func _process(delta: float) -> void:
	onground = _floor_detectors()
	completely_on_the_floor = _completely_is_on_floor()
	onwall = _wall_detectors()
	completely_on_the_wall = _completeley_is_on_the_wall()

	# Disable the wall detector to prevent player from clinging
	# While stuned.
	if Animator.state in [Hurt]:
		Wall_1.enabled = false
		Wall_2.enabled = false
		Wall_3.enabled = false
		Wall_4.enabled = false
		Wall_5.enabled = false
		Wall_6.enabled = false
		Wall_7.enabled = false
		Wall_8.enabled = false
		Wall_9.enabled = false
		Wall_10.enabled = false
		Wall_11.enabled = false
		Wall_12.enabled = false
		Wall_13.enabled = false
		Wall_14.enabled = false
		Wall_15.enabled = false
		Wall_16.enabled = false

	else:
		Wall_1.enabled = true
		Wall_2.enabled = true
		Wall_3.enabled = true
		Wall_4.enabled = true
		Wall_5.enabled = true
		Wall_6.enabled = true
		Wall_7.enabled = true
		Wall_8.enabled = true
		Wall_9.enabled = true
		Wall_10.enabled = true
		Wall_11.enabled = true
		Wall_12.enabled = true
		Wall_13.enabled = true
		Wall_14.enabled = true
		Wall_15.enabled = true
		Wall_16.enabled = true

	# Prevent player from clinging to the edge of the floor when coming back up to stage. Possible Solution
	# Use the position of the player to move up a little bit to uncling from the edge of the floor.
	if Animator.state in [Air]:
		if Wall_16.is_colliding():
			Character.position.y -= 3

func _on_controller_facing_left() -> void:
	scale.x = -1

func _on_controller_facing_right() -> void:
	scale.x = 1

# Check if player has previously jumped and is on the ground
func _on_animator_on_ground() -> void:
	if Character.previouslyjumped == true and onground == true:
		Player_Stats.Jump_Count = 3
		Character.previouslyjumped = false


func _on_animator_on_wall() -> void:
	if onwall == true:
		Player_Stats.Jump_Count = 3
