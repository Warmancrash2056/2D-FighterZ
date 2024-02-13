class_name Character extends CharacterBody2D

@export var Controller: Node
@export var Animator: AnimationPlayer

@export var Speed:int = 400
@export var Acceleration:int = 20
@export var Decceleration: int = 10
@export var Speed_Rating: float 

@export var Health: int = 1000
@export var Defense_Rating: float
@export var Attack_Rating: float

@export var Gravity:int = 30
@export var Jump_Height: int = 600
@export var Fast_Fall: int = 150
@export var Jump_Count: int = 3

var direction: int = 0
signal FacingLeft
signal FacingRight
signal JumpCloud
signal DashCloud
signal WallCloud
signal CounterCloud
signal BlockFade

func _ready():
	Speed *= Speed_Rating
func _physics_process(delta):
	move_and_slide()
	
	if !is_on_floor():
		velocity.y += Gravity
func _process(delta):
	Animator.connect("IsMoving", _moving)
	Animator.connect("IsStopping", _stopping)
	Animator.connect("IsJumping", _jumping)
	Animator.connect("IsDashing", _dashing)
	Animator.connect("IsAttacking", _attacking)
	Animator.connect("IsKnockBack", knocked)
	
func _moving():
	var dir: int = Controller.direction.x
	velocity.x = move_toward(velocity.x , dir * Speed, Acceleration) 

func _stopping():
	velocity.x = move_toward(velocity.x , 0, Decceleration)

func _jumping():
	velocity.y = move_toward(velocity.y , Jump_Height, Acceleration)
	
func _fast_falling():
	pass	
func _dashing():
	pass
func _attacking():
	pass
	
func knocked():
	pass
	
