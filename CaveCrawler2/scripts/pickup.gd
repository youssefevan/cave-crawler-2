extends Node2D
class_name Pickup

func _on_area_body_entered(body):
	if body is Player:
		picked(body)

func picked(body):
	pass
