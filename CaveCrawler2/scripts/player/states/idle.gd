extends State

var enter_jump := false

func enter():
	super.enter()
	if Input.is_action_just_pressed("jump"):
		enter_jump = true

func physics_update(delta):
	super.physics_update(delta)
	entity.handle_input()
	entity.apply_movement(delta)
	
	entity.velocity.y += entity.gravity_up * entity.gravity_multiplier * delta
	
	if entity.movement_input != 0:
		return entity.run
	
	if not entity.is_on_floor():
		return entity.fall
	
	if entity.jump_was_pressed:
		return entity.jump
	
	if enter_jump:
		return entity.fall
	
	if entity.bouncing:
		return entity.bounce

func exit():
	super.exit()
	enter_jump = false


