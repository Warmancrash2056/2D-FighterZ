extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()

func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()

