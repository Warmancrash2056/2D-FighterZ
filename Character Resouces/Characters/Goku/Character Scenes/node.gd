extends Node2D

@onready var player_stats = $'../Player Stats'
@onready var character = $'..'
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
