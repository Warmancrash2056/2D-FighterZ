extends Area2D

@export var Character: RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area:Area2D):
	Character.linear_velocity.x = 0


func _on_body_entered(body:Node2D):
	pass # Replace with function body.
