extends Sprite

var Player1Selected = false

export var Controls: Resource = preload("res://Character Resouces/Global/Player_1.tres")

# Create an array to hold the characters 
var Character = []

# The palcement of the characters 
var CurrentSelected = 0 

# Position of the cursor based on the columm
var CurrentColummSpot = 0

# Position of the cursor based on the row
var CurrentRowSpot = 0

# Get the player cursor to use and position on the character
export (Texture) var CursorIcon

# The total amount of rows the character is able to select is able to show
export (int) var AmmountOfRows = 2

# The distance between the portraits
export (Vector2) var PortraitOffset

# Get the player 1 selection grid from the parent
onready var PlayerGrid = get_parent().get_node("Player 2 Selection")

func _ready():
	# Get all the character in the group (Characters) to be sorted in the array
	for NameOfCharacters in get_tree().get_nodes_in_group("Player2"):
		Character.append(NameOfCharacters)
		
	# Prints the name of the character list 
	print(Character) 
	
	texture = CursorIcon
	
	
func _process(delta):
	#print(CurrentRowSpot)
	
	if Input.is_action_just_pressed("ui_left"):
		CurrentSelected += 1
		CurrentColummSpot += 1
		
		if CurrentColummSpot > PlayerGrid.columns - 1 && CurrentSelected < Character.size() - 1:
			position.x -= CurrentColummSpot - 1 * PortraitOffset.x
			position.y += PortraitOffset.y
			print(Character)
			CurrentColummSpot = 0
			CurrentRowSpot += 1
			
		elif CurrentColummSpot > PlayerGrid.columns - 1 && CurrentSelected > Character.size() - 1:
			position.x -= CurrentColummSpot - 1 * PortraitOffset.x 
			position.y -= CurrentRowSpot * PortraitOffset.y 
			CurrentColummSpot = 0
			CurrentRowSpot = 0
			CurrentSelected = 0
			
		else:
			position.x += PortraitOffset.x 
	
