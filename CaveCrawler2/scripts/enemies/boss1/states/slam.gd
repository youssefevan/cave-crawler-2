extends State

var frame := 0
var hit_floor := false
var shake_frame : int

var prev_collision_count

func enter():
	super.enter()
	frame = 0
	entity.velocity.x = 0

func physics_update(delta):
	frame += 1
	
	entity.velocity.y += entity.gravity * delta
	
	if prev_collision_count == 0 and entity.get_slide_collision_count() > 0:
		AudioHandler.play_sfx(entity.sfx_slam)
		entity.player.apply_camera_shake()
	
	prev_collision_count = entity.get_slide_collision_count()
	
	if frame >= 60 * 1.5:
		return entity.swoop
