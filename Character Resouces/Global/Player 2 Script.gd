class_name Goku extends CharacterBody2D

# Get character Resources
@export var controls: Node 

signal JumpSmoke
signal FacingLeft
signal FacingRight
signal DashCloud
signal DashActive
signal DashCancelled
signal WallCloud
signal CounterCloud
signal Player1Box
signal Player2Box
signal ShootProjectile

# Global player nodes.
@export var Animate: AnimationPlayer
@export var Sprite: Sprite2D
@onready var right_wall_detection: RayCast2D
@onready var left_wall_detection: RayCast2D
@export var Stat: Node
@export var Hurtbox: Area2D

var direction = Vector2() # Get the vector input to determine character movement.

enum States {
	# Normal Mode Ststes. #
	Idling,
	Jumping,
	Landing,
	Falling,

	Air_Projectile,
	Ground_Projectile,

	Nuetral_Light,
	Nuetral_Air,
	Nuetral_Heavy,
	# Nuetral is a heavy input that lift the player up.
	Nuetral_Recovery,

	Side_Heavy,
	Side_Light,
	Side_Transition,
	Side_Air,
	Side_Air_Heavy,

	Down_Light,
	Down_Heavy,
	Down_Air,
	Down_Air_Heavy,


	Air_Block,
	Ground_Block,

	Dash_Run,
	Death,
	Hurt,
	Respawn,
	Left_Wall,
	Right_Wall
	}

# Default State when entering the scene tree. #
var Select = States.Respawn

# Quickly return back to idle or jump state if sucessfully lannds an attack.

func _idle_state_(): # Normal Reset if unsucessful.
	if !is_on_floor():
		Select = States.Falling
		Animate.play("Fall")
	else:
		Select = States.Idling
		Animate.play("Idle")

func quick_reset(): # Normal Reset if unsucessful.
	if Stat.Attack_Reset == true:
		Stat.Active_Reset = false
		if !is_on_floor():
			Select = States.Falling
			Animate.play("Fall")
		else:
			Select = States.Idling
			Animate.play("Idle")


# Perform attacks within 5-10 frames of the air block. #
func _counter_nuetral_light():
	if Input.is_action_pressed(controls.light):
		Select = States.Nuetral_Light
		emit_signal("CounterCloud")
func _counter_nuetral_heavy():
	if Input.is_action_pressed(controls.heavy):
		Select = States.Nuetral_Heavy
		emit_signal("CounterCloud")
func _counter_side_light():
	if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
		if Input.is_action_pressed(controls.light):
			Select = States.Side_Light
			emit_signal("CounterCloud")
func _counter_side_heavy():
	if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
		if Input.is_action_pressed(controls.heavy):
			Select = States.Side_Heavy
			emit_signal("CounterCloud")

func counter_dowm_light():
	if Input.is_action_pressed(controls.down):
		if Input.is_action_pressed(controls.light):
			Select = States.Down_Light
			emit_signal("CounterCloud")
func counter_down_heavy():
	if Input.is_action_pressed(controls.down):
		if Input.is_action_pressed(controls.heavy):
			Select = States.Down_Heavy
			emit_signal("CounterCloud")
			
func _on_wall():
	if is_on_wall():
		if left_wall_detection.is_colliding():
			Select = States.Left_Wall
			emit_signal("WallCloud")
		else:
			if right_wall_detection.is_colliding():
				Select = States.Right_Wall
				emit_signal("WallCloud")
func _movment():
	direction = Vector2(float(Input.get_action_strength(controls.Controls.right) - Input.get_action_strength(controls.Controls.left)), float(Input.get_action_strength(controls.Controls.down)))
	direction.normalized()
	if direction.x > 0:
		velocity.x = max(velocity.x, Stat.speed_scale, Stat.Acceleration)
		emit_signal("FacingRight")
	elif direction.x < 0:
		velocity.x = min(velocity.x , -Stat.speed_scale, Stat.Acceleration)
		emit_signal("FacingLeft")
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, Stat.Decceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, 20)
			
func _drop_fall():
	if direction.y > 0 and !is_on_floor():
		if Engine.get_physics_frames() % 2 == 0:

			velocity.y += 30
			set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)


	if direction.y > 0 and !is_on_floor():
		if Engine.get_physics_frames() % 60 == 0:
			Select = States.Falling
			velocity.y += 45
func _ready():
	Select = States.Respawn

func _process(delta):
	pass
