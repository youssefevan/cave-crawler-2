extends State

var end : bool

func enter():
	super.enter()
	
	end = false
	await get_tree().create_timer(entity.land_length).timeout
	end = true
	

func physics_update(delta):
	super.physics_update(delta)
	
	if not entity.is_on_floor():
		return entity.fall
	
	if end == true:
		return entity.idle
