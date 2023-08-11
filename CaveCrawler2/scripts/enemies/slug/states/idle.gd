extends State

var end := false

func enter():
	super.enter()
	end = false
	await get_tree().create_timer(entity.inch_time).timeout
	end = true

func physics_update(delta):
	entity.velocity.x = lerp(entity.velocity.x, 0.0, 4.0 * delta)
	
	if end == true and entity.is_on_floor():
		return entity.move
	
	if entity.got_hit == true:
		return entity.shield
