extends Pickup

@export var next_level : PackedScene

@export var level_id : int

func _ready():
	#super._ready()
	Global.next_level = next_level

func picked(body):
	super.picked(body)
	$Sprite.frame = 1
	
	if level_id > 0:
		OptionsHandler.set_levels_unlocked(level_id + 1)
	
	body.end_level()
