class_name Stat extends Node

@export var Character: CharacterBody2D

@export var Speed:int = 350
@export var Acceleration:int = 40
@export var Decceleration: int = 30
@export var Speed_Rating: float 

@export var Health: int = 1000
@export var Defense_Rating: float

@export var Gravity:int = 30
@export var Jump_Height: int
@export var Fast_Fall: int
@export var Jump_Count: int = 3

@export var Block_Active: bool = false
@export var Attack_Reset: bool = false

var Dash_Active: bool = false
func _physics_process(delta):
	print_debug(Speed)
	_speed_scaling()
	defense_scaling()
	Character.connect("DashCloud",_dash_Scaling)
	if Engine.get_physics_frames() % 120 == 0:
		Block_Active = false
	
func _speed_scaling():
	Speed * Speed_Rating
func defense_scaling():
	Character.velocity * Defense_Rating

func _dash_Scaling():
	Speed * 
