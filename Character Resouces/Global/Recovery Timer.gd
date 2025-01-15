extends Timer

@export_category("Character Resources")
@export var  Character: CharacterBody2D
@export var Animator: AnimationPlayer
@export var Player_Stats: Node

@onready var Movement_Cooldown: Timer = $'Movement Cooldown'
@onready var Refresh_Block: Timer = $'Refresh Block'
var get_recovery: float
var get_movement: float
var frame_recovery: float

func calculate_recovery(new_recovery: float):
	var animation_length = Animator.current_animation_length # Get the current animation length
	var stamina_rating = Player_Stats.Dexterity_Rating # Get the stamina rating of the player based on the player stats
	var animation_frame_count: float = animation_length * 60 # multiply the animation length by 60 to get the frame count
	var stamina_reduced_frame_cont: float = animation_frame_count / stamina_rating # Divide the frame count by the stamina rating to get the reduced frame count
	var calculated_frame_count_to_sec: float = stamina_reduced_frame_cont / 60 # Divide the reduced frame count by 60 to get the recovery time in seconds
	new_recovery = calculated_frame_count_to_sec # Final value of rcvoery time converterd into seconds
	var movement_cooldown_timer: float = new_recovery * 0.1 # 10% of the recovery time
	get_recovery = new_recovery
	get_movement = movement_cooldown_timer
	Movement_Cooldown.set_wait_time(movement_cooldown_timer)
	set_wait_time(new_recovery)
	print(stamina_reduced_frame_cont)
	print("Reduced Attack Cooldoen: " ,wait_time ," Reduced Movement Cooldoen: " ,movement_cooldown_timer)

# signal AttackConnected can be found in the hitbox.gd script.
func _on_attack_connected() -> void:
	var reduced_recovery: float = get_recovery * 0.01
	var reduced_movement: float = get_movement * 0.01
	set_wait_time(reduced_recovery)
	Movement_Cooldown.set_wait_time(0.01)

	print("Hit Registered on Attack Cooldoen " ,wait_time,"Reduced Movement Cooldoen " ,Movement_Cooldown.wait_time)
