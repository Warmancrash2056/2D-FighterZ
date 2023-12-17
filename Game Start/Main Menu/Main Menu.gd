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

@onready var controller_layout = $"Control Layout"
@onready var LocalPlay = $"Local Play"
@onready var AboutCharacters = $"About Characters"
@onready var TrainingRoom = $"Training Room"
@onready var online_play = $"Online Play"
@onready var mars_studio = $"Mars Studio"

func _ready():
	general_archfield.play("Idle")
	goku.play("Idle")
	hunter.play("Idle")
	nomad.play("Idle")
	atlantis.play("Idle")
	sakura.play("Idle")

func _physics_process(delta):
	if Input.is_action_just_pressed(player_1_controller.jump) or Input.is_action_just_pressed(player_2_controller.jump) or Input.is_action_just_pressed(main_player_controller.jump):
		get_tree().change_scene_to_file("res://Game Start/Local Play/Local Play.tscn")
		
	
	
func _on_local_play_pressed():
	get_tree().change_scene_to_file("res://Game Start/Local Play/Local Play.tscn")

func _on_about_characters_pressed():
	get_tree().change_scene_to_file("res://Game Start/Aboou Character/About Characters.tscn")

func _on_training_room_pressed():
	get_tree().change_scene_to_file("res://Game Maps/Training/Training Map Selector/Training Character Selection.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Game Keys.tscn")

func _on_setting_menu_pressed():
	get_tree().change_scene_to_file("res://Game Start/Setting Menu.tscn")
func _on_online_play_pressed():
	get_tree().change_scene_to_file("")

func _on_mars_studio_pressed():
	get_tree().change_scene_to_file("res://About Studio.tscn")
