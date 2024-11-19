extends Node2D
@onready var camera = $"Local Camera"
@onready var player_1_spawn = CharacterList.get_player_1.instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()
@onready var player_1_manager = %'Player 1 Manager'
@onready var player_2_manager = %'Player 2 Manager'
@onready var timer = $'Camera Updater'
@export_range(0.0, 1.0 ,0.1) var zoom_offset : float = 1.0
@export var debug_mode : bool = false
@export var camera_move: bool = true
var camera_rect := Rect2()
var viewport_rect := Rect2()
signal Player1Knockout
signal Player2Knockout
var new_zoom: Vector2
var new_position: Vector2 # Get the position and zoom every few seconds.\

var camera_reset = false
const MAX_OFFSET_X = 1200.0
const MIN_OFFSET_X = -1200.0

const MAX_ZOOM_DISTANCE = 1.0
@export_range(0, 5, 0.1) var camera_zoom_level: float = 2.2
const CAMERA_MOVE_THRESHOLD = 30

enum {
	Idle,
	Turning,
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
	Side_Light_Start,
	Side_Light_Finish,
	Side_Heavy,
	Side_Air,
	Down_Light,
	Down_Heavy,
	Down_Air,
	Dowm_Recovery,
	Ground_Throw,
	Air_Throw,
	Hurt,
	Recover,
	Respawn
}
func _ready() -> void:
	# Set player properties directly
	setup_camera()
	GameAuido._galvin_map_play()
	timer.start()

func _process(delta: float) -> void:
	#print(player_1_manager.get_child_count())

	if player_1_manager.get_child_count() == 1 or player_2_manager.get_child_count() == 1:
		camera_move = true

	else:
		camera_move = false

	#print(camera.zoom)
	set_process(get_child_count() > 0)
	calculate_camera_rect()
	update_camera()

func calculate_camera_rect() -> void:
	var player_1_position = player_1_spawn.get_node("Controller")
	var player_2_position = player_2_spawn.get_node("Controller")
	viewport_rect = get_viewport_rect()
	set_process(get_child_count() >= 1)
	camera_rect = Rect2(MatchGameManager.player_1_global_position, Vector2())
	for index in range(get_child_count()):
		if index == 0:
			continue
		camera_rect = camera_rect.expand(MatchGameManager.player_2_global_position)

func update_camera() -> void:
	new_zoom = calculate_zoom(camera_rect, viewport_rect.size)
	# Calculate distance between players
	var player_1_position = player_1_spawn.get_node("Controller")
	var player_2_position = player_2_spawn.get_node("Controller")
	var player1_position = player_1_position.global_position
	var player2_position = player_2_position.global_position

	var distance = MatchGameManager.player_1_global_position.distance_to(MatchGameManager.player_2_global_position)
	#print("players current distance from each other. " ,distance)
	# Move the camera only when players are far away


	if distance > CAMERA_MOVE_THRESHOLD:
		new_position = calculate_center(camera_rect)




	if debug_mode:
		queue_redraw()

	# Clamp the offset to stay within the bounds
	camera.global_position.x = clamp(camera.global_position.x, MIN_OFFSET_X, MAX_OFFSET_X)
	camera.global_position.y = clamp(camera.global_position.y, -MAX_OFFSET_X, MAX_OFFSET_X)

func calculate_center(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2.0,
		rect.position.y + rect.size.y / 2.0
	)

func calculate_zoom(rect: Rect2, viewport_size: Vector2) -> Vector2:
	var min_zoom = min(
		min(camera_zoom_level, viewport_size.x / rect.size.x - zoom_offset),
		min(camera_zoom_level, viewport_size.y / rect.size.y - zoom_offset)
	)
	return Vector2(max(min_zoom, 1.7), max(min_zoom, 1.7))


func _draw() -> void:
	if not debug_mode:
		return
	draw_rect(camera_rect, Color(1, 1, 1), false)
	draw_circle(calculate_center(camera_rect), 5, Color(1, 1, 1))

func setup_camera() -> void:
	camera.zoom.x = move_toward(camera.zoom.x, 1.4, 0.5)
	camera.zoom.x = move_toward(camera.zoom.y, 1.4, 0.5)
	camera.position.x = move_toward(camera.position.x , 0, 100)
	camera.position.x = move_toward(camera.position.y, 192, 100)




func _on_knockout_area_body_entered(body: Node2D) -> void:
	if body.get_parent() is Player1Controller:
		Player1Knockout.emit()

	if body.get_parent() is Player2Controller:
		Player2Knockout.emit()

func _on_timer_timeout() -> void:
	if camera_move == true:
		var tween = get_tree().create_tween()
		tween.tween_property(camera,'zoom', new_zoom, .14).set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(camera, "global_position", new_position, .14).set_ease(Tween.EASE_OUT_IN)
