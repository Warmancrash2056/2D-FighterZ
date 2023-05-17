extends Sprite2D

@onready var NaiAnimation = $"../Player 1 Sakura"
@onready var GeneralPyrusAnimation = $"../Player 1 General Archfield"
@onready var HunterAnimation = $"../Player 1 Hunter"
@onready var NomadAnimation = $"../Player 1 Nomad"
@onready var AtlantisAnimation = $"../Player 1 Atlantis"
@onready var GokuAnimation = $"../Player 1 Goku"

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

# Call parent node to get the character selection
@onready var gridContainer = get_parent().get_node("Player 1 Selection")   # Get the Gridcontainer

var Player1Ready = false
func _ready():
# Get all of the characters stored within the group "Player 1" and place them in the Array characters
	for nameOfCharacter in get_tree().get_nodes_in_group("Player1"):
		characters.append(nameOfCharacter)
	print(characters)
	
	texture = PlayerIcon
# This whole _process(delta) function is used to allow scrolling through all the characters
func _process(delta):
	print(currentSelected)
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
		if CharacterList.Player1 == null:
			print('Current Character Selected ', '[',characters[currentSelected].name,'] ', currentSelected)
			CharacterList.Player1
			CharacterList.Player1 = CharacterList.SelectCharacters[characters[currentSelected].name]
			print("Player 1 Ready")
			Player1Ready = true
			portraitOffset.x = 0
	

func _on_player_1_general_pyrus_animation_looped():
	GeneralPyrusAnimation.play("Idle")

func _on_player_1_goku_animation_looped():
	GokuAnimation.play("Idle")


func _on_player_1_hunter_animation_looped():
	HunterAnimation.play("Idle")


func _on_player_1_nomad_animation_looped():
	NomadAnimation.play("Idle")


func _on_player_1_atlantis_animation_looped():
	pass # Replace with function body.


func _on_player_1_nai_animation_looped():
	NaiAnimation.play("Idle")


func _on_player_1_general_pyrus_select_area_entered(area):
	if area:
		GeneralPyrusAnimation.play("Ready")
		GeneralPyrusAnimation.visible = true


func _on_player_1_general_pyrus_select_area_exited(area):
	if area:
		GeneralPyrusAnimation.stop()
		GeneralPyrusAnimation.frame = 0
		GeneralPyrusAnimation.visible = false

func _on_player_1_nai_select_area_entered(area):
	if area:
		NaiAnimation.play("Ready")
		NaiAnimation.visible = true


func _on_player_1_nai_select_area_exited(area):
	if area:
		NaiAnimation.stop()
		NaiAnimation.frame = 0
		NaiAnimation.visible = false

func _on_player_1_hunter_select_area_entered(area):
	if area:
		HunterAnimation.play("Ready")
		HunterAnimation.visible = true


func _on_player_1_hunter_select_area_exited(area):
	if area:
		HunterAnimation.stop()
		HunterAnimation.frame = 0
		HunterAnimation.visible = false

func _on_player_1_nomad_select_area_entered(area):
	if area:
		NomadAnimation.play("Ready")
		NomadAnimation.visible = true


func _on_player_1_nomad_select_area_exited(area):
	if area:
		NomadAnimation.stop()
		NomadAnimation.frame = 0
		NomadAnimation.visible = false

func _on_player_1_atlantis_select_area_entered(area):
	if area:
		AtlantisAnimation.play("Ready")
		AtlantisAnimation.visible = true


func _on_player_1_atlantis_select_area_exited(area):
	if area:
		AtlantisAnimation.stop()
		AtlantisAnimation.frame = 0
		AtlantisAnimation.visible = false


func _on_player_1_goku_select_area_entered(area):
	if area:
		GokuAnimation.play("Ready")
		GokuAnimation.visible = true


func _on_player_1_goku_select_area_exited(area):
	if area:
		GokuAnimation.stop()
		GokuAnimation.frame = 0
		GokuAnimation.visible = false


func _on_player_2_hunter_animation_looped():
	pass # Replace with function body.
