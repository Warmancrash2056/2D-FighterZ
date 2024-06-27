extends Timer


@export var  Character: CharacterBody2D
@export var Animator: AnimationPlayer
@export var Player_Stats: Node

@onready var Movement_Cooldown: Timer = $'Movement Cooldown'
@export var Hurtbox: Area2D
var get_recovery: float

func _process(delta: float) -> void:
	pass
func calculate_recovery(new_recovery: float):
	# Get the current attack animation and multiply the time.
	# By the player stamina rating. Set the wait time to new recovery.
	var animation_length = Animator.current_animation_length
	var stamina_rating = Player_Stats.Stamina_Rating
	var movement_cooldown_timer: float = new_recovery * 0.5
	new_recovery = animation_length * stamina_rating
	get_recovery = new_recovery

	Movement_Cooldown.set_wait_time(movement_cooldown_timer)
	set_wait_time(new_recovery)
	print(wait_time)



func _on_attack_connected() -> void:
	var reduced_recovery: float = get_recovery * 0.01
	set_wait_time(reduced_recovery)
	Movement_Cooldown.set_wait_time(0.01)

	print("Reduced Attack Cooldoen " ,wait_time,"Reduced Movement Cooldoen " ,Movement_Cooldown.wait_time)



