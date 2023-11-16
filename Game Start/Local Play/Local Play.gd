extends Control
@onready var Cursor1 = $"Player 1 Cursor"
@onready var Cursor2 = $"Player 2 Cursor"
@onready var Prompt = $"Prompt Name"

var move_to_map_select = false

var player_1_controller: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")
var player_2_controller: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_2.tres")
var player_3_controller: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_3.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameAuido._character_select_play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Cursor1.Player1Ready == true and Cursor2.Player2Ready == true:
		Prompt.set_text(str("Characters Ready"))
		move_to_map_select = true
	
		if Input.is_action_just_pressed(player_1_controller.jump) or Input.is_action_just_pressed(player_2_controller.jump) or Input.is_action_just_pressed(player_3_controller.jump):
			get_tree().change_scene_to_file("res://Game Maps/Map Selector/Map Selection.tscn")
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Game Start/Main Menu/Main Menu.tscn")
		GameAuido._main_menu_play()
		Cursor1.Player1Ready = false
		Cursor2.Player2Ready = false
		



