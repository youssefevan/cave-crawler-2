extends State

var frame := 0

func enter():
	super.enter()
	frame = 0
	entity.velocity.x = 0

func physics_update(delta):
	frame += 1
	
	entity.velocity.y += entity.gravity * delta
	
	if frame >= 60 * 1.5:
		return entity.swoop
