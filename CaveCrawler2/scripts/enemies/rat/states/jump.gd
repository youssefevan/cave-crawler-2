extends State

func enter():
	super.enter()
	
	entity.velocity.x = entity.jump_velocity_x * entity.move_direction
	entity.velocity.y = -entity.jump_velocity_y

func physics_update(delta):
	super.physics_update(delta)
	
	if entity.is_on_floor():
		return entity.land
	
	if entity.velocity.y > 0:
		return entity.fall
