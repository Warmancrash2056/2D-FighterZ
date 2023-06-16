extends Control

@onready var Player1 = $"Player 1 Cursor"

var main_controller: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_3.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	Audio._character_select_play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Player1.Player1Ready == true:
	
		if Input.is_action_just_pressed(main_controller.input_jump):
			get_tree().change_scene_to_file("res://Game Maps/Map Selector/Training Map Selection.tscn")
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Game Start/Main Menu/Main Menu.tscn")
		Audio._main_menu_play()
		Player1.Player1Ready = false
		CharacterList.get_main_player = null
		



