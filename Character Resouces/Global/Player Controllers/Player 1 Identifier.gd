class_name Player1Controller extends Node2D
@export var Controls: Resource
@export var Attack_Layer: int = 10
@export var Attack_Mask: int = 13
@export var Body_Layer: int = 11
@export var Body_Mask: int = 12
@export var Motion_Layer: int = 14
@export var Motion_Mask: int = 15
@onready var Controller = $Controller
@onready var Player_Icon: Node2D = $'Player Icon'
@onready var Player_Indicator: Sprite2D = $'Controller/Player Indicator'
@onready var Player_Stats: Node = $'Controller/Player Stats'
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CharacterList.player_1_icon = Player_Icon.Icon
	CharacterList.player_1_health = Player_Stats.Health
	Player_Indicator.modulate = Color(0, 0, 0.545098, 1)


func _process(delta: float) -> void:
	CharacterList.player_1_health = Player_Stats.Health
	MatchGameManager.player_1_global_position = Controller.global_position


func _on_hurtbox_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_block_hurtbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
