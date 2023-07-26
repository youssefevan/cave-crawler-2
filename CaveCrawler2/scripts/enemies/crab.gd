extends CharacterBody2D
class_name Crab

var speed := 40.0
var gravity := 800.0

var move_direction := -1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		velocity.y = 1
	
	velocity.y = clampf(velocity.y, -250.0, 250.0)
	
	if is_on_wall():
		move_direction *= -1
	
	velocity.x = lerpf(velocity.x, speed * move_direction, 100 * delta) # effectively no interpolation
	
	print(velocity)
	
	move_and_slide()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		pass
