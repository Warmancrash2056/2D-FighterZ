extends Camera2D
@export var zoom_offset: float = 0.5
@export var debug_mode: bool = false

var camera_rect: Rect2
var viewport_rect: Rect2

#@onready var player_1_spawn = CharacterList.get_player_1.instantiate()
#@onready var player_2_spawn = CharacterList.get_player_2.instantiate()
# Called when the node enters the scene treefor the first time.
func _ready():
	viewport_rect = get_viewport_rect()
	set_process(get_child_count() > 0)
	#player1()
	#player2()
func _process(delta: float) -> void:
	print( "current", zoom)
	camera_rect = Rect2(get_child(0).global_position, Vector2())
	for index in range(get_child_count()):
		if index == 0:
			continue
		camera_rect = camera_rect.expand(get_child(index).global_position)
	offset = calculate_center(camera_rect)
	zoom = calculate_zoom(camera_rect, viewport_rect.size)
	
	if debug_mode:
		queue_redraw()
		
func calculate_center(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2)
		
func calculate_zoom(rect: Rect2, viewport_size: Vector2) -> Vector2:
	var min_zoom = min(
		min(1, viewport_size.x / rect.size.x - zoom_offset),
		min(1, viewport_size.y / rect.size.y - zoom_offset))
		
	return Vector2(min_zoom,min_zoom)

func _draw() -> void:
	if not debug_mode:
		return
		
		draw_rect(camera_rect , Color(1,1,1), false)
		draw_circle(calculate_center(camera_rect), 5, Color(1,1,1))
