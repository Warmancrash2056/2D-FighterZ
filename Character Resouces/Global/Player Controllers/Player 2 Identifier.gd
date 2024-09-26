class_name Player2Controller extends Node2D
@export var Controls: Resource = preload('res://Character Resouces/Global/Controller Resource/Player_2.tres')
@export var Attack_Layer: int = 12
@export var Attack_Mask: int = 11
@export var Body_Layer: int = 13
@export var Body_Mask: int = 10
@export var Motion_Layer: int = 15
@export var Motion_Mask: int = 14
@onready var Controller = $Controller
@onready var Player_Icon: Node2D = $'Player Icon'
@onready var Player_Indicator: Sprite2D = $'Controller/Player Indicator'
@onready var Player_Stats: Node = $'Controller/Player Stats'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CharacterList.player_2_icon = Player_Icon.Icon
	CharacterList.player_2_health = Player_Stats.Health
	Player_Indicator.modulate =  Color(0.545098, 0, 0, 1)

func _process(delta: float) -> void:
	CharacterList.player_2_health = Player_Stats.Health
	MatchGameManager.player_2_global_position = Controller.global_position
