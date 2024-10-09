extends Pickup

@export var next_level : PackedScene

@export var level_id : int

var level_editor_offset := Vector2(4, 0)

var sfx_end = preload("res://audio/sfx/stalactite_fall.ogg")

func _ready():
	#super._ready()
	Global.next_level = next_level

func picked(body):
	super.picked(body)
	$Sprite.frame = 1
	
	if level_id > 0:
		OptionsHandler.set_levels_unlocked(level_id + 1)
	
	if level_id != 15:
		body.end_level()
	else:
		AudioHandler.play_sfx(sfx_end)
		body.game_end_rocket()

func get_level_editor_offset() -> Vector2:
	return level_editor_offset
