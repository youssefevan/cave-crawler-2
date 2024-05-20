extends State

func physics_update(delta):
	super.physics_update(delta)
	
	if not entity.is_on_floor():
		return entity.fall
	
	if entity.player != null:
		return entity.anticipate
