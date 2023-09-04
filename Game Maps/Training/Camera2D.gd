extends Camera2D


@export var move_speed: float = 0.5 # move camera lerp #
@export var zoom_speed: float = 0.25 # zoom speed lerp #

@export var min_zoom: float = 1.8
@export var max_zoom: float = 0.8

@export var margin: Vector2 = Vector2(400,200)

var targets = []
func add_targets(t):
	if not t in targets:
		targets.append(t)
		
func _process(delta):

	
	position = lerp(position, p, move_speed)
	
	
