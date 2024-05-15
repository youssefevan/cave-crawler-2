extends State

func enter():
	super.enter()
	
	entity.velocity.y = -entity.jump_velocity
	
	if Input.is_action_just_released("jump"):
		entity.velocity.y = -entity.release_jump_velocity * entity.speed_modifier
	
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
		entity.velocity.y = -entity.release_jump_velocity * entity.speed_modifier
	
	if entity.is_on_floor() and entity.movement_input != 0:
		return entity.run
	
	if entity.is_on_floor() and entity.movement_input == 0:
		return entity.idle
	
	if entity.velocity.y > 0:
		return entity.fall
	
	if entity.bouncing:
		return entity.bounce

func apply_gravity(delta):
	entity.velocity.y = clampf(
		entity.velocity.y,
		-entity.max_fall_speed * entity.speed_modifier,
		entity.max_fall_speed  * entity.speed_modifier
	)
	entity.velocity.y += entity.gravity_up * entity.speed_modifier * delta
