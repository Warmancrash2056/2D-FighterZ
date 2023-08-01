extends CharacterBody2D

@onready var animate = $AnimationPlayer
@onready var sprite = $Sprite2D
enum {idle,hurt,falls}
func _ready():
	pass
var states = idle

func _reset():
	set_velocity(Vector2.ZERO)
func _knockback(delta):
	var col_info = move_and_collide(velocity * delta)
	if col_info:
		velocity = velocity.bounce(col_info.get_normal())
		velocity.x *= 0.5
		velocity.y *= 0.5
func _physics_process(delta):
	match states:
		idle:
			if !is_on_floor():
				states = falls
				animate.play("Fall")
			if Input.is_action_pressed("Player2_Right"):
				velocity.x = 100
				animate.play("Run")
				$Sprite2D.flip_h = false
			elif Input.is_action_pressed("Player2_Left"):
				velocity.x = -100
				animate.play("Run")
				$Sprite2D.flip_h = true
			else:
				velocity.x = 0
				animate.play("Idle")
		hurt:
			_knockback(delta)
			animate.play("Hurt")
			
		falls:
			animate.play("Fall")
			
			if is_on_floor():
				states = idle
				animate.play("Idle")
	move_and_slide()
	velocity.y += 15
func _on_area_2d_area_entered(area):
	states = hurt
	if area.is_in_group("Goku Nuetral Attack"):
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(60,-200)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-60,-200)
	if area.is_in_group("Goku Side Attack Start"):
		velocity = Vector2.ZERO
	
	if area.is_in_group("Goku Side Attack Finish"):
		if CharacterList.main_player_facing_left == false:
			set_velocity(Vector2(100,100))
		
		elif CharacterList.main_player_facing_left == true:
			set_velocity(Vector2(-100,100))
	if area.is_in_group("Goku Down Attack Bottom"):
		velocity.y = -300
		
	if area.is_in_group("Goku Up Attack Left Hand"):
		if CharacterList.main_player_facing_left == false:
			velocity.x = 50
			
		elif CharacterList.main_player_facing_left == true:
			velocity.x = -50
			
	if area.is_in_group("Goku Up Attack Right Hand"):
		if CharacterList.main_player_facing_left == false:
			velocity.x = -50
			
		elif CharacterList.main_player_facing_left == true:
			velocity.x = 50
			
	if area.is_in_group("Goku Up Attack Grab"):
		velocity.y = 30
		
	if area.is_in_group("Goku Up Attack Smash"):
		velocity.y = -400
	
	if area.is_in_group("Goku First Air Attack"):
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(20,0)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-20,0)
	
	if area.is_in_group("Goku Second Air Attack"):
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(70,-30)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-70,-30)
			
	if area.is_in_group("Goku Third Air Attack"):
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(30,0)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-30,0)
	
	if area.is_in_group("Goku Super Nuetral Attack"):
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(50,-60)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-50,-60)
			
	if area.is_in_group("Goku Super Side Attack"):
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(100,-90)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-100,-90)
	if area.is_in_group("Goku Super Down Attack"):
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(200,-200)
			
		elif  CharacterList.main_player_facing_left == true:
			velocity = Vector2(-200,-200)
		

func _on_animated_sprite_2d_animation_looped():
	if animate.animation == "Hurt":
		states = idle
		animate.play("Idle")
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Hurt":
		states = idle
		print("Retyurn to idle")
		
