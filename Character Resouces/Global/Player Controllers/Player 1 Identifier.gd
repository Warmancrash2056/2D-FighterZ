class_name Player1Controller extends Node2D

@export var Controls: Resource

@onready var Player_Icon: Node2D = $'Player Icon'
@onready var Player_Indicator: Sprite2D = $'Controller/Player Indicator'
@onready var Player_Stats: Node = $'Controller/Player Stats'
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CharacterList.player_1_icon = Player_Icon.Icon
	CharacterList.player_1_health = Player_Stats.Health
	Player_Indicator.modulate = Color(0, 0, 0.545098, 1)


func _on_hurtbox_is_hurt(Damage: int) -> void:
	CharacterList.player_1_health = Player_Stats.Health
