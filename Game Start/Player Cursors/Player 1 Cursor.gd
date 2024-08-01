extends Sprite2D

@onready var NaiAnimation = $"../Player 1 Sakura"
@onready var GeneralPyrusAnimation = $"../Player 1 General Archfield"
@onready var HunterAnimation = $"../Player 1 Hunter"
@onready var NomadAnimation = $"../Player 1 Nomad"
@onready var AtlantisAnimation = $"../Player 1 Atlantis"
@onready var GokuAnimation = $"../Player 1 Goku"

@onready var player_1_tag = $"../Player 1 Name"
var Controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")
# Object Array
var characters = []          # Array to store all the characters the player can select

# Integer
var currentSelected = 0      # Spot of the cursor within the characters[]
var currentColumnSpot = 0    # Spot of the cursor based on the column
var currentRowSpot = 0       # Spot of the cursor based on the row

@export var amountOfRows: int = 2      # The total amount of rows the character select is able to show
@export var portraitOffset: Vector2    # The distance between the portraits

# Call parent node to get the character selection
@onready var gridContainer = get_parent().get_node("Character Selection")   # Get the Gridcontainer

var Player1Ready = false
func _ready():
# Get all of the characters stored within the group "Player 1" and place them in the Array characters
	for nameOfCharacter in get_tree().get_nodes_in_group("Player1"):
		characters.append(nameOfCharacter)
# This whole _process(delta) function is used to allow scrolling through all the characters
func _process(delta):
	#print("Character 1: ", currentSelected)
	if(Input.is_action_just_pressed(Controls.right)):
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
	elif(Input.is_action_just_pressed(Controls.left)):
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

	if Input.is_action_just_pressed(Controls.jump):
		Player1Ready = true
		if CharacterList.get_player_1 == null:
			CharacterList.get_player_1
			CharacterList.get_player_1 = CharacterList.Player_1SelectCharacters[characters[currentSelected].name]
			# when character selected map spawn will be active for player 1.
			CharacterList.check_player_1_is_called = true
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
		player_1_tag.set_text(str("General Archfield"))
		player_1_tag.position.x = 304

func _on_player_1_general_pyrus_select_area_exited(area):
	if area:
		GeneralPyrusAnimation.stop()
		GeneralPyrusAnimation.frame = 0
		GeneralPyrusAnimation.visible = false
func _on_player_1_nai_select_area_entered(area):
	if area:
		NaiAnimation.play("Ready")
		NaiAnimation.visible = true
		player_1_tag.set_text(str("Sakura"))
		player_1_tag.position.x = 344

func _on_player_1_nai_select_area_exited(area):
	if area:
		NaiAnimation.stop()
		NaiAnimation.frame = 0
		NaiAnimation.visible = false

func _on_player_1_hunter_select_area_entered(area):
	if area:
		HunterAnimation.play("Ready")
		HunterAnimation.visible = true
		player_1_tag.set_text(str("Hunter"))


func _on_player_1_hunter_select_area_exited(area):
	if area:
		HunterAnimation.stop()
		HunterAnimation.frame = 0
		HunterAnimation.visible = false

func _on_player_1_nomad_select_area_entered(area):
	if area:
		NomadAnimation.play("Ready")
		NomadAnimation.visible = true
		player_1_tag.set_text(str("Nomad"))


func _on_player_1_nomad_select_area_exited(area):
	if area:
		NomadAnimation.stop()
		NomadAnimation.frame = 0
		NomadAnimation.visible = false

func _on_player_1_atlantis_select_area_entered(area):
	if area:
		AtlantisAnimation.play("Ready")
		AtlantisAnimation.visible = true
		player_1_tag.set_text(str("Atlantis"))
		player_1_tag.position.x = 328


func _on_player_1_atlantis_select_area_exited(area):
	if area:
		AtlantisAnimation.stop()
		AtlantisAnimation.frame = 0
		AtlantisAnimation.visible = false



func _on_player_1_goku_select_area_entered(area):
	if area:
		GokuAnimation.play("Ready")
		GokuAnimation.visible = true
		player_1_tag.set_text(str("Goku"))
		player_1_tag.position.x = 332


func _on_player_1_goku_select_area_exited(area):
	if area:
		GokuAnimation.stop()
		GokuAnimation.frame = 0
		GokuAnimation.visible = false

