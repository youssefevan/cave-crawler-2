extends State

var frame := 0
var move_dir : float

func enter():
	super.enter()
	
	AudioHandler.play_sfx(entity.sfx_swoop)
	
	frame = 0
	entity.velocity.y = 0
	
	if (entity.player.global_position.x - entity.global_position.x) > 0:
		move_dir = 1
	else:
		move_dir = -1

func physics_update(delta):
	frame += 1
	
	entity.velocity.y += entity.gravity * delta
	
	if frame <= 60 * .25:
		entity.velocity.x = lerpf(entity.velocity.x, 500 * move_dir, 5 * delta)
	elif frame >= (60 * .25) and frame < (60 * .7):
		entity.velocity.x = lerpf(entity.velocity.x, 0, 5 * delta)
	elif frame >= (60 * .7):
		return entity.idle
