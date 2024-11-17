extends Node2D

@onready var Floor_1 = $'Floor Left'
@onready var Floor_2 = $'Floor Middle'
@onready var Floor_3 = $'Floor Right'
@onready var Wall_1 = $'Wall 1'
@onready var Wall_2 = $'Wall 2'
@onready var Wall_3 = $'Wall 3'
@onready var Wall_4 = $'Wall 4'
@onready var Wall_5 = $'Wall 5'
@onready var Wall_6 = $'Wall 6'
@onready var Wall_7 = $'Wall 7'

var onground = false
var onwall = false
func _floor_detectors() -> bool:
	var detectors = [Floor_1, Floor_2, Floor_3]
	for detect in detectors:
		if detect.is_colliding() == true:
			return true

	return false

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
	onwall = _wall_detectors()

	print("player is on the wall: ", onwall)
