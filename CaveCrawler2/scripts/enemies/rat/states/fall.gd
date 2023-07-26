extends State

func physics_update(delta):
	super.physics_update(delta)
	
	if entity.is_on_floor():
		return entity.land
