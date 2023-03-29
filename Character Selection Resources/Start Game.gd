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

# Called when the node enters the scene tree for the first time.
func _ready():
	GeneralArchfield.play("Idle")
	Goku.play("Idle")
	Hunter.play("Idle")
	Nomad.play("Idle")
	PrincessAtlantis.play("Idle")
	Nia.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_local_play_pressed():
	get_tree().change_scene_to_file("res://Character Selection Resources/Character Selection Menu.tscn")


func _on_about_characters_pressed():
	get_tree().change_scene_to_file("res://Character Selection Resources/biography_section.tscn")


func _on_training_room_pressed():
	get_tree().change_scene_to_file("res://Character Selection Resources/Training Room.tscn")
