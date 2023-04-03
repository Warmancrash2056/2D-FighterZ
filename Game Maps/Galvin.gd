extends Node2D
# Call the autoloads saved character to load in map. 
	# iIf doesnt
@onready var Player1Spawn = Player1CharacterSelection.Player1
@onready var Player2 = Player2CharacterSelection.Player2

@onready var ExitBackground = $ColorRect
@onready var ExitText = $RichTextLabel
@onready var PauseTimer = $"Pause Timer"
@onready var TimeNotify = $"Timer Notifier"
enum Game {
	OpenExit,
	Return
}
var CheckGame = Game.Return
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match CheckGame:
		Game.Return:
			if Input.is_action_just_pressed("exit"):
				PauseTimer.start()
				CheckGame = Game.OpenExit
			ExitBackground.visible = false
			TimeNotify.visible = false
			
		Game.OpenExit:
			if Input.is_action_just_pressed("exit"):
				get_tree().change_scene_to_file("res://Character Selection Resources/Start Game.tscn")
			ExitBackground.visible = true
			TimeNotify.visible = true
			TimeNotify.set_text(str("Are you sure you want to exit the match ",int(PauseTimer.time_left), " Press Esc to return to lobby"))


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()


func _on_pause_timer_timeout():
	CheckGame = Game.Return
