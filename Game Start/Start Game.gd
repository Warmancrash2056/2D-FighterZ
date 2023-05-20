extends Control

@onready var GeneralArchfield = $"General Archfield"
@onready var Goku = $Goku
@onready var Nomad = $Nomad
@onready var Nia = $Nia
@onready var PrincessAtlantis = $"Princess Atlantis"
@onready var Hunter = $Hunter


@onready var LocalPlay = $"Local Play"
@onready var AboutCharacters = $"About Characters"
@onready var TrainingRoom = $"Training Room"

@onready var exit_prompt = $"Exit Game Prompt"



func _on_local_play_pressed():
	get_tree().change_scene_to_file("res://Game Start/Local Play/Local Play.tscn")


func _on_about_characters_pressed():
	get_tree().change_scene_to_file("res://Game Start/Aboou Character/About Characters.tscn")


func _on_training_room_pressed():
	get_tree().change_scene_to_file("res://Game Maps/Training'/Training Character Selection.tscn")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Game Keys.tscn")
