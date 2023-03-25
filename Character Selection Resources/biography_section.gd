extends Control

#Biography Section 
@onready var AboutMe = $"About Me"
@onready var Biography = $Biography

# Chaeracter Animation
@onready var GeneralArchfieldAnimation = $"General Archfield"
@onready var NiaAnimation = $"Nia Animation"
@onready var GokuAnimation = $"Goku Animation"
@onready var HunterAnimation = $"Hunter Animation"
@onready var NomadAnimation = $"Nomad Animation"
@onready var AtlantisAnimation = $"Princess Atlantis Animation"

#General Archfield Abilty Showcase
@onready var GeneralArchfieldNlightButton = $"General Archfield Nlight"
@onready var GeneralArchfieldSlightButton = $"General Archfield Slight"
@onready var GeneralArchfieldDlightButton = $"General Archfield Dlight"
@onready var GeneralArchFieldUlightButton = $"General Archfield Ulight"
@onready var GeneralArchfieldNairButton = $"General Archfield Nair"

# Goku Ability Showcase
@onready var GokuNlightButton = $"Goku Nlight"
@onready var GokuSlightButton = $"Goku Slight"
@onready var GokuDlightButton = $"Goku Dlight"
@onready var GokuUlightButton = $"Goku Ulight"
@onready var GokuNairButton = $"Goku Nair"

enum Characters {
	Set,
	GeneralArchfieldIdle,
	GeneralAarchfiedNlight,
	GeneralArchfieldSlight,
	GeneralArchfieldDlight,
	GeneralArchfieldUlight,
	GeneralArchfieldNair,
	GokuIdle,
	GokuNlight,
	GokuSlight,
	GokuDlight,
	GokuUlight,
	GokuNair,
	HunterIdle,
	HunterNlight,
	HunterSlight,
	HunterDlight,
	HunterUlight,
	HunterNair,
	NomadIdle,
	NomadNlight,
	NomadSlight,
	NomadDlight,
	NomadUlight,
	NomadNair,
	NiaIdle,
	NiaNlight,
	NiaSlight,
	NiaDlight,
	NiaUlight,
	NiaNair,
	PrincessAtlantisIdle,
	PrincessAtlantisNlight,
	PrincessAtlantisSlight,
	PrincessAtlantisDlight,
	PrincessAtlantisUlight,
	PrincessAtlantisNair
	
	
	
}

var CharacterState = Characters.Set
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match CharacterState:
		Characters.Set:
			GeneralArchfieldNlightButton.disabled = true
			GeneralArchfieldSlightButton.disabled = true
			GeneralArchfieldDlightButton.disabled = true
			GeneralArchFieldUlightButton.disabled = true
			GeneralArchfieldNairButton.disabled = true
			GokuNlightButton.disabled = true
			GokuSlightButton.disabled = true
			GokuDlightButton.disabled = true
			GokuUlightButton.disabled = true
			GokuNairButton.disabled = true	
		Characters.GeneralArchfieldIdle:
			GeneralArchfieldAnimation.visible = true
			AboutMe.set_text(str("General Arcfield is a heavy character with slow speed but the strongest character in the game with high hp.
			
","Archfield a renowned knight from the fire empire Pyrusa. Archfield is a man almost never bearing a smile. Hot to his core it was said that his blade when swung would ignite the air around him even touching the blade can leave third degree burns. Archfield's greatest accomplishment was the defeat of Archon the Dragon, a ferocious beast that terrorized Fable for centuries. Know Archfield trains and continues to hone his skills to participate in the tournament of fighters.
"))
			GeneralArchfieldAnimation.play("Idle")
			GeneralArchfieldNlightButton.disabled = false
			GeneralArchfieldSlightButton.disabled = false
			GeneralArchfieldDlightButton.disabled = false
			GeneralArchFieldUlightButton.disabled = false
			GeneralArchfieldNairButton.disabled = false
		Characters.GeneralAarchfiedNlight:
			GeneralArchfieldAnimation.play("Nlight")
		Characters.GeneralArchfieldSlight:
			GeneralArchfieldAnimation.play("Slight")
		Characters.GeneralArchfieldDlight:
			GeneralArchfieldAnimation.play("Dlight")
		Characters.GeneralArchfieldUlight:
			GeneralArchfieldAnimation.play("Ulight")
		Characters.GeneralArchfieldNair:
			GeneralArchfieldAnimation.play("Nair")
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Character Selection Resources/Character Selection Menu.tscn")


func _on_general_archfield_nlight_pressed():
	CharacterState = Characters.GeneralAarchfiedNlight

func _on_general_archfield_slight_pressed():
	CharacterState = Characters.GeneralArchfieldSlight
func _on_general_archfield_dlight_pressed():
	CharacterState = Characters.GeneralArchfieldDlight
func _on_general_archfield_ulight_pressed():
	CharacterState = Characters.GeneralArchfieldUlight


func _on_general_archfield_nair_pressed():
	CharacterState = Characters.GeneralArchfieldNair
func _on_general_archfield_detector_area_entered(area):
	if area:
		CharacterState = Characters.GeneralArchfieldIdle


func _on_general_archfield_detector_area_exited(area):
	if area:
		GeneralArchfieldAnimation.visible = false
		GeneralArchfieldNlightButton.disabled = true
		GeneralArchfieldSlightButton.disabled = true
		GeneralArchFieldUlightButton.disabled = true
		GeneralArchFieldUlightButton.disabled = true
		GeneralArchfieldNairButton.disabled = true
		GeneralArchfieldAnimation.visible = false
		GeneralArchfieldAnimation.frame = 0
		GeneralArchfieldAnimation.stop()
		CharacterState = Characters.Set
		print('GOOD')
		




func _on_general_archfield_animation_looped():
	if GeneralArchfieldAnimation.animation == "Nlight":
		CharacterState = Characters.GeneralArchfieldIdle
		print('GOOD')
	if GeneralArchfieldAnimation.animation == "Slight":
		CharacterState = Characters.GeneralArchfieldIdle
	if GeneralArchfieldAnimation.animation == "Dlight":
		CharacterState = Characters.GeneralArchfieldIdle
	if GeneralArchfieldAnimation.animation == "Ulight":
		CharacterState = Characters.GeneralArchfieldIdle
	if GeneralArchfieldAnimation.animation == "Nair":
		CharacterState = Characters.GeneralArchfieldIdle






func _on_goku_detector_area_entered(area):
	pass # Replace with function body.


func _on_goku_detector_area_exited(area):
	pass # Replace with function body.


func _on_hunter_detector_area_entered(area):
	pass # Replace with function body.


func _on_hunter_detector_area_exited(area):
	pass # Replace with function body.


func _on_nia_detector_area_entered(area):
	pass # Replace with function body.


func _on_nia_detector_area_exited(area):
	pass # Replace with function body.


func _on_nomad_detector_area_entered(area):
	pass # Replace with function body.


func _on_nomad_detector_area_exited(area):
	pass # Replace with function body.


func _on_princess_atlantis_detector_area_entered(area):
	pass # Replace with function body.


func _on_princess_atlantis_detector_area_exited(area):
	pass # Replace with function body.
