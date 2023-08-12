extends Node2D

var player_1_controller: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")
var player_2_controller: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_2.tres")
var main_player_controller: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_3.tres")
@onready var MapName = $"Map Name"
@onready var Galvin = $Galvin
@onready var Artic = $Artic

enum Map{
	Galvin,
	Artic
}
var MapCall = Map.Galvin
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		CharacterList.get_main_player = null
		get_tree().change_scene_to_file("res://Game Start/Local Play/Training Character Selection.tscn")
	match MapCall:
		Map.Galvin:
			MapName.set_text(str("Galvin"))
			Galvin.visible = true
			Artic.visible = false
			if Input.is_action_just_pressed(player_1_controller.input_right) or Input.is_action_just_pressed(player_2_controller.input_right) or Input.is_action_just_pressed(main_player_controller.input_right):
				MapCall = Map.Artic
				Galvin.visible = false
				Artic.visible = true
				
			elif Input.is_action_just_pressed(player_1_controller.input_left) or Input.is_action_just_pressed(player_2_controller.input_left) or Input.is_action_just_pressed(main_player_controller.input_left):
				MapCall = Map.Artic
				Galvin.visible = false
				Artic.visible = true
				
			if Input.is_action_just_pressed(player_1_controller.input_jump) or Input.is_action_just_pressed(player_2_controller.input_jump) or Input.is_action_just_pressed(main_player_controller.input_jump):
				get_tree().change_scene_to_file("res://Game Maps/Galvin Maps/Map Scenes/Galvin.tscn")
				
		Map.Artic:
			MapName.set_text(str("The Artic"))
			Artic.visible = true
			Galvin.visible = false
			if Input.is_action_just_pressed(player_1_controller.input_right) or Input.is_action_just_pressed(player_2_controller.input_right) or Input.is_action_just_pressed(main_player_controller.input_right):
				MapCall = Map.Galvin
				Artic.visible = false
				Galvin.visible = true
				
			elif Input.is_action_just_pressed(player_1_controller.input_left) or Input.is_action_just_pressed(player_2_controller.input_left) or Input.is_action_just_pressed(main_player_controller.input_left):
				MapCall = Map.Galvin
				Artic.visible = false
				Galvin.visible = true
			
			if Input.is_action_just_pressed(player_1_controller.input_jump) or Input.is_action_just_pressed(player_2_controller.input_jump) or Input.is_action_just_pressed(main_player_controller.input_jump):
				get_tree().change_scene_to_file("res://Game Maps/The Artic/Training Artic.tscn")
		
