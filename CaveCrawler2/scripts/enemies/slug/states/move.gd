extends State

func physics_update(delta):
	if not entity.is_on_floor():
		entity.velocity.y += entity.gravity * delta
	
	if entity.is_on_floor():
		entity.velocity.y = 1
	
	entity.velocity.y = clampf(entity.velocity.y, -250.0, 250.0)
	
	if entity.is_on_wall():
		entity.move_direction *= -1
	
	entity.velocity.x = lerpf(entity.velocity.x, entity.speed * entity.move_direction, 100 * delta) # effectively no interpolation
