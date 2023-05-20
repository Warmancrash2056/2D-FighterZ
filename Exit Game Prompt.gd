extends Control

@onready var leave_game = $"Leave Game"
@onready var return_game = $"Return to menu"

@onready var GeneralArchfield = $"../General Archfield"
@onready var Goku = $"../Goku"
@onready var Nomad = $"../Nomad"
@onready var Nia = $"../Nia"
@onready var PrincessAtlantis = $"../Princess Atlantis"
@onready var Hunter = $"../Hunter"

enum Game{
	Escape,
	Return,
	
}
var CheckGame = Game.Return
func _ready():
	visible = false
		
	GeneralArchfield.play("Idle")
	Goku.play("Idle")
	Hunter.play("Idle")
	Nomad.play("Idle")
	PrincessAtlantis.play("Idle")
	Nia.play("Idle")
func _process(delta):
	
	match CheckGame:
		Game.Return:
			visible = false
			if Input.is_action_just_pressed("exit"):
				CheckGame = Game.Escape
				
			GeneralArchfield.play("Idle")
			Goku.play("Idle")
			Hunter.play("Idle")
			Nomad.play("Idle")
			PrincessAtlantis.play("Idle")
			Nia.play("Idle")
		Game.Escape:
			visible = true
			if Input.is_action_just_pressed("exit"):
				CheckGame = Game.Return
				
				
			GeneralArchfield.stop()
			Goku.stop()
			Hunter.stop()
			Nomad.stop()
			PrincessAtlantis.stop()
			Nia.stop()

func _on_leave_game_pressed():
	get_tree().quit()


func _on_return_to_menu_pressed():
	CheckGame = Game.Return
