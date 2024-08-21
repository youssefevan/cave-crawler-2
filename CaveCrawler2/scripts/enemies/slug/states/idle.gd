extends State

var end := false

func enter():
	super.enter()
	
	entity.hurtbox_collider.disabled = true
	
	end = false
	await get_tree().create_timer(entity.inch_time).timeout
	end = true

func physics_update(delta):
	entity.hurtbox_collider.disabled = false
	
	if entity.is_on_floor():
		entity.apply_friction(delta)
	else:
		entity.velocity.x = lerp(entity.velocity.x, 0.0, 2.0 * delta)
	
	if end == true and entity.is_on_floor():
		return entity.move
	
	if entity.got_hit == true:
		return entity.shield
