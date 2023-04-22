extends Node2D

@onready var Player1 = $"Player 1 Cursor"
@onready var GameAudio = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready():
	GameAudio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Player1.Player1Ready == true:
		get_tree().change_scene_to_file("res://Game Maps/Map Selector/Training Map Selection.tscn")


func _on_audio_stream_player_2d_finished():
	GameAudio.play()
