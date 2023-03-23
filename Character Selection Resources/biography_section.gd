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
@onready var GeneralNlight = $"General Archfield Nlight"
@onready var GeneralSlight = $"General Archfield Slight"
@onready var GeneralDlight = $"General Archfield Dlight"
@onready var GeneralUlight = $"General Archfield Detector/General Archfield Ulight"
@onready var GeneralNair = $"General Archfield Detector/General Archfield Nair"

# Goku Ability Showcase
@onready var GokuNlight = $"Goku Nlight"
@onready var GokuSlight = $"Goku Slight"
@onready var GokuDlight = $"Goku Dlight"
@onready var GokuUlight = $"Goku Ulight"
@onready var GokuNair = $"Goku Nair"

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
	
	
	
	
}

var CharacterState = Characters.Set
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match CharacterState:
		Characters.Set:
			GeneralNlight.disabled = true
			GeneralSlight.disabled = true
			GeneralDlight.disabled = true
			GeneralUlight.disabled = true
			GeneralNair.disabled = true		
		Characters.GeneralArchfieldIdle:
			GeneralArchfieldAnimation.visible = true
			AboutMe.set_text(str("General Archfield a serious man who never frowns a smile. Hot to the core his ferocious flames has stories behind it most notably the defeat of Archon The Great Dragon"))
			GeneralArchfieldAnimation.play("Idle")
			GeneralNlight.disabled = false
			GeneralSlight.disabled = false
			GeneralDlight.disabled = false
			GeneralUlight.disabled = false
			GeneralNair.disabled = false
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
		GeneralNlight.disabled = true
		GeneralSlight.disabled = true
		GeneralDlight.disabled = true
		GeneralUlight.disabled = true
		GeneralNair.disabled = true
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
