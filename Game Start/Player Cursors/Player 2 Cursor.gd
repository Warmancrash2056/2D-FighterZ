extends Sprite2D

@onready var sakura_animation = $pla
@onready var general_archfield_animation = $"../Player 2 General Pyrus"
@onready var hunter_animation = $"../Player 2 Hunter"
@onready var nomad_animation = $"../Player 2 Nomad"
@onready var atlantis_animation = $"../Player 2 Atlantis"
@onready var goku_aniamtion = $"../Player 2 Goku"

@export var Controls: Resource 
# Object Array
var characters = []          # Array to store all the characters the player can select

# Integer
var currentSelected = 0      # Spot of the cursor within the characters[]
var currentColumnSpot = 0    # Spot of the cursor based on the column
var currentRowSpot = 0       # Spot of the cursor based on the row

# Exports 
@export var amountOfRows: int = 2      # The total amount of rows the character select is able to show 
@export var portraitOffset: Vector2    # The distance between the portraits

# Objects
@onready var gridContainer = get_parent().get_node("Player 1 Selection")   # Get the Gridcontainer

var Player2Ready = false
func _ready():
# Get all of the characters stored within the group "Characters" and place them in the Array characters
	for nameOfCharacter in get_tree().get_nodes_in_group("Player1"):
		characters.append(nameOfCharacter)
	
# This whole _process(delta) function is used to allow scrolling through all the characters
func _process(delta):
	
	if(Input.is_action_just_pressed(Controls.input_right)):
		currentSelected += 1
		currentColumnSpot += 1
		# If the cursor goes past the total amount of columns reset to the first item in the column and go 1 row down
		if(currentColumnSpot > gridContainer.columns - 1 && currentSelected < characters.size() - 1):
			position.x -= (currentColumnSpot - 1) * portraitOffset.x
			position.y += portraitOffset.y
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
		if CharacterList.Player2 == null:
			CharacterList.Player2
			CharacterList.Player2 = CharacterList.SelectCharacters[characters[currentSelected].name]
			Player2Ready = true
			
	



func _on_player_2_general_pyrus_animation_looped():
	general_archfield_animation.play("Idle")


func _on_player_2_goku_animation_looped():
	goku_aniamtion.play("Idle")


func _on_player_2_hunter_animation_looped():
	hunter_animation.play("Idle")


func _on_player_2_nomad_animation_looped():
	nomad_animation.play("Idle")


func _on_player_2_atlantis_animation_looped():
	pass

func _on_player_2_sakura_animation_looped():
	sakura_animation
func _on_player_2_general_pyrus_select_area_entered(area):
	if area:
		general_archfield_animation.play("Ready")
		general_archfield_animation.visible = true


func _on_player_2_general_pyrus_select_area_exited(area):
	if area:
		general_archfield_animation.stop()
		general_archfield_animation.frame = 0
		general_archfield_animation.visible = false

func _on_player_2_goku_select_area_entered(area):
	if area:
		goku_aniamtion.play("Ready")
		goku_aniamtion.visible = true

func _on_player_2_goku_select_area_exited(area):
	if area:
		goku_aniamtion.stop()
		goku_aniamtion.frame = 0
		goku_aniamtion.visible = false

func _on_player_2_nai_select_area_entered(area):
	if area:
		sakura_animation.play("Ready")
		sakura_animation.visible = true


func _on_player_2_nai_select_area_exited(area):
	if area:
		sakura_animation.stop()
		sakura_animation.frame = 0
		sakura_animation.visible = false

func _on_player_2_hunter_select_area_entered(area):
	if area:
		hunter_animation.play("Ready")
		hunter_animation.visible = true

func _on_player_2_hunter_select_area_exited(area):
	if area:
		hunter_animation.stop()
		hunter_animation.frame = 0
		hunter_animation.visible = false

func _on_player_2_nomad_select_area_entered(area):
	if area:
		NomadAnimation.play("Ready")
		NomadAnimation.visible = true


func _on_player_2_nomad_select_area_exited(area):
	if area:
		NomadAnimation.stop()
		NomadAnimation.frame = 0
		NomadAnimation.visible = false

func _on_player_2_atlantis_select_area_entered(area):
	if area:
		AtlantisAnimation.play("")
		AtlantisAnimation.visible = true


func _on_player_2_atlantis_select_area_exited(area):
	if area:
		AtlantisAnimation.stop()
		AtlantisAnimation.frame = 0
		AtlantisAnimation.visible = false
