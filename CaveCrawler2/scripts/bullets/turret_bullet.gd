extends Bullet

func _physics_process(delta):
	global_position += Vector2(speed * delta, 0).rotated(rotation)

func _on_area_entered(area):
	if area.get_collision_layer_value(7):
		if area.get_parent().is_in_group("Player"):
			explode()
