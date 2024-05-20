extends Enemy
class_name Crab

var speed := 40.0

var move_direction := -1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.y = clampf(velocity.y, -250.0 * speed_modifier, 250.0 * speed_modifier)
	
	if is_on_wall():
		move_direction *= -1
	
	velocity.x = lerpf(velocity.x, speed * speed_modifier * move_direction, 100 * delta) # effectively no interpolation
	
	$Animator.play("Move")
	
	move_and_slide()


#func _on_camera_room_detector_area_exited(area):
#	if area.get_collision_layer_value(5):
#		call_deferred("queue_free")
