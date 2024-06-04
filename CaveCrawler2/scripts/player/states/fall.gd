extends State

func physics_update(delta):
	super.physics_update(delta)
	entity.handle_input()
	entity.apply_movement(delta)
	
	apply_gravity(delta)
	
	if entity.is_on_floor() and entity.movement_input != 0:
		return entity.run
	elif entity.is_on_floor() and entity.movement_input == 0:
		return entity.idle
	
	if entity.can_coyote_jump and entity.jump_was_pressed:
		return entity.jump
	
	if entity.bouncing:
		return entity.bounce

func apply_gravity(delta):
		entity.velocity.y = clampf(
			entity.velocity.y,
			-entity.max_fall_speed,
			entity.max_fall_speed
		)
		entity.velocity.y += entity.gravity_down * entity.gravity_multiplier * delta
