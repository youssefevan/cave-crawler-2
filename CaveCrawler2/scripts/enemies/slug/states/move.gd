extends State

var end := false

func enter():
	super.enter()
	end = false
	entity.velocity.x = entity.speed * entity.move_direction
	await get_tree().create_timer(entity.inch_time).timeout
	end = true

func physics_update(delta):
	entity.apply_friction(delta)
	
	if end == true and entity.is_on_floor():
		return entity.idle
	
	if entity.is_on_wall():
		entity.move_direction *= -1
	
	if entity.got_hit == true:
		return entity.shield
