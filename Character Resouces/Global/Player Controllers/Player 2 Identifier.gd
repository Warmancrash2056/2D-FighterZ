class_name Player2Controller extends Node2D
@export var Controls: Resource
@onready var Player_Icon: Node2D = $'Player Icon'
@onready var Player_Indicator: Sprite2D = $'Controller/Player Indicator'
@onready var Player_Stats: Node = $'Controller/Player Stats'
@onready var attack_positioner = %'Attack Positioner'
@onready var transition_attack = %'Transitional Check'
@onready var nlight_1 = %'Neutral Light - 1'
@onready var nlight_2 = %'Neutral Light - 2'
@onready var nlight_3 = %'Neutral Light - 3'
@onready var nair_1 = %'Neutral Air - 1'
@onready var nair_2 = %'Neutral Air - 2'
@onready var nair_3 = %'Neutral Air - 3'
@onready var nheavy_3 = %'Neatral Heavy - 1'
@onready var nheavy_1 = %'Neutral Heavy - 2'
@onready var nheavy_2 = %'Neutral Heavy - 3'
@onready var nrec_1 = %'Neautral Recovery - 1'
@onready var nrec_2 = %'Neautral Recovery - 2'
@onready var nrec_3 = %'Neautral Recovery - 3'
@onready var dlight_1 = %'Down Light - 1'
@onready var dlight_2 = %'Down Light - 2'
@onready var dlight_3 = %'Down Light - 3'
@onready var Hurtbox = %Hurtbox
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CharacterList.player_2_icon = Player_Icon.Icon
	CharacterList.player_2_health = Player_Stats.Health
	Player_Indicator.modulate =  Color(0.545098, 0, 0, 1)
	attack_positioner.set_collision_layer_value(13, true)
	attack_positioner.set_collision_mask_value(10, true)
	transition_attack.set_collision_layer_value(13, true)
	transition_attack.set_collision_mask_value(10, true)
	nlight_1.set_collision_layer_value(13, true)
	nlight_1.set_collision_mask_value(10, true)
	nlight_2.set_collision_layer_value(13, true)
	nlight_2.set_collision_mask_value(10, true)
	nlight_3.set_collision_layer_value(13, true)
	nlight_3.set_collision_mask_value(10, true)
	nair_1.set_collision_layer_value(13, true)
	nair_1.set_collision_mask_value(10, true)
	nair_2.set_collision_layer_value(13, true)
	nair_2.set_collision_mask_value(10, true)
	nair_3.set_collision_layer_value(13, true)
	nair_3.set_collision_mask_value(10, true)
	nheavy_1.set_collision_layer_value(13, true)
	nheavy_1.set_collision_mask_value(10, true)
	nheavy_3.set_collision_layer_value(13, true)
	nheavy_3.set_collision_mask_value(10, true)
	nrec_1.set_collision_layer_value(13, true)
	nrec_1.set_collision_mask_value(10, true)
	nrec_2.set_collision_layer_value(13, true)
	nrec_2.set_collision_mask_value(10, true)
	nrec_3.set_collision_layer_value(13, true)
	nrec_3.set_collision_mask_value(10, true)
	Hurtbox.set_collision_layer_value(12, true)
	Hurtbox.set_collision_mask_value(11, true)

func _physics_process(delta: float) -> void:
	CharacterList.player_2_health = Player_Stats.Health

func _on_hurtbox_is_hurt(Damage: int) -> void:
	CharacterList.player_2_health = Player_Stats.Health
