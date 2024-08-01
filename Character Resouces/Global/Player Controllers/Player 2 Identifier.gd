class_name Player2Controller extends Node2D
@export var Controls: Resource
@onready var Player_Icon: Node2D = $'Player Icon'
@onready var Player_Indicator: Sprite2D = $'Controller/Player Indicator'
@onready var Player_Stats: Node = $'Controller/Player Stats'
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CharacterList.player_2_icon = Player_Icon.Icon
	CharacterList.player_2_health = Player_Stats.Health
	Player_Indicator.modulate =  Color(0.545098, 0, 0, 1)

func _physics_process(delta: float) -> void:
	CharacterList.player_2_health = Player_Stats.Health

func _on_hurtbox_is_hurt(Damage: int) -> void:
	CharacterList.player_2_health = Player_Stats.Health
