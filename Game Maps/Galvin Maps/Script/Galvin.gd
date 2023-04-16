extends Node2D

@onready var GalvinAudio = $"Game Audio"

# Play audio when scene entered.
func _ready():
	GalvinAudio.play()

func _on_game_audio_finished():
	GalvinAudio.play()
