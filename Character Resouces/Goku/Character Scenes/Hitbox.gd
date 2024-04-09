extends Area2D
@export var Sprite: Sprite2D
@export var Damage: int
# Damage dealth to player is reduced by player defense rating
@export var Stun_Time: int
# Sets a certain amount of frames a player is stunned for but is reduced by opponent stamina rating
@export var Knockback_X: int
@export var Knockback_Y: int
# Absolute value of knockback is not effected by any rating
var facing_left = null

func _process(delta: float) -> void:
	facing_left = Sprite.flip_h
	#print(facing_left)

# Set player hitbox and hurtbox at _ready from main node
func _on_controller_player_1_box() -> void:
	set_collision_layer_value(5, true)
	set_collision_mask_value(6, true)


func _on_controller_player_2_box() -> void:
	set_collision_layer_value(6, true)
	set_collision_mask_value(5, true)
