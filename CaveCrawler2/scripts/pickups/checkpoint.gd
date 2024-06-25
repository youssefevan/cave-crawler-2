extends Pickup

var level_editor_offset := Vector2(0, 4)
var spawn_offset := Vector2(0, 4)

var checked := false

func picked(body):
	super.picked(body)
	$Sprite.frame = 1
	body.health = body.max_health
	
	Global.checkpoint_passed = true
	Global.checkpoint_position = global_position - spawn_offset

func get_level_editor_offset() -> Vector2:
	return level_editor_offset
