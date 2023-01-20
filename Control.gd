extends Control

signal StartGame

onready var _Button = $Button
onready var _Player1_Selection = $"The Monk"
onready var _Player2_Selection = $Princess
func _ready():
	_Button.connect("pressed", self, "_play_scene")
	_Button.disabled = true
func _play_scene():
	get_tree().change_scene("res://BattleGrounds.tscn")

func _process(delta):
	if _Player1_Selection.pressed == true:
		_Player1_Selection.disabled = true
		
	elif _Player2_Selection.pressed == true:
		_Player2_Selection.disabled = true

	elif _Player1_Selection.disabled == true and _Player2_Selection.disabled == true:
		print("Ready")
		_Button.disabled = false
