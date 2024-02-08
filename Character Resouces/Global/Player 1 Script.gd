extends CharacterBody2D

@export var Animation_Player: AnimationPlayer
@export var Sprite: Sprite2D
@export var Hurtbox: Area2D
@export var Controller: Node
@export var Player_Stat: Node


enum {
	Idling,
	Moving,
	Jumping,
	Falling,
	FastFalling,
	Air_Block,
	Ground_Block,
	Neutral_Light,
	Neutral_Air,
	Neutral_Heavy,
	Neutral_Recovery,
	Side_Light,
	Side_Air,
	Side_Heavy,
	Down_Light,
	Down_Heavy,
	Down_Air,
	Air_Projecile,
	Ground_Projectile,
	Respawn,
	Hurt
}

var state = Idling

func moving():
	pass
func _ready():
	pass
	
func _physics_process(delta):
	match state:
		Idling:
			if Controller.direction.x == 0: 
				Animation_Player.play("Idle")
				
			else:
				if Controller.direction.x != 0:
					Animation_Player.play("Run")
				
			
	
func _process(delta):
	pass