func _physics_process(delta):
	move_and_slide()
	match Select:
		States.Idling:
			_movment()
			_drop_fall()
			Stat.Jump_Count = 3
			set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Jumping
				Animate.play("Jump")

			if direction.x != 0:
				Animate.play("Run")

			else:
				Animate.play("Idle")

			if direction.x != 0:
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Side_Light
				
				if Input.is_action_just_pressed(controls.Controls.heavy):
					Select = States.Side_Heavy
					
				if Input.is_action_just_pressed(controls.Controls.dash):
					emit_signal("DashCloud")
					emit_signal("DashActive")
					Select = States.Dash_Run
					set_collision_mask_value(2, false)
			if direction.x == 0:
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Nuetral_Light

				if Input.is_action_just_pressed(controls.Controls.heavy):
					Select = States.Nuetral_Heavy


				if Input.is_action_just_pressed(controls.Controls.throw):
					Select = States.Ground_Projectile
					
				if Input.is_action_just_pressed(controls.Controls.dash) and Stat.Block_Active == false:
					Select = States.Ground_Block

			if direction.y > 0:
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Down_Light
					
				if Input.is_action_just_pressed(controls.Controls.heavy):
					Select = States.Down_Heavy
					
					
			if Input.is_action_just_pressed(controls.Controls.jump) and Stat.Jump_Count > 0:
				emit_signal("JumpSmoke")
				Select = States.Jumping
				Stat.Jump_Count -= 1
				velocity.y = Stat.Jump_Height
				Animate.play("Jump")

		States.Jumping:
			_movment()
			_on_wall()
			_drop_fall()
			if direction.x != 0:
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Side_Air

			if direction.x == 0:
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Nuetral_Air

				if Input.is_action_just_pressed(controls.Controls.throw):
					Select = States.Ground_Projectile
					
				if Input.is_action_just_pressed(controls.Controls.dash) and Stat.Block_Active == false:
					Select = States.Air_Block
					set_collision_mask_value(3, true)
					
			if direction.y == 1:
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Down_Air
					
			velocity.y += Stat.Gravity
			Animate.play("Jump")


			if is_on_floor():
				Select = States.Idling
				set_collision_mask_value(3, true)
				
			if Input.is_action_just_pressed(controls.Controls.jump) and Stat.Jump_Count > 0:
				emit_signal("JumpSmoke")
				Stat.Jump_Count -= 1
				velocity.y = Stat.Jump_Height
				Animate.play("Jump")
		States.Falling:
			_movment()
			_on_wall()
			_drop_fall()
			Animate.play("Fall")


			if Input.is_action_just_pressed(controls.Controls.jump) and Stat.Jump_Count > 0:
				emit_signal("JumpSmoke")
				Stat.Jump_Count -= 1
				velocity.y = Stat.Jump_Height
				Select = States.Jumping
				Animate.play("Jump")
				
			if Input.is_action_just_pressed(controls.Controls.dash) and Stat.Block_Active == false:
				Select = States.Air_Block
				velocity = Vector2.ZERO

			if !is_on_floor():
				velocity.y += Stat.Gravity
			else:
				Select = States.Idling
				Animate.play("Idle")
				Stat.Jump_Count = 3

		States.Side_Light:
			velocity.x = lerp(velocity.x, 0.0, 0.2)
			velocity.y = 0
			Animate.play("Side Light Start")
		States.Side_Transition:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Side Light Finisher")
		States.Side_Heavy:
			Animate.play("Side Heavy")
			velocity.x = lerp(velocity.x, 0.0, 0.9)
			velocity.y = 0

		States.Side_Air:
			Animate.play("Side Air")
			velocity.x = lerp(velocity.x , 0.0, 0.2)
			velocity.y = 0
		States.Down_Light:
			Animate.play("Down Light")
			velocity.x = lerp(velocity.x, 0.0, 0.8)
			velocity.y = 0

		States.Down_Heavy:
			velocity.x = lerp(velocity.x, 0.0, 0.2)
			velocity.y = 0
			Animate.play("Down Heavy")
		States.Down_Air:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 5
			Animate.play("Down Air")
		States.Down_Air_Heavy:
			Animate.play("Down Air Heavy")
			velocity.x = lerp(velocity.x , 0.0, 0.1)
			velocity.y = 0
		States.Nuetral_Light:
			print(velocity.x)
			velocity.x = lerp(velocity.x, 0.0, 0.7)
			velocity.y = 0
			Animate.play("Nuetral Light")

		States.Nuetral_Heavy:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 0
			Animate.play("Nuetral Heavy")
		States.Nuetral_Air:
			velocity.x = lerp(velocity.x , 0.0, 0.1)
			velocity.y = lerp(velocity.y , 0.0, 0.1)
			Animate.play("Nuetral Air")

		States.Ground_Block:
			Animate.play("Ground Block")
			velocity.y = 0
			velocity.x = lerp(velocity.x, 0.0, 0.05)
		States.Air_Block:
			set_velocity(Vector2.ZERO)
			Animate.play("Air Block")
			# Activate counter smoke to be called during an attack.
		States.Dash_Run:
			if direction.x == 0:
				Select = States.Idling
				velocity.x = move_toward(velocity.x, 0, Stat.Acceleration)
				
			if Input.is_action_pressed(controls.Controls.dash):
				if direction.x > 0:
					velocity.x = move_toward(velocity.x, Stat.Speed, Stat.Acceleration )
					
				else:
					velocity.x = move_toward(velocity.x, -Stat.Speed, Stat.Acceleration )
			else:
				if Input.is_action_just_released(controls.Controls.dash) or direction.x == 0:
					Select = States.Idling
					velocity.x = move_toward(velocity.x, Stat.Speed, Stat.Decceleration)
					emit_signal("DashCancelled")
					
			if Stat.Jump_Count > 0:
				if Input.is_action_just_pressed(controls.Controls.jump):
					Stat.Jump_Count -= 1
					velocity.y = Stat.Jump_Height
					Select = States.Jumping
					emit_signal("DashCancelled")
			Animate.play("Dash")

			if Input.is_action_just_pressed(controls.Controls.dash) and Stat.Block_Active == false:
				Select = States.Ground_Block
				Stat.Block_Active = true
				emit_signal("DashCancelled")
				velocity.x = lerp(velocity.x, 0.0, 0.2)
				
			if Input.is_action_just_pressed(controls.Controls.light):
				Select = States.Nuetral_Light
				emit_signal("DashCancelled")

			if Input.is_action_just_pressed(controls.Controls.heavy):
				Select = States.Nuetral_Heavy
				emit_signal("DashCancelled")

			if Input.is_action_pressed(controls.Controls.left) or Input.is_action_pressed(controls.Controls.right):
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Side_Light
					emit_signal("DashCancelled")

				if Input.is_action_just_pressed(controls.Controls.heavy):
					Select = States.Side_Heavy
					emit_signal("DashCancelled")


			if Input.is_action_just_pressed(controls.Controls.heavy):
				Select = States.Nuetral_Heavy
				emit_signal("DashCancelled")


			if Input.is_action_pressed(controls.Controls.down):
				if Input.is_action_just_pressed(controls.Controls.light):
					Select = States.Down_Light
					emit_signal("DashCancelled")
				if Input.is_action_just_pressed(controls.Controls.heavy):
					Select = States.Down_Heavy
					emit_signal("DashCancelled")


			if !is_on_floor():
				Select = States.Jumping

		States.Hurt:
			if is_on_floor():
				Animate.play("Ground Hurt")
			else:
				if !is_on_floor():
					Animate.play("Air Hurt")
		States.Respawn:
			Animate.play("Respawn")
			velocity.x = 0
			velocity.y = 0
		States.Right_Wall:
			Stat.Jump_Count = 3
			Animate.play("Wall")
			velocity.y = 35
			velocity.x = 0
			Sprite.flip_h = true
			if Input.is_action_pressed(controls.left):
				if Input.is_action_just_pressed(controls.jump):
					Animate.play("Jump")
					velocity.x = -200
					Select = States.Jumping
					velocity.y = Stat.Jump_Height
					emit_signal("JumpSmoke")
			if !right_wall_detection.is_colliding():
				Select = States.Jumping
		States.Left_Wall:
			Stat.Jump_Count = 3
			Animate.play("Wall")
			Sprite.flip_h = false
			velocity.y = 35
			velocity.x = 0
			if Input.is_action_pressed(controls.right):
				if Input.is_action_just_pressed(controls.jump):
					Animate.play("Jump")
					velocity.x = 200
					Select = States.Jumping
					velocity.y = 	Stat.Jump_Height
					emit_signal("JumpSmoke")
			if !left_wall_detection.is_colliding():
				Select = States.Jumping

		States.Air_Projectile:
			Animate.play("Air Projectile")
			velocity.x = lerp(velocity.x , 0.0, 0.05)
			velocity.y = 0

		States.Ground_Projectile:
			Animate.play("Ground Projectile")
			velocity.x = 0
			velocity.y = 0


func _on_hurtbox_area_entered(area):
	Select = States.Hurt
	print("Is Hurting")

