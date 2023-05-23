extends Control

@export var Controls : Resource

#Biography Section 
@onready var GeneralArchfieldDescription = $"General Archfield Description"
@onready var GokuDescription = $"Goku Description"
@onready var NomadDescription = $"Nomad Description"
@onready var HunterDescription = $"Hunter Description"
@onready var NiaDescription = $"Nia Description"
@onready var PrincessAtlantisDescription = $"Princess Atlantis Description"

@onready var Biography = $Biography

#General Archfield Abilty Showcase
@onready var GeneralArchfieldAnimation = $"General Archfield Character Selection/General Archfield Animation"
@onready var GeneralArchfieldNlightButton = $"General Archfield Character Selection/General Archfield Nlight"
@onready var GeneralArchfieldSlightButton = $"General Archfield Character Selection/General Archfield Slight"
@onready var GeneralArchfieldDlightButton = $"General Archfield Character Selection/General Archfield Dlight"
@onready var GeneralArchFieldUlightButton = $"General Archfield Character Selection/General Archfield Ulight"
@onready var GeneralArchfieldNairButton = $"General Archfield Character Selection/General Archfield Nair"

# Goku Ability Showcase
@onready var GokuAnimation = $"Goku Character Selection/Goku Animation"
@onready var GokuNlightButton = $"Goku Character Selection/Goku Nlight"
@onready var GokuSlightButton = $"Goku Character Selection/Goku Slight"
@onready var GokuDlightButton = $"Goku Character Selection/Goku Dlight"
@onready var GokuUlightButton = $"Goku Character Selection/Goku Ulight"
@onready var GokuNairButton = $"Goku Character Selection/Goku Nair"

# Nomad Animation Showcas
@onready var NomadAnimation = $"Nomad Character Selection/Nomad Animation"
@onready var NomadNlightButton = $"Nomad Character Selection/Nomad Nlight"
@onready var NomadSlightButton = $"Nomad Character Selection/Nomad Slight"
@onready var NomadDlightButton = $"Nomad Character Selection/Nomad Dlight"
@onready var NomadUlightButton = $"Nomad Character Selection/Nomad Ulight"
@onready var NomadNairButton = $"Nomad Character Selection/Nomad Nair"

# Hunter Animation Showcase
@onready var HunterAnimation = $"Hunter Character Selelction/Hunter Animation"
@onready var HunterNlightButton = $"Hunter Character Selelction/Hunter Nlight"
@onready var HunterSlightButton = $"Hunter Character Selelction/Hunter Slight"
@onready var HunterDlightButton = $"Hunter Character Selelction/Hunter Dlight"
@onready var HunterUlightButton = $"Hunter Character Selelction/Hunter Ulight"
@onready var HunterNairButton = $"Hunter Character Selelction/Hunter Nair"

# Princess Atlantis Animation Showcase
@onready var PrincessAtlantisAnimation = $"Princess Atlantis Character Selection/Princess Atlantis Animation"
@onready var PrincessAtlantisNlightButton = $"Princess Atlantis Character Selection/Princess Atlantis Nlight"
@onready var PrincessAtlantisSlightButton = $"Princess Atlantis Character Selection/Princess Atlantis Slight"
@onready var PrincessAtlantisDlightButton = $"Princess Atlantis Character Selection/Princess Atlantis Dlight"
@onready var PrincessAtlantisUlightButton= $"Princess Atlantis Character Selection/Princess Atlantis Ulight"
@onready var PrincessAtlantisNairButton = $"Princess Atlantis Character Selection/Princess Atlantis Nair"

# Nia Animation Animation Showcase
@onready var NiaAnimation = $"Nia Character Selection/Nia Animation"
@onready var NiaNlightButton = $"Nia Character Selection/Nia Nlight"
@onready var NiaSlightButton= $"Nia Character Selection/Nia Slight"
@onready var NiaDlightButton = $"Nia Character Selection/Nia Dlight"
@onready var NiaUlightButton = $"Nia Character Selection/Nia Ulight"
@onready var NiaNairButton = $"Nia Character Selection/Nia Nair"

