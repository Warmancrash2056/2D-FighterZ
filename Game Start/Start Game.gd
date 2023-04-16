extends Control

@onready var GeneralArchfield = $"General Archfield"
@onready var Goku = $Goku
@onready var Nomad = $Nomad
@onready var Nia = $Nia
@onready var PrincessAtlantis = $"Princess Atlantis"
@onready var Hunter = $Hunter

@onready var GameAudio = $"Game Audio"
@onready var LocalPlay = $"Local Play"
@onready var AboutCharacters = $"About Characters"
@onready var TrainingRoom = $"Training Room"

@onready var EscapeBackground = $"End Game/ColorRect"
@onready var EscapeText = $"End Game/RichTextLabel"
@onready var TimerText = $"End Game/Timer"
@onready var EscapeTimer = $Timer

var set_time = false
enum Game{
	EndGame,
	Escape,
	Return,
	
}
var CheckGame = Game.Return

func _process(delta):
	
	print(EscapeTimer.time_left)
	match CheckGame:
		Game.Return:
			EscapeBackground.visible = false
			EscapeText.visible = false
			TimerText.visible = false
			if Input.is_action_just_pressed("exit"):
				CheckGame = Game.Escape
				EscapeTimer.start()
			GeneralArchfield.play("Idle")
			Goku.play("Idle")
			Hunter.play("Idle")
			Nomad.play("Idle")
			PrincessAtlantis.play("Idle")
			Nia.play("Idle")
		Game.Escape:
			TimerText.set_text(str(int(EscapeTimer.time_left),"s"))
			EscapeBackground.visible = true
			EscapeText.visible = true
			TimerText.visible = true
			if Input.is_action_just_pressed("exit"):
				get_tree().quit()
				
			GeneralArchfield.stop()
			Goku.stop()
			Hunter.stop()
			Nomad.stop()
			PrincessAtlantis.stop()
			Nia.stop()
			
		Game.EndGame:
			pass
			
# Called when the node enters the scene tree for the first time.
func _ready():
	GameAudio.play()


func _on_local_play_pressed():
	get_tree().change_scene_to_file("res://Game Start/Local Play/Local Play.tscn")


func _on_about_characters_pressed():
	get_tree().change_scene_to_file("res://Character Selection Resources/Biography Menu.tscn")


func _on_training_room_pressed():
	get_tree().change_scene_to_file("")
func _on_timer_timeout():
	CheckGame = Game.Return


func _on_game_audio_finished():
	GameAudio.play()
