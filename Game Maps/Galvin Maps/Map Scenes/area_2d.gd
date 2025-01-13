extends Area2D

@export var Collider: CollisionShape2D
@export var Reset_Timer: Timer
var respawn_space_occupied = false ## Checks if area is cleared for player to respawn
var respawn_position: Vector2
func _ready() -> void:
	respawn_position = Collider.global_position



func _on_body_entered(body: Node2D) -> void:
	respawn_space_occupied = true
	Collider.disabled = true
	Reset_Timer.start()

func _on_timer_timeout() -> void:
	respawn_space_occupied = false
	Collider.disabled = false
