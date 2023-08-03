extends Enemy
class_name SkeletonHand

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += 800.0 * delta
	else:
		velocity.y = 1
	
	move_and_slide()
