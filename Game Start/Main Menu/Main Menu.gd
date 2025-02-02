extends Control

var player_1_controller = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")
var player_2_controller = preload("res://Character Resouces/Global/Controller Resource/Player_2.tres")
var main_player_controller = preload("res://Character Resouces/Global/Controller Resource/Player_3.tres")
@onready var general_archfield = $"Character Pose/General Archfield"
@onready var goku = $"Character Pose/Goku"
@onready var nomad = $"Character Pose/Nomad"
@onready var sakura = $"Character Pose/Sakura"
@onready var atlantis = $"Character Pose/Atlantis"
@onready var hunter = $"Character Pose/Hunter"

@onready var setting_menu = $"Setting Menu"
@onready var controller_layout = $"Control Layout"
@onready var LocalPlay = $"Local Play"
@onready var AboutCharacters = $"About Characters"
@onready var TrainingRoom = $"Training Room"
@onready var online_play = $"Online Play"
@onready var mars_studio = $"Mars Studio"
@onready var exit_prompt = $"Exit Prompt"
@onready var exit_game = $"Exit Prompt/Exit Game"
@onready var return_game = $"Exit Prompt/Return To Game"

func _ready():
	general_archfield.play("Idle")
	goku.play("Idle")
	hunter.play("Idle")
	nomad.play("Idle")
	atlantis.play("Idle")
	sakura.play("Idle")
	exit_prompt.visible = false

func _process(delta):
	if Input.is_action_just_pressed("exit") and exit_prompt.visible == false:
		exit_prompt.visible = true
	elif Input.is_action_just_pressed("exit") and exit_prompt.visible == true:
		exit_prompt.visible = false
		
	if exit_game.button_pressed == true:
		get_tree().quit()
		
	if return_game.button_pressed == true:
		exit_prompt.visible = false
		
	if Input.is_action_just_pressed(player_1_controller.input_jump) or Input.is_action_just_pressed(player_2_controller.input_jump) or Input.is_action_just_pressed(main_player_controller.input_jump):
		get_tree().change_scene_to_file("res://Game Start/Local Play/Local Play.tscn")
		
	
	
func _on_local_play_pressed():
	get_tree().change_scene_to_file("res://Game Start/Local Play/Local Play.tscn")

func _on_about_characters_pressed():
	get_tree().change_scene_to_file("res://Game Start/Aboou Character/About Characters.tscn")

func _on_training_room_pressed():
	get_tree().change_scene_to_file("res://Game Start/Local Play/Training Character Selection.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Game Keys.tscn")

func _on_setting_menu_pressed():
	get_tree().change_scene_to_file("res://Game Start/Setting Menu.tscn")
func _on_online_play_pressed():
	get_tree().change_scene_to_file("")

func _on_mars_studio_pressed():
	get_tree().change_scene_to_file("res://About Studio.tscn")
