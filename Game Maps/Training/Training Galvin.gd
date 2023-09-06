extends Node2D
# Training Galvin

@onready var main_player_spawn = CharacterList.get_main_player.instantiate()

@onready var exit_prompt = $"Exit Prompt"
@onready var exit_prompt_return = $"Exit Prompt/Return To Game"
@onready var exit_prompt_exit = $"Exit Prompt/Exit Game"

func _ready():
	Audio._galvin_map_play()
	_main_player()
func _main_player():
	print("gOOD")
	call_deferred("add_child", main_player_spawn)
	main_player_spawn.set_script(CharacterList.get_player_2_script)
	
	# Spawn player at this location beginning of thr
	main_player_spawn.position = Vector2(0,-192)
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
