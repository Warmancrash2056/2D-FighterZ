extends Control

@onready var general_archfield = $"Character Pose/General Archfield"
@onready var goku = $"Character Pose/Goku"
@onready var nomad = $"Character Pose/Nomad"
@onready var sakura = $"Character Pose/Sakura"
@onready var atlantis = $"Character Pose/Atlantis"
@onready var hunter = $"Character Pose/Hunter"


@onready var LocalPlay = $"Local Play"
@onready var AboutCharacters = $"About Characters"
@onready var TrainingRoom = $"Training Room"

func _ready():
	general_archfield.play("Idle")
	goku.play("Idle")
	hunter.play("Idle")
	nomad.play("Idle")
	atlantis.play("Idle")
	sakura.play("Idle")



func _on_local_play_pressed():
	get_tree().change_scene_to_file("res://Game Start/Local Play/Local Play.tscn")


func _on_about_characters_pressed():
	get_tree().change_scene_to_file("res://Game Start/Aboou Character/About Characters.tscn")


func _on_training_room_pressed():
	get_tree().change_scene_to_file("res://Game Maps/Training'/Training Character Selection.tscn")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Game Keys.tscn")
