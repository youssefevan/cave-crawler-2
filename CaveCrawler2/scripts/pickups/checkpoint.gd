extends Pickup

var level_editor_offset := Vector2(0, 8)
var spawn_offset := Vector2(0, 4)

var checked := false

var particles = preload("res://scenes/particles/health_picked.tscn")
var sfx = preload("res://audio/sfx/checkpoint.ogg")

func picked(body) -> void:
	if Global.checkpoint_position != global_position - spawn_offset:
		super.picked(body)
		$Sprite.frame = 1
		body.health = body.max_health
		
		var p = particles.instantiate()
		add_child(p)
		p.position = Vector2(0, -16)
		
		AudioHandler.play_sfx(sfx)
		
		Global.checkpoint_passed = true
		Global.checkpoint_position = global_position - spawn_offset

func get_level_editor_offset() -> Vector2:
	return level_editor_offset
