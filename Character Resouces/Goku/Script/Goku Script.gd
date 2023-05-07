extends CharacterBody2D

@export var controls: Resource


@onready var Animate = $"Scale Player/AnimationPlayer"
@onready var SpriteH = $Animation

# Action Bar Nodes #
@onready var ActionBar = $"Status Bar/Action Bar"
@onready var Healthbar = $"Status Bar/Health Bar"
@onready var ActionNotifier = $"Status Bar/Action Notifier"
@onready var HealthNotifier = $"Status Bar/Health Notifier"
@onready var PointsPlayer = $"Add Points"
@onready var ActionBrokenPlayer = $"Status Bar/Action Break"

@export var Movement: int  = 300
@export var AirMovement: int  = 150
@export var Acceleration: int  = 35
@export var JumpHeight: int = 550
@export var Gravity : int  = 35

@export var Health: int
@export var ActionPts: int

var Motion = Vector2.ZERO
var Up = Vector2.UP
var Can_Attack = true
var Action_Exceeded = false
var Jump_Count = 3
var Direction = 1
enum States { Idle, Jump, Fall, Nlight, Slight, Dlight, Ulight,
	Nair,
	Defend,
	Roll,
	Death,
	Hurt
}
var Select = States.Idle

func _ready():
	
	# Set Status bar when player loaded #
	ActionBrokenPlayer.play("Normal")

func _stop_points():
	PointsPlayer.stop()

func _start_points():
	PointsPlayer.play("Add Points")
# Checks if action points needs to be replenished if under 6 points.
func _add_action_pts():
	
	# Add 1pt of action after idle or run animation is finished. 
	if ActionPts < 9:
		ActionPts += 1
		
	
	# If action points are at 6. Set action points to stop increasing number.
	else:
		ActionPts = 9
func _process(delta):
	PointsPlayer.play("Add Points")
	ActionBar.value = ActionPts
	ActionBar.max_value = 9
	Healthbar.value = Health
	Healthbar.max_value = 500
	ActionNotifier.set_text(str(ActionPts))
	HealthNotifier.set_text(str(Health))

	if Motion.x >= 1:
		SpriteH.flip_h = false
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	elif Motion.x <= -1:
		SpriteH.flip_h = true
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	
	if ActionPts <= 0:
		Can_Attack = false
	else:
		Can_Attack = true
	
	if ActionPts >= 1:
		ActionBar.texture_under = load("res://Health System/Unbroken Progress Background.png")
		Action_Exceeded = false
	if ActionPts <= -1:
		ActionBar.texture_under = load("res://Health System/Broken Progress Background.png")
		ActionBrokenPlayer.play("Actions Exceeded")
		Action_Exceeded = true
		
func _physics_process(delta):
	PointsPlayer.play("Add Points")
	set_velocity(Motion)
	set_up_direction(Up)
	move_and_slide()
	Motion = velocity

	match Select:

		States.Idle:
			Jump_Count = 3
			Motion.y += Gravity * delta
			if !is_on_floor():
				Select = States.Fall
				
				
			if Input.is_action_pressed(controls.input_left):
				Animate.play("Run")
				Motion.x = max(Motion.x - Acceleration, -Movement)
				if Can_Attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Slight
						ActionPts -= 2
						
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						Motion.x = -350
						ActionPts -= 6
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Run")
				Motion.x = min(Motion.x + Acceleration, Movement)
				
				if Can_Attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Slight
						ActionPts -= 2
						
						
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						Motion.x = 350
						ActionPts -= 6
			
			elif Input.is_action_pressed(controls.input_down):
				Animate.play("Idle")
				if Can_Attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Dlight
						ActionPts -= 5

					
			elif Input.is_action_pressed(controls.input_up):
				Animate.play("Idle")
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
					ActionPts -= 7
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.8)
				Animate.play("Idle")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nlight
					ActionPts -= 1
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Defend
					ActionPts -= 8
			if Action_Exceeded == false:
				if Input.is_action_just_pressed(controls.input_jump) and Jump_Count > 0:
					Animate.pla
					Select = States.Jump
					Jump_Count -= 1
					$"Jump Sound".play()
				
		States.Jump:
			Motion.y += Gravity * delta
			if is_on_floor():
				Motion.y = -JumpHeight
					
			Animate.play("Jump")
			if Input.is_action_pressed(controls.input_down):
				Motion.y += 50
				
			if Input.is_action_just_pressed(controls.input_jump) and Jump_Count > 0:
				Motion.y = -JumpHeight
				Jump_Count -= 1
				
			if Input.is_action_pressed(controls.input_left):
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
				
			elif Input.is_action_pressed(controls.input_right):
				Motion.x = min(Motion.x + Acceleration, AirMovement)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
					ActionPts -= 4
			if Motion.y > 100:
				Select = States.Fall
				
				
					
		States.Nlight:
			Motion.x = 0
			Animate.play("Nlight")
			
		States.Slight:
			Motion.x = 0
			Motion.y = 0
			
			Animate.play("Slight")

		States.Dlight:
			Motion.x = 0
			Motion.y = 0
			Animate.play("Dlight")
			
				
		States.Ulight:
			Motion.x = 0
			Motion.y = 0
			Animate.play("Ulight")
			
				
		States.Nair:
			Motion.x = lerp(Motion.x , 0.1, 0.03)
			Motion.y = 0
			Animate.play("Nair")

			
		States.Defend:
			Animate.play("Block")
			Motion.y = 0
			Motion.x = 0
			
		
			
			
		States.Roll:
			Motion.x = lerp(Motion.x , 0.01, 0.02)
			Motion.y += Gravity
			Animate.play("Roll")
			if !is_on_floor():
				Select = States.Fall
			await get_tree().create_timer(0.05).timeout
			if Input.is_action_just_pressed(controls.input_block):
				Select = States.Defend
				
			elif Input.is_action_just_pressed(controls.input_jump):
				Select = States.Jump
				
		States.Death:
			Animate.play("Jump")
			
		States.Hurt:
			Motion.x = 0
			Animate.play("Take Hit")


	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Nlight":
		Select = States.Idle

	if anim_name == "Slight":
		Select = States.Idle

	if anim_name == "Ulight":
		Select = States.Idle
		
	if anim_name == "Dlight":
		Select = States.Idle
	
	if anim_name == "Nair":
		Select = States.Fall
	
	if anim_name == "Roll":
		Select = States.Idle
		
	if anim_name == "Block":
		if is_on_floor():
			Select = States.Idle
		else: 
			Select = States.Fall
	
