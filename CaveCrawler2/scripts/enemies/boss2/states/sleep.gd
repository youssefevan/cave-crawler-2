extends State

func enter():
	super.enter()

func physics_update(delta):
	super.physics_update(delta)
	
	if entity.current_health <= (entity.max_health - 10):
		return entity.idle

func exit():
	entity.vines()
	entity.player.apply_camera_shake()
