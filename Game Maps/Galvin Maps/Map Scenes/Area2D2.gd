extends Area2D






func _on_area_entered(area):
	if area:
		print("good")
		print(area.global_position)


func _on_body_entered(body):
	print('GOOD')
