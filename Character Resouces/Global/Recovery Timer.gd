extends Timer


@export var  Character: CharacterBody2D
@export var Animator: AnimationPlayer
@export var Player_Stats: Node

@onready var Movement_Cooldown: Timer = $'Movement Cooldown'
@onready var Refresh_Block: Timer = $'Refresh Block'
@export var Hurtbox: Area2D
var get_recovery: float
var get_movement: float

func calculate_recovery(new_recovery: float):
	# Get the current attack animation and multiply the time.
	# By the player stamina rating. Set the wait time to new recovery.
	var animation_length = Animator.current_animation_length
	var stamina_rating = Player_Stats.Stamina_Rating
	new_recovery = animation_length * stamina_rating
	var movement_cooldown_timer: float = new_recovery * 0.1
	get_recovery = new_recovery
	get_movement = movement_cooldown_timer
	Movement_Cooldown.set_wait_time(movement_cooldown_timer)
	set_wait_time(new_recovery)
	#print(wait_time)
	print("Reduced Attack Cooldoen " ,wait_time,"Reduced Movement Cooldoen " ,movement_cooldown_timer)


func _on_attack_connected() -> void:
	var reduced_recovery: float = get_recovery * 0.01
	var reduced_movement: float = get_movement * 0.01
	set_wait_time(reduced_recovery)
	Movement_Cooldown.set_wait_time(0.01)

	print("Hit Registered on Attack Cooldoen " ,wait_time,"Reduced Movement Cooldoen " ,Movement_Cooldown.wait_time)


func _on_side_air__2_attack_connected() -> void:
	pass # Replace with function body.
