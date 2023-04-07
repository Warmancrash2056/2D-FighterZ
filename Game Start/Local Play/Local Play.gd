extends Control
@onready var Cursor1 = $"Player 1 Cursor"
@onready var Cursor2 = $"Player 2 Cursor"
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Cursor1.Player1Ready == true and Cursor2.Player2Ready == true:
		get_tree().change_scene_to_file("res://Game Maps/Map Selection.tscn")
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Character Selection Resources/Start Game.tscn")


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