func _ready():
	pass
func _process(delta):
	if Input.is_action_just_pressed(""):
		get_tree().change_scene_to_file("res://Character Selection Resources/Start Game.tscn")

func _on_general_archfield_animation_looped():
	GeneralArchfieldAnimation.play("Idle")

func _on_general_archfield_nlight_pressed():
	GeneralArchfieldAnimation.play("Nlight")


func _on_general_archfield_slight_pressed():
	GeneralArchfieldAnimation.play("Slight")


func _on_general_archfield_dlight_pressed():
	GeneralArchfieldAnimation.play("Dlight")


func _on_general_archfield_ulight_pressed():
	GeneralArchfieldAnimation.play("Ulight")


func _on_general_archfield_nair_pressed():
	GeneralArchfieldAnimation.play("Nair")


func _on_general_archfield_detector_area_entered(area):
	if area:	
		# Make Character Visible. #
		GeneralArchfieldDescription.visible = true
		GeneralArchfieldAnimation.play("Idle")
		GeneralArchfieldAnimation.visible = true
		
		# Turn on buttons and make them visible. #
		GeneralArchfieldNlightButton.visible = true
		GeneralArchfieldNlightButton.disabled = false
		
		GeneralArchfieldSlightButton.visible = true
		GeneralArchfieldSlightButton.disabled = false
		
		GeneralArchfieldDlightButton.visible = true
		GeneralArchfieldDlightButton.disabled = false
		
		GeneralArchFieldUlightButton.visible = true
		GeneralArchFieldUlightButton.disabled = false
		
		GeneralArchfieldNairButton.visible = true
		GeneralArchfieldNairButton.disabled = false


func _on_general_archfield_detector_area_exited(area):
	
		GeneralArchfieldDescription.visible = false
		GeneralArchfieldAnimation.visible = false
		GeneralArchfieldAnimation.stop()
		GeneralArchfieldAnimation.frame = 0
		
		
		# Turn on buttons and make them visible. #
		GeneralArchfieldNlightButton.visible = false
		GeneralArchfieldNlightButton.disabled = true
		
		GeneralArchfieldSlightButton.visible = false
		GeneralArchfieldSlightButton.disabled = true
		
		GeneralArchfieldDlightButton.visible = false
		GeneralArchfieldDlightButton.disabled = true
		
		GeneralArchFieldUlightButton.visible = false
		GeneralArchFieldUlightButton.disabled = true
		
		GeneralArchfieldNairButton.visible = false
		GeneralArchfieldNairButton.disabled = true

func _on_goku_animation_animation_looped():
	GokuAnimation.play("Idle")

func _on_goku_nlight_pressed():
	GokuAnimation.play("Nlight")


func _on_goku_slight_pressed():
	GokuAnimation.play("Slight")


func _on_goku_dlight_pressed():
	GokuAnimation.play("Dlight")


func _on_goku_ulight_pressed():
	GokuAnimation.play("Ulight")


func _on_goku_nair_pressed():
	GokuAnimation.play("Nair")
	
func _on_goku_detector_area_entered(area):
	GokuDescription.visible = true
	GokuAnimation.visible = true
	GokuAnimation.play("Idle")
	
	GokuNlightButton.disabled = false
	GokuNlightButton.visible = true
	
	GokuSlightButton.disabled = false
	GokuSlightButton.visible = true
	
	GokuDlightButton.disabled = false
	GokuDlightButton.visible = true
	
	GokuUlightButton.disabled = false
	GokuUlightButton.visible = true
	
	GokuNairButton.disabled = false
	GokuNairButton.visible = true
	
