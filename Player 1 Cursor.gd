extends Sprite2D

@onready var NaiAnimation = get_parent().get_node("Player 1 Nai")
@onready var GeneralPyrusAniamtion = get_parent().get_node("Player 1 General Pyrus")
@onready var GokuAnimation = get_parent().get_node("Player 1 Goku")
@onready var HunterAnimaton = get_parent().get_node("Player 1 Hunter")
@onready var AtlantisAnimation = get_parent().get_node("Player 1 Atlantis")
@onready var NomadAnimation = get_parent().get_node("Player 1 Nomad")

@export var Controls: Resource
# Object Array
var characters = []          # Array to store all the characters the player can select

# Integer
var currentSelected = 0      # Spot of the cursor within the characters[]
var currentColumnSpot = 0    # Spot of the cursor based on the column
var currentRowSpot = 0       # Spot of the cursor based on the row

# Exports 
@export var PlayerIcon: Texture2D    # Cursor Texture2D for when Player 1 is making a decision    
@export var amountOfRows: int = 2      # The total amount of rows the character select is able to show 
@export var portraitOffset: Vector2    # The distance between the portraits

# Objects
@onready var gridContainer = get_parent().get_node("Player 1 Selection")   # Get the Gridcontainer

var Player1Ready = false
func _ready():
# Get all of the characters stored within the group "Characters" and place them in the Array characters
	for nameOfCharacter in get_tree().get_nodes_in_group("Player1"):
		characters.append(nameOfCharacter)
	print(characters)
	
	texture = PlayerIcon
# This whole _process(delta) function is used to allow scrolling through all the characters
func _process(delta):
	
	if(Input.is_action_just_pressed(Controls.input_right)):
		currentSelected += 1
		currentColumnSpot += 1
		# If the cursor goes past the total amount of columns reset to the first item in the column and go 1 row down
		if(currentColumnSpot > gridContainer.columns - 1 && currentSelected < characters.size() - 1):
			position.x -= (currentColumnSpot - 1) * portraitOffset.x
			position.y += portraitOffset.y
			print(characters)
			currentColumnSpot = 0
			currentRowSpot += 1
		# If the cursor goes past the total amount of columns and amount of characters, reset to the first item in the whole roster 
		elif(currentColumnSpot > gridContainer.columns - 1 && currentSelected > characters.size() - 1):
			position.x -= (currentColumnSpot - 1) * portraitOffset.x
			position.y -= currentRowSpot * portraitOffset.y
			
			currentColumnSpot = 0
			currentRowSpot = 0
			currentSelected = 0
		else:
			position.x += portraitOffset.x
	elif(Input.is_action_just_pressed(Controls.input_left)):
		currentSelected -= 1
		currentColumnSpot -= 1
		# If the cursor goes past the 0 amount on a column position reset to the first item in the column and go 1 row up
		if(currentColumnSpot < 0 && currentSelected > 0):
			position.x += (gridContainer.columns - 1) * portraitOffset.x
			position.y -= (amountOfRows - 1) * portraitOffset.y
			
			currentColumnSpot = gridContainer.columns - 1
			currentRowSpot -= 1
		# If the cursor goes past the 0 amount on a column position and 0 amount of characters, reset to the last item in the whole roster 
		elif (currentColumnSpot < 0 && currentSelected < 0):
			position.x += (gridContainer.columns - 1) * portraitOffset.x
			position.y += (amountOfRows - 1) * portraitOffset.y
			
			currentColumnSpot = gridContainer.columns - 1
			currentRowSpot = amountOfRows - 1
			currentSelected = characters.size() - 1
		else:
			position.x -= portraitOffset.x
	
	if Input.is_action_just_pressed(Controls.input_jump):
		if CharacterSelection.Player1 == null:
			print('Current Character Selected ', '[',characters[currentSelected].name,']', currentSelected)
			print(CharacterSelection.Player1)
			print("remove this item from array " , CharacterSelection.SelectCharacters[characters[currentSelected].name])
			CharacterSelection.Player1
			CharacterSelection.Player1 = CharacterSelection.SelectCharacters[characters[currentSelected].name]
			Player1Ready = true
			print("Player 1 Ready")
			
		elif Input.is_action_just_pressed(Controls.input_jump):
			characters
			
# Control the animation selected
func _on_Player_1_General_Pyrus_area_entered(area):
	if area:
		GeneralPyrusAniamtion.play("General Pyrus Ready ")
		GeneralPyrusAniamtion.visible = true

func _on_Player_1_General_Pyrus_area_exited(area):
	if area:
		GeneralPyrusAniamtion.frame = 0
		GeneralPyrusAniamtion.visible = false


func _on_Player_1_Goku_area_entered(area):
	if area:
		GokuAnimation.play("Goku Ready")
		GokuAnimation.visible = true


func _on_Player_1_Goku_area_exited(area):
	if area:
		GokuAnimation.frame = 0
		GokuAnimation.visible = false


func _on_Player_1_Nai_area_entered(area):
	if area:
		NaiAnimation.play("Ready")
		NaiAnimation.visible = true


func _on_Player_1_Nai_area_exited(area):
	NaiAnimation.frame = 0
	NaiAnimation.visible = false


func _on_Player_1_Hunter_area_entered(area):
	if area: 
		HunterAnimaton.play("Hunter Ready")
		HunterAnimaton.visible = true

func _on_Player_1_Hunter_area_exited(area):
	if area:
		HunterAnimaton.frame = 0
		HunterAnimaton.visible = false


func _on_Player_1_Nomad_area_entered(area):
	if area:
		NomadAnimation.play("Nomad Ready")
		NomadAnimation.visible = true


func _on_Player_1_Nomad_area_exited(area):
	if area:
		NomadAnimation.frame = 0
		NomadAnimation.visible = false


func _on_Player_1_Atlantis_area_entered(area):
	if area:
		AtlantisAnimation.play("Atlantis Ready")
		AtlantisAnimation.visible = true
		


func _on_Player_1_Atlantis_area_exited(area):
	if area:
		AtlantisAnimation.frame = 0
		AtlantisAnimation.visible = false


func _on_Nai_animation_finished():
	NaiAnimation.play("Hold")


func _on_Player_1_General_Pyrus_animation_finished():
	GeneralPyrusAniamtion.play("Hold ")


func _on_Player_1_Goku_animation_finished():
	GokuAnimation.play("Hold")


func _on_Player_1_Hunter_animation_finished():
	HunterAnimaton.play("Hold")


func _on_Player_1_Atlantis_animation_finished():
	pass # Replace with function body.


func _on_Player_1_Nomad_animation_finished():
	NomadAnimation.play("Hold")
