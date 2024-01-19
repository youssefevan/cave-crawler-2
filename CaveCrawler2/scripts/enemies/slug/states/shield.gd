extends State

var end := false

func enter():
	super.enter()
	end = false
	entity.shield_timer.start()
	await entity.shield_timer.timeout
	end = true

func physics_update(delta):
	if end == true:
		return entity.idle
	
	if entity.got_hit == true:
		return entity.shield

func exit():
	super.exit()
	entity.got_hit = false
