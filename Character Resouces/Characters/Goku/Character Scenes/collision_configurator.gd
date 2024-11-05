extends Node2D
@export var Player_Identifier: Node
@export var Motion_Body: RigidBody2D
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
func _process(delta: float) -> void:
	# Layer : 11 Mask : 12 Plauer
	# Colliders section for Neautral Attacks #
	attack_positioner.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	attack_positioner.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	transition_attack.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	transition_attack.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nlight_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nlight_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nlight_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nlight_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nlight_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nlight_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nair_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)

	nair_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nair_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nair_2.set_collision_mask_value(Player_Identifier.Attack_Layer, true)
	nair_3.set_collision_layer_value(Player_Identifier.Attack_Mask, true)
	nair_3.set_collision_mask_value(Player_Identifier.Attack_Layer, true)

	nheavy_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nheavy_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nheavy_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nheavy_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nheavy_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nheavy_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	nrec_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nrec_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nrec_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nrec_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	nrec_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	nrec_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	# Section for Down Attacks #
	dlight_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dlight_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	dlight_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dlight_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	dlight_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dlight_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	dair_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dair_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	dair_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dair_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	dair_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dair_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	dheavy_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dheavy_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	dheavy_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dheavy_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	dheavy_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	dheavy_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	drec_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	drec_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	drec_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	drec_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	drec_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	drec_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	# Section for Side Attacks
	slight_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	slight_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	slight_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	slight_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	slight_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	slight_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	sair_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	sair_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	sair_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	sair_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	sair_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	sair_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	sheavy_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	sheavy_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	sheavy_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	sheavy_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	sheavy_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	sheavy_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	Motion_Body.set_collision_layer_value(Player_Identifier.Motion_Layer, true)

	Hurtbox.set_collision_layer_value(Player_Identifier.Body_Layer, true)
	Hurtbox.set_collision_mask_value(1, true)
	Hurtbox.set_collision_mask_value(Player_Identifier.Body_Mask, true)
