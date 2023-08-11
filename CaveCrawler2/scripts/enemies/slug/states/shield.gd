extends State

var end := false

func enter():
	super.enter()
	end = false
	await get_tree().create_timer(entity.shield_time).timeout
	end = true

func physics_update(delta):
	if end == true:
		return entity.idle

func exit():
	super.exit()
	entity.got_hit = false
