extends Node2D

@onready var exit_prompt_return = $"Exit Prompt/Return To Game"
@onready var exit_prompt_exit = $"Exit Prompt/Exit Game"
func _ready():
	Audio._galvin_map_play()
func _process(delta):
		
	if exit_prompt_exit.button_pressed == true:
		get_tree().change_scene_to_file("res://Game Start/Local Play/Training Character Selection.tscn")
		Audio._main_menu_play()
		CharacterList.get_main_player = null
