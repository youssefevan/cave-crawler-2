extends State

var end : bool

func enter():
	super.enter()
	
	end = false
	await get_tree().create_timer(entity.anticipate_length).timeout
	end = true

func physics_update(delta):
	
	if end == true:
		return entity.jump
	
	if not entity.is_on_floor():
		return entity.fall
