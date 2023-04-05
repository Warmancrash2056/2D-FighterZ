extends Control

@onready var CharacterBio = $"Character Bio"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Character Selection Resources/Start Game.tscn")


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