func _on_goku_detector_area_exited(area):
	GokuDescription.visible = false
	GokuAnimation.visible = false
	GokuAnimation.frame = 0
	GokuAnimation.stop()
	
	GokuNlightButton.disabled = true
	GokuNlightButton.visible = false
	
	GokuSlightButton.disabled = true
	GokuSlightButton.visible = false
	
	GokuDlightButton.disabled = true
	GokuDlightButton.visible = false
	
	GokuUlightButton.disabled = true
	GokuUlightButton.visible = false
	
	GokuNairButton.disabled = true
	GokuNairButton.visible = false
	
func _on_princess_atlantis_animation_animation_looped():
	PrincessAtlantisAnimation.play("Idle")
	
func _on_princess_atlantis_nlight_pressed():
	PrincessAtlantisAnimation.play("Nlight")

func _on_princess_atlantis_slight_pressed():
	PrincessAtlantisAnimation.play("Slight")

func _on_princess_atlantis_dlight_pressed():
	PrincessAtlantisAnimation.play("Dlight")


func _on_princess_atlantis_ulight_pressed():
	PrincessAtlantisAnimation.play("Ulight")


func _on_princess_atlantis_nair_pressed():
	PrincessAtlantisAnimation.play("Nair")


func _on_princess_atlantis_detector_area_entered(area):
	PrincessAtlantisAnimation.play("Idle")
	PrincessAtlantisAnimation.visible = true
	
	PrincessAtlantisDescription.visible = true
	
	PrincessAtlantisNlightButton.disabled = false
	PrincessAtlantisNlightButton.visible = true
	
	PrincessAtlantisSlightButton.disabled = false
	PrincessAtlantisSlightButton.visible = true
	
	PrincessAtlantisDlightButton.disabled = false
	PrincessAtlantisDlightButton.visible = true
	
	PrincessAtlantisUlightButton.disabled = false
	PrincessAtlantisUlightButton.visible = true
	
	PrincessAtlantisNairButton.disabled = false
	PrincessAtlantisNairButton.visible = true
	
	


func _on_princess_atlantis_detector_area_exited(area):
	PrincessAtlantisAnimation.visible = false
	PrincessAtlantisAnimation.stop()
	PrincessAtlantisAnimation.frame = 0
	PrincessAtlantisDescription.visible = false
	
	
	
	PrincessAtlantisNlightButton.disabled = true
	PrincessAtlantisNlightButton.visible = false
	
	PrincessAtlantisSlightButton.disabled = true
	PrincessAtlantisSlightButton.visible = false
	
	PrincessAtlantisDlightButton.disabled = true
	PrincessAtlantisDlightButton.visible = false
	
	PrincessAtlantisUlightButton.disabled = true
	PrincessAtlantisUlightButton.visible = false
	
	PrincessAtlantisNairButton.disabled = true
	PrincessAtlantisNairButton.visible = false


func _on_hunter_detector_area_entered(area):
	HunterAnimation.visible = true
	HunterAnimation.play("Idle")
	HunterDescription.visible = true
	
	HunterNlightButton.disabled = false
	HunterNlightButton.visible = true
	
	HunterSlightButton.disabled = false
	HunterSlightButton.visible = true
	
	HunterDlightButton.disabled = false
	HunterDlightButton.visible = true
	
	HunterUlightButton.disabled = false
	HunterUlightButton.visible = true
	
	HunterNairButton.disabled = false
	HunterNairButton.visible = true
func _on_hunter_detector_area_exited(area):
	HunterAnimation.visible = false
	HunterAnimation.frame = 0
	HunterAnimation.stop()
	HunterDescription.visible = false
	
	HunterNlightButton.disabled = true
	HunterNlightButton.visible = false
	
	HunterSlightButton.disabled = true
	HunterSlightButton.visible = false
	
	HunterDlightButton.disabled = true
	HunterDlightButton.visible = false
	
	HunterUlightButton.disabled = true
	HunterUlightButton.visible = false
	
	HunterNairButton.disabled = true
	HunterNairButton.visible = false


