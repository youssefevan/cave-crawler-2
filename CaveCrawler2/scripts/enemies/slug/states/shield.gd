extends State

var end := false

func enter():
	super.enter()
	
	AudioHandler.play_sfx(entity.sfx_bounce)
	
	end = false
	entity.shield_timer.start()
	await entity.shield_timer.timeout
	end = true

func physics_update(delta):
	entity.apply_friction(delta)
	
	if end == true:
		return entity.idle
	
	if entity.got_hit == true:
		return entity.shield

func exit():
	super.exit()
	entity.got_hit = false
