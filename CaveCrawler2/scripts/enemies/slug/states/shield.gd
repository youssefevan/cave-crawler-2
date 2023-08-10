extends State

var end := false

func enter():
	super.enter()
	end = false
	await get_tree().create_timer(entity.shield_time).timeout
	end = true

func physics_update(delta):
	if not entity.is_on_floor():
		entity.velocity.y += entity.gravity * delta
	
	if entity.is_on_floor():
		entity.velocity.y = 1
	
	entity.velocity.x = lerp(entity.velocity.x, 0.0, 4.0 * delta)
	
	if end == true:
		return entity.idle

func exit():
	super.exit()
	entity.got_hit = false
