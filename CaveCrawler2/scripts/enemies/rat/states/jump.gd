extends State

func enter():
	super.enter()
	
	entity.velocity.x = entity.jump_velocity_x * entity.move_direction * entity.speed_modifier
	entity.velocity.y = -entity.jump_velocity_y
	
	
	if OptionsHandler.particles_enabled == true:
		var j = entity.jump_dust.instantiate()
		entity.add_child(j)
		j.global_position.y = entity.global_position.y + 4

func physics_update(delta):
	super.physics_update(delta)
	
	if entity.is_on_floor():
		return entity.land
	
	if entity.velocity.y > 0:
		return entity.fall
