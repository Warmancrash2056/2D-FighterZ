extends AnimationPlayer

@export var Controlller: Node
@export var Character: CharacterBody2D

var follow_up: bool = false # checks if starting attacking hit to follow with final attack

signal IsMoving
signal isDashing
signal IsStopping
signal IsAttacking
signal IsJumping
signal OnWall

enum {
	Idle,
	Run,
	Jump,
	Fall,
	Dash,
	Block,
	Neutral_Air,
	Neutral_Light,
	Neutral_Heavy,
	Neutral_Recovery,
	Side_Light,
	Side_Heavy,
	Side_Air,
	Down_Light,
	Down_Heavy,
	Down_Air,
	Down_Recovery,
	Shoot_Projectile,
	Hurt,
	Respawn
}

var state = Idle
func _process(delta: float) -> void:
	match state:
		Idle:
			play("Idle")
	
			if Controlller.light == true:
				state = Neutral_Light
				emit_signal("isAttacking")
				Controlller.light = false
				
			if Controlller.heavy == true:
				state = Neutral_Heavy
				emit_signal("isAttacking")
				Controlller.heavy = false
				
			if Controlller.block == true:
				state = Block
				emit_signal("IsStopping")
				Controlller.block = false
				
			if Controlller.direction.y != 0:
				if Controlller.light == true:
					state = Down_Light
					emit_signal("isAttacking")
					Controlller.light = false
					
				if Controlller.heavy == true:
					state = Down_Heavy
					emit_signal("isAttacking")
					Controlller.heavy = false
					
			if Controlller.jump == true:
				state = Jump
				emit_signal("IsJumping")
				Controlller.jump = false
				
			if Controlller.direction.x != 0:
				state = Run
				emit_signal("IsMoving")
		Run:
			play("Run")
			
			if Controlller.direction.x == 0:
				state = Idle
				emit_signal("isStopping")
				
			if Controlller.direction.x != 0:
				if Controlller.light == true:
					state = Side_Light
					emit_signal("isAttacking")
					Controlller.light = false
					
				if Controlller.heavy == true:
					state = Side_Heavy
					emit_signal("isAttacking")
					Controlller.heavy = false
					
				if Controlller.dash == true:
					state = Dash
					emit_signal("isDashing")
					Controlller.dash = false
				
			if Controlller.direction.y != 0:
				if Controlller.light == true:
					state = Down_Light
					emit_signal("isAttacking")
					Controlller.light = false
						
				if Controlller.heavy == true:
					state = Down_Heavy
					emit_signal("isAttacking")
					Controlller.heavy = false
		Jump:
			play("Jump")
			
			if Controlller.direction.x != 0:
				if Controlller.light == true:
					state = Side_Air
					emit_signal("isAttacking")
					Controlller.light = false
					
			if Controlller.direction.y != 0:
				if Controlller.light == true:
					state = Down_Air
					emit_signal("isAttacking")
					Controlller.light = false
					
				if Controlller.heavy == true:
					state = Down_Recovery
					emit_signal("isAttacking")
					Controlller.heavy = false
					
			if Controlller.dirction.x == 0:
				if Controlller.light == true:
					state = Neutral_Air
					emit_signal("isAttacking")
					Controlller.light = false
					
				if Controlller.block == true:
					state = Block
					emit_signal("IsStopping")
					Controlller.block = false
					
		Fall:
			play("Fall")
			
		Dash:
			play("Dash")
			
		Block:
			if Character.is_on_floor():
				play("Ground Block")
				
			else:
				play("Air Block")
				
		Hurt:
			if Character.is_on_floor():
				play("Ground Hurt")
				
			else:
				play("Air Hurt")
			
		Respawn:
			play("Respawn")
			
		Shoot_Projectile:
			if Character.is_on_floor():
				play("Ground Projectile")
				
			else:
				play("Air Projectile")
		Neutral_Light:
			play("Nuetral Light")
			
		Neutral_Heavy:
			play("Nuetral Heavy")
			
		Neutral_Air:
			play("Nuetral Air")
			
		Neutral_Recovery:
			play("Nuetral Recovery")
			
		Side_Light:
			play("Side Light")
			
		Side_Heavy:
			play("Side Heavy")
			
		Side_Air:
			play("Side Air")
			
		Down_Light:
			play("Down Light")
			
		Down_Heavy:
			play("Down Heavy")
			
		Down_Air:
			play("Down Air")
			
		Down_Recovery:
			play("Down Recovery")
			

func _normal_reset():
	if Character.is_on_floor():
		state = Idle
		
	else:
		state = Fall
		
func _quick_reset():
	if follow_up == true:
		if Character.is_on_floor():
			state = Idle
			follow_up = false
		else:
			state = Fall
			follow_up = false
		
func _side_light_transition():
	if follow_up == true:
		play("Side Light Finisher")
		follow_up = false
		
