extends State

func enter():
	super.enter()

func physics_update(delta):
	super.physics_update(delta)
	
	if entity.current_health <= (entity.max_health - 10):
		return entity.wait

func exit():
	entity.vines()
	entity.player.apply_camera_shake()
	AudioHandler.play_sfx(entity.sfx_phase)
