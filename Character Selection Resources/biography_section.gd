extends Control

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


func _on_princess_atlantis_detector_area_entered(area):
	pass # Replace with function body.


func _on_princess_atlantis_detector_area_exited(area):
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	pass # Replace with function body.


func _on_hunter_detector_area_entered(area):
	pass # Replace with function body.


func _on_hunter_detector_area_exited(area):
	pass # Replace with function body.


func _on_nia_detector_area_entered(area):
	pass # Replace with function body.


func _on_nia_detector_area_exited(area):
	pass # Replace with function body.

func _on_hunter_animation_animation_looped():
	pass # Replace with function body.


func _on_nia_animation_animation_looped():
	pass # Replace with function body.


func _on_nomad_animation_animation_looped():
	pass # Replace with function body.


func _on_princess_atlantis_animation_animation_looped():
	pass # Replace with function body.

