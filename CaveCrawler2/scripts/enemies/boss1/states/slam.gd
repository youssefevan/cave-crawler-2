extends State

var frame := 0
var hit_floor := false
var shake_frame : int

func enter():
	super.enter()
	frame = 0
	entity.velocity.x = 0

func physics_update(delta):
	frame += 1
	
	entity.velocity.y += entity.gravity * delta
	
	if entity.is_on_floor():
		if hit_floor == false:
			shake_frame = frame
			hit_floor = true
		else:
			if frame == shake_frame:
				AudioHandler.play_sfx(entity.sfx_slam)
				entity.player.apply_camera_shake()
	
	if frame >= 60 * 1.5:
		return entity.swoop
