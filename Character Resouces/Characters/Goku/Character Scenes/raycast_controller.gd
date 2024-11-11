extends Node
@onready var Wall_Detector_1 = $'Wall Detector - 1'
@onready var Wall_Detector_2 = $'Wall Detector - 2'
@onready var Wall_Detector_3 = $'Wall Detector - 3'
@onready var Wall_Detector_4 = $'Wall Detector - 4'
@onready var Wall_Detector_5 = $'Wall Detector - 5'
@onready var Wall_Detector_6 = $'Wall Detector - 6'
@onready var Floor_Detector_1 = $'Wall Detector - 6'
@onready var Floor_Detector_2 = $'Wall Detector - 6'
@onready var Floor_Detector_3 = $'Wall Detector - 6'

var completely_on_floor: bool = false
var completely_on_wall: bool = false

enum {SurfaceGround, SurfaceWall, SurfaceAir}
var surface_state = SurfaceAir

func _wall_detection() -> bool:
	var detectors = [Wall_Detector_1,
	Wall_Detector_2,
	Wall_Detector_3,
	Wall_Detector_4,
	Wall_Detector_5,
	Wall_Detector_6]

	for detection in detectors:
		if not detection.is_coliding():
			return false
	return true

func _physics_process(delta: float) -> void:
	completely_on_wall = _wall_detection()
func _on_controller_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_controller_body_exited(body: Node) -> void:
	pass # Replace with function body.
