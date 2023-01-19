extends KinematicBody2D

export (float) var MovementSpeed = 120
export (float) var JumpHeight = 900
export (float) var Gravity = 35
export (float) var ForceKnockback = 5
export (float) var Friction = 300


onready var Animate = $AnimationPlayer
onready var SpriteSheet = $Sprite
onready var CheckFloor = $"Is On Floor Cast"

onready var Nlight_Col = $"Nuetral Light/CollisionShape2D"
onready var Slight_Col = $"Side Light/CollisionShape2D"
onready var Dlight_Col_Large = $"Down Light/Large Collision"
onready var Dlight_Col_Small = $"Down Light/Small Collision"
onready var Ulight_Col_Left = $"Up Light/Left Hand"
onready var Ulight_Col_Right = $"Up Light/Right Hand"
onready var Ulight_Col_Bottom = $"Up Light/Bottom"
onready var Ulight_Col_Middle = $"Up Light/Middle"
onready var Nair_Col = $"Nuetral Air"


var DirectionFacing = 1

var Motion = Vector2.ZERO
var Up = Vector2.UP

enum StateList {
	Nlight,
	Slight,
	Dlight,
	Ulight,
	Nair,
	Idle,
	Jump,
	Fall,
	Block,
	Dash,
	Nsig,
	Ssig,
	Dsig,
	Hurt,
	Respwan
}

var SelectState = StateList.Idle

func _ready():
	pass
	
func _apply_gravity_():
	Motion.y += Gravity
func _physics_process(delta):
	Motion = move_and_slide(Motion, Up)
	
	match SelectState:
		StateList.Idle:
			_apply_gravity_()
			
			if !is_on_floor():
				SelectState = StateList.Fall
				
			if Input.is_action_pressed("Right"):
				Animate.play("Run")
				Motion.x = MovementSpeed
			
				
				Nlight_Col.position = Vector2(27,-8)
				Slight_Col.position = Vector2(16.5,-7.25)
				Dlight_Col_Large.position = Vector2(67,-1)
				Dlight_Col_Small.position = Vector2(43,10)
				Ulight_Col_Left.position = Vector2(12,-3)
				Ulight_Col_Right.position = Vector2(58, -3)
				Ulight_Col_Middle.position = Vector2(36, -14)
				Ulight_Col_Bottom.position = Vector2(36, 10)
				SpriteSheet.flip_h = false
				
				if Input.is_action_just_released("Attack"):
					SelectState = StateList.Slight
					Motion.x = 0
					
				#elif Input.is_action_just_pressed("Dash"):
					#SelectState = StateList.Dash
					#Motion.x = MovementSpeed					
			elif Input.is_action_pressed("Left"):
				Animate.play("Run")
				Motion.x = -MovementSpeed
			
				
				
				Nlight_Col.position = Vector2(-27,-8)
				Slight_Col.position = Vector2(-16.5,-7.25)
				Dlight_Col_Large.position = Vector2(-67,-1)
				Dlight_Col_Small.position = Vector2(-43,10)
				Ulight_Col_Left.position = Vector2(-12,-3)
				Ulight_Col_Right.position = Vector2(-58, -3)
				Ulight_Col_Middle.position = Vector2(-36, -14)
				Ulight_Col_Bottom.position = Vector2(-36, 10)
				SpriteSheet.flip_h = true
				
				if Input.is_action_just_released("Attack"):
					SelectState = StateList.Slight
					Motion.x = 0
					
				#elif Input.is_action_just_pressed("Dash"):
					#SelectState = StateList.Dash
					#Motion.x = -MovementSpeed
			else:
				Animate.play("Idle")
				Motion.x = 0
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Nlight
				
				elif Input.is_action_just_pressed("Signature"):
					SelectState = StateList.Nsig
			
			if Input.is_action_pressed("Up"):
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Ulight
					Motion.x = 0
			if Input.is_action_pressed("Down"):
				$Platform.play("Disable")
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Dlight
					Motion.x = 0
					
			if Input.is_action_just_pressed("Jump"):
				SelectState = StateList.Jump
				
			if Input.is_action_just_pressed("Dash"):
				SelectState = StateList.Dash
		StateList.Jump:
			Animate.play("Jump")
			_apply_gravity_()
			
			if is_on_floor():
				Motion.y = -JumpHeight
				
			if Motion.y > 0:
				SelectState = StateList.Fall
			
			if Input.is_action_just_pressed("Attack"):
				SelectState = StateList.Nair
				
			if Input.is_action_pressed("Left"):
				Motion.x = -MovementSpeed
				
			elif Input.is_action_pressed("Right"):
				Motion.x = MovementSpeed
			else:
				Motion.x = 0
				
		StateList.Fall:
			_apply_gravity_()
			Animate.play("Fall")
			
			if CheckFloor.is_colliding():
				SelectState = StateList.Idle
				
			if Input.is_action_pressed("Left"):
				Motion.x = -MovementSpeed
				
			elif Input.is_action_pressed("Right"):
				Motion.x = MovementSpeed
			else:
				Motion.x = 0
		
		StateList.Dash:
			_apply_gravity_()
			
			if Motion.x != 0:
				Animate.play("Roll")
				
			else:
				Animate.play("Block")
			if Input.is_action_pressed("Down"):
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Dlight
					
			if Input.is_action_pressed("Up"):
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Ulight
					
			if Input.is_action_pressed("Left"):
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Slight
					
			if Input.is_action_pressed("Right"):
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Slight
					
			
		StateList.Nlight:
			Animate.play("Nuetral Light")
			
		StateList.Slight:
			Animate.play("Side Light")
			
		StateList.Dlight:
			Animate.play("Down Light")
			
		StateList.Ulight:
			Animate.play("Up Light")
		
		StateList.Nair:
			Motion.y = 0
			Animate.play("Nuetral Air")
			
			if Input.is_action_pressed("Left"):
				Motion.x = -MovementSpeed
				
			elif Input.is_action_pressed("Right"):
				Motion.x = MovementSpeed
			else:
				Motion.x = 0
		
		StateList.Nsig:
			Animate.play("Signature Nlight")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Nuetral Light":
		SelectState = StateList.Idle

	if anim_name == "Down Light":
		SelectState = StateList.Idle

	if anim_name == "Side Light":
		SelectState = StateList.Idle
		
	if anim_name == "Up Light":
		SelectState = StateList.Idle
	
	if anim_name == "Nuetral Air":
		SelectState = StateList.Fall

	if anim_name == "Roll":
		SelectState = StateList.Idle
	
	if anim_name == "Block":
		SelectState = StateList.Idle
		
	if anim_name == "Signature Nlight":
		SelectState = StateList.Idle
