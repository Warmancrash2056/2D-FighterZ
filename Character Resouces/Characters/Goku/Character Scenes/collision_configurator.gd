extends Node2D
@export var Player_Identifier: Node
@export var Motion_Body: RigidBody2D
@onready var attack_positioner = %'Attack Positioner'
@onready var transition_attack = %'Transitional Check'
@onready var neutral_light_quick_punch = %"Neutral Light Quick Punch"
@onready var neutral_air_upward_sweep = %'Neutral Air Upward Sweep'
@onready var nheavy_3 = %'Neatral Heavy - 1'
@onready var nheavy_1 = %'Neutral Heavy - 2'
@onready var nheavy_2 = %'Neutral Heavy - 3'
@onready var nrec_1 = %'Neautral Recovery - 1'
@onready var nrec_2 = %'Neautral Recovery - 2'
@onready var nrec_3 = %'Neautral Recovery - 3'
@onready var down_light_upward_kick = %'Down Light Upward kick'
@onready var down_air_axe_kick = %'Down Air Axe Kick'
@onready var down_heavy_pillar = %'Down Heavy Pillar'
@onready var drec_1 = %'Down Recovery - 1'
@onready var drec_2 = %'Down Recovery - 2'
@onready var drec_3 = %'Down Recovery - 3'
@onready var side_light_transition_opener = %'Side Light Transition Opener'
@onready var side_light_transition_ender = %'Side Light Transition Ender'
@onready var side_air_force_kick = %'Side Air Force Kick'
@onready var side_air_stop_movement_on_contact = %"Side Air Stop Movement"
@onready var side_heavy_pillar = %'Side Heavy Pillar'
@onready var Hurtbox = %Hurtbox
func _process(delta: float) -> void:
	# Layer : 11 Mask : 12 Plauer
	# Colliders section for Neautral Attacks #
	attack_positioner.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	attack_positioner.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	transition_attack.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	transition_attack.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	neutral_light_quick_punch.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	neutral_light_quick_punch.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	neutral_air_upward_sweep.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	neutral_air_upward_sweep.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

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
	down_light_upward_kick.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	down_light_upward_kick.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	down_air_axe_kick.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	down_air_axe_kick.set_collision_mask_value(Player_Identifier.Attack_Mask, true)


	down_heavy_pillar.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	down_heavy_pillar.set_collision_mask_value(Player_Identifier.Attack_Mask, true)


	drec_1.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	drec_1.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	drec_2.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	drec_2.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	drec_3.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	drec_3.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	# Section for Side Attacks
	side_light_transition_opener.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	side_light_transition_opener.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	side_light_transition_ender.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	side_light_transition_ender.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	side_air_force_kick.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	side_air_force_kick.set_collision_mask_value(Player_Identifier.Attack_Mask, true)
	side_air_stop_movement_on_contact.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	side_air_stop_movement_on_contact.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	side_heavy_pillar.set_collision_layer_value(Player_Identifier.Attack_Layer, true)
	side_heavy_pillar.set_collision_mask_value(Player_Identifier.Attack_Mask, true)

	Motion_Body.set_collision_layer_value(Player_Identifier.Motion_Layer, true)

	Hurtbox.set_collision_layer_value(Player_Identifier.Body_Layer, true)
	Hurtbox.set_collision_mask_value(1, true)
	Hurtbox.set_collision_mask_value(Player_Identifier.Body_Mask, true)
