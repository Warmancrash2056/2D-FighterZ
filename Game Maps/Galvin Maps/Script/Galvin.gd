extends Node2D
# Local Galvin

@onready var player_1_spawn = CharacterList.get_player_1.instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()
@onready var exit_prompt = $"Exit Prompt"
@onready var exit_prompt_return = $"Exit Prompt/Return To Game"
@onready var exit_prompt_exit = $"Exit Prompt/Exit Game"

func _ready():
	Audio._galvin_map_play()
	_player_1()
	_player_2()
func _player_1():
	call_deferred("add_child", player_1_spawn)
	player_1_spawn.set_script(CharacterList.get_player_1_script)
	
	# Spawn player at this location beginning of thr
	player_1_spawn.position = Vector2(-192,-192)
func _player_2():
	call_deferred("add_child", player_2_spawn)
	player_1_spawn.set_script(CharacterList.get_player_2_script)

	
	player_2_spawn.position = Vector2(128,-192)
func _process(delta):
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

