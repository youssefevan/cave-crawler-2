extends Pickup

var spawn_offset := Vector2(0, 4)

var checked := false

func picked(body):
	super.picked(body)
	$Sprite.frame = 1
	
	Global.checkpoint_passed = true
	Global.checkpoint_position = global_position - spawn_offset
