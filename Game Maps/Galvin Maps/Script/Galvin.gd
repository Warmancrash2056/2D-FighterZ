extends Node2D
@onready var camera = $Camera2D
@onready var player_1_spawn = CharacterList.get_player_1.instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()

@export_range(0.1, 1.5) var zoom_offset : float = 0.8
@export var debug_mode : bool = false
var camera_rect := Rect2()
var viewport_rect := Rect2()

var camera_reset = false
const MAX_OFFSET_X = 800.0
const MIN_OFFSET_X = -800.0

const MAX_ZOOM_DISTANCE = 500.0
const CAMERA_MOVE_THRESHOLD = 5.0

func _ready() -> void:
	# Set player properties directly
	call_deferred("add_child", player_1_spawn)
	player_1_spawn.set_script(CharacterList.get_player_1_script)
	player_1_spawn.position = Vector2(192, -328)

	call_deferred("add_child", player_2_spawn)
	player_2_spawn.set_script(CharacterList.get_player_2_script)
	player_2_spawn.position = Vector2(-192, -328)

	setup_camera()
	GameAuido._galvin_map_play()

func _process(delta: float) -> void:
	set_process(get_child_count() > 0)
	calculate_camera_rect()
	update_camera()
func _reset_c():
	camera.position.x = move_toward(camera.position.x , 0.0, 1.0)
	camera.position.y = move_toward(camera.position.y , 0.0, 1.0)
	camera.zoom.x = move_toward(camera.zoom.x, 0.6, 0.1)
	camera.zoom.y = move_toward(camera.zoom.y, 0.6, 0.1)

func calculate_camera_rect() -> void:
	viewport_rect = get_viewport_rect()
	set_process(get_child_count() >= 3)
	camera_rect = Rect2(player_1_spawn.global_position, Vector2())
	for index in range(get_child_count()):
		if index == 0:
			continue
		camera_rect = camera_rect.expand(player_2_spawn.global_position)

func update_camera() -> void:
	camera.zoom = calculate_zoom(camera_rect, viewport_rect.size)
	
	# Calculate distance between players
	var player1_position = player_1_spawn.global_position
	var player2_position = player_2_spawn.global_position
	var distance = player1_position.distance_to(player2_position)
	
	# Move the camera only when players are far away
	#print(camera.position)
	if distance > CAMERA_MOVE_THRESHOLD:
		camera.global_position = lerp(camera.global_position,calculate_center(camera_rect),0.1)
		
	
	# Adjust zoom based on distance between players
	camera.zoom *= calculate_zoom_factor(distance)
	
	if debug_mode:
		queue_redraw()

	# Clamp the offset to stay within the bounds
	#camera.global_position.x = clamp(camera.global_position.x, MIN_OFFSET_X, MAX_OFFSET_X)
	#camera.global_position.y = clamp(camera.global_position.y, -MAX_OFFSET_X, MAX_OFFSET_X)

func calculate_center(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2.0,
		rect.position.y + rect.size.y / 2.0
	)

func calculate_zoom(rect: Rect2, viewport_size: Vector2) -> Vector2:
	var min_zoom = min(
		min(1.3, viewport_size.x / rect.size.x - zoom_offset),
		min(1.3, viewport_size.y / rect.size.y - zoom_offset)
	)
	return Vector2(max(min_zoom, 0.7), max(min_zoom, 0.7))

func calculate_zoom_factor(distance: float) -> float:
	# Calculate the zoom factor based on the distance between players
	var zoom_factor = 1.0 - distance / MAX_ZOOM_DISTANCE

	# Clamp the zoom factor to be at least 1.0
	return max(zoom_factor, 1.0)

func _draw() -> void:
	if not debug_mode:
		return
	draw_rect(camera_rect, Color(1, 1, 1), false)
	draw_circle(calculate_center(camera_rect), 5, Color(1, 1, 1))

func setup_camera() -> void:
	# Set initial camera properties here, if needed
	pass


func _on_area_2d_area_entered(area):
	pass
