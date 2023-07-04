extends CharacterBody2D

enum {idle,hurt}
var direction = 1
func _ready():
	pass
func _hurt():
	states = idle
var states = idle
func _physics_process(delta):
	match states:
		idle:
			if Input.is_action_pressed("Player2_Right"):
				velocity.x = 100
				direction = 1
			elif Input.is_action_pressed("Player2_Left"):
				velocity.x = -100
				direction = 0
			else:
				velocity.x = 0
		hurt:
			$AnimationPlayer.play("hurt")
			
			
	move_and_slide()
	velocity.y += 15
func _on_area_2d_area_entered(area):
	if area.is_in_group("Goku Side Attack Start"):
		pass
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
			velocity = Vector2(70,0)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-70,0)
	
	elif area.is_in_group("Goku Second Air Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(170,-30)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-170,-30)
			
	elif area.is_in_group("Goku Third Air Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(270,0)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-270,0)
	
	elif area.is_in_group("Goku Super Nuetral Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(100,-60)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-100,-60)
			
	elif area.is_in_group("Goku Super Side Attack"):
		states = hurt
		if CharacterList.main_player_facing_left == false:
			velocity = Vector2(100,-60)
			
		elif CharacterList.main_player_facing_left == true:
			velocity = Vector2(-100,-60)
