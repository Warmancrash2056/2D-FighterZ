class_name Player1Controller extends Node2D
@export var Controls: Resource = preload('res://Character Resouces/Global/Controller Resource/Player_1.tres')
@export var Projectile_Layer: int = 11
@export var Projectile_Mask: int = 12
@onready var Controller = $Controller
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
@onready var dair_1 = %'Down Air - 1'
@onready var dair_2 = %'Down Air - 2'
@onready var dair_3 = %'Down Air - 3'
@onready var dheavy_1 = %'Down Heavy - 1'
@onready var dheavy_2 = %'Down Heavy - 2'
@onready var dheavy_3 = %'Down Heavy - 3'
@onready var drec_1 = %'Down Recovery - 1'
@onready var drec_2 = %'Down Recovery - 2'
@onready var drec_3 = %'Down Recovery - 3'
@onready var slight_1 = %'Side Light - 1'
@onready var slight_2 = %'Side Light -  2'
@onready var slight_3 = %'Side Light - 3'
@onready var sair_1 = %'Side Air - 1'
@onready var sair_2 = %'Side Air - 2'
@onready var sair_3 = %'Side Air - 3'
@onready var sheavy_1 = %'Side Heavy - 1'
@onready var sheavy_2 = %'Side Heavy - 2'
@onready var sheavy_3 = %'Side Heavy - 3'
@onready var Hurtbox = %Hurtbox
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CharacterList.player_1_icon = Player_Icon.Icon
	CharacterList.player_1_health = Player_Stats.Health
	Player_Indicator.modulate = Color(0, 0, 0.545098, 1)
	attack_positioner.set_collision_layer_value(11, true)
	attack_positioner.set_collision_mask_value(12, true)
	transition_attack.set_collision_layer_value(11, true)
	transition_attack.set_collision_mask_value(12, true)
	# Layer : 11 Mask : 12 Plauer
	# Colliders section for Neautral Attacks #
	nlight_1.set_collision_layer_value(11, true)
	nlight_1.set_collision_mask_value(12, true)
	nlight_2.set_collision_layer_value(11, true)
	nlight_2.set_collision_mask_value(12, true)
	nlight_3.set_collision_layer_value(11, true)
	nlight_3.set_collision_mask_value(12, true)
	nair_1.set_collision_layer_value(11, true)
	nair_1.set_collision_mask_value(12, true)
	nair_2.set_collision_layer_value(11, true)
	nair_2.set_collision_mask_value(12, true)
	nair_3.set_collision_layer_value(11, true)
	nair_3.set_collision_mask_value(12, true)
	nheavy_1.set_collision_layer_value(11, true)
	nheavy_1.set_collision_mask_value(12, true)
	nheavy_2.set_collision_layer_value(11, true)
	nheavy_2.set_collision_mask_value(12, true)
	nheavy_3.set_collision_layer_value(11, true)
	nheavy_3.set_collision_mask_value(12, true)
	nrec_1.set_collision_layer_value(11, true)
	nrec_1.set_collision_mask_value(12, true)
	nrec_2.set_collision_layer_value(11, true)
	nrec_2.set_collision_mask_value(12, true)
	nrec_3.set_collision_layer_value(11, true)
	nrec_3.set_collision_mask_value(12, true)

	# Section for Down Attacks #
	dlight_1.set_collision_layer_value(11, true)
	dlight_1.set_collision_mask_value(12, true)
	dlight_2.set_collision_layer_value(11, true)
	dlight_2.set_collision_mask_value(12, true)
	dlight_3.set_collision_layer_value(11, true)
	dlight_3.set_collision_mask_value(12, true)
	dair_1.set_collision_layer_value(11, true)
	dair_1.set_collision_mask_value(12, true)
	dair_2.set_collision_layer_value(11, true)
	dair_2.set_collision_mask_value(12, true)
	dair_3.set_collision_layer_value(11, true)
	dair_3.set_collision_mask_value(12, true)
	dheavy_1.set_collision_layer_value(11, true)
	dheavy_1.set_collision_mask_value(12, true)
	dheavy_2.set_collision_layer_value(11, true)
	dheavy_2.set_collision_mask_value(12, true)
	dheavy_3.set_collision_layer_value(12, true)
	dheavy_3.set_collision_mask_value(12, true)
	drec_1.set_collision_layer_value(11, true)
	drec_1.set_collision_mask_value(12, true)
	drec_2.set_collision_layer_value(11, true)
	drec_2.set_collision_mask_value(12, true)
	drec_3.set_collision_layer_value(11, true)
	drec_3.set_collision_mask_value(12, true)

	# Section for Side Attacks
	slight_1.set_collision_layer_value(11, true)
	slight_1.set_collision_mask_value(12, true)
	slight_2.set_collision_layer_value(11, true)
	slight_2.set_collision_mask_value(12, true)
	slight_3.set_collision_layer_value(11, true)
	slight_3.set_collision_mask_value(12, true)
	sair_1.set_collision_layer_value(11, true)
	sair_1.set_collision_mask_value(12, true)
	sair_2.set_collision_layer_value(11, true)
	sair_2.set_collision_mask_value(12, true)
	sair_2.set_collision_layer_value(11, true)
	sair_3.set_collision_mask_value(12, true)
	sair_3.set_collision_layer_value(11, true)
	sheavy_1.set_collision_mask_value(12, true)
	sheavy_1.set_collision_layer_value(11, true)
	sheavy_2.set_collision_mask_value(12, true)
	sheavy_2.set_collision_layer_value(12, true)
	sheavy_3.set_collision_mask_value(12, true)
	sheavy_3.set_collision_layer_value(11, true)
	Hurtbox.set_collision_layer_value(10, true)
	Hurtbox.set_collision_mask_value(13, true)
func _process(delta: float) -> void:
	CharacterList.player_1_health = Player_Stats.Health
	MatchGameManager.player_1_global_position = Controller.global_position
