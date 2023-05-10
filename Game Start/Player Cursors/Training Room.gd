extends Sprite2D

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

# Call parent node to get the node player selction.
# Important for using columms to move the cursor around
@onready var gridContainer = get_parent().get_node("Player Selection")   # Get the Gridcontainer

var Player1Ready = false
func _ready():
# Get all of the characters stored within the group "Player 1" and place them in the Array characters
	for nameOfCharacter in get_tree().get_nodes_in_group("Player 1"):
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
		if CharacterList.Player2 == null:
			print('Current Character Selected ', '[',characters[currentSelected].name,'] ', currentSelected)
			CharacterList.Player2
			CharacterList.Player2 = CharacterList.SelectCharacters[characters[currentSelected].name]
			print("Player 1 Ready")
			Player1Ready = true
			portraitOffset.x = 0
	


func _on_general_archfield_animation_animation_looped():
	pass # Replace with function body.
