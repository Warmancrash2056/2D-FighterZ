extends Node2D



@onready var player_1_position = $"Player 1 Position"
@onready var player_2_position = $"Player 2 Position"
@onready var main_player_position = $"Main Player Position"
@onready var exit_prompt = $"Exit Prompt"
@onready var exit_prompt_return = $"Exit Prompt/Return To Game"
@onready var exit_prompt_exit = $"Exit Prompt/Exit Game"
var distance_vec: float
func _ready():
	Audio._galvin_map_play()
	
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

