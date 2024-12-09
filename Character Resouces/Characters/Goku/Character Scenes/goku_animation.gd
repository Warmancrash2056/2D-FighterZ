extends Node

# Handle charactger animation keyframes and transitions.

@export var Character: RigidBody2D
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer
@export var Hurtbox_Collider: CollisionShape2D

func side_light_movement():
    if Sprite.flip_h == true:
        Character.linear_velocity.x = -5
    else:
        Character.linear_velocity.x = 5

func _neautral_recoveery():
    if Sprite.flip_h == true:
        Character.linear_velocity.y = -20
    else:
        Character.linear_velocity.y = 20

 