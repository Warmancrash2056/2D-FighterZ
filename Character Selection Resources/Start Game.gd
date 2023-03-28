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
