extends Camera2D
@onready var player_1_spawn = CharacterList.get_player_1 .instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()

@export_range(0.1, 1.0) var zoom_offset : float = 0.8
@export var debug_mode : bool = false
var camera_rect := Rect2()
var viewport_rect := Rect2()

func _ready() -> void:
	Player_1()
	Player_2()
	
func _process(delta: float) -> void:
	#print(zoom)
	viewport_rect = get_viewport_rect()
	set_process(get_child_count() > 0)
	camera_rect = Rect2(get_child(0).global_position, Vector2())
	for index in range(get_child_count()):
		if index == 0:
			continue
		camera_rect = camera_rect.expand(get_child(index).global_position)
		
	zoom = calculate_zoom(camera_rect, viewport_rect.size)
	offset = calculate_center(camera_rect)
	if debug_mode:
		queue_redraw()
		
	# Define the maximum allowed offset (adjust as needed)
	var max_offset = Vector2(800.0, 800.0)
	
	# Clamp the offset to stay within the bounds
	offset.x = clamp(offset.x, -max_offset.x, max_offset.x)
	offset.y = clamp(offset.y, -max_offset.y, max_offset.y)
func calculate_center(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2.0,
		rect.position.y + rect.size.y / 2.0 )

func calculate_zoom(rect: Rect2, viewport_size: Vector2) -> Vector2:
	var min_zoom = min(
		min(1.3, viewport_size.x / rect.size.x - zoom_offset),
		min(1.3, viewport_size.y / rect.size.y - zoom_offset))
	
	# Set a minimum zoom value (adjust as needed)
	var min_zoom_value = 1.1
	
	return Vector2(max(min_zoom, min_zoom_value), max(min_zoom, min_zoom_value))

func _draw() -> void:
	if not debug_mode:
		return
	draw_rect(camera_rect, Color(1, 1, 1), false)
	draw_circle(calculate_center(camera_rect), 5, Color(1, 1, 1))
func Player_1():
	
	call_deferred("add_child", player_1_spawn)
	player_1_spawn.set_script(CharacterList.get_player_1_script)
	
	player_1_spawn.position = Vector2(192,-102)
	
func Player_2():
	
	call_deferred("add_child", player_2_spawn)
	player_2_spawn.set_script(CharacterList.get_player_2_script)
	
	player_2_spawn.position = Vector2(-192,-102)
