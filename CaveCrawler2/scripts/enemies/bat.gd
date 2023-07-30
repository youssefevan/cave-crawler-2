extends Enemy
class_name Bat

var speed := 50.0
var move_direction_x := -1
var move_direction_y := -1

func _physics_process(delta):
	velocity = Vector2(speed * move_direction_x, speed * move_direction_y)
	
	if is_on_floor():
		move_direction_y *= -1
	if is_on_ceiling():
		move_direction_y *= -1
	if is_on_wall():
		move_direction_x *= -1
	
	velocity.x = lerpf(velocity.x, speed * move_direction_x, 100 * delta) # effectively no interpolation
	velocity.y = lerpf(velocity.y, speed * move_direction_y, 100 * delta) # effectively no interpolation
	
	$Animator.play("Fly")
	
	move_and_slide()
