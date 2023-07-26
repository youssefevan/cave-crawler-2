extends Area2D
class_name Bullet

var speed := 200.0

func _physics_process(delta):
	position.x += speed * delta

func _on_body_entered(body):
	if body is TileMap:
		call_deferred("queue_free")
	elif body.get_collision_layer_value(2) or body.get_collision_layer_value(3):
		call_deferred("queue_free")

func _on_area_exited(area):
	if area.get_collision_layer_value(5):
		call_deferred("queue_free")