func _on_hunter_animation_animation_looped():
	HunterAnimation.play("Idle")
	
func _on_hunter_nlight_pressed():
	HunterAnimation.play("Nlight")


func _on_hunter_slight_pressed():
	HunterAnimation.play("Slight")


func _on_hunter_dlight_pressed():
	HunterAnimation.play("Dlight")


func _on_hunter_ulight_pressed():
	HunterAnimation.play("Ulight")


func _on_hunter_nair_pressed():
	HunterAnimation.play("Nair")

func _on_nomad_animation_animation_looped():
	NomadAnimation.play("Idle")
	
func _on_nomad_detector_area_entered(area):
	NomadAnimation.play("Idle")
	NomadAnimation.visible = true
	NomadDescription.visible = true

	NomadNlightButton.disabled = false
	NomadNlightButton.visible = true

	NomadSlightButton.disabled = false
	NomadSlightButton.visible = true
	
	NomadDlightButton.disabled = false
	NomadDlightButton.visible = true
	
	NomadUlightButton.disabled = false
	NomadUlightButton.visible = true
	
	NomadNairButton.disabled = false
	NomadNairButton.visible = true
	
func _on_nomad_detector_area_exited(area):
	NomadAnimation.stop()
	NomadAnimation.frame = 0
	NomadDescription.visible = false
	NomadAnimation.visible = false
	
	NomadNlightButton.disabled = true
	NomadNlightButton.visible = false
	
	NomadSlightButton.disabled = true
	NomadSlightButton.visible = false
	
	NomadDlightButton.disabled = true
	NomadDlightButton.visible = false
	
	NomadUlightButton.disabled = true
	NomadUlightButton.visible = false
	
	NomadNairButton.disabled = true
	NomadNairButton.visible = false


func _on_nomad_nair_pressed():
	NomadAnimation.play("Nair")


func _on_nomad_ulight_pressed():
	NomadAnimation.play("Ulight")


func _on_nomad_dlight_pressed():
	NomadAnimation.play("Dlight")


func _on_nomad_slight_pressed():
	NomadAnimation.play("Slight")


func _on_nomad_nlight_pressed():
	NomadAnimation.play("Nlight")
	
func _on_nia_detector_area_entered(area):
	if area:
		NiaAnimation.play("Idle")
		NiaAnimation.visible = true
		NiaDescription.visible = true
		
		NiaNlightButton.disabled = false
		NiaNlightButton.visible = true
		
		NiaSlightButton.disabled = false
		NiaSlightButton.visible = true
		
		NiaDlightButton.disabled = false
		NiaDlightButton.visible = true
		
		NiaUlightButton.disabled = false
		NiaUlightButton.visible = true
		
		NiaNairButton.disabled = false
		NiaNairButton.visible = true


func _on_nia_detector_area_exited(area):
	if area:
		NiaAnimation.stop()
		NiaAnimation.frame = 0
		NiaAnimation.visible = false
		NiaDescription.visible = false
		NiaNlightButton.disabled = true
		NiaNlightButton.visible = false
		
		NiaSlightButton.disabled = true
		NiaSlightButton.visible = false
		
		NiaDlightButton.disabled = true
		NiaDlightButton.visible = false
		
		NiaUlightButton.disabled = true
		NiaUlightButton.visible = false
		
		NiaNairButton.disabled = true
		NiaNairButton.visible = false


func _on_nia_animation_animation_looped():
	NiaAnimation.play("Idle")
	
func _on_nia_nlight_pressed():
	NiaAnimation.play("Nlight")


func _on_nia_slight_pressed():
	NiaAnimation.play("Slight")


func _on_nia_dlight_pressed():
	NiaAnimation.play("Dlight")


func _on_nia_ulight_pressed():
	NiaAnimation.play("Ulight")


func _on_nia_nair_pressed():
	NiaAnimation.play("Nair")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Character Selection Resources/Character Selection Menu.tscn")


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
