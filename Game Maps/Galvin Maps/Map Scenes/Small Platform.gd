extends StaticBody2D

func _physics_process(delta):
	if CharacterList.disable_mini_platform == true:
		$CollisionPolygon2D.disabled = true
	
	else:
		$CollisionPolygon2D.disabled = false
	
