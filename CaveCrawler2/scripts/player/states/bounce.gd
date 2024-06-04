extends State

func enter():
	super.enter()
	
	entity.velocity.y = -entity.bounce_force
	
	AudioHandler.play_sfx(entity.sfx_jump)
	
	if OptionsHandler.particles_enabled == true:
		var j = entity.jump_dust.instantiate()
		entity.add_child(j)
		j.global_position.y = entity.global_position.y + 4

func physics_update(delta):
	super.physics_update(delta)
	entity.handle_input()
	entity.apply_movement(delta)
	
	apply_gravity(delta)
	
	if entity.velocity.y < -entity.release_jump_velocity and Input.is_action_just_released("jump"):
		entity.velocity.y = -entity.release_jump_velocity
	
	if entity.is_on_floor() and entity.movement_input != 0:
		return entity.run
	
	if entity.is_on_floor() and entity.movement_input == 0:
		return entity.idle
	
	if entity.velocity.y > 0:
		return entity.fall

func apply_gravity(delta):
	entity.velocity.y = clampf(
		entity.velocity.y,
		-entity.max_fall_speed,
		entity.max_fall_speed
	)
	entity.velocity.y += entity.gravity_up * entity.gravity_multiplier * delta

func exit():
	super.exit()
	entity.bouncing = false
