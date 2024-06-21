extends Timer

@export var  Character: CharacterBody2D
@export var Animator: AnimationPlayer
@export var Player_Stats: Node
var get_recovery: float
func calculate_recovery(new_recovery: float):
	# Get the current attack animation and multiply the time.
	# By the player stamina rating. Set the wait time to new recovery.
	var animation_length = Animator.current_animation_length
	var stamina_rating = Player_Stats.Stamina_Rating

	new_recovery = animation_length * stamina_rating
	get_recovery = new_recovery
	set_wait_time(new_recovery)
	print(wait_time)


func _on_area_2d_attack_connected() -> void:
	var reduced_recovery: float = get_recovery * 0.5

	set_wait_time(reduced_recovery)


