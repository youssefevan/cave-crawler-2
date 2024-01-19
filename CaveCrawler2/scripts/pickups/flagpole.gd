extends Pickup

@export var next_level : PackedScene

func _ready():
	#super._ready()
	Global.next_level = next_level

func picked(body):
	super.picked(body)
	$Sprite.frame = 1
	body.end_level()
