extends Timer

@export var Animator: AnimationPlayer
@export var Character: CharacterBody2D

# Calculate the attack length and multiply the stamina rating to get.
# Exact time to recover to idle state.
func _calculate_recovery(new_recovery: float):
	var attack_length: float = Animator.current_animation_length
	var stamina_rate: float = Character.Stamina_Rating

	new_recovery = stamina_rate * attack_length

