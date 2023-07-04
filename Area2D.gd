extends CharacterBody2D

@onready var animate = $AnimatedSprite2D

enum {idle,hurt}
func _ready():
	pass
var states = idle
func _physics_process(delta):
	match states:
		idle:
			if Input.is_action_pressed("Player2_Right"):
				velocity.x = 100
				animate.play("Run")
				animate.flip_h = false
			elif Input.is_action_pressed("Player2_Left"):
				velocity.x = -100
				animate.play("Run")
				animate.flip_h = true
			else:
				velocity.x = 0
				animate.play("Idle")
		hurt:
			animate.play("Hurt")
			
			
	move_and_slide()
	velocity.y += 15
func _on_area_2d_area_entered(area):
	if area.is_in_group("Goku Side Attack Start"):
		states = hurt
		velocity = Vector2.ZERO
	
	elif area.is_in_group("Goku Side Attack Finish"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity.x = 100
		
		elif CharacterList.main_player_facing_left == true:
			velocity.x = -100
	elif area.is_in_group("Goku Nuetral Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(60,-200)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-60,-200)
	elif area.is_in_group("Goku Down Attack Bottom"):
		states = hurt
		velocity.y = -500
	
	elif area.is_in_group("Goku First Air Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(20,0)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-20,0)
	
	elif area.is_in_group("Goku Second Air Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(70,-30)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-70,-30)
			
	elif area.is_in_group("Goku Third Air Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(30,0)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-30,0)
	
	elif area.is_in_group("Goku Super Nuetral Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(50,-60)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-50,-60)
			
	elif area.is_in_group("Goku Super Side Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(100,-60)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-100,-60)


func _on_animated_sprite_2d_animation_looped():
	if animate.animation == "Hurt":
		states = idle
		animate.play("Idle")
	
