extends Node2D
@onready var player_1_spawn = CharacterList.get_player_1 .instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()


@onready var player_1_position = $"Player 1 Position"
@onready var player_2_position = $"Player 2 Position"
@onready var main_player_position = $"Main Player Position"
@onready var exit_prompt = $"Exit Prompt"
@onready var exit_prompt_return = $"Exit Prompt/Return To Game"
@onready var exit_prompt_exit = $"Exit Prompt/Exit Game"
var distance_vec: float
func _ready():
	Audio._galvin_map_play()
	Player_1()
	Player_2()
func _process(delta):
	var distance = player_1_spawn.position.distance_to(player_2_spawn.position)
	
	
	distance_vec = distance	
	if Input.is_action_just_pressed("exit") and exit_prompt.visible == false:
		exit_prompt.visible = true
	elif Input.is_action_just_pressed("exit") and exit_prompt.visible == true:
		exit_prompt.visible = false
		
	if exit_prompt_exit.button_pressed == true:
		get_tree().change_scene_to_file("res://Game Start/Local Play/Training Character Selection.tscn")
		Audio._main_menu_play()
		CharacterList.get_main_player = null
	if exit_prompt_return.button_pressed == true:
		exit_prompt.visible = false

func Player_1():
	
	call_deferred("add_child", player_1_spawn)
	player_1_spawn.set_script(CharacterList.get_player_1_script)
	
	player_1_spawn.position = Vector2(192,-102)
	
func Player_2():
	
	call_deferred("add_child", player_2_spawn)
	player_2_spawn.set_script(CharacterList.get_player_2_script)
	
	player_2_spawn.position = Vector2(-192,-102)

func cam():
	$Camera2D.position.x = distance_vec



func _on_camera_change_timeout():
	$Camera2D.offset.x = distance_vec
	print("changed")
